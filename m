Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D794F2C93
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbiDEJBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237555AbiDEImt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:42:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0686FD3F;
        Tue,  5 Apr 2022 01:35:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DA4CB81B92;
        Tue,  5 Apr 2022 08:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8EAC385A1;
        Tue,  5 Apr 2022 08:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147705;
        bh=UGpzPQNI4GOt0ywa7n6WBbyYUgXZfRiJ3AkseXs1ivo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuxajA+rhxmMMPoAChwonX8UykM3QCM1xSjs0Tsfv0mxKKxiXLPggsB1UJUoHOj23
         rOd0AORfU7ua1wPeV3dQEOZ6R5IvG0mUSAmqk6fqmRfiF04akMZjIhWhHYlz5i/QRr
         6Oen50wAltaYx9/r+UUd+7oF3ZwVGOOGOQ+VLfPQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0092/1017] scsi: ufs: Fix runtime PM messages never-ending cycle
Date:   Tue,  5 Apr 2022 09:16:45 +0200
Message-Id: <20220405070356.925632006@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 71bb9ab6e3511b7bb98678a19eb8cf1ccbf3ca2f upstream.

Kernel messages produced during runtime PM can cause a never-ending cycle
because user space utilities (e.g. journald or rsyslog) write the messages
back to storage, causing runtime resume, more messages, and so on.

Messages that tell of things that are expected to happen, are arguably
unnecessary, so suppress them.

UFS driver messages are changes to from dev_err() to dev_dbg() which means
they will not display unless activated by dynamic debug of building with
-DDEBUG.

sdev->silence_suspend is set to skip messages from sd_suspend_common()
"Synchronizing SCSI cache", "Stopping disk" and scsi_report_sense()
"Power-on or device reset occurred" message (Note, that message appears
when the LUN is accessed after runtime PM, not during runtime PM)

 Example messages from Ubuntu 21.10:

 $ dmesg | tail
 [ 1620.380071] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
 [ 1620.408825] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[4, 4], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
 [ 1620.409020] ufshcd 0000:00:12.5: ufshcd_find_max_sup_active_icc_level: Regulator capability was not set, actvIccLevel=0
 [ 1620.409524] sd 0:0:0:0: Power-on or device reset occurred
 [ 1622.938794] sd 0:0:0:0: [sda] Synchronizing SCSI cache
 [ 1622.939184] ufs_device_wlun 0:0:0:49488: Power-on or device reset occurred
 [ 1625.183175] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[1, 1], lane[1, 1], pwr[SLOWAUTO_MODE, SLOWAUTO_MODE], rate = 0
 [ 1625.208041] ufshcd 0000:00:12.5: ufshcd_print_pwr_info:[RX, TX]: gear=[4, 4], lane[2, 2], pwr[FAST MODE, FAST MODE], rate = 2
 [ 1625.208311] ufshcd 0000:00:12.5: ufshcd_find_max_sup_active_icc_level: Regulator capability was not set, actvIccLevel=0
 [ 1625.209035] sd 0:0:0:0: Power-on or device reset occurred

Note for stable: depends on patch "scsi: core: sd: Add silence_suspend flag
to suppress some PM messages".

Link: https://lore.kernel.org/r/20220228113652.970857-3-adrian.hunter@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufshcd.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -585,7 +585,12 @@ static void ufshcd_print_pwr_info(struct
 		"INVALID MODE",
 	};
 
-	dev_err(hba->dev, "%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
+	/*
+	 * Using dev_dbg to avoid messages during runtime PM to avoid
+	 * never-ending cycles of messages written back to storage by user space
+	 * causing runtime resume, causing more messages and so on.
+	 */
+	dev_dbg(hba->dev, "%s:[RX, TX]: gear=[%d, %d], lane[%d, %d], pwr[%s, %s], rate = %d\n",
 		 __func__,
 		 hba->pwr_info.gear_rx, hba->pwr_info.gear_tx,
 		 hba->pwr_info.lane_rx, hba->pwr_info.lane_tx,
@@ -4999,6 +5004,12 @@ static int ufshcd_slave_configure(struct
 		pm_runtime_get_noresume(&sdev->sdev_gendev);
 	else if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
+	/*
+	 * Do not print messages during runtime PM to avoid never-ending cycles
+	 * of messages written back to storage by user space causing runtime
+	 * resume, causing more messages and so on.
+	 */
+	sdev->silence_suspend = 1;
 
 	ufshcd_crypto_register(hba, q);
 
@@ -7285,7 +7296,13 @@ static u32 ufshcd_find_max_sup_active_ic
 
 	if (!hba->vreg_info.vcc || !hba->vreg_info.vccq ||
 						!hba->vreg_info.vccq2) {
-		dev_err(hba->dev,
+		/*
+		 * Using dev_dbg to avoid messages during runtime PM to avoid
+		 * never-ending cycles of messages written back to storage by
+		 * user space causing runtime resume, causing more messages and
+		 * so on.
+		 */
+		dev_dbg(hba->dev,
 			"%s: Regulator capability was not set, actvIccLevel=%d",
 							__func__, icc_level);
 		goto out;


