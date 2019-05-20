Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDC323642
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390030AbfETMoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389599AbfETM2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F96E216E3;
        Mon, 20 May 2019 12:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355289;
        bh=N/ofm5rj9sNV0irbNixsRv2fu+2poIF2HeRoIMIthLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RF5cMI1huTl1VOLC84Y9UxBDp4Ef7cBlNT7elcwXIo7EMT0YZMKA8TJnTDNgllOqc
         GcAWFuggQhA3fOyzJD2z+gGDLFLGTgyxVSh3SIny1f+PA2U7bCW0z1G6uBARQn+9wQ
         fkW3dg1XSIJ5ytCJZmB8NfJlub/xfRBzq97Pa5lA=
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
        Yazen Ghannam <yazen.ghannam@amd.com>, x86-ml <x86@kernel.org>
Subject: [PATCH 5.0 022/123] x86/MCE/AMD: Carve out the MC4_MISC thresholding quirk
Date:   Mon, 20 May 2019 14:13:22 +0200
Message-Id: <20190520115246.323227905@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shirish S <Shirish.S@amd.com>

commit 30aa3d26edb0f3d7992757287eec0ca588a5c259 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mce/amd.c  |   36 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mce/core.c |   29 -----------------------------
 2 files changed, 36 insertions(+), 29 deletions(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -545,6 +545,40 @@ out:
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
@@ -552,6 +586,8 @@ void mce_amd_feature_init(struct cpuinfo
 	unsigned int bank, block, cpu = smp_processor_id();
 	int offset = -1;
 
+	disable_err_thresholding(c);
+
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (mce_flags.smca)
 			smca_configure(bank, cpu);
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1612,35 +1612,6 @@ static int __mcheck_cpu_apply_quirks(str
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


