Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9752E21F4FF
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 16:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgGNOje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 10:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728987AbgGNOjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 10:39:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6785F22525;
        Tue, 14 Jul 2020 14:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594737573;
        bh=6Hipu7uWNfRUtHM/Af23/Iw1ZjSCu359/UrYQ+9V0vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4RP6hQvBOffpW8nQ72ssP4qrvnPXpv8uAJxFdr+R1FLDkExnpYkJsMZq9SBmVVvO
         KzCXgNS0s0yfbvW7hk2TzP2ynYEpOCwv92GClDaBsbNtzIuN5CglWAGCc/kO9nuCH4
         jFC+XX5EXm8x5+GRxvAVRm524zV3CLomAQzKcBhs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/18] scsi: mpt3sas: Fix error returns in BRM_status_show
Date:   Tue, 14 Jul 2020 10:39:11 -0400
Message-Id: <20200714143914.4035489-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200714143914.4035489-1-sashal@kernel.org>
References: <20200714143914.4035489-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 0fd181456aa0826057adbfb6c79c40f4083cfd75 ]

BRM_status_show() has several error branches, but none of them record the
error in the error return.

Also while at it remove the manual mutex_unlock() of the pci_access_mutex
in case of an ongoing pci error recovery or host removal and jump to the
cleanup label instead.

Note: We can safely jump to out from here as io_unit_pg3 is initialized to
NULL and if it hasn't been allocated, kfree() skips the NULL pointer.

[mkp: compilation warning]

Link: https://lore.kernel.org/r/20200701131454.5255-1-johannes.thumshirn@wdc.com
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Acked-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 82c4ecc16f191..d5a62fea8fe3e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2925,15 +2925,14 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	}
 	/* pci_access_mutex lock acquired by sysfs show path */
 	mutex_lock(&ioc->pci_access_mutex);
-	if (ioc->pci_error_recovery || ioc->remove_host) {
-		mutex_unlock(&ioc->pci_access_mutex);
-		return 0;
-	}
+	if (ioc->pci_error_recovery || ioc->remove_host)
+		goto out;
 
 	/* allocate upto GPIOVal 36 entries */
 	sz = offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);
 	io_unit_pg3 = kzalloc(sz, GFP_KERNEL);
 	if (!io_unit_pg3) {
+		rc = -ENOMEM;
 		ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\n",
 			__func__, sz);
 		goto out;
@@ -2943,6 +2942,7 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	    0) {
 		ioc_err(ioc, "%s: failed reading iounit_pg3\n",
 			__func__);
+		rc = -EINVAL;
 		goto out;
 	}
 
@@ -2950,12 +2950,14 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
 		ioc_err(ioc, "%s: iounit_pg3 failed with ioc_status(0x%04x)\n",
 			__func__, ioc_status);
+		rc = -EINVAL;
 		goto out;
 	}
 
 	if (io_unit_pg3->GPIOCount < 25) {
 		ioc_err(ioc, "%s: iounit_pg3->GPIOCount less than 25 entries, detected (%d) entries\n",
 			__func__, io_unit_pg3->GPIOCount);
+		rc = -EINVAL;
 		goto out;
 	}
 
-- 
2.25.1

