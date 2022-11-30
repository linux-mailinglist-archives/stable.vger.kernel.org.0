Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC0C63DF45
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbiK3Spg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbiK3SpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:45:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8782A268
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:45:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CB60B81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53EFC433C1;
        Wed, 30 Nov 2022 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833906;
        bh=Q/oD89con3HfIF8UyBMoJI14EGHlr2hadrJ7ayPy84o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHTg5kxjhmrUNlevkuz9J2PvQ5Q3Z3j8fspGjoF7RKUyauwmDBlQuyJzVZQlxriHJ
         9XDEA1f/CcTMsljY5MysFpQh2Asf6tsIxfkXlGV5bXH4ywT2dbBT61rRR4MxlMqKn0
         jTI8cWknwG07jpguaT4hnwl35T6NOy60mSoq5N/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Juan Tian <juantian@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 058/289] scsi: storvsc: Fix handling of srb_status and capacity change events
Date:   Wed, 30 Nov 2022 19:20:43 +0100
Message-Id: <20221130180545.447121217@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit b8a5376c321b4669f7ffabc708fd30c3970f3084 ]

Current handling of the srb_status is incorrect. Commit 52e1b3b3daa9
("scsi: storvsc: Correctly handle multiple flags in srb_status")
is based on srb_status being a set of flags, when in fact only the
2 high order bits are flags and the remaining 6 bits are an integer
status. Because the integer values of interest mostly look like flags,
the code actually works when treated that way.

But in the interest of correctness going forward, fix this by treating
the low 6 bits of srb_status as an integer status code. Add handling
for SRB_STATUS_INVALID_REQUEST, which was the original intent of commit
52e1b3b3daa9. Furthermore, treat the ERROR, ABORTED, and INVALID_REQUEST
srb status codes as essentially equivalent for the cases we care about.
There's no harm in doing so, and it isn't always clear which status code
current or older versions of Hyper-V report for particular conditions.

Treating the srb status codes as equivalent has the additional benefit
of ensuring that capacity change events result in an immediate rescan
so that the new size is known to Linux. Existing code checks SCSI
sense data for capacity change events when the srb status is ABORTED.
But capacity change events are also being observed when Hyper-V reports
the srb status as ERROR. Without the immediate rescan, the new size
isn't known until something else causes a rescan (such as running
fdisk to expand a partition), and in the meantime, tools such as "lsblk"
continue to report the old size.

Fixes: 52e1b3b3daa9 ("scsi: storvsc: Correctly handle multiple flags in srb_status")
Reported-by: Juan Tian <juantian@microsoft.com>
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/1668019722-1983-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 69 +++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8ced292c4b96..d93604318ecd 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -300,16 +300,21 @@ enum storvsc_request_type {
 };
 
 /*
- * SRB status codes and masks; a subset of the codes used here.
+ * SRB status codes and masks. In the 8-bit field, the two high order bits
+ * are flags, while the remaining 6 bits are an integer status code.  The
+ * definitions here include only the subset of the integer status codes that
+ * are tested for in this driver.
  */
-
 #define SRB_STATUS_AUTOSENSE_VALID	0x80
 #define SRB_STATUS_QUEUE_FROZEN		0x40
-#define SRB_STATUS_INVALID_LUN	0x20
-#define SRB_STATUS_SUCCESS	0x01
-#define SRB_STATUS_ABORTED	0x02
-#define SRB_STATUS_ERROR	0x04
-#define SRB_STATUS_DATA_OVERRUN	0x12
+
+/* SRB status integer codes */
+#define SRB_STATUS_SUCCESS		0x01
+#define SRB_STATUS_ABORTED		0x02
+#define SRB_STATUS_ERROR		0x04
+#define SRB_STATUS_INVALID_REQUEST	0x06
+#define SRB_STATUS_DATA_OVERRUN		0x12
+#define SRB_STATUS_INVALID_LUN		0x20
 
 #define SRB_STATUS(status) \
 	(status & ~(SRB_STATUS_AUTOSENSE_VALID | SRB_STATUS_QUEUE_FROZEN))
@@ -966,38 +971,25 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 	void (*process_err_fn)(struct work_struct *work);
 	struct hv_host_device *host_dev = shost_priv(host);
 
-	/*
-	 * In some situations, Hyper-V sets multiple bits in the
-	 * srb_status, such as ABORTED and ERROR. So process them
-	 * individually, with the most specific bits first.
-	 */
-
-	if (vm_srb->srb_status & SRB_STATUS_INVALID_LUN) {
-		set_host_byte(scmnd, DID_NO_CONNECT);
-		process_err_fn = storvsc_remove_lun;
-		goto do_work;
-	}
+	switch (SRB_STATUS(vm_srb->srb_status)) {
+	case SRB_STATUS_ERROR:
+	case SRB_STATUS_ABORTED:
+	case SRB_STATUS_INVALID_REQUEST:
+		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID) {
+			/* Check for capacity change */
+			if ((asc == 0x2a) && (ascq == 0x9)) {
+				process_err_fn = storvsc_device_scan;
+				/* Retry the I/O that triggered this. */
+				set_host_byte(scmnd, DID_REQUEUE);
+				goto do_work;
+			}
 
-	if (vm_srb->srb_status & SRB_STATUS_ABORTED) {
-		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID &&
-		    /* Capacity data has changed */
-		    (asc == 0x2a) && (ascq == 0x9)) {
-			process_err_fn = storvsc_device_scan;
 			/*
-			 * Retry the I/O that triggered this.
+			 * Otherwise, let upper layer deal with the
+			 * error when sense message is present
 			 */
-			set_host_byte(scmnd, DID_REQUEUE);
-			goto do_work;
-		}
-	}
-
-	if (vm_srb->srb_status & SRB_STATUS_ERROR) {
-		/*
-		 * Let upper layer deal with error when
-		 * sense message is present.
-		 */
-		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID)
 			return;
+		}
 
 		/*
 		 * If there is an error; offline the device since all
@@ -1020,6 +1012,13 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 		default:
 			set_host_byte(scmnd, DID_ERROR);
 		}
+		return;
+
+	case SRB_STATUS_INVALID_LUN:
+		set_host_byte(scmnd, DID_NO_CONNECT);
+		process_err_fn = storvsc_remove_lun;
+		goto do_work;
+
 	}
 	return;
 
-- 
2.35.1



