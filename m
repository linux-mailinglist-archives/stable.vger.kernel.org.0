Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B2A3B636E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhF1O46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:56:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234673AbhF1OxS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:53:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB70361D3E;
        Mon, 28 Jun 2021 14:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891045;
        bh=uv/0NXoXFqk+Q6hq8RclpBb7MT9vuBeFi6DBxhvZu4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tY927JFNyDisao3BLRp2BLJ55WMKzI7F1+8qK0nz4haElOyuLzTka8vlwvkBwO/fm
         yk4IQFDUQW5+xbJpiHxCyQC3EIB3VDbGSHq3ksUW1/Fg2tmalDKLOp76J8387AXJy5
         UhsCKJpkcN50pLunjrWbNbjw6waWWSSt709y8rx+ZqFeeDR2ZoWLEf2SJj908W8f8a
         KBdAhz5pbIS8GH5vFOOklvPB4ESx5ZTD8ZRDFiAXQRrflMidxDIZm5/W+lBhYfm60E
         RCHq2dmpDSm0Q8sNfQeQgbVj9mLUX9FnTBkeEbcDFYVG8Zz/InYpcXk4CAv0e/fXwk
         +Z7651KcsKxuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 64/88] x86/fpu: Reset state for all signal restore failures
Date:   Mon, 28 Jun 2021 10:36:04 -0400
Message-Id: <20210628143628.33342-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 arch/x86/kernel/fpu/signal.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index d99a8ee9e185..86a231338bbf 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -272,6 +272,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 	int state_size = fpu_kernel_xstate_size;
 	u64 xfeatures = 0;
 	int fx_only = 0;
+	int ret = 0;
 
 	ia32_fxstate &= (IS_ENABLED(CONFIG_X86_32) ||
 			 IS_ENABLED(CONFIG_IA32_EMULATION));
@@ -281,15 +282,21 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		return 0;
 	}
 
-	if (!access_ok(VERIFY_READ, buf, size))
-		return -EACCES;
+	if (!access_ok(VERIFY_READ, buf, size)) {
+		ret = -EACCES;
+		goto out_err;
+	}
 
 	fpu__initialize(fpu);
 
-	if (!static_cpu_has(X86_FEATURE_FPU))
-		return fpregs_soft_set(current, NULL,
-				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, buf) != 0;
+	if (!static_cpu_has(X86_FEATURE_FPU)) {
+		ret = fpregs_soft_set(current, NULL,
+				      0, sizeof(struct user_i387_ia32_struct),
+				      NULL, buf) != 0;
+		if (ret)
+			goto out_err;
+		return 0;
+	}
 
 	if (use_xsave()) {
 		struct _fpx_sw_bytes fx_sw_user;
@@ -349,6 +356,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		fpu__restore(fpu);
 		local_bh_enable();
 
+		/* Failure is already handled */
 		return err;
 	} else {
 		/*
@@ -356,13 +364,14 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		 * state to the registers directly (with exceptions handled).
 		 */
 		user_fpu_begin();
-		if (copy_user_to_fpregs_zeroing(buf_fx, xfeatures, fx_only)) {
-			fpu__clear(fpu);
-			return -1;
-		}
+		if (!copy_user_to_fpregs_zeroing(buf_fx, xfeatures, fx_only))
+			return 0;
+		ret = -1;
 	}
 
-	return 0;
+out_err:
+	fpu__clear(fpu);
+	return ret;
 }
 
 static inline int xstate_sigframe_size(void)
-- 
2.30.2

