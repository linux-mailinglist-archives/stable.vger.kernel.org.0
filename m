Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE1538E9B2
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 16:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbhEXOuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 10:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233490AbhEXOsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 10:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3A45613DB;
        Mon, 24 May 2021 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867639;
        bh=6J+VSZR2RVrPRUpwU04x1RUQWW0xg8KZLbMcUqkVw6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTbfseDHwN739QvRXcf7ie4gSuLFgJCMJow/8rUj6MbzQ9eIwuoEkgMH8QWliM9VN
         BqO9CRV1hiBN/lXtc2HUBgg00OUiLM6zm/s6sC1EG2T0LYfIKG1hTXJDgNafztpWMu
         UeQmBmaGEB3uQ4TfvHUQy+c+0ca1rnaV5yk30SVANNlGlIYMxWs0P/OydUJQw6NVFv
         I7dTT0lCNU45sLM63+1O/MmJUcgEpR0mTN7aSNPxLmCoZJgWr9p3bNFSKC8NlXXF6U
         c9XEH7kBDq+z25OwimDLhx18FXtS4bpHLIJEf8S+AenlY1Oj/FJSkRuE/6aRpnIrgt
         4cRQuS4t0y6HQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 45/63] scsi: ufs: ufs-mediatek: Fix power down spec violation
Date:   Mon, 24 May 2021 10:46:02 -0400
Message-Id: <20210524144620.2497249-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144620.2497249-1-sashal@kernel.org>
References: <20210524144620.2497249-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit c625b80b9d00f3546722cd77527f9697c8c4c911 ]

As per spec, e.g. JESD220E chapter 7.2, while powering off the UFS device,
RST_N signal should be between VSS(Ground) and VCCQ/VCCQ2. The power down
sequence after fixing:

Power down:

 1. Assert RST_N low

 2. Turn-off VCC

 3. Turn-off VCCQ/VCCQ2

Link: https://lore.kernel.org/r/1620813706-25331-1-git-send-email-peter.wang@mediatek.com
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index a981f261b304..aee3cfc7142a 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -922,6 +922,7 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int err;
+	struct arm_smccc_res res;
 
 	if (ufshcd_is_link_hibern8(hba)) {
 		err = ufs_mtk_link_set_lpm(hba);
@@ -941,6 +942,9 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			goto fail;
 	}
 
+	if (ufshcd_is_link_off(hba))
+		ufs_mtk_device_reset_ctrl(0, res);
+
 	return 0;
 fail:
 	/*
-- 
2.30.2

