Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8627859208D
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240162AbiHNP24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240134AbiHNP23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:28:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F4BB1EC;
        Sun, 14 Aug 2022 08:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62ED1B80B56;
        Sun, 14 Aug 2022 15:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F08C433D6;
        Sun, 14 Aug 2022 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490901;
        bh=yWDQ9RtqIFVVwTO4cTahQSOk9mCzHcSac7SkVGICur4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bm/F5tB/oyeeVi/2omXYj0Q8C8fPuihHuigUk/TVRaREQCib7rNiDCl0msj7uKmhC
         tf4Tv3JuFnOfOE2sXuusrJLximRGbeHHExnSa5rL78obTroDbnp3YQPgw6atgwDQ0f
         ENS+xqWF1Yc66dlEMfiD52SVRivtqanQ0+Bbuhyt6KcHXYhda1ptYIcAX9DfG/Lyeb
         Yd9H5I8nzESFCznfgubaghMG6TLi9oLhqI7/NNM/i0MuhTh3s352UsubJYlMzs3+Ne
         eZwBNUZLnK7bAuWVu5qRrptljlHEDRhNeTiu7SCKZ7Zirzh5HUifkMRD0gkVZTjWKy
         VM406UnqxozOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        bvanassche@acm.org, beanhuo@micron.com, avri.altman@wdc.com,
        adrian.hunter@intel.com, jjmin.jeong@samsung.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 14/64] scsi: ufs: core: Add UFSHCD_QUIRK_HIBERN_FASTAUTO
Date:   Sun, 14 Aug 2022 11:23:47 -0400
Message-Id: <20220814152437.2374207-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220814152437.2374207-1-sashal@kernel.org>
References: <20220814152437.2374207-1-sashal@kernel.org>
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
 drivers/ufs/core/ufshcd.c | 9 +++++++--
 include/ufs/ufshcd.h      | 6 ++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dc5f0dfc8c79..7360a1fe52a7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4292,8 +4292,13 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
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
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 795c8951341d..991aea081ec7 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -583,6 +583,12 @@ enum ufshcd_quirks {
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

