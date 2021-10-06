Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2D1424470
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 19:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhJFRku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 13:40:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59496 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhJFRku (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 13:40:50 -0400
Date:   Wed, 06 Oct 2021 17:38:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633541936;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lwbQ1w46VdwS4T2SNaMgsDkCkxDBkCSzgzR9rXqJ1fk=;
        b=YOsp5j81Yer+KoaFuLdmwT+V6QNEhakXPPXE6nWGBsIqomWe/Ng+69hCMKo6DNkHvUHG3R
        KptIBTLhqi5uX9IISgR9Yj2QlwltAXWatIaIfpY0lRSS8yTlXm/JcbWZFnrm1MguQTC06h
        XGM/3xctWixZkYqwJCF4J/6jUoozF+/pYW+DKrM2PrJ2EBcjByItuJzRBSo84k3j4ymRVa
        hyz1TIg/0s22q0I6yIsoD/ikFgZj/S2zucCTRopeeW7nagDPczgcV2XS4fHGFazZGbbm3K
        AtKJuM3kpPMoGQFq5ey2WnaUhptNFsOGXuAGXNXY7NR5zmA9wU3D4NT/ac+CwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633541936;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lwbQ1w46VdwS4T2SNaMgsDkCkxDBkCSzgzR9rXqJ1fk=;
        b=5Qd/byuCrsEbIfkK48NdK6SXLFOXeJVEOCrlS3/7cv4AI91Xi4KtbwDt6tfyOv57IRSk/v
        rZqFTzdSj3EmpdBQ==
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/fpu: Restore the masking out of reserved MXCSR bits
Cc:     Ser Olmy <ser.olmy@protonmail.com>, Borislav Petkov <bp@suse.de>,
        <stable@vger.kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <YVtA67jImg3KlBTw@zn.tnic>
References: <YVtA67jImg3KlBTw@zn.tnic>
MIME-Version: 1.0
Message-ID: <163354193576.25758.8132624386883258818.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     908d969f88bfcf6d8538a0159e502567c7678775
Gitweb:        https://git.kernel.org/tip/908d969f88bfcf6d8538a0159e502567c7678775
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Wed, 06 Oct 2021 18:33:52 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 06 Oct 2021 18:46:06 +02:00

x86/fpu: Restore the masking out of reserved MXCSR bits

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

so restore the original behavior.

Fixes: 6f9866a166cd ("x86/fpu/signal: Let xrstor handle the features to init")
Reported-by: Ser Olmy <ser.olmy@protonmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Ser Olmy <ser.olmy@protonmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/YVtA67jImg3KlBTw@zn.tnic
---
 arch/x86/kernel/fpu/signal.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 445c57c..684be34 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -379,9 +379,8 @@ static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 				     sizeof(fpu->state.fxsave)))
 			return -EFAULT;
 
-		/* Reject invalid MXCSR values. */
-		if (fpu->state.fxsave.mxcsr & ~mxcsr_feature_mask)
-			return -EINVAL;
+		/* Mask out reserved MXCSR bits. */
+		fpu->state.fxsave.mxcsr &= mxcsr_feature_mask;
 
 		/* Enforce XFEATURE_MASK_FPSSE when XSAVE is enabled */
 		if (use_xsave())
