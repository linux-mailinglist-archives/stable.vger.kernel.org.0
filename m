Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89AF2E14A3
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgLWClr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:41:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729958AbgLWCXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06412229C5;
        Wed, 23 Dec 2020 02:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690180;
        bh=Wa3DOgXCw4joMzbcnvPmB1yM8gF9Zj4VxFT+kaS3pMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clJITbCB2p0eBQGJdxNb9wrjGU9RhpPNk6NEYfbOWEdi/iUSTXwuIzj82RBozH0bR
         99vtLArHuGSEu+AxL4K8k18f4iY2MbCETANlnolmD5XhyWmH8UdKf0DFEqCBk9/6gk
         7EBdwjeNVr0sdNMIlqoLEd0t0etdjvjtdXqbOq6tPlQSnbGYuN/in96JS6CW1zF5qs
         Rx9Pg/GTbsfI6N13SymCJnWO9UY+7HvvZIWf6yM2+2a+w0Gib7wB3EsQvx1QDlo/iv
         qDQ1/Nl/5jmh8xwutRaROJoH+42p77a9ue9+r4QN6QvDAFBdTsoonthN6pGDaezXfx
         bZOuMAUatJa3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     akshatzen <akshatzen@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Viswas G <Viswas.G@microchip.com>,
        Ruksar Devadi <Ruksar.devadi@microchip.com>,
        Radha Ramachandran <radha@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/66] scsi: pm80xx: Avoid busywait in FW ready check
Date:   Tue, 22 Dec 2020 21:21:51 -0500
Message-Id: <20201223022253.2793452-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: akshatzen <akshatzen@google.com>

[ Upstream commit 48cd6b38eb4f2874f091c4776ea1c26e7e4f967e ]

In function check_fw_ready() we busy wait using udelay. The CPU is not
released and we see need_resched failures.

Busy waiting is not necessary since we are in process context and we can
sleep instead. Replace udelay with msleep of 20 ms intervals while waiting
for firmware to become ready.

It has been verified that check_fw_ready is not being used in interrupt
context anywhere, hence it is safe to make this change.

Link: https://lore.kernel.org/r/20201102165528.26510-4-Viswas.G@microchip.com.com
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: akshatzen <akshatzen@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 21 +++++++++++----------
 drivers/scsi/pm8001/pm80xx_hwi.h |  6 ++++++
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index df5f0bc295875..50e0890ddc678 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -692,6 +692,7 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 
 /**
  * check_fw_ready - The LLDD check if the FW is ready, if not, return error.
+ * This function sleeps hence it must not be used in atomic context.
  * @pm8001_ha: our hba card information
  */
 static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
@@ -702,16 +703,16 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	int ret = 0;
 
 	/* reset / PCIe ready */
-	max_wait_time = max_wait_count = 100 * 1000;	/* 100 milli sec */
+	max_wait_time = max_wait_count = 5;	/* 100 milli sec */
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 	} while ((value == 0xFFFFFFFF) && (--max_wait_count));
 
 	/* check ila status */
-	max_wait_time = max_wait_count = 1000 * 1000;	/* 1000 milli sec */
+	max_wait_time = max_wait_count = 50;	/* 1000 milli sec */
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 	} while (((value & SCRATCH_PAD_ILA_READY) !=
 			SCRATCH_PAD_ILA_READY) && (--max_wait_count));
@@ -724,9 +725,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	}
 
 	/* check RAAE status */
-	max_wait_time = max_wait_count = 1800 * 1000;	/* 1800 milli sec */
+	max_wait_time = max_wait_count = 90;	/* 1800 milli sec */
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 	} while (((value & SCRATCH_PAD_RAAE_READY) !=
 				SCRATCH_PAD_RAAE_READY) && (--max_wait_count));
@@ -739,9 +740,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	}
 
 	/* check iop0 status */
-	max_wait_time = max_wait_count = 600 * 1000;	/* 600 milli sec */
+	max_wait_time = max_wait_count = 30;	/* 600 milli sec */
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 	} while (((value & SCRATCH_PAD_IOP0_READY) != SCRATCH_PAD_IOP0_READY) &&
 			(--max_wait_count));
@@ -757,9 +758,9 @@ static int check_fw_ready(struct pm8001_hba_info *pm8001_ha)
 	if ((pm8001_ha->chip_id != chip_8008) &&
 			(pm8001_ha->chip_id != chip_8009)) {
 		/* 200 milli sec */
-		max_wait_time = max_wait_count = 200 * 1000;
+		max_wait_time = max_wait_count = 10;
 		do {
-			udelay(1);
+			msleep(FW_READY_INTERVAL);
 			value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_1);
 		} while (((value & SCRATCH_PAD_IOP1_READY) !=
 				SCRATCH_PAD_IOP1_READY) && (--max_wait_count));
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 411b414a9a0ef..85cdd6d9348a6 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1534,3 +1534,9 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 
 #define MEMBASE_II_SHIFT_REGISTER       0x1010
 #endif
+
+/**
+ * As we know sleep (1~20) ms may result in sleep longer than ~20 ms, hence we
+ * choose 20 ms interval.
+ */
+#define FW_READY_INTERVAL	20
-- 
2.27.0

