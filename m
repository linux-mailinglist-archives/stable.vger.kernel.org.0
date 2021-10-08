Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C09426744
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 11:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239454AbhJHKAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 06:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238917AbhJHKAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 06:00:52 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058F4C061570;
        Fri,  8 Oct 2021 02:58:56 -0700 (PDT)
Date:   Fri, 08 Oct 2021 09:58:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633687134;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HkaEHRILfubdoOT6X98a6xdXk/Gxl5tQm58DK03ukdo=;
        b=34iVcs2Q3buVbs22dpGC1ml+Q+GFlSFBPT91GsSqD8UrbsX5Gd0qF3JyLU0MqunF911E58
        Lkccj9NAqIKaRGZUUA2jhjjz42ASfRn+kmfDDVUq0DCDq/+XMYELo5jvmlPbu3wdZhrhh3
        02dAu0kMtKMDi8KlSg646xcSLvsbP0IwiElnZfTKUOE8qWak2wxO3dCUD80IDBMUGd3Wwf
        c6PC+KH9SJC+kT1vxg+K0KHCnNmkuxNZvGr8wbuQ6WC3Mmf0YBj29GZV29uFALsgx67wb+
        Yd4RQSJM2ZzMAUbzyb7e9thc1onKawm4l0l02Q/9q+rGe+gd/45MqAEiBKj9rw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633687134;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HkaEHRILfubdoOT6X98a6xdXk/Gxl5tQm58DK03ukdo=;
        b=LwsgU2FQs1eERt37rvaumQyrspKAVAmYYW9JomsKQGoZ+4PN9OvR0vqHQ2T/OJWj8bUBL9
        Dic6Jas9It9XX2DA==
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
Message-ID: <163368713375.25758.3020127637765994658.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     d298b03506d3e161f7492c440babb0bfae35e650
Gitweb:        https://git.kernel.org/tip/d298b03506d3e161f7492c440babb0bfae35e650
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Wed, 06 Oct 2021 18:33:52 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 08 Oct 2021 11:12:17 +02:00

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
---
 arch/x86/kernel/fpu/signal.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 445c57c..fa17a27 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -379,9 +379,14 @@ static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
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
