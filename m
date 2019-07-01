Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672C5235E7
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390505AbfETMlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389946AbfETMbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:31:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B178521479;
        Mon, 20 May 2019 12:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355511;
        bh=VULUz7VOMABH6Ci++gMoVwRwZO6JSd7hSO3oluI7m2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APJSwdRbAfF6+RS9slmlPB4AUHoX3ZgSas4nodbKmGjkOEJ4plTmQUKpPXjHk0/g9
         JYuhgFkYA+IyPDANy7E+hJGqQM8vTrgW1/6JVXezYgvbaNZoKziO1vikixC4l/ugK2
         4vkux6zH7tQ9l2Ttw6aKLydfuvW/yrKWeA6jJs58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "clemej@gmail.com" <clemej@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pu Wen <puwen@hygon.cn>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        Shirish S <Shirish.S@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-edac <linux-edac@vger.kernel.org>, x86-ml <x86@kernel.org>
Subject: [PATCH 5.1 022/128] x86/MCE/AMD: Dont report L1 BTB MCA errors on some family 17h models
Date:   Mon, 20 May 2019 14:13:29 +0200
Message-Id: <20190520115251.036216224@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 71a84402b93e5fbd8f817f40059c137e10171788 upstream.

AMD family 17h Models 10h-2Fh may report a high number of L1 BTB MCA
errors under certain conditions. The errors are benign and can safely be
ignored. However, the high error rate may cause the MCA threshold
counter to overflow causing a high rate of thresholding interrupts.

In addition, users may see the errors reported through the AMD MCE
decoder module, even with the interrupt disabled, due to MCA polling.

Clear the "Counter Present" bit in the Instruction Fetch bank's
MCA_MISC0 register. This will prevent enabling MCA thresholding on this
bank which will prevent the high interrupt rate due to this error.

Define an AMD-specific function to filter these errors from the MCE
event pool so that they don't get reported during early boot.

Rename filter function in EDAC/mce_amd to avoid a naming conflict, while
at it.

 [ bp: Move function prototype to the internal header and
   massage/cleanup, fix typos. ]

Reported-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "clemej@gmail.com" <clemej@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Pu Wen <puwen@hygon.cn>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: Shirish S <Shirish.S@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: x86-ml <x86@kernel.org>
Cc: <stable@vger.kernel.org> # 5.0.x: c95b323dcd35: x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models
Cc: <stable@vger.kernel.org> # 5.0.x: 30aa3d26edb0: x86/MCE/AMD: Carve out the MC4_MISC thresholding quirk
Cc: <stable@vger.kernel.org> # 5.0.x: 9308fd407455: x86/MCE: Group AMD function prototypes in <asm/mce.h>
Cc: <stable@vger.kernel.org> # 5.0.x
Link: https://lkml.kernel.org/r/20190325163410.171021-2-Yazen.Ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mce/amd.c      |   52 +++++++++++++++++++++++++++----------
 arch/x86/kernel/cpu/mce/core.c     |    3 ++
 arch/x86/kernel/cpu/mce/internal.h |    6 ++++
 drivers/edac/mce_amd.c             |    4 +-
 4 files changed, 50 insertions(+), 15 deletions(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -563,33 +563,59 @@ out:
 	return offset;
 }
 
+bool amd_filter_mce(struct mce *m)
+{
+	enum smca_bank_types bank_type = smca_get_bank_type(m->bank);
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	u8 xec = (m->status >> 16) & 0x3F;
+
+	/* See Family 17h Models 10h-2Fh Erratum #1114. */
+	if (c->x86 == 0x17 &&
+	    c->x86_model >= 0x10 && c->x86_model <= 0x2F &&
+	    bank_type == SMCA_IF && xec == 10)
+		return true;
+
+	return false;
+}
+
 /*
- * Turn off MC4_MISC thresholding banks on all family 0x15 models since
- * they're not supported there.
+ * Turn off thresholding banks for the following conditions:
+ * - MC4_MISC thresholding is not supported on Family 0x15.
+ * - Prevent possible spurious interrupts from the IF bank on Family 0x17
+ *   Models 0x10-0x2F due to Erratum #1114.
  */
-void disable_err_thresholding(struct cpuinfo_x86 *c)
+void disable_err_thresholding(struct cpuinfo_x86 *c, unsigned int bank)
 {
-	int i;
+	int i, num_msrs;
 	u64 hwcr;
 	bool need_toggle;
-	u32 msrs[] = {
-		0x00000413, /* MC4_MISC0 */
-		0xc0000408, /* MC4_MISC1 */
-	};
+	u32 msrs[NR_BLOCKS];
 
-	if (c->x86 != 0x15)
+	if (c->x86 == 0x15 && bank == 4) {
+		msrs[0] = 0x00000413; /* MC4_MISC0 */
+		msrs[1] = 0xc0000408; /* MC4_MISC1 */
+		num_msrs = 2;
+	} else if (c->x86 == 0x17 &&
+		   (c->x86_model >= 0x10 && c->x86_model <= 0x2F)) {
+
+		if (smca_get_bank_type(bank) != SMCA_IF)
+			return;
+
+		msrs[0] = MSR_AMD64_SMCA_MCx_MISC(bank);
+		num_msrs = 1;
+	} else {
 		return;
+	}
 
 	rdmsrl(MSR_K7_HWCR, hwcr);
 
 	/* McStatusWrEn has to be set */
 	need_toggle = !(hwcr & BIT(18));
-
 	if (need_toggle)
 		wrmsrl(MSR_K7_HWCR, hwcr | BIT(18));
 
 	/* Clear CntP bit safely */
-	for (i = 0; i < ARRAY_SIZE(msrs); i++)
+	for (i = 0; i < num_msrs; i++)
 		msr_clear_bit(msrs[i], 62);
 
 	/* restore old settings */
@@ -604,12 +630,12 @@ void mce_amd_feature_init(struct cpuinfo
 	unsigned int bank, block, cpu = smp_processor_id();
 	int offset = -1;
 
-	disable_err_thresholding(c);
-
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		if (mce_flags.smca)
 			smca_configure(bank, cpu);
 
+		disable_err_thresholding(c, bank);
+
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			address = get_block_address(address, low, high, bank, block);
 			if (!address)
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1773,6 +1773,9 @@ static void __mcheck_cpu_init_timer(void
 
 bool filter_mce(struct mce *m)
 {
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+		return amd_filter_mce(m);
+
 	return false;
 }
 
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -176,4 +176,10 @@ extern struct mca_msr_regs msr_ops;
 /* Decide whether to add MCE record to MCE event pool or filter it out. */
 extern bool filter_mce(struct mce *m);
 
+#ifdef CONFIG_X86_MCE_AMD
+extern bool amd_filter_mce(struct mce *m);
+#else
+static inline bool amd_filter_mce(struct mce *m)			{ return false; };
+#endif
+
 #endif /* __X86_MCE_INTERNAL_H__ */
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -1004,7 +1004,7 @@ static inline void amd_decode_err_code(u
 /*
  * Filter out unwanted MCE signatures here.
  */
-static bool amd_filter_mce(struct mce *m)
+static bool ignore_mce(struct mce *m)
 {
 	/*
 	 * NB GART TLB error reporting is disabled by default.
@@ -1038,7 +1038,7 @@ amd_decode_mce(struct notifier_block *nb
 	unsigned int fam = x86_family(m->cpuid);
 	int ecc;
 
-	if (amd_filter_mce(m))
+	if (ignore_mce(m))
 		return NOTIFY_STOP;
 
 	pr_emerg(HW_ERR "%s\n", decode_error_status(m));


