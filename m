Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D0432AF06
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhCCAOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:14:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1443473AbhCBL5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 06:57:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A86A164F18;
        Tue,  2 Mar 2021 11:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686143;
        bh=7g8UtlJwsXJhtU+uw66xDGlPqPQWabpsfn0k+UZabfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEUDs5/Gap+yHxolgdSOSQ/Unwax71XG3mLSPp6hryNaFGE5NPZOblpUGnsI5yHFQ
         4uKnb2jLDSf1lWhH+LsAbm4C/vJDhHB9/y46xXteAlSAcsjBmBOUPrbRgNGv80cH5C
         UXNSDfnvj39VOAQkDrDbhOtpE3uuifYd6y9PUF5e0vOmcpwdqasG1xpX/qYsx6czIi
         +TjHsdnNTTSb/9ai0ACA0Eb+s732Tdu30xVWuQWpns7Xj4ILmYeMXxdQw3rKV8/k4l
         RisyebXWFqYA+5bR6ws8RGt+n7WIVA1izW9vpWyOiY6o08j50hOf5HCLyU3HVEc96V
         Ervz4PiNttC0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 06/52] scsi: ufs: Introduce a quirk to allow only page-aligned sg entries
Date:   Tue,  2 Mar 2021 06:54:47 -0500
Message-Id: <20210302115534.61800-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115534.61800-1-sashal@kernel.org>
References: <20210302115534.61800-1-sashal@kernel.org>
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
index 48cbd4f294dd..3ab1702e5b04 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4829,6 +4829,8 @@ static int ufshcd_slave_configure(struct scsi_device *sdev)
 	struct request_queue *q = sdev->request_queue;
 
 	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD - 1);
+	if (hba->quirks & UFSHCD_QUIRK_ALIGN_SG_WITH_PAGE_SIZE)
+		blk_queue_update_dma_alignment(q, PAGE_SIZE - 1);
 
 	if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 85f9d0fbfbd9..8cb64ae95462 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -557,6 +557,10 @@ enum ufshcd_quirks {
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

