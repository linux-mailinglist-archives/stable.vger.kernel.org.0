Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721F2126B8C
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfLSS5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:57:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:52060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728993AbfLSSzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:55:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD53124682;
        Thu, 19 Dec 2019 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781750;
        bh=LJLJvnGwCXDsIA9Ln7CmQsEqfN6rhQf1x7joY2IBQYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPaQDSoXjg1R181WLFRHm7fLQiax2D9S+uSexyBNM0IRG3dNeLklcb6ZfbDjHLV6o
         HKhR4sblSDkEy2UMecyc6rWIp+WvX2K9uabD35IDbl2YYlBiiw7wCtPxu+X3B4xuKu
         32qBvWM7NFv1vlJiUGV6tGOqy9nYuLcOyi8PITw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Hernandez <mhernandez@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 64/80] scsi: qla2xxx: Correctly retrieve and interpret active flash region
Date:   Thu, 19 Dec 2019 19:34:56 +0100
Message-Id: <20191219183137.117790260@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Himanshu Madhani <hmadhani@marvell.com>

commit 4e71dcae0c4cd1e9d19b8b3d80214a4bcdca5a42 upstream.

ISP27XX/28XX supports multiple flash regions. This patch fixes issue where
active flash region was not interpreted correctly during secure flash
update process.

[mkp: typo]

Fixes: 5fa8774c7f38c ("scsi: qla2xxx: Add 28xx flash primary/secondary status/image mechanism")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20191203223657.22109-2-hmadhani@marvell.com
Signed-off-by: Michael Hernandez <mhernandez@marvell.com>
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_attr.c |    1 +
 drivers/scsi/qla2xxx/qla_bsg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c  |    6 +++---
 3 files changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -176,6 +176,7 @@ qla2x00_sysfs_read_nvram(struct file *fi
 
 	faddr = ha->flt_region_nvram;
 	if (IS_QLA28XX(ha)) {
+		qla28xx_get_aux_images(vha, &active_regions);
 		if (active_regions.aux.vpd_nvram == QLA27XX_SECONDARY_IMAGE)
 			faddr = ha->flt_region_nvram_sec;
 	}
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2399,7 +2399,7 @@ qla2x00_get_flash_image_status(struct bs
 	struct qla_active_regions regions = { };
 	struct active_regions active_regions = { };
 
-	qla28xx_get_aux_images(vha, &active_regions);
+	qla27xx_get_active_image(vha, &active_regions);
 	regions.global_image = active_regions.global;
 
 	if (IS_QLA28XX(ha)) {
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -847,15 +847,15 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vh
 				ha->flt_region_img_status_pri = start;
 			break;
 		case FLT_REG_IMG_SEC_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_img_status_sec = start;
 			break;
 		case FLT_REG_FW_SEC_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_fw_sec = start;
 			break;
 		case FLT_REG_BOOTLOAD_SEC_27XX:
-			if (IS_QLA27XX(ha) && !IS_QLA28XX(ha))
+			if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
 				ha->flt_region_boot_sec = start;
 			break;
 		case FLT_REG_AUX_IMG_PRI_28XX:


