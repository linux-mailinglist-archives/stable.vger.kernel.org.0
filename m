Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C223B2E1478
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgLWCjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:39:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730064AbgLWCXq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18CC422AAF;
        Wed, 23 Dec 2020 02:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690210;
        bh=rMAraAbSoN60xGi383renZXB910pyJXmXglFmSTIQzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G+yu7555hEc5NmGAB5IIp6n9vX9i46vLhXjdvtaeZKFJX55axlGukCdqz+X21VQTP
         tWS1zLLxCJW8F4BXzMxEhbYcp7NCUvr8TkvQuxVBSSzx2prS7c1MQy1m89Mp7uR/5/
         QkfOCWLUGvErqJ8YfXOMN8+yERsVcoqu3uPjcrIjiLvS4QdadGTLLT6wy7vV6tTTUj
         9qdC736l8j6NVk+4rvnq9qgyiCe3OhyFsNuGHpc9zLyybRFLJGH+8VYSQOckf4wjJL
         lKhz/8LH37gNbFMoGQo6qOeBA65z/Q29zmkWSiCeXYO3929Jp3w22xeyvS70b1cLnb
         SP2KrHcqhoSKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@google.com>, Can Guo <cang@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 30/66] scsi: ufs: Atomic update for clkgating_enable
Date:   Tue, 22 Dec 2020 21:22:16 -0500
Message-Id: <20201223022253.2793452-30-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index a3a3ee6e2a002..68d3d463e2e16 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1649,19 +1649,19 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
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

