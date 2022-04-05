Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F24A4F32D8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244273AbiDEKiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240441AbiDEJe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:34:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0ACF85645;
        Tue,  5 Apr 2022 02:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 346076164E;
        Tue,  5 Apr 2022 09:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440E6C385A0;
        Tue,  5 Apr 2022 09:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150637;
        bh=nzGYsikKbXTo3ofPbBteuWmzrEF10M28ReEJiqZdw2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjkEl+I/2Tpbt/PiW9eTIN5PO1ZbJYg7RcpuM8+sKbXYoODuKr9XGn1PRLBy8nzpI
         KFRFZGoRlMhV60/x76pfd59tfXlJY3xdQBRwrWMYAg4wDJtqAM3ivQdfGwtWjg/MDZ
         DfQxKePcBwoXCU/5eyuPqDu4Zl15/AhxqGPMWNmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 088/913] scsi: ufs: Fix runtime PM messages never-ending cycle
Date:   Tue,  5 Apr 2022 09:19:10 +0200
Message-Id: <20220405070342.461308967@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
@@ -576,7 +576,12 @@ static void ufshcd_print_pwr_info(struct
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
@@ -4967,6 +4972,12 @@ static int ufshcd_slave_configure(struct
 		pm_runtime_get_noresume(&sdev->sdev_gendev);
 	else if (ufshcd_is_rpm_autosuspend_allowed(hba))
 		sdev->rpm_autosuspend = 1;
+	/*
+	 * Do not print messages during runtime PM to avoid never-ending cycles
+	 * of messages written back to storage by user space causing runtime
+	 * resume, causing more messages and so on.
+	 */
+	sdev->silence_suspend = 1;
 
 	ufshcd_crypto_setup_rq_keyslot_manager(hba, q);
 
@@ -7199,7 +7210,13 @@ static u32 ufshcd_find_max_sup_active_ic
 
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


