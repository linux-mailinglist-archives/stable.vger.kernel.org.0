Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82634996B0
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347198AbiAXVFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:05:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51470 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359090AbiAXU62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:58:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E9EB6136A;
        Mon, 24 Jan 2022 20:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74BBC33E2A;
        Mon, 24 Jan 2022 20:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057905;
        bh=V1/GE+ipgnFiumzM9fD21tp0S16TTWKVT62r/khFqjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3MjMcwNJYV3DqL88egH9NRNPd72dA0x25vqC5oHdPStijHsBQW5V7t5LaEbPtWPR
         WhbuyA9hkLHpeh7ULVw/qRwb33XfreEt2q7ovQOUdcC8b/EBV/uoTuc7/ALWB3iLSL
         pUAOmKggt/xfvGcrdmfWaJajeMg/1FS/F5VtlNOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>,
        Rameshkumar Sundaram <ramess@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0116/1039] ath11k: Send PPDU_STATS_CFG with proper pdev mask to firmware
Date:   Mon, 24 Jan 2022 19:31:45 +0100
Message-Id: <20220124184129.040711646@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rameshkumar Sundaram <ramess@codeaurora.org>

[ Upstream commit 16a2c3d5406f95ef6139de52669c60a39443f5f7 ]

HTT_PPDU_STATS_CFG_PDEV_ID bit mask for target FW PPDU stats request message
was set as bit 8 to 15. Bit 8 is reserved for soc stats and pdev id starts from
bit 9. Hence change the bitmask as bit 9 to 15 and fill the proper pdev id in
the request message.

In commit 701e48a43e15 ("ath11k: add packet log support for QCA6390"), both
HTT_PPDU_STATS_CFG_PDEV_ID and pdev_mask were changed, but this pdev_mask
calculation is not valid for platforms which has multiple pdevs with 1 rxdma
per pdev, as this is writing same value(i.e. 2) for all pdevs.  Hence fixed it
to consider pdev_idx as well, to make it compatible for both single and multi
pd cases.

Tested on: IPQ8074 hw2.0 AHB WLAN.HK.2.5.0.1-01092-QCAHKSWPL_SILICONZ-1
Tested on: IPQ6018 hw1.0 WLAN.HK.2.5.0.1-01067-QCAHKSWPL_SILICONZ-1

Fixes: 701e48a43e15 ("ath11k: add packet log support for QCA6390")

Co-developed-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
Signed-off-by: Rameshkumar Sundaram <ramess@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210721212029.142388-10-jouni@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp.h    | 3 ++-
 drivers/net/wireless/ath/ath11k/dp_tx.c | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp.h b/drivers/net/wireless/ath/ath11k/dp.h
index 4794ca04f2136..f524d19aca349 100644
--- a/drivers/net/wireless/ath/ath11k/dp.h
+++ b/drivers/net/wireless/ath/ath11k/dp.h
@@ -517,7 +517,8 @@ struct htt_ppdu_stats_cfg_cmd {
 } __packed;
 
 #define HTT_PPDU_STATS_CFG_MSG_TYPE		GENMASK(7, 0)
-#define HTT_PPDU_STATS_CFG_PDEV_ID		GENMASK(15, 8)
+#define HTT_PPDU_STATS_CFG_SOC_STATS		BIT(8)
+#define HTT_PPDU_STATS_CFG_PDEV_ID		GENMASK(15, 9)
 #define HTT_PPDU_STATS_CFG_TLV_TYPE_BITMASK	GENMASK(31, 16)
 
 enum htt_ppdu_stats_tag_type {
diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index 879fb2a9dc0c6..10b76f6f710b0 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -903,7 +903,7 @@ int ath11k_dp_tx_htt_h2t_ppdu_stats_req(struct ath11k *ar, u32 mask)
 		cmd->msg = FIELD_PREP(HTT_PPDU_STATS_CFG_MSG_TYPE,
 				      HTT_H2T_MSG_TYPE_PPDU_STATS_CFG);
 
-		pdev_mask = 1 << (i + 1);
+		pdev_mask = 1 << (ar->pdev_idx + i);
 		cmd->msg |= FIELD_PREP(HTT_PPDU_STATS_CFG_PDEV_ID, pdev_mask);
 		cmd->msg |= FIELD_PREP(HTT_PPDU_STATS_CFG_TLV_TYPE_BITMASK, mask);
 
-- 
2.34.1



