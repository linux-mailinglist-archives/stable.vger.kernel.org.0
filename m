Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7167D5EC2E9
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 14:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiI0MjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 08:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231753AbiI0MjQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 08:39:16 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4C415E46F;
        Tue, 27 Sep 2022 05:39:13 -0700 (PDT)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4McJzB75FtzHqMd;
        Tue, 27 Sep 2022 20:36:54 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 20:39:10 +0800
Received: from huawei.com (10.175.127.227) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 20:39:09 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <yukuai3@huawei.com>,
        <yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>
Subject: [PATCH 5.10] scsi: hisi_sas: Revert "scsi: hisi_sas: Limit max hw sectors for v3 HW"
Date:   Tue, 27 Sep 2022 21:01:16 +0800
Message-ID: <20220927130116.1013775-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 24cd0b9bfdff126c066032b0d40ab0962d35e777.

1) commit 4e89dce72521 ("iommu/iova: Retry from last rb tree node if
iova search fails") tries to fix that iova allocation can fail while
there are still free space available. This is not backported to 5.10
stable.
2) commit fce54ed02757 ("scsi: hisi_sas: Limit max hw sectors for v3
HW") fix the performance regression introduced by 1), however, this
is just a temporary solution and will cause io performance regression
because it limit max io size to PAGE_SIZE * 32(128k for 4k page_size).
3) John Garry posted a patchset to fix the problem.
4) The temporary solution is reverted.

It's weird that the patch in 2) is backported to 5.10 stable alone,
while the right thing to do is to backport them all together.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index dfe7e6370d84..cd41dc061d87 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2738,7 +2738,6 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 	struct hisi_hba *hisi_hba = shost_priv(shost);
 	struct device *dev = hisi_hba->dev;
 	int ret = sas_slave_configure(sdev);
-	unsigned int max_sectors;
 
 	if (ret)
 		return ret;
@@ -2756,12 +2755,6 @@ static int slave_configure_v3_hw(struct scsi_device *sdev)
 		}
 	}
 
-	/* Set according to IOMMU IOVA caching limit */
-	max_sectors = min_t(size_t, queue_max_hw_sectors(sdev->request_queue),
-			    (PAGE_SIZE * 32) >> SECTOR_SHIFT);
-
-	blk_queue_max_hw_sectors(sdev->request_queue, max_sectors);
-
 	return 0;
 }
 
-- 
2.31.1

