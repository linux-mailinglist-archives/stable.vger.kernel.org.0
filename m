Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E65727AB7F
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 12:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgI1KGQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 06:06:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46526 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgI1KGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 06:06:16 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200928095915epoutp04ccbe9302cb4aa8907bf92647edb0d8e1~46i8Btkzj0671806718epoutp04O
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 09:59:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200928095915epoutp04ccbe9302cb4aa8907bf92647edb0d8e1~46i8Btkzj0671806718epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601287155;
        bh=3MWbm8SIPjRmmG0n+g+YuSLuI8bg8y9M+axmJ2jW5/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZrzNpaDUvjoZgBC43XzrcLnKtcGiqxINp6tjSK3slwdEmqwxqgEhSjzP/M5XfFBG
         +dfqBzfX8cleqJaxwnuW4NE3e3Adk3Geu7CCHC95S3AZZZu6ECF3O3PcfoHIqx/qkY
         hOcS6LJ/kfT1kfNPIUQTZjEBI5DYf5Hq4Wp8PDgI=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200928095914epcas5p37f5a3c1cd7a16a628a15b29aa04c970c~46i7hXYnj2289422894epcas5p3s;
        Mon, 28 Sep 2020 09:59:14 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        72.3A.09573.2F3B17F5; Mon, 28 Sep 2020 18:59:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20200928095914epcas5p1beae8d5a201c35b598fde8288532d58d~46i7IBfsw1718817188epcas5p1V;
        Mon, 28 Sep 2020 09:59:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200928095914epsmtrp1934b795e64f69a884e2a34d6d4db0c7e~46i7HTO9O0567205672epsmtrp1E;
        Mon, 28 Sep 2020 09:59:14 +0000 (GMT)
X-AuditID: b6c32a49-a7dff70000002565-94-5f71b3f21b2c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        20.D9.08745.2F3B17F5; Mon, 28 Sep 2020 18:59:14 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200928095912epsmtip1469f7e18429eebe922dd19370e6273bf~46i5oz_Tj2605326053epsmtip10;
        Mon, 28 Sep 2020 09:59:12 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, Damien.LeMoal@wdc.com
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        stable@vger.kernel.org, selvakuma.s1@samsung.com,
        nj.shetty@samsung.com, javier.gonz@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH v2 1/1] null_blk: synchronization fix for zoned device
Date:   Mon, 28 Sep 2020 15:25:49 +0530
Message-Id: <20200928095549.184510-2-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200928095549.184510-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42LZdlhTU/fT5sJ4gyn98har7/azWbS2f2Oy
        eHznM7vF0f9v2Sz23tK2uLxrDpvFtt/zmS2uTFnEbPH6x0k2iwUbHzE6cHlcPlvq0bdlFaPH
        501yHu0HupkCWKK4bFJSczLLUov07RK4MtY/6GYqOCJesfbeDtYGxo3CXYycHBICJhJXFq9g
        6WLk4hAS2M0oce3gdyjnE6PEvw1LmCGcz4wSC8/OYIJp2TXrMTuILSSwi1FixmVvuKIVM8+y
        dTFycLAJaEpcmFwKUiMioCWxdGsjG0gNs8AJRomfpzeygiSEBdwkHrRNZwSxWQRUJTr2/mID
        sXkFLCVObfjKCLFMXmLmpe/sIDM5BawkPjYIQZQISpyc+YQFxGYGKmneOpsZovwru8S6RzIg
        5RICLhITTsdChIUlXh3fwg5hS0m87G+Dsoslft05CvajhEAHo8T1hpksEAl7iYt7/jKBzGEG
        emX9Ln2IVXwSvb+fMEGM55XoaBOCqFaUuDfpKSuELS7xcMYSKNtD4sWhl0yQ0OlllOjZvZ5t
        AqP8LCQfzELywSyEbQsYmVcxSqYWFOempxabFhjmpZbrFSfmFpfmpesl5+duYgQnGS3PHYx3
        H3zQO8TIxMF4iFGCg1lJhNc3pyBeiDclsbIqtSg/vqg0J7X4EKM0B4uSOK/SjzNxQgLpiSWp
        2ampBalFMFkmDk6pBiZLz58ypk/nvP/b8/4q98tQlXW5rdUvw/Onmyqz1X34Eu0WKd0e+KaO
        Z6GNpcSRHXX8DT/mLefWC2q7c8VvX/3V6fwM/xm372HeyaVp5LtAOV+3Y89D8ZolgR9WPdnu
        Yrxk+ekJLF/fyP5T0Hb80H9DXWrbRYGqW2+aVjsxnzpmf6JcjnnHLjsRX1/+m6l/q++Vez6v
        XJ+de/pC7fb6wMj4Q3MmvlC7F37iEW/n2303qj7nah+7yvRnl2s0T8qGfzu2lXs9Fm5JX7VR
        o+NGyr2+P9MffWCYx8WS3G4zRdB81r4cy8mV02bOnn1jwruzXV8Cl5vJiq1ZnR3WdMJ4f/6l
        ZzJfJN1C3jWvvqPM/HWPEktxRqKhFnNRcSIAJcjwEKEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSnO6nzYXxBocnsFisvtvPZtHa/o3J
        4vGdz+wWR/+/ZbPYe0vb4vKuOWwW237PZ7a4MmURs8XrHyfZLBZsfMTowOVx+WypR9+WVYwe
        nzfJebQf6GYKYInisklJzcksSy3St0vgylj/oJup4Ih4xdp7O1gbGDcKdzFyckgImEjsmvWY
        vYuRi0NIYAejxJubR1kgEuISzdd+sEPYwhIr/z2HKvrIKLHmz2+mLkYODjYBTYkLk0tBakQE
        dCT2fWxjAalhFrjAKLHsyndWkISwgJvEg7bpjCA2i4CqRMfeX2wgNq+ApcSpDV8ZIRbIS8y8
        9J0dZCangJXExwYhEFMIqOTMJy6IakGJkzOfgJ3GDFTdvHU28wRGgVlIUrOQpBYwMq1ilEwt
        KM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAgOcS2tHYx7Vn3QO8TIxMF4iFGCg1lJhNc3pyBe
        iDclsbIqtSg/vqg0J7X4EKM0B4uSOO/XWQvjhATSE0tSs1NTC1KLYLJMHJxSDUzTs1iW2Os0
        VLdV234QZV+vvIhhlp9ytdEUhUeL71dvKRLveMPWOvFcc0aqudThvhd/pvfcerXP33+F9Mrm
        bZ7THxvFMotuvPTmPXNWrzWvb35aV/tGh1mqbUGJZ/407HLTWu+5YPOZOuX/F6NNO5KU7Bk8
        U9dZraz5a6C4b4974oL/Dcr3g6Ka774zOmsi13O13krNg1Vzbkl88cIao86sHROnBnx/cWpr
        ic356rjpIgffMQee/qMXZlygwfXEdwX3P5aypS2Ol9I3njW7bu6qusLsVqWJaeLTBTl5md+a
        z4jM945nzH/FmzzV+vZ6n0tyLTujI7rvbWhTn3BiTuc+AaXNHgzx/bpBQjuLlViKMxINtZiL
        ihMBM+U6y+ACAAA=
X-CMS-MailID: 20200928095914epcas5p1beae8d5a201c35b598fde8288532d58d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200928095914epcas5p1beae8d5a201c35b598fde8288532d58d
References: <20200928095549.184510-1-joshi.k@samsung.com>
        <CGME20200928095914epcas5p1beae8d5a201c35b598fde8288532d58d@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Parallel write,read,zone-mgmt operations accessing/altering zone state
and write-pointer may get into race. Avoid the situation by using a new
spinlock for zoned device.
Concurrent zone-appends (on a zone) returning same write-pointer issue
is also avoided using this lock.

Fixes: e0489ed5daeb ("null_blk: Support REQ_OP_ZONE_APPEND")
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 drivers/block/null_blk.h       |  1 +
 drivers/block/null_blk_zoned.c | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
index daed4a9c3436..28099be50395 100644
--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -44,6 +44,7 @@ struct nullb_device {
 	unsigned int nr_zones;
 	struct blk_zone *zones;
 	sector_t zone_size_sects;
+	spinlock_t zone_lock;
 
 	unsigned long size; /* device size in MB */
 	unsigned long completion_nsec; /* time in ns to complete a request */
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 3d25c9ad2383..e8d8b13aaa5a 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -45,6 +45,7 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 	if (!dev->zones)
 		return -ENOMEM;
 
+	spin_lock_init(&dev->zone_lock);
 	if (dev->zone_nr_conv >= dev->nr_zones) {
 		dev->zone_nr_conv = dev->nr_zones - 1;
 		pr_info("changed the number of conventional zones to %u",
@@ -131,8 +132,11 @@ int null_report_zones(struct gendisk *disk, sector_t sector,
 		 * So use a local copy to avoid corruption of the device zone
 		 * array.
 		 */
+		spin_lock_irq(&dev->zone_lock);
 		memcpy(&zone, &dev->zones[first_zone + i],
 		       sizeof(struct blk_zone));
+		spin_unlock_irq(&dev->zone_lock);
+
 		error = cb(&zone, i, data);
 		if (error)
 			return error;
@@ -277,18 +281,28 @@ static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
 blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_opf op,
 				    sector_t sector, sector_t nr_sectors)
 {
+	blk_status_t sts;
+	struct nullb_device *dev = cmd->nq->dev;
+
+	spin_lock_irq(&dev->zone_lock);
 	switch (op) {
 	case REQ_OP_WRITE:
-		return null_zone_write(cmd, sector, nr_sectors, false);
+		sts = null_zone_write(cmd, sector, nr_sectors, false);
+		break;
 	case REQ_OP_ZONE_APPEND:
-		return null_zone_write(cmd, sector, nr_sectors, true);
+		sts = null_zone_write(cmd, sector, nr_sectors, true);
+		break;
 	case REQ_OP_ZONE_RESET:
 	case REQ_OP_ZONE_RESET_ALL:
 	case REQ_OP_ZONE_OPEN:
 	case REQ_OP_ZONE_CLOSE:
 	case REQ_OP_ZONE_FINISH:
-		return null_zone_mgmt(cmd, op, sector);
+		sts = null_zone_mgmt(cmd, op, sector);
+		break;
 	default:
-		return null_process_cmd(cmd, op, sector, nr_sectors);
+		sts = null_process_cmd(cmd, op, sector, nr_sectors);
 	}
+	spin_unlock_irq(&dev->zone_lock);
+
+	return sts;
 }
-- 
2.25.1

