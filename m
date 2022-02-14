Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE14B477C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245163AbiBNJsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:48:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343678AbiBNJqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:46:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA6C25C4D;
        Mon, 14 Feb 2022 01:39:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBB9FB80DA9;
        Mon, 14 Feb 2022 09:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5952C340E9;
        Mon, 14 Feb 2022 09:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831585;
        bh=DliUIAbOhT7PflrHsH2KMRlmp6VOx0lJtRmJdkFXJXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M4cb2aFoH1IFGQhQ37GrstAaOvIJF8zO5lMJ9qTO6o2O3jmz/gGBc+wcYgVW9LniQ
         SDDxNCAUxsAZvLut9upX45Y8Ssm8qyIvzHmhtynA+I1S6SOu0vy9VpFmCBbVZFLS2q
         d1iTdGzsJXKpxbJV0gTTYb9tqxL+JgRz8Ochqr1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/116] scsi: pm8001: Fix bogus FW crash for maxcpus=1
Date:   Mon, 14 Feb 2022 10:25:28 +0100
Message-Id: <20220214092459.689498513@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index a203a4fc2674a..b22a8ab754faa 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4057,10 +4057,22 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	unsigned long flags;
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
index 701951a0f715b..0dfe9034f7e7f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1391,8 +1391,12 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
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



