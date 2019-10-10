Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F97D25D6
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387757AbfJJIjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:39:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387712AbfJJIjB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:39:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDB3621BE5;
        Thu, 10 Oct 2019 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696740;
        bh=TsbFjjj0pO0yLV3H0oyCsZrNK77KX6ZYSuHEraysTRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xy7hr3+KMyX1pB4Z1OQe49LF6C/RIYqRWGXmZCcNjo1h7QIeA/rAV4l2aOOVTpGXI
         ueimHUjUmstOdC+lJeu2e/RDeJo9T4+nLCIWR4vbe4draDUehB5g6EA98sRkKnYkKj
         U55m0sRUYYda9gOm8ljag9makPd2erfoTEEJywH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Heimes <frank.heimes@canonical.com>,
        =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 007/148] s390/dasd: Fix error handling during online processing
Date:   Thu, 10 Oct 2019 10:34:28 +0200
Message-Id: <20191010083611.206491471@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Höppner <hoeppner@linux.ibm.com>

commit dd45483981ac62f432e073fea6e5e11200b9070d upstream.

It is possible that the CCW commands for reading volume and extent pool
information are not supported, either by the storage server (for
dedicated DASDs) or by z/VM (for virtual devices, such as MDISKs).

As a command reject will occur in such a case, the current error
handling leads to a failing online processing and thus the DASD can't be
used at all.

Since the data being read is not essential for an fully operational
DASD, the error handling can be removed. Information about the failing
command is sent to the s390dbf debug feature.

Fixes: c729696bcf8b ("s390/dasd: Recognise data for ESE volumes")
Cc: <stable@vger.kernel.org> # 5.3
Reported-by: Frank Heimes <frank.heimes@canonical.com>
Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/block/dasd_eckd.c |   24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1553,8 +1553,8 @@ static int dasd_eckd_read_vol_info(struc
 	if (rc == 0) {
 		memcpy(&private->vsq, vsq, sizeof(*vsq));
 	} else {
-		dev_warn(&device->cdev->dev,
-			 "Reading the volume storage information failed with rc=%d\n", rc);
+		DBF_EVENT_DEVID(DBF_WARNING, device->cdev,
+				"Reading the volume storage information failed with rc=%d", rc);
 	}
 
 	if (useglobal)
@@ -1737,8 +1737,8 @@ static int dasd_eckd_read_ext_pool_info(
 	if (rc == 0) {
 		dasd_eckd_cpy_ext_pool_data(device, lcq);
 	} else {
-		dev_warn(&device->cdev->dev,
-			 "Reading the logical configuration failed with rc=%d\n", rc);
+		DBF_EVENT_DEVID(DBF_WARNING, device->cdev,
+				"Reading the logical configuration failed with rc=%d", rc);
 	}
 
 	dasd_sfree_request(cqr, cqr->memdev);
@@ -2020,14 +2020,10 @@ dasd_eckd_check_characteristics(struct d
 	dasd_eckd_read_features(device);
 
 	/* Read Volume Information */
-	rc = dasd_eckd_read_vol_info(device);
-	if (rc)
-		goto out_err3;
+	dasd_eckd_read_vol_info(device);
 
 	/* Read Extent Pool Information */
-	rc = dasd_eckd_read_ext_pool_info(device);
-	if (rc)
-		goto out_err3;
+	dasd_eckd_read_ext_pool_info(device);
 
 	/* Read Device Characteristics */
 	rc = dasd_generic_read_dev_chars(device, DASD_ECKD_MAGIC,
@@ -5663,14 +5659,10 @@ static int dasd_eckd_restore_device(stru
 	dasd_eckd_read_features(device);
 
 	/* Read Volume Information */
-	rc = dasd_eckd_read_vol_info(device);
-	if (rc)
-		goto out_err2;
+	dasd_eckd_read_vol_info(device);
 
 	/* Read Extent Pool Information */
-	rc = dasd_eckd_read_ext_pool_info(device);
-	if (rc)
-		goto out_err2;
+	dasd_eckd_read_ext_pool_info(device);
 
 	/* Read Device Characteristics */
 	rc = dasd_generic_read_dev_chars(device, DASD_ECKD_MAGIC,


