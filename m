Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0FA32B03C
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbhCCAd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351122AbhCBNbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 08:31:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0C1E64F50;
        Tue,  2 Mar 2021 11:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686214;
        bh=FsbxVUZQEbNKwnaiELpYl6GatbDluX+gvj5fOZZgdW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mz/meOVX100FpGRuuUKI/CcXhoschJyF+NCb2WvPzq8OGBaOZu3k9VEuaUwvrG9Mj
         rILQhQBdXi4lbWvML/r7gOGJKiF1QO5Hcr0hHBUKi2M6DTcl0jb6tO9J+49LK1yu7z
         6SXObf9F8pirtT6rCc8OTrN7IUl/Wu+mvGIdE/iEHSwouWAaKlRnjXEPSeLiRx6gOL
         CjuNQmQWfh/1QXftxSdEJQGD8IO06DxoIUCeoeMmeyGPDItPgJKFUnzMgEmSF7VANd
         UGDnfqEp0tE+019WR+LrsCroJdr2CmFP6sbeyJaPQLzof+cEKzTHSj2Q9eq6wH3spr
         ymupVX852YkKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/47] scsi: ufs: Introduce a quirk to allow only page-aligned sg entries
Date:   Tue,  2 Mar 2021 06:56:04 -0500
Message-Id: <20210302115646.62291-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiwoong Kim <kwmad.kim@samsung.com>

[ Upstream commit 2b2bfc8aa519f696087475ed8e8c61850c673272 ]

Some SoCs require a single scatterlist entry for smaller than page size,
i.e. 4KB. When dispatching commands with more than one scatterlist entry
under 4KB in size the following behavior is observed:

A command to read a block range is dispatched with two scatterlist entries
that are named AAA and BBB. After dispatching, the host builds two PRDT
entries and during transmission, device sends just one DATA IN because
device doesn't care about host DMA. The host then transfers the combined
amount of data from start address of the area named AAA. As a consequence,
the area that follows AAA in memory would be corrupted.

    |<------------->|
    +-------+------------         +-------+
    +  AAA  + (corrupted)   ...   +  BBB  +
    +-------+------------         +-------+

To avoid this we need to enforce page size alignment for sg entries.

Link: https://lore.kernel.org/r/56dddef94f60bd9466fd77e69f64bbbd657ed2a1.1611026909.git.kwmad.kim@samsung.com
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 ++
 drivers/scsi/ufs/ufshcd.h | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e602c08d740b..97d9d5d99adc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4748,6 +4748,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct request_queue *q = sdev->request_queue;
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
+	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
+		blk_queue_update_dma_alignment(q, PAGE_SIZE - 1);
 
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index fcca4e15c8cd..a0bc118f9188 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -550,6 +550,10 @@ enum ufshcd_quirks {
 	 */
 	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
 
+	/*
+	 * This quirk allows only sg entries aligned with page size.
+	 */
+	UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE		= 1 << 13,
 };
 
 enum ufshcd_caps {
-- 
2.30.1

