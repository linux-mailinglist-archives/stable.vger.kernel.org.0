Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D64C59D372
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbiHWISh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243086AbiHWIQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:16:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D25CD0;
        Tue, 23 Aug 2022 01:11:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFCF3B81C26;
        Tue, 23 Aug 2022 08:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13732C433C1;
        Tue, 23 Aug 2022 08:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242278;
        bh=kEu+tVAAMz7l6eaSkXFjJcQXu+RSWjRkIomwdhEVcyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMNTQXJpZgYmVXylz9tPVTEMtDQ69gLia4yVWHXSUdmI0VpFgs3BezdnNRBWiq+uk
         wX5u8ojJG778OCPF8N0FvS3bA61vCbjeGRanEeyqeMZNaBy/CJ9SjV72ZKunFQu7fS
         cETMKP86KacJHk6Q8u1uhJRw9wlz3bmyioHzzIxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 087/365] net: atm: bring back zatm uAPI
Date:   Tue, 23 Aug 2022 09:59:48 +0200
Message-Id: <20220823080121.829262938@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit c2e75634cbe368065f140dd30bf8b1a0355158fd upstream.

Jiri reports that linux-atm does not build without this header.
Bring it back. It's completely dead code but we can't break
the build for user space :(

Reported-by: Jiri Slaby <jirislaby@kernel.org>
Fixes: 052e1f01bfae ("net: atm: remove support for ZeitNet ZN122x ATM devices")
Link: https://lore.kernel.org/all/8576aef3-37e4-8bae-bab5-08f82a78efd3@kernel.org/
Link: https://lore.kernel.org/r/20220810164547.484378-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/atm_zatm.h | 47 +++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 include/uapi/linux/atm_zatm.h

diff --git a/include/uapi/linux/atm_zatm.h b/include/uapi/linux/atm_zatm.h
new file mode 100644
index 000000000000..5135027b93c1
--- /dev/null
+++ b/include/uapi/linux/atm_zatm.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* atm_zatm.h - Driver-specific declarations of the ZATM driver (for use by
+		driver-specific utilities) */
+
+/* Written 1995-1999 by Werner Almesberger, EPFL LRC/ICA */
+
+
+#ifndef LINUX_ATM_ZATM_H
+#define LINUX_ATM_ZATM_H
+
+/*
+ * Note: non-kernel programs including this file must also include
+ * sys/types.h for struct timeval
+ */
+
+#include <linux/atmapi.h>
+#include <linux/atmioc.h>
+
+#define ZATM_GETPOOL	_IOW('a',ATMIOC_SARPRV+1,struct atmif_sioc)
+						/* get pool statistics */
+#define ZATM_GETPOOLZ	_IOW('a',ATMIOC_SARPRV+2,struct atmif_sioc)
+						/* get statistics and zero */
+#define ZATM_SETPOOL	_IOW('a',ATMIOC_SARPRV+3,struct atmif_sioc)
+						/* set pool parameters */
+
+struct zatm_pool_info {
+	int ref_count;			/* free buffer pool usage counters */
+	int low_water,high_water;	/* refill parameters */
+	int rqa_count,rqu_count;	/* queue condition counters */
+	int offset,next_off;		/* alignment optimizations: offset */
+	int next_cnt,next_thres;	/* repetition counter and threshold */
+};
+
+struct zatm_pool_req {
+	int pool_num;			/* pool number */
+	struct zatm_pool_info info;	/* actual information */
+};
+
+#define ZATM_OAM_POOL		0	/* free buffer pool for OAM cells */
+#define ZATM_AAL0_POOL		1	/* free buffer pool for AAL0 cells */
+#define ZATM_AAL5_POOL_BASE	2	/* first AAL5 free buffer pool */
+#define ZATM_LAST_POOL	ZATM_AAL5_POOL_BASE+10 /* max. 64 kB */
+
+#define ZATM_TIMER_HISTORY_SIZE	16	/* number of timer adjustments to
+					   record; must be 2^n */
+
+#endif
-- 
2.37.2



