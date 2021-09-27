Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC296419320
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 13:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhI0LdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 07:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233972AbhI0LdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 07:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5816960F4F;
        Mon, 27 Sep 2021 11:31:26 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     <stable@vger.kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Collingbourne <pcc@google.com>
Subject: [PATCH stable-5.14.y] arm64: add MTE supported check to thread switching and syscall entry/exit
Date:   Mon, 27 Sep 2021 12:31:24 +0100
Message-Id: <20210927113124.439854-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Collingbourne <pcc@google.com>

commit 8c8a3b5bd960cd88f7655b5251dc28741e11f139 upstream.

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
---
 arch/arm64/include/asm/mte.h |  6 ++++++
 arch/arm64/kernel/mte.c      | 10 ++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 58c7f80f5596..c724a288a412 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -105,11 +105,17 @@ void mte_check_tfsr_el1(void);
 
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
index 36f51b0e438a..d223df11fc00 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -173,12 +173,7 @@ bool mte_report_once(void)
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
@@ -221,6 +216,9 @@ void mte_thread_init_user(void)
 
 void mte_thread_switch(struct task_struct *next)
 {
+	if (!system_supports_mte())
+		return;
+
 	/*
 	 * Check if an async tag exception occurred at EL1.
 	 *
