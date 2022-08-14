Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3D059215B
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240797AbiHNPgq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240808AbiHNPfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD401CFE8;
        Sun, 14 Aug 2022 08:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CB0660B90;
        Sun, 14 Aug 2022 15:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D272C433D6;
        Sun, 14 Aug 2022 15:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491053;
        bh=GUcB9eD+iEOCbxU+UeqApPApFnGb+Rc+D67AbgcVBCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5D7+MeVhbc7r0SHjDXpq0utDRIKmYYf3zhbTfJGLxhiy9XcSrynPlN/TYlcdv6me
         28R7r+Hg7CR8qR2vmDQh0mvup7V9tWFlVj/et0HS42Qs3HIlmgwT0AqLqGIKBJ7AVW
         9Wh/oVlEfv/Fm+P+EgQV+9d7yN5FAyz5JgC+BNqcUpyfkv3optUghbibjB1oMFW4z3
         KvULYg3tHmKnGAdSYYxCnBBm8xVlODnHEVcwyOwPSqfIVD9gq/V6sLd/+/S90FY7RG
         WTteFwKLrd575pu8lS/QKfohehxyRicUayynEteHhSdgU6jtNIcl4xVLbZn/BTcKaC
         n2+6QPEX7VZOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        bvanassche@acm.org, beanhuo@micron.com, avri.altman@wdc.com,
        adrian.hunter@intel.com, j-young.choi@samsung.com,
        ebiggers@google.com, jjmin.jeong@samsung.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 11/56] scsi: ufs: core: Add UFSHCD_QUIRK_HIBERN_FASTAUTO
Date:   Sun, 14 Aug 2022 11:29:41 -0400
Message-Id: <20220814153026.2377377-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814153026.2377377-1-sashal@kernel.org>
References: <20220814153026.2377377-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 2f11bbc2c7f37e3a6151ac548b1c0679cc90ea83 ]

Add UFSHCD_QUIRK_HIBERN_FASTAUTO quirk for host controllers which supports
auto-hibernate the capability but only FASTAUTO mode.

Link: https://lore.kernel.org/r/20220603110524.1997825-4-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++++--
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 95be78549ed2..92de5b8d187c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4290,8 +4290,13 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 	if (hba->max_pwr_info.is_valid)
 		return 0;
 
-	pwr_info->pwr_tx = FAST_MODE;
-	pwr_info->pwr_rx = FAST_MODE;
+	if (hba->quirks & UFSHCD_QUIRK_HIBERN_FASTAUTO) {
+		pwr_info->pwr_tx = FASTAUTO_MODE;
+		pwr_info->pwr_rx = FASTAUTO_MODE;
+	} else {
+		pwr_info->pwr_tx = FAST_MODE;
+		pwr_info->pwr_rx = FAST_MODE;
+	}
 	pwr_info->hs_rate = PA_HS_MODE_B;
 
 	/* Get the connected lane count */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1745144eb904..d14cc48226ce 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -608,6 +608,12 @@ enum ufshcd_quirks {
 	 * 64-bit addressing supported capability but it doesn't work.
 	 */
 	UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS		= 1 << 17,
+
+	/*
+	 * This quirk needs to be enabled if the host controller has
+	 * auto-hibernate capability but it's FASTAUTO only.
+	 */
+	UFSHCD_QUIRK_HIBERN_FASTAUTO			= 1 << 18,
 };
 
 enum ufshcd_caps {
-- 
2.35.1

