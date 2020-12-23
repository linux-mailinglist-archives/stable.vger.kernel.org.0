Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5CC2E16B9
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgLWDBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:01:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbgLWCTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29A4122A83;
        Wed, 23 Dec 2020 02:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689957;
        bh=qNauWqOc7Y53sLA+7aVelqASFvB0sPMN+UPgqkxdoHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AUlXL5WD3fDC2g9bm4Zmj500USy7VgME1jIaFJ6Anjd5Kkv7HXyBoMBw8ScEXzzo6
         yHgQL+8HqSXhpb5yskCa4/hMUKPQ7sTFPLD1hboY5jBJDM0PP1PyQ1QuUKJmZhM0jV
         h42pgn5nW3SM6fb4/50brbz6UnY6/zZfjoSvhS72eZdtSLcYb2dVW+Xhiq9LgCMbnt
         5IYEB3NJ3zBvLSNzzuMFtgdm0psdRPr4bJQIpW/jRVnIm+V3NDqX+YiSjJAF2u+jhd
         krwDN7lBwL1OwdkHTb7tDAiU6BLrwzNIWgjeOtZwp7o70pJgCOYGk//aITgE3XkwPE
         1Fv8cQ+qYr9vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@google.com>, Can Guo <cang@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 050/130] scsi: ufs: Atomic update for clkgating_enable
Date:   Tue, 22 Dec 2020 21:16:53 -0500
Message-Id: <20201223021813.2791612-50-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index 675e16e61ebdd..ed07e52fa861b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1751,19 +1751,19 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
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

