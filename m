Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFEA3F65BD
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhHXRQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239291AbhHXRNF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:13:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90A2A61A6D;
        Tue, 24 Aug 2021 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824487;
        bh=9usGj9LMxMGrtwCjIZPjldvX11yA78hDphKW+uN0NgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tSi5KG3Np3o15caZOq64WctKKQdtD97BnfzKfc9zovYBmtKrDMnAMzXpwU80b8KwK
         41gLriO/9hK0wGr4EoeVT5b7+H+162itskWoZAHVk1U397MKbu7DBVcurUVA4ZmSIv
         gU+XcUXrJ5HNHTLMV1+HEO6iy8JCa+wAjIr7BuHui3ui5znzOx4xRuAI/mdqIWfjPY
         A6sAGWP3x7+3ScVBJ6sjQXleC87Tz+IO+t/KlZMJocH3IqcVc42bhpJ/qobC3XBtS9
         sXcrNqOMYV+zAaaQSUpAjdj5U1VXmISHf9eDfnn/k/kh9T9Ih2kOXSPtAZY+fPLj/m
         fu3ZnVvWa4YXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/61] scsi: core: Avoid printing an error if target_alloc() returns -ENXIO
Date:   Tue, 24 Aug 2021 13:00:24 -0400
Message-Id: <20210824170106.710221-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
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
index 79232cef1af1..3fd109fd9335 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -454,7 +454,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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

