Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C540015EEA4
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389689AbgBNQDg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:03:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389682AbgBNQDg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:03:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A9D32467D;
        Fri, 14 Feb 2020 16:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696215;
        bh=bF3mm8LgK4WLj9DZFyScvnTUuhRmv0kvP5u5CVxcBuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ozb+ZQ8kaafj5iAKmnntAR4VDZ/mPoERy6SF5x/Fmm4axPjqFZMI5nobmNn2Z8jWq
         RfWz4zorYUDJ1gTlVVWbr1eyuK6XArtqrUSmCs2bfJ5xFr+tMQM+XH8rpMbImGzl+m
         HjRt20N31n2IEikd7lyV7QI+HD/AFdqSB9FaDIBg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 079/459] scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails
Date:   Fri, 14 Feb 2020 10:55:29 -0500
Message-Id: <20200214160149.11681-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

[ Upstream commit b9fc5320212efdfb4e08b825aaa007815fd11d16 ]

A non-zero error value likely being returned by ufshcd_scsi_add_wlus() in
case of failure of adding the WLs, but ufshcd_probe_hba() doesn't use this
value, and doesn't report this failure to upper caller.  This patch is to
fix this issue.

Fixes: 2a8fa600445c ("ufs: manually add well known logical units")
Link: https://lore.kernel.org/r/20200120130820.1737-2-huobean@gmail.com
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0d41a7dc1d6b2..b0d6978d78bf8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6953,7 +6953,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 			ufshcd_init_icc_levels(hba);
 
 		/* Add required well known logical units to scsi mid layer */
-		if (ufshcd_scsi_add_wlus(hba))
+		ret = ufshcd_scsi_add_wlus(hba);
+		if (ret)
 			goto out;
 
 		/* Initialize devfreq after UFS device is detected */
-- 
2.20.1

