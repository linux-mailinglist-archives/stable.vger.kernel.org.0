Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609303E5D8C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 16:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241590AbhHJOVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 10:21:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243330AbhHJOTl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 10:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B465B61163;
        Tue, 10 Aug 2021 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628605023;
        bh=kln+TdL2yLTp4Awig9Sffb7Fm7JG6GfX55GX2Gh1dxg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFf+Ka8DhGH9SMiWJtJDwo2s+S+m1e2cu5zkLiitNzOwBELjFEL3cyUaDqvpJ/Qu+
         B//P4bw3Aaqv7cTYO108a6Z34+NyaThx5zsyiCei3sC/ReFODLuOclEcRfgy+WWr7I
         z0gprHp4tTqRGXBFWX/q9CgzSc+T0wLpcTIsHTwWvX6Cm+OEW2Bo15LZPp/NXe85G8
         E5DCokKp223rW9jzpE6BER+F/53UIGveExB4aPzkrU2ONeov3ONhkO05Ib/V1ls37D
         MA6e0NVr6GLBUiWylVoA0Akk7YDiFCb8HLVc94rwJ2u12FBMV+CVHtQNp50KYWfcIL
         GfC5ZSvUUB9Dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 6/8] scsi: core: Avoid printing an error if target_alloc() returns -ENXIO
Date:   Tue, 10 Aug 2021 10:16:53 -0400
Message-Id: <20210810141655.3118498-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810141655.3118498-1-sashal@kernel.org>
References: <20210810141655.3118498-1-sashal@kernel.org>
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
index 397deb69c659..e51819e3a508 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -460,7 +460,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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

