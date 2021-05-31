Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D229B396230
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbhEaOw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232605AbhEaOuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04D5961C9A;
        Mon, 31 May 2021 13:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469450;
        bh=6J+VSZR2RVrPRUpwU04x1RUQWW0xg8KZLbMcUqkVw6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MI2j11wSB7lYbkpjhTtn6ghWW7k2Aijy/vGJbQJGKLIwFfT6isflK+AHwI7v7Qab1
         hT295DufmtCqkG7t2FLkkGgL2CxI5xvulirUKDTG3LjkuabxwNJqWaSpcXT177zvSB
         dy7403ithckgaXXSgtx2xctcbnYijNANZ/KCeDmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 201/296] scsi: ufs: ufs-mediatek: Fix power down spec violation
Date:   Mon, 31 May 2021 15:14:16 +0200
Message-Id: <20210531130710.641085795@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



