Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7DC45C5FD
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348786AbhKXOEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:47004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353620AbhKXOAg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:00:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52A0C61B74;
        Wed, 24 Nov 2021 13:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759351;
        bh=4Jz5er3Kn/YEzGSi9BMkk41sRxMHvzDZjIwrMeUwC64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dp8RLzc6v1gXnb3e6zSJ+viNBWG6Fte8fCn7osVi6P0Y/eoVgC9z031lS/XcGi2jG
         s5/7paMk7afBx9F7oP2kulqQh8fL8JAckR5nM6ROCVmHZPGb99/8/OY18bwZS5xU+3
         sh7NlP1zZJ3in+XJMLFG+hNiR5wx0d4tsu7FXcmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 212/279] Revert "parisc: Reduce sigreturn trampoline to 3 instructions"
Date:   Wed, 24 Nov 2021 12:58:19 +0100
Message-Id: <20211124115726.066887681@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 79df39d535c7a3770856fe9f5aba8c0ad1eebdb6 upstream.

This reverts commit e4f2006f1287e7ea17660490569cff323772dac4.

This patch shows problems with signal handling. Revert it for now.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v5.15
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/rt_sigframe.h |    2 +-
 arch/parisc/kernel/signal.c           |   13 +++++++------
 arch/parisc/kernel/signal32.h         |    2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

--- a/arch/parisc/include/asm/rt_sigframe.h
+++ b/arch/parisc/include/asm/rt_sigframe.h
@@ -2,7 +2,7 @@
 #ifndef _ASM_PARISC_RT_SIGFRAME_H
 #define _ASM_PARISC_RT_SIGFRAME_H
 
-#define SIGRETURN_TRAMP 3
+#define SIGRETURN_TRAMP 4
 #define SIGRESTARTBLOCK_TRAMP 5 
 #define TRAMP_SIZE (SIGRETURN_TRAMP + SIGRESTARTBLOCK_TRAMP)
 
--- a/arch/parisc/kernel/signal.c
+++ b/arch/parisc/kernel/signal.c
@@ -288,21 +288,22 @@ setup_rt_frame(struct ksignal *ksig, sig
 	   already in userspace. The first words of tramp are used to
 	   save the previous sigrestartblock trampoline that might be
 	   on the stack. We start the sigreturn trampoline at 
-	   SIGRESTARTBLOCK_TRAMP. */
+	   SIGRESTARTBLOCK_TRAMP+X. */
 	err |= __put_user(in_syscall ? INSN_LDI_R25_1 : INSN_LDI_R25_0,
 			&frame->tramp[SIGRESTARTBLOCK_TRAMP+0]);
-	err |= __put_user(INSN_BLE_SR2_R0, 
+	err |= __put_user(INSN_LDI_R20,
 			&frame->tramp[SIGRESTARTBLOCK_TRAMP+1]);
-	err |= __put_user(INSN_LDI_R20,
+	err |= __put_user(INSN_BLE_SR2_R0,
 			&frame->tramp[SIGRESTARTBLOCK_TRAMP+2]);
+	err |= __put_user(INSN_NOP, &frame->tramp[SIGRESTARTBLOCK_TRAMP+3]);
 
-	start = (unsigned long) &frame->tramp[SIGRESTARTBLOCK_TRAMP+0];
-	end = (unsigned long) &frame->tramp[SIGRESTARTBLOCK_TRAMP+3];
+	start = (unsigned long) &frame->tramp[0];
+	end = (unsigned long) &frame->tramp[TRAMP_SIZE];
 	flush_user_dcache_range_asm(start, end);
 	flush_user_icache_range_asm(start, end);
 
 	/* TRAMP Words 0-4, Length 5 = SIGRESTARTBLOCK_TRAMP
-	 * TRAMP Words 5-7, Length 3 = SIGRETURN_TRAMP
+	 * TRAMP Words 5-9, Length 4 = SIGRETURN_TRAMP
 	 * So the SIGRETURN_TRAMP is at the end of SIGRESTARTBLOCK_TRAMP
 	 */
 	rp = (unsigned long) &frame->tramp[SIGRESTARTBLOCK_TRAMP];
--- a/arch/parisc/kernel/signal32.h
+++ b/arch/parisc/kernel/signal32.h
@@ -36,7 +36,7 @@ struct compat_regfile {
         compat_int_t rf_sar;
 };
 
-#define COMPAT_SIGRETURN_TRAMP 3
+#define COMPAT_SIGRETURN_TRAMP 4
 #define COMPAT_SIGRESTARTBLOCK_TRAMP 5
 #define COMPAT_TRAMP_SIZE (COMPAT_SIGRETURN_TRAMP + \
 				COMPAT_SIGRESTARTBLOCK_TRAMP)


