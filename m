Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9699D664AC9
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239379AbjAJSgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239387AbjAJSfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:35:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D350A4C73
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4534CE18E6
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E376C433EF;
        Tue, 10 Jan 2023 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375414;
        bh=YTp6D+nUCgXbEq2GxAqtAM1xVu/u4ogKHCukgMBjgW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxL6/P8Y84AOR1WyQEEcHQqZAnQbSi6EHC70XOnVlbG0z29i0xE0M4YznjlPmKUdi
         vzrQQx7wnXoumBQJjy2weBaU1+QZyGmiKMiao1gJA793Ff0spLwMoq8X/rc/akDWc1
         a2gs3kIT69TTc5CbqARDhBZmpUzWTvYBCYAi1yJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Borislav Petkov <bp@suse.de>,
        Tony Luck <tony.luck@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/290] x86/mce: Get rid of msr_ops
Date:   Tue, 10 Jan 2023 19:04:34 +0100
Message-Id: <20230110180038.219885262@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit 8121b8f947be0033f567619be204639a50cad298 ]

Avoid having indirect calls and use a normal function which returns the
proper MSR address based on ->smca setting.

No functional changes.

Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Link: https://lkml.kernel.org/r/20210922165101.18951-4-bp@alien8.de
Stable-dep-of: bc1b705b0eee ("x86/MCE/AMD: Clear DFR errors found in THR handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/amd.c      | 10 ++--
 arch/x86/kernel/cpu/mce/core.c     | 95 ++++++++++--------------------
 arch/x86/kernel/cpu/mce/internal.h | 12 ++--
 3 files changed, 42 insertions(+), 75 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index a873577e49dc..b8b7c304e4ba 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -526,7 +526,7 @@ static u32 get_block_address(u32 current_addr, u32 low, u32 high,
 	/* Fall back to method we used for older processors: */
 	switch (block) {
 	case 0:
-		addr = msr_ops.misc(bank);
+		addr = mca_msr_reg(bank, MCA_MISC);
 		break;
 	case 1:
 		offset = ((low & MASK_BLKPTR_LO) >> 21);
@@ -978,8 +978,8 @@ static void log_error_deferred(unsigned int bank)
 {
 	bool defrd;
 
-	defrd = _log_error_bank(bank, msr_ops.status(bank),
-					msr_ops.addr(bank), 0);
+	defrd = _log_error_bank(bank, mca_msr_reg(bank, MCA_STATUS),
+				mca_msr_reg(bank, MCA_ADDR), 0);
 
 	if (!mce_flags.smca)
 		return;
@@ -1009,7 +1009,7 @@ static void amd_deferred_error_interrupt(void)
 
 static void log_error_thresholding(unsigned int bank, u64 misc)
 {
-	_log_error_bank(bank, msr_ops.status(bank), msr_ops.addr(bank), misc);
+	_log_error_bank(bank, mca_msr_reg(bank, MCA_STATUS), mca_msr_reg(bank, MCA_ADDR), misc);
 }
 
 static void log_and_reset_block(struct threshold_block *block)
@@ -1397,7 +1397,7 @@ static int threshold_create_bank(struct threshold_bank **bp, unsigned int cpu,
 		}
 	}
 
-	err = allocate_threshold_blocks(cpu, b, bank, 0, msr_ops.misc(bank));
+	err = allocate_threshold_blocks(cpu, b, bank, 0, mca_msr_reg(bank, MCA_MISC));
 	if (err)
 		goto out_kobj;
 
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 773037e5fd76..5ee82fd386dd 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -176,53 +176,27 @@ void mce_unregister_decode_chain(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(mce_unregister_decode_chain);
 
-static inline u32 ctl_reg(int bank)
+u32 mca_msr_reg(int bank, enum mca_msr reg)
 {
-	return MSR_IA32_MCx_CTL(bank);
-}
-
-static inline u32 status_reg(int bank)
-{
-	return MSR_IA32_MCx_STATUS(bank);
-}
-
-static inline u32 addr_reg(int bank)
-{
-	return MSR_IA32_MCx_ADDR(bank);
-}
-
-static inline u32 misc_reg(int bank)
-{
-	return MSR_IA32_MCx_MISC(bank);
-}
-
-static inline u32 smca_ctl_reg(int bank)
-{
-	return MSR_AMD64_SMCA_MCx_CTL(bank);
-}
-
-static inline u32 smca_status_reg(int bank)
-{
-	return MSR_AMD64_SMCA_MCx_STATUS(bank);
-}
+	if (mce_flags.smca) {
+		switch (reg) {
+		case MCA_CTL:	 return MSR_AMD64_SMCA_MCx_CTL(bank);
+		case MCA_ADDR:	 return MSR_AMD64_SMCA_MCx_ADDR(bank);
+		case MCA_MISC:	 return MSR_AMD64_SMCA_MCx_MISC(bank);
+		case MCA_STATUS: return MSR_AMD64_SMCA_MCx_STATUS(bank);
+		}
+	}
 
-static inline u32 smca_addr_reg(int bank)
-{
-	return MSR_AMD64_SMCA_MCx_ADDR(bank);
-}
+	switch (reg) {
+	case MCA_CTL:	 return MSR_IA32_MCx_CTL(bank);
+	case MCA_ADDR:	 return MSR_IA32_MCx_ADDR(bank);
+	case MCA_MISC:	 return MSR_IA32_MCx_MISC(bank);
+	case MCA_STATUS: return MSR_IA32_MCx_STATUS(bank);
+	}
 
-static inline u32 smca_misc_reg(int bank)
-{
-	return MSR_AMD64_SMCA_MCx_MISC(bank);
+	return 0;
 }
 
-struct mca_msr_regs msr_ops = {
-	.ctl	= ctl_reg,
-	.status	= status_reg,
-	.addr	= addr_reg,
-	.misc	= misc_reg
-};
-
 static void __print_mce(struct mce *m)
 {
 	pr_emerg(HW_ERR "CPU %d: Machine Check%s: %Lx Bank %d: %016Lx\n",
@@ -371,11 +345,11 @@ static int msr_to_offset(u32 msr)
 
 	if (msr == mca_cfg.rip_msr)
 		return offsetof(struct mce, ip);
-	if (msr == msr_ops.status(bank))
+	if (msr == mca_msr_reg(bank, MCA_STATUS))
 		return offsetof(struct mce, status);
-	if (msr == msr_ops.addr(bank))
+	if (msr == mca_msr_reg(bank, MCA_ADDR))
 		return offsetof(struct mce, addr);
-	if (msr == msr_ops.misc(bank))
+	if (msr == mca_msr_reg(bank, MCA_MISC))
 		return offsetof(struct mce, misc);
 	if (msr == MSR_IA32_MCG_STATUS)
 		return offsetof(struct mce, mcgstatus);
@@ -676,10 +650,10 @@ static struct notifier_block mce_default_nb = {
 static noinstr void mce_read_aux(struct mce *m, int i)
 {
 	if (m->status & MCI_STATUS_MISCV)
-		m->misc = mce_rdmsrl(msr_ops.misc(i));
+		m->misc = mce_rdmsrl(mca_msr_reg(i, MCA_MISC));
 
 	if (m->status & MCI_STATUS_ADDRV) {
-		m->addr = mce_rdmsrl(msr_ops.addr(i));
+		m->addr = mce_rdmsrl(mca_msr_reg(i, MCA_ADDR));
 
 		/*
 		 * Mask the reported address by the reported granularity.
@@ -749,7 +723,7 @@ bool machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		m.bank = i;
 
 		barrier();
-		m.status = mce_rdmsrl(msr_ops.status(i));
+		m.status = mce_rdmsrl(mca_msr_reg(i, MCA_STATUS));
 
 		/* If this entry is not valid, ignore it */
 		if (!(m.status & MCI_STATUS_VAL))
@@ -817,7 +791,7 @@ bool machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		/*
 		 * Clear state for this bank.
 		 */
-		mce_wrmsrl(msr_ops.status(i), 0);
+		mce_wrmsrl(mca_msr_reg(i, MCA_STATUS), 0);
 	}
 
 	/*
@@ -842,7 +816,7 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
 	int i;
 
 	for (i = 0; i < this_cpu_read(mce_num_banks); i++) {
-		m->status = mce_rdmsrl(msr_ops.status(i));
+		m->status = mce_rdmsrl(mca_msr_reg(i, MCA_STATUS));
 		if (!(m->status & MCI_STATUS_VAL))
 			continue;
 
@@ -1143,7 +1117,7 @@ static void mce_clear_state(unsigned long *toclear)
 
 	for (i = 0; i < this_cpu_read(mce_num_banks); i++) {
 		if (test_bit(i, toclear))
-			mce_wrmsrl(msr_ops.status(i), 0);
+			mce_wrmsrl(mca_msr_reg(i, MCA_STATUS), 0);
 	}
 }
 
@@ -1202,7 +1176,7 @@ static void __mc_scan_banks(struct mce *m, struct pt_regs *regs, struct mce *fin
 		m->addr = 0;
 		m->bank = i;
 
-		m->status = mce_rdmsrl(msr_ops.status(i));
+		m->status = mce_rdmsrl(mca_msr_reg(i, MCA_STATUS));
 		if (!(m->status & MCI_STATUS_VAL))
 			continue;
 
@@ -1699,8 +1673,8 @@ static void __mcheck_cpu_init_clear_banks(void)
 
 		if (!b->init)
 			continue;
-		wrmsrl(msr_ops.ctl(i), b->ctl);
-		wrmsrl(msr_ops.status(i), 0);
+		wrmsrl(mca_msr_reg(i, MCA_CTL), b->ctl);
+		wrmsrl(mca_msr_reg(i, MCA_STATUS), 0);
 	}
 }
 
@@ -1726,7 +1700,7 @@ static void __mcheck_cpu_check_banks(void)
 		if (!b->init)
 			continue;
 
-		rdmsrl(msr_ops.ctl(i), msrval);
+		rdmsrl(mca_msr_reg(i, MCA_CTL), msrval);
 		b->init = !!msrval;
 	}
 }
@@ -1883,13 +1857,6 @@ static void __mcheck_cpu_init_early(struct cpuinfo_x86 *c)
 		mce_flags.succor	 = !!cpu_has(c, X86_FEATURE_SUCCOR);
 		mce_flags.smca		 = !!cpu_has(c, X86_FEATURE_SMCA);
 		mce_flags.amd_threshold	 = 1;
-
-		if (mce_flags.smca) {
-			msr_ops.ctl	= smca_ctl_reg;
-			msr_ops.status	= smca_status_reg;
-			msr_ops.addr	= smca_addr_reg;
-			msr_ops.misc	= smca_misc_reg;
-		}
 	}
 }
 
@@ -2265,7 +2232,7 @@ static void mce_disable_error_reporting(void)
 		struct mce_bank *b = &mce_banks[i];
 
 		if (b->init)
-			wrmsrl(msr_ops.ctl(i), 0);
+			wrmsrl(mca_msr_reg(i, MCA_CTL), 0);
 	}
 	return;
 }
@@ -2617,7 +2584,7 @@ static void mce_reenable_cpu(void)
 		struct mce_bank *b = &mce_banks[i];
 
 		if (b->init)
-			wrmsrl(msr_ops.ctl(i), b->ctl);
+			wrmsrl(mca_msr_reg(i, MCA_CTL), b->ctl);
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/mce/internal.h b/arch/x86/kernel/cpu/mce/internal.h
index 80dc94313bcf..760b57814760 100644
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -168,14 +168,14 @@ struct mce_vendor_flags {
 
 extern struct mce_vendor_flags mce_flags;
 
-struct mca_msr_regs {
-	u32 (*ctl)	(int bank);
-	u32 (*status)	(int bank);
-	u32 (*addr)	(int bank);
-	u32 (*misc)	(int bank);
+enum mca_msr {
+	MCA_CTL,
+	MCA_STATUS,
+	MCA_ADDR,
+	MCA_MISC,
 };
 
-extern struct mca_msr_regs msr_ops;
+u32 mca_msr_reg(int bank, enum mca_msr reg);
 
 /* Decide whether to add MCE record to MCE event pool or filter it out. */
 extern bool filter_mce(struct mce *m);
-- 
2.35.1



