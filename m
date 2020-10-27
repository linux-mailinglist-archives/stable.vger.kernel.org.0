Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7805B29BCBF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802432AbgJ0Qg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766567AbgJ0Pry (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:47:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D93FD207C3;
        Tue, 27 Oct 2020 15:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813673;
        bh=qJcaBPI2mpjKRF25A9fT+An3OTp2VsJhIqAmscVe8WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PnrwScJmTbj1P1G4sg4x2U5fiN+cH/C0AbQI3B9JU4vlEN0hNjXfDIOn1qCulCiV/
         j2MNtR8NI0O7LLs3bkmw2xDsawLG6HbELj8bxNX5pSDJrAKGAtDXMq/kJgjDQ7q8F3
         Lhr6XmfkJ/TLQAO2X3KcI7Fupn0sJoXgkwPwgFfc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ganesh Goudar <ganeshgr@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 631/757] powerpc/pseries: Avoid using addr_to_pfn in real mode
Date:   Tue, 27 Oct 2020 14:54:41 +0100
Message-Id: <20201027135520.141286265@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ganesh Goudar <ganeshgr@linux.ibm.com>

[ Upstream commit 4ff753feab021242144818b9a3ba011238218145 ]

When an UE or memory error exception is encountered the MCE handler
tries to find the pfn using addr_to_pfn() which takes effective
address as an argument, later pfn is used to poison the page where
memory error occurred, recent rework in this area made addr_to_pfn
to run in real mode, which can be fatal as it may try to access
memory outside RMO region.

Have two helper functions to separate things to be done in real mode
and virtual mode without changing any functionality. This also fixes
the following error as the use of addr_to_pfn is now moved to virtual
mode.

Without this change following kernel crash is seen on hitting UE.

[  485.128036] Oops: Kernel access of bad area, sig: 11 [#1]
[  485.128040] LE SMP NR_CPUS=2048 NUMA pSeries
[  485.128047] Modules linked in:
[  485.128067] CPU: 15 PID: 6536 Comm: insmod Kdump: loaded Tainted: G OE 5.7.0 #22
[  485.128074] NIP:  c00000000009b24c LR: c0000000000398d8 CTR: c000000000cd57c0
[  485.128078] REGS: c000000003f1f970 TRAP: 0300   Tainted: G OE (5.7.0)
[  485.128082] MSR:  8000000000001003 <SF,ME,RI,LE>  CR: 28008284  XER: 00000001
[  485.128088] CFAR: c00000000009b190 DAR: c0000001fab00000 DSISR: 40000000 IRQMASK: 1
[  485.128088] GPR00: 0000000000000001 c000000003f1fbf0 c000000001634300 0000b0fa01000000
[  485.128088] GPR04: d000000002220000 0000000000000000 00000000fab00000 0000000000000022
[  485.128088] GPR08: c0000001fab00000 0000000000000000 c0000001fab00000 c000000003f1fc14
[  485.128088] GPR12: 0000000000000008 c000000003ff5880 d000000002100008 0000000000000000
[  485.128088] GPR16: 000000000000ff20 000000000000fff1 000000000000fff2 d0000000021a1100
[  485.128088] GPR20: d000000002200000 c00000015c893c50 c000000000d49b28 c00000015c893c50
[  485.128088] GPR24: d0000000021a0d08 c0000000014e5da8 d0000000021a0818 000000000000000a
[  485.128088] GPR28: 0000000000000008 000000000000000a c0000000017e2970 000000000000000a
[  485.128125] NIP [c00000000009b24c] __find_linux_pte+0x11c/0x310
[  485.128130] LR [c0000000000398d8] addr_to_pfn+0x138/0x170
[  485.128133] Call Trace:
[  485.128135] Instruction dump:
[  485.128138] 3929ffff 7d4a3378 7c883c36 7d2907b4 794a1564 7d294038 794af082 3900ffff
[  485.128144] 79291f24 790af00e 78e70020 7d095214 <7c69502a> 2fa30000 419e011c 70690040
[  485.128152] ---[ end trace d34b27e29ae0e340 ]---

Fixes: 9ca766f9891d ("powerpc/64s/pseries: machine check convert to use common event code")
Signed-off-by: Ganesh Goudar <ganeshgr@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200724063946.21378-1-ganeshgr@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/ras.c | 118 ++++++++++++++++-----------
 1 file changed, 69 insertions(+), 49 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index 13c86a292c6d7..b2b245b25edba 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -521,18 +521,55 @@ int pSeries_system_reset_exception(struct pt_regs *regs)
 	return 0; /* need to perform reset */
 }
 
+static int mce_handle_err_realmode(int disposition, u8 error_type)
+{
+#ifdef CONFIG_PPC_BOOK3S_64
+	if (disposition == RTAS_DISP_NOT_RECOVERED) {
+		switch (error_type) {
+		case	MC_ERROR_TYPE_SLB:
+		case	MC_ERROR_TYPE_ERAT:
+			/*
+			 * Store the old slb content in paca before flushing.
+			 * Print this when we go to virtual mode.
+			 * There are chances that we may hit MCE again if there
+			 * is a parity error on the SLB entry we trying to read
+			 * for saving. Hence limit the slb saving to single
+			 * level of recursion.
+			 */
+			if (local_paca->in_mce == 1)
+				slb_save_contents(local_paca->mce_faulty_slbs);
+			flush_and_reload_slb();
+			disposition = RTAS_DISP_FULLY_RECOVERED;
+			break;
+		default:
+			break;
+		}
+	} else if (disposition == RTAS_DISP_LIMITED_RECOVERY) {
+		/* Platform corrected itself but could be degraded */
+		pr_err("MCE: limited recovery, system may be degraded\n");
+		disposition = RTAS_DISP_FULLY_RECOVERED;
+	}
+#endif
+	return disposition;
+}
 
-static int mce_handle_error(struct pt_regs *regs, struct rtas_error_log *errp)
+static int mce_handle_err_virtmode(struct pt_regs *regs,
+				   struct rtas_error_log *errp,
+				   struct pseries_mc_errorlog *mce_log,
+				   int disposition)
 {
 	struct mce_error_info mce_err = { 0 };
-	unsigned long eaddr = 0, paddr = 0;
-	struct pseries_errorlog *pseries_log;
-	struct pseries_mc_errorlog *mce_log;
-	int disposition = rtas_error_disposition(errp);
 	int initiator = rtas_error_initiator(errp);
 	int severity = rtas_error_severity(errp);
+	unsigned long eaddr = 0, paddr = 0;
 	u8 error_type, err_sub_type;
 
+	if (!mce_log)
+		goto out;
+
+	error_type = mce_log->error_type;
+	err_sub_type = rtas_mc_error_sub_type(mce_log);
+
 	if (initiator == RTAS_INITIATOR_UNKNOWN)
 		mce_err.initiator = MCE_INITIATOR_UNKNOWN;
 	else if (initiator == RTAS_INITIATOR_CPU)
@@ -571,18 +608,7 @@ static int mce_handle_error(struct pt_regs *regs, struct rtas_error_log *errp)
 	mce_err.error_type = MCE_ERROR_TYPE_UNKNOWN;
 	mce_err.error_class = MCE_ECLASS_UNKNOWN;
 
-	if (!rtas_error_extended(errp))
-		goto out;
-
-	pseries_log = get_pseries_errorlog(errp, PSERIES_ELOG_SECT_ID_MCE);
-	if (pseries_log == NULL)
-		goto out;
-
-	mce_log = (struct pseries_mc_errorlog *)pseries_log->data;
-	error_type = mce_log->error_type;
-	err_sub_type = rtas_mc_error_sub_type(mce_log);
-
-	switch (mce_log->error_type) {
+	switch (error_type) {
 	case MC_ERROR_TYPE_UE:
 		mce_err.error_type = MCE_ERROR_TYPE_UE;
 		mce_common_process_ue(regs, &mce_err);
@@ -682,37 +708,31 @@ static int mce_handle_error(struct pt_regs *regs, struct rtas_error_log *errp)
 		mce_err.error_type = MCE_ERROR_TYPE_UNKNOWN;
 		break;
 	}
+out:
+	save_mce_event(regs, disposition == RTAS_DISP_FULLY_RECOVERED,
+		       &mce_err, regs->nip, eaddr, paddr);
+	return disposition;
+}
 
-#ifdef CONFIG_PPC_BOOK3S_64
-	if (disposition == RTAS_DISP_NOT_RECOVERED) {
-		switch (error_type) {
-		case	MC_ERROR_TYPE_SLB:
-		case	MC_ERROR_TYPE_ERAT:
-			/*
-			 * Store the old slb content in paca before flushing.
-			 * Print this when we go to virtual mode.
-			 * There are chances that we may hit MCE again if there
-			 * is a parity error on the SLB entry we trying to read
-			 * for saving. Hence limit the slb saving to single
-			 * level of recursion.
-			 */
-			if (local_paca->in_mce == 1)
-				slb_save_contents(local_paca->mce_faulty_slbs);
-			flush_and_reload_slb();
-			disposition = RTAS_DISP_FULLY_RECOVERED;
-			break;
-		default:
-			break;
-		}
-	} else if (disposition == RTAS_DISP_LIMITED_RECOVERY) {
-		/* Platform corrected itself but could be degraded */
-		printk(KERN_ERR "MCE: limited recovery, system may "
-		       "be degraded\n");
-		disposition = RTAS_DISP_FULLY_RECOVERED;
-	}
-#endif
+static int mce_handle_error(struct pt_regs *regs, struct rtas_error_log *errp)
+{
+	struct pseries_errorlog *pseries_log;
+	struct pseries_mc_errorlog *mce_log = NULL;
+	int disposition = rtas_error_disposition(errp);
+	u8 error_type;
+
+	if (!rtas_error_extended(errp))
+		goto out;
+
+	pseries_log = get_pseries_errorlog(errp, PSERIES_ELOG_SECT_ID_MCE);
+	if (!pseries_log)
+		goto out;
+
+	mce_log = (struct pseries_mc_errorlog *)pseries_log->data;
+	error_type = mce_log->error_type;
+
+	disposition = mce_handle_err_realmode(disposition, error_type);
 
-out:
 	/*
 	 * Enable translation as we will be accessing per-cpu variables
 	 * in save_mce_event() which may fall outside RMO region, also
@@ -723,10 +743,10 @@ static int mce_handle_error(struct pt_regs *regs, struct rtas_error_log *errp)
 	 * Note: All the realmode handling like flushing SLB entries for
 	 *       SLB multihit is done by now.
 	 */
+out:
 	mtmsr(mfmsr() | MSR_IR | MSR_DR);
-	save_mce_event(regs, disposition == RTAS_DISP_FULLY_RECOVERED,
-			&mce_err, regs->nip, eaddr, paddr);
-
+	disposition = mce_handle_err_virtmode(regs, errp, mce_log,
+					      disposition);
 	return disposition;
 }
 
-- 
2.25.1



