Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7098E333E45
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbhCJNZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:46738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233236AbhCJNZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:25:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9365F64FF7;
        Wed, 10 Mar 2021 13:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382708;
        bh=kZq5hc93neSL74M+vk8fXw0dLZp9MBr5+vaTLjI4JaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uL+yw9A2uqYWQ9HrloFijGlGc/Aj66xrvMt+ilsEHvXr2icVEllppKor5CsMecw1I
         L+p/0BCnPGrzBC3pLdwdqMHPtOs/qH/JEDAQELviFIBo/j2tRnX9R10XjYkpa230H0
         aO3qPQtVnPQcq82ESUdjrv3bWawN9UJXP79X4oD0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiwoong Kim <kwmad.kim@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/49] scsi: ufs: Introduce a quirk to allow only page-aligned sg entries
Date:   Wed, 10 Mar 2021 14:23:46 +0100
Message-Id: <20210310132323.055351773@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
index 379d44d6b9eb..5a7cc2e42ffd 100644
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



