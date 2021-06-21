Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E0D3AEF2E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbhFUQgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:36:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:54546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232986AbhFUQe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:34:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D769661361;
        Mon, 21 Jun 2021 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292848;
        bh=d9exkhx6UjYb5GaV55vnkVuxfYJd+RqPRziOKf0SAp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvKn3q1qw3hjK0C/dXYjVE3WR1c4scPT7cwljm8I16CSkyOV96SeojrE0WYohR/Lc
         KkihTHFHh9kVZIEp8/DNAVOOT89AoTKe8RyXz6TpbLcBbXUNp+fSl/K/yxQjlPe8R5
         URLnaDSADqtpN+zQCk42DvZHtdpjWzGbBqnpQTPs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 124/146] x86/fpu: Reset state for all signal restore failures
Date:   Mon, 21 Jun 2021 18:15:54 +0200
Message-Id: <20210621154919.282112764@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit efa165504943f2128d50f63de0c02faf6dcceb0d upstream.

If access_ok() or fpregs_soft_set() fails in __fpu__restore_sig() then the
function just returns but does not clear the FPU state as it does for all
other fatal failures.

Clear the FPU state for these failures as well.

Fixes: 72a671ced66d ("x86, fpu: Unify signal handling code paths for x86 and x86_64 kernels")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/87mtryyhhz.ffs@nanos.tec.linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/signal.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -307,13 +307,17 @@ static int __fpu__restore_sig(void __use
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
@@ -396,7 +400,7 @@ static int __fpu__restore_sig(void __use
 		 */
 		ret = __copy_from_user(&env, buf, sizeof(env));
 		if (ret)
-			goto err_out;
+			goto out;
 		envp = &env;
 	}
 
@@ -426,7 +430,7 @@ static int __fpu__restore_sig(void __use
 
 		ret = copy_user_to_xstate(&fpu->state.xsave, buf_fx);
 		if (ret)
-			goto err_out;
+			goto out;
 
 		sanitize_restored_user_xstate(&fpu->state, envp, user_xfeatures,
 					      fx_only);
@@ -446,7 +450,7 @@ static int __fpu__restore_sig(void __use
 		ret = __copy_from_user(&fpu->state.fxsave, buf_fx, state_size);
 		if (ret) {
 			ret = -EFAULT;
-			goto err_out;
+			goto out;
 		}
 
 		sanitize_restored_user_xstate(&fpu->state, envp, user_xfeatures,
@@ -464,7 +468,7 @@ static int __fpu__restore_sig(void __use
 	} else {
 		ret = __copy_from_user(&fpu->state.fsave, buf_fx, state_size);
 		if (ret)
-			goto err_out;
+			goto out;
 
 		fpregs_lock();
 		ret = copy_kernel_to_fregs_err(&fpu->state.fsave);
@@ -475,7 +479,7 @@ static int __fpu__restore_sig(void __use
 		fpregs_deactivate(fpu);
 	fpregs_unlock();
 
-err_out:
+out:
 	if (ret)
 		fpu__clear_user_states(fpu);
 	return ret;


