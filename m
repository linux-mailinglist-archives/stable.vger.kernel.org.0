Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF9422F16E
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732136AbgG0OcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730406AbgG0OTN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:19:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03AD020775;
        Mon, 27 Jul 2020 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859552;
        bh=GAFcz6VMhCl4x1qHq3sS9k3Cf5CjbBVOHTbT3FSCZ9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qifkfn3AjvJ1KHOMBhHG8nrWhBDVYb01Rqa2hc9BQ3QpsItHvjN0hbxJAbFEz64+r
         gewkA4Yos29Bjb5th47buwpdqd+phDFBl2gieVwL5JSJCh1jrk7iNZldFRZcmeRH9t
         9KiyOS9esKLlIaaBB8ipfzJe1hwEtNR734ulXUJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 015/179] scsi: mpt3sas: Fix error returns in BRM_status_show
Date:   Mon, 27 Jul 2020 16:03:10 +0200
Message-Id: <20200727134933.416219782@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e94e72de2fc68..983e568ff2317 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3149,15 +3149,14 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
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
@@ -3167,6 +3166,7 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
 	    0) {
 		ioc_err(ioc, "%s: failed reading iounit_pg3\n",
 			__func__);
+		rc = -EINVAL;
 		goto out;
 	}
 
@@ -3174,12 +3174,14 @@ BRM_status_show(struct device *cdev, struct device_attribute *attr,
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



