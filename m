Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D2C259834
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgIAQXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730958AbgIAPcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:32:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BE42205F4;
        Tue,  1 Sep 2020 15:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974338;
        bh=UAEfanVHMcu0t1YDn0lkH/w2zKBrI7FIzTNrxj2b8V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThG9g8NC4eUVMUOG21lH7jN356O0lv6RoAmALG6iQ7O53ZaxkNFmOcxKM1jjMe0Qh
         7OebNPHcvoww3QDBtHydn+e2+xytPrOgMLvnKrV4j33iLpgX7/SaYNwypKm6ybDoWt
         p44gy0JIRSuEkKJu+gmL35G/Oyq2U/MX0/5KfyOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/214] scsi: ufs: Improve interrupt handling for shared interrupts
Date:   Tue,  1 Sep 2020 17:10:18 +0200
Message-Id: <20200901150959.591462610@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 336cf72397e50..b51ccbf6cc59c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5612,7 +5612,7 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
  */
 static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
-	u32 intr_status, enabled_intr_status;
+	u32 intr_status, enabled_intr_status = 0;
 	irqreturn_t retval = IRQ_NONE;
 	struct ufs_hba *hba = __hba;
 	int retries = hba->nutrs;
@@ -5626,7 +5626,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	 * read, make sure we handle them by checking the interrupt status
 	 * again in a loop until we process all of the reqs before returning.
 	 */
-	do {
+	while (intr_status && retries--) {
 		enabled_intr_status =
 			intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 		if (intr_status)
@@ -5637,7 +5637,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		}
 
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-	} while (intr_status && --retries);
+	}
 
 	spin_unlock(hba->host->host_lock);
 	return retval;
-- 
2.25.1



