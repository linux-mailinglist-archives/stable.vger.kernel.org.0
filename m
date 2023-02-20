Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F62E69CD40
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjBTNrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbjBTNrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:47:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A35B1D915
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:47:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 08E6860D41
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EF7C433D2;
        Mon, 20 Feb 2023 13:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900856;
        bh=mM94gfvrqTRHIIsgSEPorfBSaCF8o7xCtNAVmysAXPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NhOrhNuMaUX756Kqk17GMsfGq4CjSOQczXKjbWQahffxWkvJTPVm18wJWPSXGcQI6
         xi1gE/PHSuCVtfXYh9l1B9dQHtXGQzekU+Gt4xaxkKZK8sW3ZwWkx84M/kJMD6YvSU
         db/DxAe4clID02lcxNEgYC6di6bjiM+4Lt8B2fFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shunsuke Mie <mie@igel.co.jp>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/156] tools/virtio: fix the vringh test for virtio ring changes
Date:   Mon, 20 Feb 2023 14:35:37 +0100
Message-Id: <20230220133606.326775706@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shunsuke Mie <mie@igel.co.jp>

[ Upstream commit 3f7b75abf41cc4143aa295f62acbb060a012868d ]

Fix the build caused by missing kmsan_handle_dma() and is_power_of_2() that
are used in drivers/virtio/virtio_ring.c.

Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
Message-Id: <20230110034310.779744-1-mie@igel.co.jp>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/virtio/linux/bug.h         |  8 +++-----
 tools/virtio/linux/build_bug.h   |  7 +++++++
 tools/virtio/linux/cpumask.h     |  7 +++++++
 tools/virtio/linux/gfp.h         |  7 +++++++
 tools/virtio/linux/kernel.h      |  1 +
 tools/virtio/linux/kmsan.h       | 12 ++++++++++++
 tools/virtio/linux/scatterlist.h |  1 +
 tools/virtio/linux/topology.h    |  7 +++++++
 8 files changed, 45 insertions(+), 5 deletions(-)
 create mode 100644 tools/virtio/linux/build_bug.h
 create mode 100644 tools/virtio/linux/cpumask.h
 create mode 100644 tools/virtio/linux/gfp.h
 create mode 100644 tools/virtio/linux/kmsan.h
 create mode 100644 tools/virtio/linux/topology.h

diff --git a/tools/virtio/linux/bug.h b/tools/virtio/linux/bug.h
index b14c2c3b6b857..74aef964f5099 100644
--- a/tools/virtio/linux/bug.h
+++ b/tools/virtio/linux/bug.h
@@ -1,11 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef BUG_H
-#define BUG_H
+#ifndef _LINUX_BUG_H
+#define _LINUX_BUG_H
 
 #define BUG_ON(__BUG_ON_cond) assert(!(__BUG_ON_cond))
 
-#define BUILD_BUG_ON(x)
-
 #define BUG() abort()
 
-#endif /* BUG_H */
+#endif /* _LINUX_BUG_H */
diff --git a/tools/virtio/linux/build_bug.h b/tools/virtio/linux/build_bug.h
new file mode 100644
index 0000000000000..cdbb75e28a604
--- /dev/null
+++ b/tools/virtio/linux/build_bug.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BUILD_BUG_H
+#define _LINUX_BUILD_BUG_H
+
+#define BUILD_BUG_ON(x)
+
+#endif	/* _LINUX_BUILD_BUG_H */
diff --git a/tools/virtio/linux/cpumask.h b/tools/virtio/linux/cpumask.h
new file mode 100644
index 0000000000000..307da69d6b26c
--- /dev/null
+++ b/tools/virtio/linux/cpumask.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CPUMASK_H
+#define _LINUX_CPUMASK_H
+
+#include <linux/kernel.h>
+
+#endif /* _LINUX_CPUMASK_H */
diff --git a/tools/virtio/linux/gfp.h b/tools/virtio/linux/gfp.h
new file mode 100644
index 0000000000000..43d146f236f14
--- /dev/null
+++ b/tools/virtio/linux/gfp.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_GFP_H
+#define __LINUX_GFP_H
+
+#include <linux/topology.h>
+
+#endif
diff --git a/tools/virtio/linux/kernel.h b/tools/virtio/linux/kernel.h
index 6683b4a70b059..3325cdf229410 100644
--- a/tools/virtio/linux/kernel.h
+++ b/tools/virtio/linux/kernel.h
@@ -10,6 +10,7 @@
 #include <stdarg.h>
 
 #include <linux/compiler.h>
+#include <linux/log2.h>
 #include <linux/types.h>
 #include <linux/printk.h>
 #include <linux/bug.h>
diff --git a/tools/virtio/linux/kmsan.h b/tools/virtio/linux/kmsan.h
new file mode 100644
index 0000000000000..272b5aa285d5a
--- /dev/null
+++ b/tools/virtio/linux/kmsan.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KMSAN_H
+#define _LINUX_KMSAN_H
+
+#include <linux/gfp.h>
+
+inline void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
+			     enum dma_data_direction dir)
+{
+}
+
+#endif /* _LINUX_KMSAN_H */
diff --git a/tools/virtio/linux/scatterlist.h b/tools/virtio/linux/scatterlist.h
index 369ee308b6686..74d9e1825748e 100644
--- a/tools/virtio/linux/scatterlist.h
+++ b/tools/virtio/linux/scatterlist.h
@@ -2,6 +2,7 @@
 #ifndef SCATTERLIST_H
 #define SCATTERLIST_H
 #include <linux/kernel.h>
+#include <linux/bug.h>
 
 struct scatterlist {
 	unsigned long	page_link;
diff --git a/tools/virtio/linux/topology.h b/tools/virtio/linux/topology.h
new file mode 100644
index 0000000000000..910794afb993a
--- /dev/null
+++ b/tools/virtio/linux/topology.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_TOPOLOGY_H
+#define _LINUX_TOPOLOGY_H
+
+#include <linux/cpumask.h>
+
+#endif /* _LINUX_TOPOLOGY_H */
-- 
2.39.0



