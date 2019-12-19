Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FDC126C6A
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfLSTDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728641AbfLSSsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:48:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F8F424680;
        Thu, 19 Dec 2019 18:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781284;
        bh=u2/OnGNY8RICnn/6dHSAt89D83O7cVsjECwTeTQC3C4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ukYU+UbUZ15Xk5TpD9FF3MFMU1Jertw7tBtWpVEOWrukNtBvspYofzqvVXZhBwZUZ
         7CsILdQsEUMBI8S19kfu2VU7xyxhd2tEIEIsOjFqRwQN5kkrx/oSy23l9Volz6RKwh
         0gVAp+K/nSq9sE+aP261ZELJJqJtkxAp9Xiho6sA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirish S <shirish.s@amd.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 157/199] x86/MCE/AMD: Carve out the MC4_MISC thresholding quirk
Date:   Thu, 19 Dec 2019 19:33:59 +0100
Message-Id: <20191219183224.035695321@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shirish S <Shirish.S@amd.com>

[ Upstream commit 30aa3d26edb0f3d7992757287eec0ca588a5c259 ]

The MC4_MISC thresholding quirk needs to be applied during S5 -> S0 and
S3 -> S0 state transitions, which follow different code paths. Carve it
out into a separate function and call it mce_amd_feature_init() where
the two code paths of the state transitions converge.

 [ bp: massage commit message and the carved out function. ]

Signed-off-by: Shirish S <shirish.s@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Yazen Ghannam <yazen.ghannam@amd.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/1547651417-23583-3-git-send-email-shirish.s@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c     | 29 ----------------------
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 36 ++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2664c3df85a60..d3b2c5b25c9c0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1648,35 +1648,6 @@ static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 		if (c->x86 == 0x15 && c->x86_model <= 0xf)
 			mce_flags.overflow_recov = 1;
 
-		/*
-		 * Turn off MC4_MISC thresholding banks on all models since
-		 * they're not supported there.
-		 */
-		if (c->x86 == 0x15) {
-			int i;
-			u64 hwcr;
-			bool need_toggle;
-			u32 msrs[] = {
-				0x00000413, /* MC4_MISC0 */
-				0xc0000408, /* MC4_MISC1 */
-			};
-
-			rdmsrl(MSR_K7_HWCR, hwcr);
-
-			/* McStatusWrEn has to be set */
-			need_toggle = !(hwcr & BIT(18));
-
-			if (need_toggle)
-				wrmsrl(MSR_K7_HWCR, hwcr | BIT(18));
-
-			/* Clear CntP bit safely */
-			for (i = 0; i < ARRAY_SIZE(msrs); i++)
-				msr_clear_bit(msrs[i], 62);
-
-			/* restore old settings */
-			if (need_toggle)
-				wrmsrl(MSR_K7_HWCR, hwcr);
-		}
 	}
 
 	if (c->x86_vendor == X86_VENDOR_INTEL) {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 39526e1e3132d..2a473cda39774 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -499,6 +499,40 @@ out:
 	return offset;
 }
 
+/*
+ * Turn off MC4_MISC thresholding banks on all family 0x15 models since
+ * they're not supported there.
+ */
+void disable_err_thresholding(struct cpuinfo_x86 *c)
+{
+	int i;
+	u64 hwcr;
+	bool need_toggle;
+	u32 msrs[] = {
+		0x00000413, /* MC4_MISC0 */
+		0xc0000408, /* MC4_MISC1 */
+	};
+
+	if (c->x86 != 0x15)
+		return;
+
+	rdmsrl(MSR_K7_HWCR, hwcr);
+
+	/* McStatusWrEn has to be set */
+	need_toggle = !(hwcr & BIT(18));
+
+	if (need_toggle)
+		wrmsrl(MSR_K7_HWCR, hwcr | BIT(18));
+
+	/* Clear CntP bit safely */
+	for (i = 0; i < ARRAY_SIZE(msrs); i++)
+		msr_clear_bit(msrs[i], 62);
+
+	/* restore old settings */
+	if (need_toggle)
+		wrmsrl(MSR_K7_HWCR, hwcr);
+}
+
 /* cpu init entry point, called from mce.c with preempt off */
 void mce_amd_feature_init(struct cpuinfo_x86 *c)
 {
@@ -506,6 +540,8 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 	unsigned int bank, block, cpu = smp_processor_id();
 	int offset = -1;
 
+	disable_err_thresholding(c);
+
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (mce_flags.smca)
 			get_smca_bank_info(bank);
-- 
2.20.1



