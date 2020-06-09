Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAF31F4607
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732146AbgFISXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:58914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732119AbgFIRrg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:47:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5EE520801;
        Tue,  9 Jun 2020 17:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724856;
        bh=gz4yzpENGTwtO6BvLL61gS3WMm5cksSG2EmPaENhZtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XoINWjCIWFHmRqoBdb55MjPhIUdGRPRwMm8BFlSk7XUQAzDNdOku9iH1NJw/76FRc
         q1ZnJeQwJjVwIQLhXYpwDVgoF433aaKLulR2dVH6goZiu0Fux/dmRh7fCAVG3OyzNV
         6cGjyD43pGXM0OqSG0RNR2Ty9AFlCJubS+3ll69k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 01/42] scsi: scsi_devinfo: fixup string compare
Date:   Tue,  9 Jun 2020 19:44:07 +0200
Message-Id: <20200609174015.533553608@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174015.379493548@linuxfoundation.org>
References: <20200609174015.379493548@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

commit b8018b973c7cefa5eb386540130fa47315b8e337 upstream.

When checking the model and vendor string we need to use the minimum
value of either string, otherwise we'll miss out on wildcard matches.

And we should take care when matching with zero size strings; results
might be unpredictable.  With this patch the rules for matching devinfo
strings are as follows:

- Vendor strings must match exactly
- Empty Model strings will only match if the devinfo model
  is also empty
- Model strings shorter than the devinfo model string will
  not match

Fixes: 5e7ff2c ("SCSI: fix new bug in scsi_dev_info_list string matching")
Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_devinfo.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -394,8 +394,8 @@ EXPORT_SYMBOL(scsi_dev_info_list_add_key
 
 /**
  * scsi_dev_info_list_find - find a matching dev_info list entry.
- * @vendor:	vendor string
- * @model:	model (product) string
+ * @vendor:	full vendor string
+ * @model:	full model (product) string
  * @key:	specify list to use
  *
  * Description:
@@ -410,7 +410,7 @@ static struct scsi_dev_info_list *scsi_d
 	struct scsi_dev_info_list *devinfo;
 	struct scsi_dev_info_list_table *devinfo_table =
 		scsi_devinfo_lookup_by_key(key);
-	size_t vmax, mmax;
+	size_t vmax, mmax, mlen;
 	const char *vskip, *mskip;
 
 	if (IS_ERR(devinfo_table))
@@ -449,15 +449,18 @@ static struct scsi_dev_info_list *scsi_d
 			    dev_info_list) {
 		if (devinfo->compatible) {
 			/*
-			 * Behave like the older version of get_device_flags.
+			 * vendor strings must be an exact match
 			 */
-			if (memcmp(devinfo->vendor, vskip, vmax) ||
-					(vmax < sizeof(devinfo->vendor) &&
-						devinfo->vendor[vmax]))
+			if (vmax != strlen(devinfo->vendor) ||
+			    memcmp(devinfo->vendor, vskip, vmax))
 				continue;
-			if (memcmp(devinfo->model, mskip, mmax) ||
-					(mmax < sizeof(devinfo->model) &&
-						devinfo->model[mmax]))
+
+			/*
+			 * @model specifies the full string, and
+			 * must be larger or equal to devinfo->model
+			 */
+			mlen = strlen(devinfo->model);
+			if (mmax < mlen || memcmp(devinfo->model, mskip, mlen))
 				continue;
 			return devinfo;
 		} else {


