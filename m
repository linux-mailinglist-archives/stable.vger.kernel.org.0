Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECDE82EB0D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfE3DJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:45142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727732AbfE3DJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:09:44 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD82F24490;
        Thu, 30 May 2019 03:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185783;
        bh=BTwjII6Wd+SwyBvRtmFt2MY9N4RyqCEHuN3z/WsuiMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TR2RFtctA3kl4C3UrfqrgRVtA/jBe/F1Yv8wYsYKfTSm58xle3e+aMOyoVQyU/3MK
         iolSbWOo7JnoDV2haALLM5GUzts91MdYk6F5IS47qk1RkcqfqCh4NXpmeCskNlV+/m
         1qz6HGkRSbcxbNk+G+ZasCaZyBN66+NfWlYLDd0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.1 008/405] Revert "scsi: sd: Keep disk read-only when re-reading partition"
Date:   Wed, 29 May 2019 20:00:06 -0700
Message-Id: <20190530030540.816673121@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
@@ -2603,7 +2603,6 @@ sd_read_write_protect_flag(struct scsi_d
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
-	int disk_ro = get_disk_ro(sdkp->disk);
 	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
@@ -2644,7 +2643,7 @@ sd_read_write_protect_flag(struct scsi_d
 			  "Test WP failed, assume Write Enabled\n");
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
-		set_disk_ro(sdkp->disk, sdkp->write_prot || disk_ro);
+		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
 				  sdkp->write_prot ? "on" : "off");


