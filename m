Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 513702F044
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731485AbfE3ECM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731385AbfE3DSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:02 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 744E224763;
        Thu, 30 May 2019 03:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186281;
        bh=fGKK+pcT+AlvrtG9AhPCrF4t6p1NfH72TS0Z4aRRBdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrsKF599cxtxoeIRgws6IL74MN7DI7NWIyCjHgeCivfjJ9ANi0FfjQFINuTO+c6+9
         Wm5xO/cewPJefF+3LG+H7tcRdgezI7d5k0S7meKwJETZiU/O/AZ1DYbnt3fg+ASw/i
         4QAzk1yWkoOMJXFJSqqCEOOPEdyMHPQHWkO7gndc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-edac <linux-edac@vger.kernel.org>, Pu Wen <puwen@hygon.cn>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/276] x86/mce: Handle varying MCA bank counts
Date:   Wed, 29 May 2019 20:06:31 -0700
Message-Id: <20190530030539.701299147@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 006c077041dc73b9490fffc4c6af5befe0687110 ]

Linux reads MCG_CAP[Count] to find the number of MCA banks visible to a
CPU. Currently, this number is the same for all CPUs and a warning is
shown if there is a difference. The number of banks is overwritten with
the MCG_CAP[Count] value of each following CPU that boots.

According to the Intel SDM and AMD APM, the MCG_CAP[Count] value gives
the number of banks that are available to a "processor implementation".
The AMD BKDGs/PPRs further clarify that this value is per core. This
value has historically been the same for every core in the system, but
that is not an architectural requirement.

Future AMD systems may have different MCG_CAP[Count] values per core,
so the assumption that all CPUs will have the same MCG_CAP[Count] value
will no longer be valid.

Also, the first CPU to boot will allocate the struct mce_banks[] array
using the number of banks based on its MCG_CAP[Count] value. The machine
check handler and other functions use the global number of banks to
iterate and index into the mce_banks[] array. So it's possible to use an
out-of-bounds index on an asymmetric system where a following CPU sees a
MCG_CAP[Count] value greater than its predecessors.

Thus, allocate the mce_banks[] array to the maximum number of banks.
This will avoid the potential out-of-bounds index since the value of
mca_cfg.banks is capped to MAX_NR_BANKS.

Set the value of mca_cfg.banks equal to the max of the previous value
and the value for the current CPU. This way mca_cfg.banks will always
represent the max number of banks detected on any CPU in the system.

This will ensure that all CPUs will access all the banks that are
visible to them. A CPU that can access fewer than the max number of
banks will find the registers of the extra banks to be read-as-zero.

Furthermore, print the resulting number of MCA banks in use. Do this in
mcheck_late_init() so that the final value is printed after all CPUs
have been initialized.

Finally, get bank count from target CPU when doing injection with mce-inject
module.

 [ bp: Remove out-of-bounds example, passify and cleanup commit message. ]

Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: Pu Wen <puwen@hygon.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20180727214009.78289-1-Yazen.Ghannam@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c | 14 +++++++-------
 arch/x86/kernel/cpu/mcheck/mce.c        | 22 +++++++---------------
 2 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index c805a06e14c38..ff1c00b695aed 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -46,8 +46,6 @@
 static struct mce i_mce;
 static struct dentry *dfs_inj;
 
-static u8 n_banks;
-
 #define MAX_FLAG_OPT_SIZE	4
 #define NBCFG			0x44
 
@@ -567,9 +565,15 @@ static void do_inject(void)
 static int inj_bank_set(void *data, u64 val)
 {
 	struct mce *m = (struct mce *)data;
+	u8 n_banks;
+	u64 cap;
+
+	/* Get bank count on target CPU so we can handle non-uniform values. */
+	rdmsrl_on_cpu(m->extcpu, MSR_IA32_MCG_CAP, &cap);
+	n_banks = cap & MCG_BANKCNT_MASK;
 
 	if (val >= n_banks) {
-		pr_err("Non-existent MCE bank: %llu\n", val);
+		pr_err("MCA bank %llu non-existent on CPU%d\n", val, m->extcpu);
 		return -EINVAL;
 	}
 
@@ -659,10 +663,6 @@ static struct dfs_node {
 static int __init debugfs_init(void)
 {
 	unsigned int i;
-	u64 cap;
-
-	rdmsrl(MSR_IA32_MCG_CAP, cap);
-	n_banks = cap & MCG_BANKCNT_MASK;
 
 	dfs_inj = debugfs_create_dir("mce-inject", NULL);
 	if (!dfs_inj)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 45bd926359f62..fee118b3b69fd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1480,13 +1480,12 @@ EXPORT_SYMBOL_GPL(mce_notify_irq);
 static int __mcheck_cpu_mce_banks_init(void)
 {
 	int i;
-	u8 num_banks = mca_cfg.banks;
 
-	mce_banks = kcalloc(num_banks, sizeof(struct mce_bank), GFP_KERNEL);
+	mce_banks = kcalloc(MAX_NR_BANKS, sizeof(struct mce_bank), GFP_KERNEL);
 	if (!mce_banks)
 		return -ENOMEM;
 
-	for (i = 0; i < num_banks; i++) {
+	for (i = 0; i < MAX_NR_BANKS; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		b->ctl = -1ULL;
@@ -1500,28 +1499,19 @@ static int __mcheck_cpu_mce_banks_init(void)
  */
 static int __mcheck_cpu_cap_init(void)
 {
-	unsigned b;
 	u64 cap;
+	u8 b;
 
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 
 	b = cap & MCG_BANKCNT_MASK;
-	if (!mca_cfg.banks)
-		pr_info("CPU supports %d MCE banks\n", b);
-
-	if (b > MAX_NR_BANKS) {
-		pr_warn("Using only %u machine check banks out of %u\n",
-			MAX_NR_BANKS, b);
+	if (WARN_ON_ONCE(b > MAX_NR_BANKS))
 		b = MAX_NR_BANKS;
-	}
 
-	/* Don't support asymmetric configurations today */
-	WARN_ON(mca_cfg.banks != 0 && b != mca_cfg.banks);
-	mca_cfg.banks = b;
+	mca_cfg.banks = max(mca_cfg.banks, b);
 
 	if (!mce_banks) {
 		int err = __mcheck_cpu_mce_banks_init();
-
 		if (err)
 			return err;
 	}
@@ -2503,6 +2493,8 @@ EXPORT_SYMBOL_GPL(mcsafe_key);
 
 static int __init mcheck_late_init(void)
 {
+	pr_info("Using %d MCE banks\n", mca_cfg.banks);
+
 	if (mca_cfg.recovery)
 		static_branch_inc(&mcsafe_key);
 
-- 
2.20.1



