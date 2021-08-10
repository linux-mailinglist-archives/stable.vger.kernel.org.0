Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37943E5CCD
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242333AbhHJOPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:15:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242281AbhHJOPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B44626101E;
        Tue, 10 Aug 2021 14:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628604919;
        bh=a58CtOqhhxArCXSpeLkqc6U7Wh0GX9ftrQnFBMuCjmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WG3n20wTfBdqLJEafb/cKE0I6c9DCqV7w7iK+IQ5YbCvaPpr/eTvB4CDrWkROJIRx
         x8AIr2WDqFDIwX6980z+Sha7nihkOP82tDd3rBk7QfakAy3bn8MzNGfoGHS+gX/tLg
         lT0Y0kYNUdePQFLJQYL8Zusb9q5XXqe9Yq/WtchDTbbGRCGKJCZvHT8ctnlAmHAcGG
         GHWF/YAbxJfCRTcVNPeIrAUVEKNtCJuLF+m6x4zGRKFSDQskPWRbwgRL20676/5ozx
         yZppf3/Er7Z4L/XLemQgYLBhyN86UeVMMaGAGPjULOCvZuHTAm8rWrl3+lxYkv0ltg
         qeNdlHIBD2vkw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 10/24] scsi: core: Avoid printing an error if target_alloc() returns -ENXIO
Date:   Tue, 10 Aug 2021 10:14:51 -0400
Message-Id: <20210810141505.3117318-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141505.3117318-1-sashal@kernel.org>
References: <20210810141505.3117318-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 70edd2e6f652f67d854981fd67f9ad0f1deaea92 ]

Avoid printing a 'target allocation failed' error if the driver
target_alloc() callback function returns -ENXIO. This return value
indicates that the corresponding H:C:T:L entry is empty.

Removing this error reduces the scan time if the user issues SCAN_WILD_CARD
scan operation through sysfs parameter on a host with a lot of empty
H:C:T:L entries.

Avoiding the printk on -ENXIO matches the behavior of the other callback
functions during scanning.

Link: https://lore.kernel.org/r/20210726115402.1936-1-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 12f54571b83e..f0367115632b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -471,7 +471,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 		error = shost->hostt->target_alloc(starget);
 
 		if(error) {
-			dev_printk(KERN_ERR, dev, "target allocation failed, error %d\n", error);
+			if (error != -ENXIO)
+				dev_err(dev, "target allocation failed, error %d\n", error);
 			/* don't want scsi_target_reap to do the final
 			 * put because it will be under the host lock */
 			scsi_target_destroy(starget);
-- 
2.30.2

