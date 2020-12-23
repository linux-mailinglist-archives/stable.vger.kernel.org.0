Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8017E2E158B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgLWCtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:49:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:49956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729537AbgLWCWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBA7B221E5;
        Wed, 23 Dec 2020 02:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690106;
        bh=VE727nvXGpFomCq6VgNh6/FXE50Z43folyCCKCVosUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYWF/+nef7NqDDkU0fcmkqppX5DfT9q7mYGo9aloHvK+pB7YJHtvU6fvM+DA+iW9m
         Li/Fi5Y+k8lBIzffG8ZcGZhIdDIu8litnGndQjySvsINWrFKG/Skqm8sUINbYy8IQy
         uq3De5CqmFP4g+BUUtS5/nSv87JulNc1/WM+/vLwCCT8yX7m8D92UZTMiKAR3HULyJ
         Ukp6J/X52+AwJoulaRZMoZ9pwwam7d7rXxMbxIj7owQ5Hk2q0jFD7ycOprPYmYluFh
         ZiIgj5Nm2EvAJlkrjrTQRrH7BgDVrteO698awIgbKZl57V9w09NDN0fnKaUYWpiyVy
         ga462uDmarR+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@google.com>, Can Guo <cang@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 35/87] scsi: ufs: Atomic update for clkgating_enable
Date:   Tue, 22 Dec 2020 21:20:11 -0500
Message-Id: <20201223022103.2792705-35-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

[ Upstream commit b664511297644eac34038df877b3ad7bcaa81913 ]

While running a stress test which enables/disables clkgating, we
occasionally hit device timeout. This patch avoids a subtle race condition
to address it.

Link: https://lore.kernel.org/r/20201117165839.1643377-3-jaegeuk@kernel.org
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7e4e6e982055e..b2fd853f07573 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1766,19 +1766,19 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 		return -EINVAL;
 
 	value = !!value;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (value == hba->clk_gating.is_enabled)
 		goto out;
 
-	if (value) {
-		ufshcd_release(hba);
-	} else {
-		spin_lock_irqsave(hba->host->host_lock, flags);
+	if (value)
+		__ufshcd_release(hba);
+	else
 		hba->clk_gating.active_reqs++;
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-	}
 
 	hba->clk_gating.is_enabled = value;
 out:
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	return count;
 }
 
-- 
2.27.0

