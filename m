Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6146C178A
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjCTPOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbjCTPOZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:14:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB22625286
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:09:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 225EAB80EC4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE6BC433D2;
        Mon, 20 Mar 2023 15:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324969;
        bh=WaPvSlBJZcFujpY1vhJURYO2urHV40NGcoFnk+qFrn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2siNMHovkhm8t801qKSzoy/gfHCQMh41Y1qijoMJAz6m7FgbjZCODdHsN40OvtZ9
         z5PEykXVFsIMBLvAdBPQ9MH6tDKye1b+2HvqjWESMNF4AEUlvt+Nh6vNr0g3Apb+b/
         elAoNEN+r7LWCGGXL8K9jyMeRWl4UIADWq7WHmAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Martin Wilck <mwilck@suse.com>,
        Hannes Reinecke <hare@suse.de>, Lee Duncan <lduncan@suse.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/198] scsi: core: Add BLIST_NO_VPD_SIZE for some VDASD
Date:   Mon, 20 Mar 2023 15:52:47 +0100
Message-Id: <20230320145508.705832077@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

[ Upstream commit 4b1a2c2a8e0ddcb89c5f6c5003bd9b53142f69e3 ]

Some storage, such as AIX VDASD (virtual storage) and IBM 2076 (front
end), fail as a result of commit c92a6b5d6335 ("scsi: core: Query VPD
size before getting full page").

That commit changed getting SCSI VPD pages so that we now read just
enough of the page to get the actual page size, then read the whole
page in a second read. The problem is that the above mentioned
hardware returns zero for the page size, because of a firmware
error. In such cases, until the firmware is fixed, this new blacklist
flag says to revert to the original method of reading the VPD pages,
i.e. try to read a whole buffer's worth on the first try.

[mkp: reworked somewhat]

Fixes: c92a6b5d6335 ("scsi: core: Query VPD size before getting full page")
Reported-by: Martin Wilck <mwilck@suse.com>
Suggested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Lee Duncan <lduncan@suse.com>
Link: https://lore.kernel.org/r/20220928181350.9948-1-leeman.duncan@gmail.com
Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi.c         | 3 +++
 drivers/scsi/scsi_devinfo.c | 3 ++-
 drivers/scsi/scsi_scan.c    | 3 +++
 include/scsi/scsi_device.h  | 2 ++
 include/scsi/scsi_devinfo.h | 6 +++---
 5 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2a..24c4c92543599 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -326,6 +326,9 @@ static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
 	unsigned char vpd_header[SCSI_VPD_HEADER_SIZE] __aligned(4);
 	int result;
 
+	if (sdev->no_vpd_size)
+		return SCSI_DEFAULT_VPD_LEN;
+
 	/*
 	 * Fetch the VPD page header to find out how big the page
 	 * is. This is done to prevent problems on legacy devices
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c7080454aea99..bc9d280417f6a 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -134,7 +134,7 @@ static struct {
 	{"3PARdata", "VV", NULL, BLIST_REPORTLUN2},
 	{"ADAPTEC", "AACRAID", NULL, BLIST_FORCELUN},
 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
-	{"AIX", "VDASD", NULL, BLIST_TRY_VPD_PAGES},
+	{"AIX", "VDASD", NULL, BLIST_TRY_VPD_PAGES | BLIST_NO_VPD_SIZE},
 	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN},
 	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"BROWNIE", "1200U3P", NULL, BLIST_NOREPORTLUN},
@@ -188,6 +188,7 @@ static struct {
 	{"HPE", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"IBM", "2076", NULL, BLIST_NO_VPD_SIZE},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
 	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d149b218715e5..d12f2dcb4040a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1056,6 +1056,9 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	else if (*bflags & BLIST_SKIP_VPD_PAGES)
 		sdev->skip_vpd_pages = 1;
 
+	if (*bflags & BLIST_NO_VPD_SIZE)
+		sdev->no_vpd_size = 1;
+
 	transport_configure_device(&sdev->sdev_gendev);
 
 	if (sdev->host->hostt->slave_configure) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index c36656d8ac6c7..006858ed04e8c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -145,6 +145,7 @@ struct scsi_device {
 	const char * model;		/* ... after scan; point to static string */
 	const char * rev;		/* ... "nullnullnullnull" before scan */
 
+#define SCSI_DEFAULT_VPD_LEN	255	/* default SCSI VPD page size (max) */
 	struct scsi_vpd __rcu *vpd_pg0;
 	struct scsi_vpd __rcu *vpd_pg83;
 	struct scsi_vpd __rcu *vpd_pg80;
@@ -214,6 +215,7 @@ struct scsi_device {
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
 	unsigned silence_suspend:1;	/* Do not print runtime PM related messages */
+	unsigned no_vpd_size:1;		/* No VPD size reported in header */
 
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 5d14adae21c78..6b548dc2c4965 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -32,7 +32,8 @@
 #define BLIST_IGN_MEDIA_CHANGE	((__force blist_flags_t)(1ULL << 11))
 /* do not do automatic start on add */
 #define BLIST_NOSTARTONADD	((__force blist_flags_t)(1ULL << 12))
-#define __BLIST_UNUSED_13	((__force blist_flags_t)(1ULL << 13))
+/* do not ask for VPD page size first on some broken targets */
+#define BLIST_NO_VPD_SIZE	((__force blist_flags_t)(1ULL << 13))
 #define __BLIST_UNUSED_14	((__force blist_flags_t)(1ULL << 14))
 #define __BLIST_UNUSED_15	((__force blist_flags_t)(1ULL << 15))
 #define __BLIST_UNUSED_16	((__force blist_flags_t)(1ULL << 16))
@@ -74,8 +75,7 @@
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \
 			       ((__force __u64)__BLIST_LAST_USED - 1ULL)))
-#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_13 | \
-			     __BLIST_UNUSED_14 | \
+#define __BLIST_UNUSED_MASK (__BLIST_UNUSED_14 | \
 			     __BLIST_UNUSED_15 | \
 			     __BLIST_UNUSED_16 | \
 			     __BLIST_UNUSED_24 | \
-- 
2.39.2



