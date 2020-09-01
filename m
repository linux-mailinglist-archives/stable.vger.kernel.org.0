Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5E3259AE4
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgIAPYO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:24:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728378AbgIAPYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:24:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFB25207D3;
        Tue,  1 Sep 2020 15:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973849;
        bh=VlWSxCahxGTsAg8riNAYQKzrPh8ni/S6sbuyR/BcenQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5BAIkaRm9Vqz0tfoHGa/5MdjVlsKU75gFvwsWIPxIXMOp1uNNyur1YVKR1Qu3ftc
         KtvWgj0Ovau/ZfNii9cmy5fSnK+cBWSIA5+WJ/ovFZC0gQwxEdvN25e4kb8ZkUpU6s
         EFpo5iLdGHhSBDFNgtFFDivf5WofJkJa/+xoKaxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 072/125] scsi: ufs: Improve interrupt handling for shared interrupts
Date:   Tue,  1 Sep 2020 17:10:27 +0200
Message-Id: <20200901150938.111124787@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150934.576210879@linuxfoundation.org>
References: <20200901150934.576210879@linuxfoundation.org>
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
index 747a2321b5f7d..d8c6fd2012757 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5605,7 +5605,7 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
  */
 static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
-	u32 intr_status, enabled_intr_status;
+	u32 intr_status, enabled_intr_status = 0;
 	irqreturn_t retval = IRQ_NONE;
 	struct ufs_hba *hba = __hba;
 	int retries = hba->nutrs;
@@ -5619,7 +5619,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	 * read, make sure we handle them by checking the interrupt status
 	 * again in a loop until we process all of the reqs before returning.
 	 */
-	do {
+	while (intr_status && retries--) {
 		enabled_intr_status =
 			intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 		if (intr_status)
@@ -5630,7 +5630,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 		}
 
 		intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-	} while (intr_status && --retries);
+	}
 
 	spin_unlock(hba->host->host_lock);
 	return retval;
-- 
2.25.1



