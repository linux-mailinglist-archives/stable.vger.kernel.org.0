Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A358D3F6689
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbhHXRZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239996AbhHXRXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 626C2615A2;
        Tue, 24 Aug 2021 17:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824626;
        bh=UJyf+URRaZRGF4EBvF+sX7h0iZKBCnMv8itoRrSVuPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s3cNeJDtZsHLqYu1tlceqH8zyHmOhqHG1Mw2Mk6TE+V/ZKrs5nSzwt33rvLGtF/7A
         d4fIjItJ77rcLBuQZQjQbM6hS4dZvqXR5NXJEgYWti/BV/WhDlCm7Xv2ZAI+YRXZVf
         X9iyJcI/1A3LuB+u2yb5qJH1w3fyEp6k5WY5gKTPFkmBUg6d0Ne8Er0lVz2zzbxeBu
         QE0XE46qQqBZajN1klh8KX3kkb6jYcdNoJp9CJodlNr77mu7Dw9lwT66AZQlvD5Se1
         6/0KWktM5nuF/kpCMZP2xeCju3oMGydlk5g3RlabJxRDQ6ECltYcCoYq9BTAzqzcfx
         KBPqJlVD6s0PQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 56/84] scsi: core: Avoid printing an error if target_alloc() returns -ENXIO
Date:   Tue, 24 Aug 2021 13:02:22 -0400
Message-Id: <20210824170250.710392-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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
index 009a5b2aa3d0..149465de35b2 100644
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

