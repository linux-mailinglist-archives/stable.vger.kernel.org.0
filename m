Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1354A8D88
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354323AbiBCUbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:31:33 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34320 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354337AbiBCUbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77D40B83556;
        Thu,  3 Feb 2022 20:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41644C340EF;
        Thu,  3 Feb 2022 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920267;
        bh=bjoUDtJjdYhBbXWDCNWeCPkAHE8XCLOofGzvfH6ksWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CF+vp0N2al/KtjuCOGU4mx/c1b6chrIYR6SHU0n36uzINm7k1/TY4vMV9KCvQ+8Tr
         QEkhkd6bZUrZpERwVMd+iYnTE1uTA8gkXUkRheC2qefCSM1y2haZmikmjXdVMcP6ry
         vDRsbAbWdhGQl1xftxK4toU3sa6cDvtX8uFG4b88rOOfUvVKBzYtnPc7W2aJPPKygy
         +vSPmxtaL1M5IW6WjsYBBNbcDNiDMXiOAZLP7KSaY1pwE3iIXqsjPcvOqajQk2pii+
         Q0mu4FQeorLcBXy4kG0gSgEE1hEgTtcmCs90OAJ3a8no/rFQ7l7d3HRrX9ARAFerW3
         TvQvwNyBhRQLw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 31/52] scsi: pm8001: Fix bogus FW crash for maxcpus=1
Date:   Thu,  3 Feb 2022 15:29:25 -0500
Message-Id: <20220203202947.2304-31-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 62afb379a0fee7e9c2f9f68e1abeb85ceddf51b9 ]

According to the comment in check_fw_ready() we should not check the
IOP1_READY field in register SCRATCH_PAD_1 for 8008 or 8009 controllers.

However we check this very field in process_oq() for processing the highest
index interrupt vector. The highest interrupt vector is checked as the FW
is programmed to signal fatal errors through this irq.

Change that function to not check IOP1_READY for those mentioned
controllers, but do check ILA_READY in both cases.

The reason I assume that this was not hit earlier was because we always
allocated 64 MSI(X), and just did not pass the vector index check in
process_oq(), i.e.  the handler never ran for vector index 63.

Link: https://lore.kernel.org/r/1642508105-95432-1-git-send-email-john.garry@huawei.com
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 16 ++++++++++++++--
 drivers/scsi/pm8001/pm80xx_hwi.h |  6 +++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 2101fc5761c3c..4c5b945bf3187 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4161,10 +4161,22 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	u32 ret = MPI_IO_STATUS_FAIL;
 	u32 regval;
 
+	/*
+	 * Fatal errors are programmed to be signalled in irq vector
+	 * pm8001_ha->max_q_num - 1 through pm8001_ha->main_cfg_tbl.pm80xx_tbl.
+	 * fatal_err_interrupt
+	 */
 	if (vec == (pm8001_ha->max_q_num - 1)) {
+		u32 mipsall_ready;
+
+		if (pm8001_ha->chip_id == chip_8008 ||
+		    pm8001_ha->chip_id == chip_8009)
+			mipsall_ready = SCRATCH_PAD_MIPSALL_READY_8PORT;
+		else
+			mipsall_ready = SCRATCH_PAD_MIPSALL_READY_16PORT;
+
 		regval = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
-		if ((regval & SCRATCH_PAD_MIPSALL_READY) !=
-					SCRATCH_PAD_MIPSALL_READY) {
+		if ((regval & mipsall_ready) != mipsall_ready) {
 			pm8001_ha->controller_fatal_error = true;
 			pm8001_dbg(pm8001_ha, FAIL,
 				   "Firmware Fatal error! Regval:0x%x\n",
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index c7e5d93bea924..c41ed039c92ac 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1405,8 +1405,12 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 #define SCRATCH_PAD_BOOT_LOAD_SUCCESS	0x0
 #define SCRATCH_PAD_IOP0_READY		0xC00
 #define SCRATCH_PAD_IOP1_READY		0x3000
-#define SCRATCH_PAD_MIPSALL_READY	(SCRATCH_PAD_IOP1_READY | \
+#define SCRATCH_PAD_MIPSALL_READY_16PORT	(SCRATCH_PAD_IOP1_READY | \
 					SCRATCH_PAD_IOP0_READY | \
+					SCRATCH_PAD_ILA_READY | \
+					SCRATCH_PAD_RAAE_READY)
+#define SCRATCH_PAD_MIPSALL_READY_8PORT	(SCRATCH_PAD_IOP0_READY | \
+					SCRATCH_PAD_ILA_READY | \
 					SCRATCH_PAD_RAAE_READY)
 
 /* boot loader state */
-- 
2.34.1

