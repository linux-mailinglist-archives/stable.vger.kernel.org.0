Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C79429115
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244251AbhJKOPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243886AbhJKON1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:13:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D835F6128A;
        Mon, 11 Oct 2021 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633961059;
        bh=99AyWAF8IJk2ARIKBNNnAEB7qLtTvX0BfrcYa2p3i/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yjp0fe7EkEIlfHBU0nf4wso4qrY3RKXqE6K3iISh162lnrB3Ym/I9kEs5EAO/4Hj
         B12S9+vHwzymRfxVr51ZlR9YHdEBX+1UwzR4MGhAIOfp8codEZBYOXJoElKZrYzbfc
         6Njnpmcfo0M8eLaNOlflnaRYnrMHWBIZvoZZFaIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ser Olmy <ser.olmy@protonmail.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.14 147/151] x86/fpu: Restore the masking out of reserved MXCSR bits
Date:   Mon, 11 Oct 2021 15:46:59 +0200
Message-Id: <20211011134522.575320425@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

commit d298b03506d3e161f7492c440babb0bfae35e650 upstream.

Ser Olmy reported a boot failure:

  init[1] bad frame in sigreturn frame:(ptrval) ip:b7c9fbe6 sp:bf933310 orax:ffffffff \
	  in libc-2.33.so[b7bed000+156000]
  Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
  CPU: 0 PID: 1 Comm: init Tainted: G        W         5.14.9 #1
  Hardware name: Hewlett-Packard HP PC/HP Board, BIOS  JD.00.06 12/06/2001
  Call Trace:
   dump_stack_lvl
   dump_stack
   panic
   do_exit.cold
   do_group_exit
   get_signal
   arch_do_signal_or_restart
   ? force_sig_info_to_task
   ? force_sig
   exit_to_user_mode_prepare
   syscall_exit_to_user_mode
   do_int80_syscall_32
   entry_INT80_32

on an old 32-bit Intel CPU:

  vendor_id       : GenuineIntel
  cpu family      : 6
  model           : 6
  model name      : Celeron (Mendocino)
  stepping        : 5
  microcode       : 0x3

Ser bisected the problem to the commit in Fixes.

tglx suggested reverting the rejection of invalid MXCSR values which
this commit introduced and replacing it with what the old code did -
simply masking them out to zero.

Further debugging confirmed his suggestion:

  fpu->state.fxsave.mxcsr: 0xb7be13b4, mxcsr_feature_mask: 0xffbf
  WARNING: CPU: 0 PID: 1 at arch/x86/kernel/fpu/signal.c:384 __fpu_restore_sig+0x51f/0x540

so restore the original behavior only for 32-bit kernels where you have
ancient machines with buggy hardware. For 32-bit programs on 64-bit
kernels, user space which supplies wrong MXCSR values is considered
malicious so fail the sigframe restoration there.

Fixes: 6f9866a166cd ("x86/fpu/signal: Let xrstor handle the features to init")
Reported-by: Ser Olmy <ser.olmy@protonmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Ser Olmy <ser.olmy@protonmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/YVtA67jImg3KlBTw@zn.tnic
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/signal.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -379,9 +379,14 @@ static int __fpu_restore_sig(void __user
 				     sizeof(fpu->state.fxsave)))
 			return -EFAULT;
 
-		/* Reject invalid MXCSR values. */
-		if (fpu->state.fxsave.mxcsr & ~mxcsr_feature_mask)
-			return -EINVAL;
+		if (IS_ENABLED(CONFIG_X86_64)) {
+			/* Reject invalid MXCSR values. */
+			if (fpu->state.fxsave.mxcsr & ~mxcsr_feature_mask)
+				return -EINVAL;
+		} else {
+			/* Mask invalid bits out for historical reasons (broken hardware). */
+			fpu->state.fxsave.mxcsr &= ~mxcsr_feature_mask;
+		}
 
 		/* Enforce XFEATURE_MASK_FPSSE when XSAVE is enabled */
 		if (use_xsave())


