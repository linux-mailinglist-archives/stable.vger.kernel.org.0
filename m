Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D613B645E
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbhF1PHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237259AbhF1PF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91AA261D6F;
        Mon, 28 Jun 2021 14:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891413;
        bh=rehbVIc31Iq19OxRw6aouktuh4CrueShfwSKGptDFiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofKzcK20Y+QRwToYrYa9U6HeQ/iRkArAp8f9ZgxO1FcXMomvztXQGkbTVBnWPxG9R
         9y7RDGWNAZdrVHxN/u2Eju2VkTu/W6UAyJIcrtyUMJ/WB8KeJD8bQAow6hMZLVBtUf
         S6xCKM6BS3Jp/do/eKCb+iT/3oBN99re1IS1ohkkrNcWvWmvxJql4Fy9trtY+8O+AJ
         cNGFugAngJMuGbx1144Zt6y7VKycohsjEsELzfuEs2rURgkOyz+VbPTncGCVIOQaQF
         hlL70FtRb51NTWabBwXOprHD2xHxHl+445RMSB9g52oExuIY6ICkM1DejuC+obldWr
         7H2xwtfPhZrgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 41/57] x86/fpu: Reset state for all signal restore failures
Date:   Mon, 28 Jun 2021 10:42:40 -0400
Message-Id: <20210628144256.34524-42-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
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
 arch/x86/kernel/fpu/signal.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 8fc842dae3b3..9a1489b92782 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -262,15 +262,23 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		return 0;
 	}
 
-	if (!access_ok(VERIFY_READ, buf, size))
+	if (!access_ok(VERIFY_READ, buf, size)) {
+		fpu__clear(fpu);
 		return -EACCES;
+	}
 
 	fpu__activate_curr(fpu);
 
-	if (!static_cpu_has(X86_FEATURE_FPU))
-		return fpregs_soft_set(current, NULL,
-				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, buf) != 0;
+	if (!static_cpu_has(X86_FEATURE_FPU)) {
+		int ret = fpregs_soft_set(current, NULL, 0,
+					  sizeof(struct user_i387_ia32_struct),
+					  NULL, buf);
+
+		if (ret)
+			fpu__clear(fpu);
+
+		return ret != 0;
+	}
 
 	if (use_xsave()) {
 		struct _fpx_sw_bytes fx_sw_user;
-- 
2.30.2

