Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69463A249B
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 08:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhFJGla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 02:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhFJGl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 02:41:28 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBFCC061574;
        Wed,  9 Jun 2021 23:39:32 -0700 (PDT)
Date:   Thu, 10 Jun 2021 06:39:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1623307168;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pHfBmgSSl0LVj0j/mIks/eDK1NXKCYXj541XDw2jgp8=;
        b=G+6GumO1S0lYEs3+FOoZZE3bhxdSiq8/J0eJJk48lx+JX2GpEDTS2UvBT+kUM2/bKByrOA
        WnFM2OEWOJCpqHMpdMJZx8tZ6MsJ2aH6J/OHGoXdAxsT95654yLuUzlaocK7OAWrOjaBMo
        ylk2ie0pZk4/PxIcdNeBkGAVkFi78FuMCgkx/SAhIfJ1O6CEHaGmBmf/DqsX2UkFloOT72
        xl7ch28e4IENsMYIRetnTEZHPmXB0fLKmN/EVluUqaNg+85L+k/4K3CZU9KkHvLJ3RvFZn
        AOgwdBXvgWIPAsejv93eal7RyDa0w7pS3JJpdEuuG5tWMktmFqNiOiavnlleNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1623307168;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pHfBmgSSl0LVj0j/mIks/eDK1NXKCYXj541XDw2jgp8=;
        b=ilb+VLgXgKZc9sZQyMSoP9oGDa2TMKk2a7NaLnNUPDRbXpuftWMJ1o6t4fedoIjz7eu/6x
        6pIjC36oU31SOtAw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/fpu: Reset state for all signal restore failures
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <87mtryyhhz.ffs@nanos.tec.linutronix.de>
References: <87mtryyhhz.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <162330716797.29796.6651101584652382146.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     efa165504943f2128d50f63de0c02faf6dcceb0d
Gitweb:        https://git.kernel.org/tip/efa165504943f2128d50f63de0c02faf6dcceb0d
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 09 Jun 2021 21:18:00 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 10 Jun 2021 08:04:24 +02:00

x86/fpu: Reset state for all signal restore failures

If access_ok() or fpregs_soft_set() fails in __fpu__restore_sig() then the
function just returns but does not clear the FPU state as it does for all
other fatal failures.

Clear the FPU state for these failures as well.

Fixes: 72a671ced66d ("x86, fpu: Unify signal handling code paths for x86 and x86_64 kernels")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/87mtryyhhz.ffs@nanos.tec.linutronix.de
---
 arch/x86/kernel/fpu/signal.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 4ab9aeb..ec3ae30 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -307,13 +307,17 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		return 0;
 	}
 
-	if (!access_ok(buf, size))
-		return -EACCES;
+	if (!access_ok(buf, size)) {
+		ret = -EACCES;
+		goto out;
+	}
 
-	if (!static_cpu_has(X86_FEATURE_FPU))
-		return fpregs_soft_set(current, NULL,
-				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, buf) != 0;
+	if (!static_cpu_has(X86_FEATURE_FPU)) {
+		ret = fpregs_soft_set(current, NULL, 0,
+				      sizeof(struct user_i387_ia32_struct),
+				      NULL, buf);
+		goto out;
+	}
 
 	if (use_xsave()) {
 		struct _fpx_sw_bytes fx_sw_user;
@@ -396,7 +400,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		 */
 		ret = __copy_from_user(&env, buf, sizeof(env));
 		if (ret)
-			goto err_out;
+			goto out;
 		envp = &env;
 	}
 
@@ -426,7 +430,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 
 		ret = copy_user_to_xstate(&fpu->state.xsave, buf_fx);
 		if (ret)
-			goto err_out;
+			goto out;
 
 		sanitize_restored_user_xstate(&fpu->state, envp, user_xfeatures,
 					      fx_only);
@@ -446,7 +450,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		ret = __copy_from_user(&fpu->state.fxsave, buf_fx, state_size);
 		if (ret) {
 			ret = -EFAULT;
-			goto err_out;
+			goto out;
 		}
 
 		sanitize_restored_user_xstate(&fpu->state, envp, user_xfeatures,
@@ -464,7 +468,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 	} else {
 		ret = __copy_from_user(&fpu->state.fsave, buf_fx, state_size);
 		if (ret)
-			goto err_out;
+			goto out;
 
 		fpregs_lock();
 		ret = copy_kernel_to_fregs_err(&fpu->state.fsave);
@@ -475,7 +479,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		fpregs_deactivate(fpu);
 	fpregs_unlock();
 
-err_out:
+out:
 	if (ret)
 		fpu__clear_user_states(fpu);
 	return ret;
