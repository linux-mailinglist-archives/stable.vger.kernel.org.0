Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5F74188FF
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 15:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhIZNNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 09:13:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231673AbhIZNNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 09:13:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A89160FC1;
        Sun, 26 Sep 2021 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632661906;
        bh=k+Ibi4/G/5nXwDtz5mruATwLpRqC4HS0rmQkuPSgCHg=;
        h=Subject:To:Cc:From:Date:From;
        b=MxRlOD5dFYwMEweTd6BBU6qNEa6A6xizCWDHt4MMthZiAwvM1Xe/dVQ+bFZq5mQ91
         OthY8tN7win6xTt++kwYMHgHYw0u9Hb4Y2rTaI9IRjOeYf6+v1lDqxFihbtxvFvAOP
         Se8M+jxP1yedxPbHPunNEelfTcQyLl6Y8wWFpIMQ=
Subject: FAILED: patch "[PATCH] arm64: add MTE supported check to thread switching and" failed to apply to 5.14-stable tree
To:     pcc@google.com, catalin.marinas@arm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 26 Sep 2021 15:11:43 +0200
Message-ID: <163266190311422@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8c8a3b5bd960cd88f7655b5251dc28741e11f139 Mon Sep 17 00:00:00 2001
From: Peter Collingbourne <pcc@google.com>
Date: Wed, 15 Sep 2021 12:03:35 -0700
Subject: [PATCH] arm64: add MTE supported check to thread switching and
 syscall entry/exit

This lets us avoid doing unnecessary work on hardware that does not
support MTE, and will allow us to freely use MTE instructions in the
code called by mte_thread_switch().

Since this would mean that we do a redundant check in
mte_check_tfsr_el1(), remove it and add two checks now required in its
callers. This also avoids an unnecessary DSB+ISB sequence on the syscall
exit path for hardware not supporting MTE.

Fixes: 65812c6921cc ("arm64: mte: Enable async tag check fault")
Cc: <stable@vger.kernel.org> # 5.13.x
Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/I02fd000d1ef2c86c7d2952a7f099b254ec227a5d
Link: https://lore.kernel.org/r/20210915190336.398390-1-pcc@google.com
[catalin.marinas@arm.com: adjust the commit log slightly]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 3f93b9e0b339..02511650cffe 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -99,11 +99,17 @@ void mte_check_tfsr_el1(void);
 
 static inline void mte_check_tfsr_entry(void)
 {
+	if (!system_supports_mte())
+		return;
+
 	mte_check_tfsr_el1();
 }
 
 static inline void mte_check_tfsr_exit(void)
 {
+	if (!system_supports_mte())
+		return;
+
 	/*
 	 * The asynchronous faults are sync'ed automatically with
 	 * TFSR_EL1 on kernel entry but for exit an explicit dsb()
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 9d314a3bad3b..e5e801bc5312 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -142,12 +142,7 @@ void mte_enable_kernel_async(void)
 #ifdef CONFIG_KASAN_HW_TAGS
 void mte_check_tfsr_el1(void)
 {
-	u64 tfsr_el1;
-
-	if (!system_supports_mte())
-		return;
-
-	tfsr_el1 = read_sysreg_s(SYS_TFSR_EL1);
+	u64 tfsr_el1 = read_sysreg_s(SYS_TFSR_EL1);
 
 	if (unlikely(tfsr_el1 & SYS_TFSR_EL1_TF1)) {
 		/*
@@ -199,6 +194,9 @@ void mte_thread_init_user(void)
 
 void mte_thread_switch(struct task_struct *next)
 {
+	if (!system_supports_mte())
+		return;
+
 	mte_update_sctlr_user(next);
 
 	/*

