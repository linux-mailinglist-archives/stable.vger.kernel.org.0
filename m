Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA95250378
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 18:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgHXQov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 12:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbgHXQj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:39:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6214120838;
        Mon, 24 Aug 2020 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287166;
        bh=RacWlbSMKAJd0bJ0QP8Nbv2sinIB1vEMPGx2J0kjzqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zF5eGdzfoo6QwNVkZk5+2PiK8eeXY9pNEOMIQ5z2xK6DBX87KrgEZOloqY1JJAKm/
         uCx9Je0v/ugS1aM9IzqUaM0CS/K4O4rtStMpLxJW/AaL9DfylGbLaAGtKuh2tl+ikj
         6NvY5a7NNnv1ylvjhWSZOsIcFeQ1UPLb6D/tadgk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/11] scsi: ufs: Improve interrupt handling for shared interrupts
Date:   Mon, 24 Aug 2020 12:39:11 -0400
Message-Id: <20200824163914.607152-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163914.607152-1-sashal@kernel.org>
References: <20200824163914.607152-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 127d5f7c4b653b8be5eb3b2c7bbe13728f9003ff ]

For shared interrupts, the interrupt status might be zero, so check that
first.

Link: https://lore.kernel.org/r/20200811133936.19171-2-adrian.hunter@intel.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8144a54371c35..4eaecc3cdebc8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5371,7 +5371,7 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
  */
 static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
-	u32 intr_status, enabled_intr_status;
+	u32 intr_status, enabled_intr_status = 0;
 	irqreturn_t retval = IRQ_NONE;
 	struct ufs_hba *hba = __hba;
 	int retries = hba->nutrs;
@@ -5385,7 +5385,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	 * read, make sure we handle them by checking the interrupt status
 	 * again in a loop until we process all of the reqs before returning.
 	 */
-	do {
+	while (intr_status && retries--) {
 		enabled_intr_status =
 			intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 		if (intr_status)
@@ -5396,7 +5396,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		}
 
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-	} while (intr_status && --retries);
+	}
 
 	spin_unlock(hba->host->host_lock);
 	return retval;
-- 
2.25.1

