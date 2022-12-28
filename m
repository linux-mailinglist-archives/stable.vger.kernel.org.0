Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBA96578A0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiL1OxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiL1Ow0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:52:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8785E12607
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:52:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23B31614B2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 399A4C433EF;
        Wed, 28 Dec 2022 14:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239137;
        bh=i9x2hb2mbl61DebPVRFCVXIwAxfCYJh2pqlrHn1USCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OA5zvmus1uhlrHeKJFkb2ww5NyG6QIc/XACgwKiG64e6lTqfXo306a+Yprcq/csqc
         RIThb+Eboz5tTokwWcRFgZTANmoc0CjvrdaghyizqnrJeNEhw9YXeagZy4syWuhrMz
         XzLt/C8v2wgKFOSgwgOVx1dkTr70CxpvSP/TwTRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/731] futex: Move to kernel/futex/
Date:   Wed, 28 Dec 2022 15:33:43 +0100
Message-Id: <20221228144259.916209162@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 77e52ae35463521041906c510fe580d15663bb93 ]

In preparation for splitup..

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: André Almeida <andrealmeid@collabora.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: André Almeida <andrealmeid@collabora.com>
Link: https://lore.kernel.org/r/20210923171111.300673-2-andrealmeid@collabora.com
Stable-dep-of: 90d758896787 ("futex: Resend potentially swallowed owner death notification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                      | 2 +-
 kernel/Makefile                  | 2 +-
 kernel/futex/Makefile            | 3 +++
 kernel/{futex.c => futex/core.c} | 2 +-
 4 files changed, 6 insertions(+), 3 deletions(-)
 create mode 100644 kernel/futex/Makefile
 rename kernel/{futex.c => futex/core.c} (99%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1cf05aee91af..4f50a453e18a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7746,7 +7746,7 @@ F:	Documentation/locking/*futex*
 F:	include/asm-generic/futex.h
 F:	include/linux/futex.h
 F:	include/uapi/linux/futex.h
-F:	kernel/futex.c
+F:	kernel/futex/*
 F:	tools/perf/bench/futex*
 F:	tools/testing/selftests/futex/
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 0e119c52a2cd..599cb926449a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -59,7 +59,7 @@ obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
-obj-$(CONFIG_FUTEX) += futex.o
+obj-$(CONFIG_FUTEX) += futex/
 obj-$(CONFIG_GENERIC_ISA_DMA) += dma.o
 obj-$(CONFIG_SMP) += smp.o
 ifneq ($(CONFIG_SMP),y)
diff --git a/kernel/futex/Makefile b/kernel/futex/Makefile
new file mode 100644
index 000000000000..b89ba3fba343
--- /dev/null
+++ b/kernel/futex/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-y += core.o
diff --git a/kernel/futex.c b/kernel/futex/core.c
similarity index 99%
rename from kernel/futex.c
rename to kernel/futex/core.c
index c15ad276fd15..f9bc9aa0ce1e 100644
--- a/kernel/futex.c
+++ b/kernel/futex/core.c
@@ -42,7 +42,7 @@
 
 #include <asm/futex.h>
 
-#include "locking/rtmutex_common.h"
+#include "../locking/rtmutex_common.h"
 
 /*
  * READ this before attempting to hack on futexes!
-- 
2.35.1



