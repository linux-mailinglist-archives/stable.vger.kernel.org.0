Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEC1592188
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbiHNPhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239858AbiHNPfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:35:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161B913D53;
        Sun, 14 Aug 2022 08:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63919B80B77;
        Sun, 14 Aug 2022 15:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC7EC433C1;
        Sun, 14 Aug 2022 15:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660491046;
        bh=USr/7H+W22phQatZu5Xppi2ymWAL1+5qrZm1balBdmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EO/IfEBs3sXyixftAeaB1nz3igTFztKHe1eiWlNSbjygqnQIGWWJpiL3d2xA5RNoM
         Uf/3i2y5RpMZCBjvAA3hMxmsIu/av8H9OtchZlmq2pJ4/oPqEAgkqQ5rd+UCnWxIMM
         VRV+JLGGKHWbbMstHVlG2K2r1tkmAD6FJSZHS38k6QCJXhAeA/FRTNvxWeBfHnqvyM
         CIKgmeGeTMk/knjrXLRHM5DQlt75WtEr9S7fYUOs3fUI/Q3I7TWjiG8xpvzQn0dokz
         BK0RjWPE7gpJW15vxXImyoZrn9J331upiEh3aumolXWFgYO5A6uqhiDEZtfrzWlgu3
         PtNDNN5Freo1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        bvanassche@acm.org, beanhuo@micron.com, avri.altman@wdc.com,
        adrian.hunter@intel.com, j-young.choi@samsung.com,
        ebiggers@google.com, jjmin.jeong@samsung.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 10/56] scsi: ufs: core: Add UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS
Date:   Sun, 14 Aug 2022 11:29:40 -0400
Message-Id: <20220814153026.2377377-10-sashal@kernel.org>
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

[ Upstream commit 6554400d6f66b9494a0c0f07712ab0a9d307eb01 ]

Add UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS for host controllers which do not
support 64-bit addressing.

Link: https://lore.kernel.org/r/20220603110524.1997825-3-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 874490f7f5e7..95be78549ed2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2210,6 +2210,8 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
 	int err;
 
 	hba->capabilities = ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS)
+		hba->capabilities &= ~MASK_64_ADDRESSING_SUPPORT;
 
 	/* nutrs and nutmrs are 0 based values */
 	hba->nutrs = (hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS) + 1;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 94f545be183a..1745144eb904 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -602,6 +602,12 @@ enum ufshcd_quirks {
 	 * support physical host configuration.
 	 */
 	UFSHCD_QUIRK_SKIP_PH_CONFIGURATION		= 1 << 16,
+
+	/*
+	 * This quirk needs to be enabled if the host controller has
+	 * 64-bit addressing supported capability but it doesn't work.
+	 */
+	UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS		= 1 << 17,
 };
 
 enum ufshcd_caps {
-- 
2.35.1

