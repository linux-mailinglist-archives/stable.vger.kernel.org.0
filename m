Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEA8E17AA83
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 17:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgCEQaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 11:30:12 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40193 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgCEQaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 11:30:12 -0500
Received: by mail-ed1-f67.google.com with SMTP id a13so7522246edu.7;
        Thu, 05 Mar 2020 08:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=er+u9V77ih48BVeG57U+ehFeWhGkKdoyt7DvlKYwru8=;
        b=n8JzhLk3k+K8+UvPzTNYMLK8WxV5ZFNM6r7g1yK5Jt5Tl6QBW/a0n1B0Kez2uBjkEw
         FALHHSIQxWyIknxV/320yk6iu5S7Tz+ihg7eZpInVndQ3NHYbSNCVmbkRBSj3GKdkXgK
         yIqpaUTYSd/RX6rko+pCTwLwZooXOW7FDgRj5nFDgh0GdthCn3BkMoOsAfey//7WgqEU
         pNNYyHWqeQGIynlkIXdPMKtAUoSc5cKFrUuwgA38ziLhNzC4GOP7ZVc6qPUwPghiVOMM
         Ys0kGFMPynm37gzS/pchE1M93HZlVOXQ2TqPzUe6JrKjduCZpMcAi5mfhaR8i843Vj3u
         Cj0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=er+u9V77ih48BVeG57U+ehFeWhGkKdoyt7DvlKYwru8=;
        b=pUGVDSsnwx+yVPLBnibcsEkRqNDSbp9bWQO8E+Ufvjyim+lEYa1DkivCf6/PigLwQG
         5hOP1LwsvVvP9oDO/iTIgPu4vHxksX31cMofxD9GI9tXGnp04lQ38I5S6EifuYtIN10l
         CeephB0Kb29DB1yyC1jz7JS78bpFHKfRd9MkqGwUc6+0vtY+cYzIROGBJlf8lwDqmaL2
         Fz4jSxjGXTDlxwH9Rv2dqS80YIJTdcgKUV4URMuODwvAjHqb/7xcn2waVYSQhTQNXWPO
         Wy/a231hWIqGNrBaGlkSP7edHd3yEId3DWkOCnAj+6h/40Bzh9ZhMYOaa0jnEfFc5kHp
         U/hQ==
X-Gm-Message-State: ANhLgQ1JBE7VzvZUDX2DMiqq591En9nwpBJoBW1d7PpncKSqgyEMmZ7Q
        4RAKRM6ZwpKHxY+koQ8GcEY=
X-Google-Smtp-Source: ADFU+vtm8cHwzJrp9yfvX5j9g16j2RO2hko1IdG5FTvZiqCFmtnIqa8+ZhgzBHCVd6DOg8Qamwu56A==
X-Received: by 2002:a05:6402:22b0:: with SMTP id cx16mr9483964edb.263.1583425810127;
        Thu, 05 Mar 2020 08:30:10 -0800 (PST)
Received: from jwang-Latitude-5491.pb.local ([2001:1438:4010:2558:d8ec:cf8e:d7de:fb22])
        by smtp.gmail.com with ESMTPSA id h22sm293651edq.28.2020.03.05.08.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 08:30:09 -0800 (PST)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        linux-edac <linux-edac@vger.kernel.org>, Pu Wen <puwen@hygon.cn>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        x86-ml <x86@kernel.org>, Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [stable-4.14 2/3] x86/mce: Handle varying MCA bank counts
Date:   Thu,  5 Mar 2020 17:30:06 +0100
Message-Id: <20200305163007.25659-3-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305163007.25659-1-jinpuwang@gmail.com>
References: <20200305163007.25659-1-jinpuwang@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

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
[jwang: cherry-pick to fix boot warning in
arch/x86/kernel/cpu/mcheck/mce.c:1549 in epyc rome server]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 arch/x86/kernel/cpu/mcheck/mce-inject.c | 14 +++++++-------
 arch/x86/kernel/cpu/mcheck/mce.c        | 22 +++++++---------------
 2 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index f12141ba9a76..e57b59762f9f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -46,8 +46,6 @@
 static struct mce i_mce;
 static struct dentry *dfs_inj;
 
-static u8 n_banks;
-
 #define MAX_FLAG_OPT_SIZE	4
 #define NBCFG			0x44
 
@@ -570,9 +568,15 @@ static void do_inject(void)
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
 
@@ -665,10 +669,6 @@ static struct dfs_node {
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
index 0b0e44f85393..95c09db1bba2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1499,13 +1499,12 @@ EXPORT_SYMBOL_GPL(mce_notify_irq);
 static int __mcheck_cpu_mce_banks_init(void)
 {
 	int i;
-	u8 num_banks = mca_cfg.banks;
 
-	mce_banks = kzalloc(num_banks * sizeof(struct mce_bank), GFP_KERNEL);
+	mce_banks = kcalloc(MAX_NR_BANKS, sizeof(struct mce_bank), GFP_KERNEL);
 	if (!mce_banks)
 		return -ENOMEM;
 
-	for (i = 0; i < num_banks; i++) {
+	for (i = 0; i < MAX_NR_BANKS; i++) {
 		struct mce_bank *b = &mce_banks[i];
 
 		b->ctl = -1ULL;
@@ -1519,28 +1518,19 @@ static int __mcheck_cpu_mce_banks_init(void)
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
@@ -2470,6 +2460,8 @@ EXPORT_SYMBOL_GPL(mcsafe_key);
 
 static int __init mcheck_late_init(void)
 {
+	pr_info("Using %d MCE banks\n", mca_cfg.banks);
+
 	if (mca_cfg.recovery)
 		static_branch_inc(&mcsafe_key);
 
-- 
2.17.1

