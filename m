Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD67C2EBCF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbfE3DQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730633AbfE3DQO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:14 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54909245AF;
        Thu, 30 May 2019 03:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186174;
        bh=uX0O8fFyjqjn47LlhwbHs8LWWpB51mG9r7AbkqwtLpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTrI3gLg0W2bYMtNWWNYmW639dTP76Qpcy3OVfwIByoGdybP3O8Vid6qZAXuGbCRl
         6tSXAV5B1BysXn8KiH3wa6Fsy+pq7soN8bmAqerFfb/ePXnvBHjaXReyY9cR2HW36T
         yRfhv+1EsZiaOH5+afY7ZLYrHK5GGSCpHUubgx4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 008/276] Revert "scsi: sd: Keep disk read-only when re-reading partition"
Date:   Wed, 29 May 2019 20:02:46 -0700
Message-Id: <20190530030524.061242852@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

commit 8acf608e602f6ec38b7cc37b04c80f1ce9a1a6cc upstream.

This reverts commit 20bd1d026aacc5399464f8328f305985c493cde3.

This patch introduced regressions for devices that come online in
read-only state and subsequently switch to read-write.

Given how the partition code is currently implemented it is not
possible to persist the read-only flag across a device revalidate
call. This may need to get addressed in the future since it is common
for user applications to proactively call BLKRRPART.

Reverting this commit will re-introduce a regression where a
device-initiated revalidate event will cause the admin state to be
forgotten. A separate patch will address this issue.

Fixes: 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading partition")
Cc: <stable@vger.kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2605,7 +2605,6 @@ sd_read_write_protect_flag(struct scsi_d
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
-	int disk_ro = get_disk_ro(sdkp->disk);
 	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
@@ -2646,7 +2645,7 @@ sd_read_write_protect_flag(struct scsi_d
 			  "Test WP failed, assume Write Enabled\n");
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
-		set_disk_ro(sdkp->disk, sdkp->write_prot || disk_ro);
+		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
 				  sdkp->write_prot ? "on" : "off");


