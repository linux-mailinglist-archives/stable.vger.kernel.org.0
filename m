Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66096AEA14
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjCGRah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:30:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbjCGRaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:30:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B33A7287
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:25:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B213B819AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49536C433EF;
        Tue,  7 Mar 2023 17:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209926;
        bh=/JonikviO08kni1fHh3PaZzKxrm6nGQvEz0ZYsZ3S9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAtzokHtOIdYa+55oZq3EES8xxkQsYW8nP46s34g1fp0Dn0ZyhwkjqoMoUGyO7r94
         MasPnXFJRZAcaNGIj4u32HEsiQWWsUqgxuTqyZ06Dep+xKjJ5ITPFbMbE10RFrCD83
         FCV1QN5OE8MUjZIfu7YWpeAFFwnRIC0w+alCRHWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kiwoong Kim <kwmad.kim@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0376/1001] scsi: ufs: exynos: Fix DMA alignment for PAGE_SIZE != 4096
Date:   Tue,  7 Mar 2023 17:52:28 +0100
Message-Id: <20230307170037.687131135@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 86bd0c4a2a5dc4265884648cb92c681646509692 ]

The Exynos UFS controller only supports scatter/gather list elements that
are aligned on a 4 KiB boundary. Fix DMA alignment in case PAGE_SIZE !=
4096. Rename UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE into
UFSHCD_QUIRK_4KB_DMA_ALIGNMENT.

Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Fixes: 2b2bfc8aa519 ("scsi: ufs: Introduce a quirk to allow only page-aligned sg entries")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Tested-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c     | 4 ++--
 drivers/ufs/host/ufs-exynos.c | 2 +-
 include/ufs/ufshcd.h          | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 3a1c4d31e010d..fd6f421ff4a46 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5030,8 +5030,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	ufshcd_hpb_configure(hba, sdev);
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
-	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
-		blk_queue_update_dma_alignment(q, PAGE_SIZE - 1);
+	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
+		blk_queue_update_dma_alignment(q, 4096 - 1);
 	/*
 	 * Block runtime-pm until all consumers are added.
 	 * Refer ufshcd_setup_links().
diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index c3628a8645a56..3cdac89a28b81 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1673,7 +1673,7 @@ static const struct exynos_ufs_drv_data exynos_ufs_drvs = {
 				  UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
 				  UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
 				  UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING |
-				  UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE,
+				  UFSHCD_QUIRK_4KB_DMA_ALIGNMENT,
 	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
 				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 727084cd79be4..97a09a14c6349 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -566,9 +566,9 @@ enum ufshcd_quirks {
 	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
 
 	/*
-	 * This quirk allows only sg entries aligned with page size.
+	 * Align DMA SG entries on a 4 KiB boundary.
 	 */
-	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 14,
+	UFSHCD_QUIRK_4KB_DMA_ALIGNMENT			= 1 << 14,
 
 	/*
 	 * This quirk needs to be enabled if the host controller does not
-- 
2.39.2



