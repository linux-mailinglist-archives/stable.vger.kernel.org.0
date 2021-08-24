Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B95F3F64C7
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238929AbhHXRHW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:07:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239844AbhHXRFB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:05:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2581619E5;
        Tue, 24 Aug 2021 16:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824375;
        bh=FktZTSF8BWKM69s9jXoBFOK3vesoPn+vrbrFUlZyrpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loPyS4VUnzv10kivF79urz2lm2w1XITyf3cD+63U9IzzngBPwYVm/scgtvQ3XiC9W
         xUmiy25lMJK+4e/Itd1xYY2jgsmpdC1wnQgmyCoeSUNCIfOdPbuv5p9lvSIgrghnR8
         OjgH3qXsFU2H9bvFId/TbqkiCQ1wVpyCXzlg/evUUUnnriPUdzAagM5kVyU5bDHyj+
         0fUnUr19Mz7XCHLHbAURqcUANsSxCeCCeMtW99GSCVUvBx+yWjaYswcEZMv0tsmywm
         /M5EQJCO9+XnnghWOIGufBqJqRTpkVCpB6/rhWh82COmpDl1eDbOmjL/rQfUdwrG+7
         i9IugLvfE7lKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/98] scsi: core: Avoid printing an error if target_alloc() returns -ENXIO
Date:   Tue, 24 Aug 2021 12:57:55 -0400
Message-Id: <20210824165908.709932-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index 9af50e6f94c4..8e474b145249 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -453,7 +453,8 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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

