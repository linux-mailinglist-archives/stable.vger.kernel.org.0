Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8C33F674E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240901AbhHXRck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:35536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239673AbhHXRan (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54F3C61B5D;
        Tue, 24 Aug 2021 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824740;
        bh=sJ2imIScDrbHpEF5E/7Kj7O/+S7DmbkGg5TtuFP58Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjqMmsSmDBkEywQDddIO4RM2rMs3FivQ/FvV3C5S6Y+mBRZ/Xch9n39jr82w6v/v8
         n82DyeyN2vdRGDZY8qMFohbb6B//lvaCZMFkya9i5rDpXhdF/nTFrzPrBd+/v3aJvv
         NO8HJP7a+lsnYnW6rLwo2vNX38Cpx84GWnHygwoPDburZP3b3o+RoO3izuogcfn/pb
         +4bJ6x7R4ggArullrvHlgovvtQ8FegGS2nQqmczvTYCpWXUQ0140CQ1gPlHDM69J8L
         t0TVOyOrhAJklx1b1eHs/6GIGpBtzMM9VBeIqZqKztMk8QXaxQ3SgEm9K533kj6CAT
         8aMxtn4GDrBhg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 44/64] scsi: core: Avoid printing an error if target_alloc() returns -ENXIO
Date:   Tue, 24 Aug 2021 13:04:37 -0400
Message-Id: <20210824170457.710623-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
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
index 40acc060b655..95ca7039f493 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -462,7 +462,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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

