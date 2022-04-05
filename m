Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2404F2C21
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235395AbiDEJBp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237578AbiDEImt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:42:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0657BE0F8;
        Tue,  5 Apr 2022 01:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8B01B81A32;
        Tue,  5 Apr 2022 08:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A3EC385A0;
        Tue,  5 Apr 2022 08:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147702;
        bh=PtiUFmJWekEDwY8UObS7pyYJvrAHvgLHr0gp6vBSGeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/U4cjRXzd6+ZUDenPcZJIybOuw3Py16lBxvGWkAOVI93bAWATx4ZMW9lXrNnncdq
         g/lLB0rGMqLVm24bfHxFzYh4y1Dix4jkFA7ZzA6CYszLDOu7K3j/EXEYfiTDcMTeB3
         K5J2jnvfTSAyvyxsKDljqTHx+3r+mnYbhtVYP76U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0091/1017] scsi: core: sd: Add silence_suspend flag to suppress some PM messages
Date:   Tue,  5 Apr 2022 09:16:44 +0200
Message-Id: <20220405070356.895353746@linuxfoundation.org>
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

commit af4edb1d50c6d1044cb34bc43621411b7ba2cffe upstream.

Kernel messages produced during runtime PM can cause a never-ending cycle
because user space utilities (e.g. journald or rsyslog) write the messages
back to storage, causing runtime resume, more messages, and so on.

Messages that tell of things that are expected to happen are arguably
unnecessary, so add a flag to suppress them. This flag is used by the UFS
driver.

Link: https://lore.kernel.org/r/20220228113652.970857-2-adrian.hunter@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_error.c  |    9 +++++++--
 drivers/scsi/sd.c          |    6 ++++--
 include/scsi/scsi_device.h |    1 +
 3 files changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -483,8 +483,13 @@ static void scsi_report_sense(struct scs
 
 		if (sshdr->asc == 0x29) {
 			evt_type = SDEV_EVT_POWER_ON_RESET_OCCURRED;
-			sdev_printk(KERN_WARNING, sdev,
-				    "Power-on or device reset occurred\n");
+			/*
+			 * Do not print message if it is an expected side-effect
+			 * of runtime PM.
+			 */
+			if (!sdev->silence_suspend)
+				sdev_printk(KERN_WARNING, sdev,
+					    "Power-on or device reset occurred\n");
 		}
 
 		if (sshdr->asc == 0x2a && sshdr->ascq == 0x01) {
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3754,7 +3754,8 @@ static int sd_suspend_common(struct devi
 		return 0;
 
 	if (sdkp->WCE && sdkp->media_present) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+		if (!sdkp->device->silence_suspend)
+			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
 		ret = sd_sync_cache(sdkp, &sshdr);
 
 		if (ret) {
@@ -3776,7 +3777,8 @@ static int sd_suspend_common(struct devi
 	}
 
 	if (sdkp->device->manage_start_stop) {
-		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
+		if (!sdkp->device->silence_suspend)
+			sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		/* an error is not worth aborting a system sleep */
 		ret = sd_start_stop_device(sdkp, 0);
 		if (ignore_stop_errors)
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -206,6 +206,7 @@ struct scsi_device {
 	unsigned rpm_autosuspend:1;	/* Enable runtime autosuspend at device
 					 * creation time */
 	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
+	unsigned silence_suspend:1;	/* Do not print runtime PM related messages */
 
 	unsigned int queue_stopped;	/* request queue is quiesced */
 	bool offline_already;		/* Device offline message logged */


