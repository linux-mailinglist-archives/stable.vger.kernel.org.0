Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D13E4FD762
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353043AbiDLHqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356912AbiDLHjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5DDC4AE18;
        Tue, 12 Apr 2022 00:10:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 639C6B81B4F;
        Tue, 12 Apr 2022 07:10:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF6EC385A1;
        Tue, 12 Apr 2022 07:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747424;
        bh=orY96oY5zBi4Mw6ib00BZeppDyNc/Z+f7495WgzDBYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b8ESX7tNjhzBllmcWVtoBOcBOCDciGs8dm4KqtMc614+U6oe0whO5eV6VNsqPh/sR
         rkwlSrZ0jNG7Xha0IDKbaCx3kWWew8/KCMqSA9+O6aCXtP430L8OmNo558MU0LjEYV
         RzEGD0+1wxoAfB6kG4B7wM6ejps5SXLaKzHQFlsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 075/343] scsi: mpi3mr: Fix deadlock while canceling the fw event
Date:   Tue, 12 Apr 2022 08:28:13 +0200
Message-Id: <20220412062953.265790600@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit 580e6742205efe6b0bfa5a6a6079f509d99168e0 ]

During controller reset, the driver tries to flush all the pending firmware
event works from worker queue that are queued prior to the reset. However,
if any work is waiting for device addition/removal operation to be
completed at the SML, then a deadlock is observed. This is due to the
controller reset waiting for the device addition/removal to be completed
and the device/addition removal is waiting for the controller reset to be
completed.

To limit this deadlock, continue with the controller reset handling without
canceling the work which is waiting for device addition/removal operation
to complete at SML.

Link: https://lore.kernel.org/r/20220210095817.22828-2-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |   4 ++
 drivers/scsi/mpi3mr/mpi3mr_fw.c |   2 +-
 drivers/scsi/mpi3mr/mpi3mr_os.c | 106 ++++++++++++++++++++++++++------
 3 files changed, 91 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index fc4eaf6d1e47..d892ade421bf 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -866,6 +866,8 @@ struct mpi3mr_ioc {
  * @send_ack: Event acknowledgment required or not
  * @process_evt: Bottomhalf processing required or not
  * @evt_ctx: Event context to send in Ack
+ * @pending_at_sml: waiting for device add/remove API to complete
+ * @discard: discard this event
  * @ref_count: kref count
  * @event_data: Actual MPI3 event data
  */
@@ -877,6 +879,8 @@ struct mpi3mr_fwevt {
 	bool send_ack;
 	bool process_evt;
 	u32 evt_ctx;
+	bool pending_at_sml;
+	bool discard;
 	struct kref ref_count;
 	char event_data[0] __aligned(4);
 };
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 15bdc21ead66..7193b983ee3b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4353,8 +4353,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
 	memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
 	memset(mrioc->evtack_cmds_bitmap, 0, mrioc->evtack_cmds_bitmap_sz);
-	mpi3mr_cleanup_fwevt_list(mrioc);
 	mpi3mr_flush_host_io(mrioc);
+	mpi3mr_cleanup_fwevt_list(mrioc);
 	mpi3mr_invalidate_devhandles(mrioc);
 	if (mrioc->prepare_for_reset) {
 		mrioc->prepare_for_reset = 0;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 284117da9086..d205354be63a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -285,6 +285,35 @@ static struct mpi3mr_fwevt *mpi3mr_dequeue_fwevt(
 	return fwevt;
 }
 
+/**
+ * mpi3mr_cancel_work - cancel firmware event
+ * @fwevt: fwevt object which needs to be canceled
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_cancel_work(struct mpi3mr_fwevt *fwevt)
+{
+	/*
+	 * Wait on the fwevt to complete. If this returns 1, then
+	 * the event was never executed.
+	 *
+	 * If it did execute, we wait for it to finish, and the put will
+	 * happen from mpi3mr_process_fwevt()
+	 */
+	if (cancel_work_sync(&fwevt->work)) {
+		/*
+		 * Put fwevt reference count after
+		 * dequeuing it from worker queue
+		 */
+		mpi3mr_fwevt_put(fwevt);
+		/*
+		 * Put fwevt reference count to neutralize
+		 * kref_init increment
+		 */
+		mpi3mr_fwevt_put(fwevt);
+	}
+}
+
 /**
  * mpi3mr_cleanup_fwevt_list - Cleanup firmware event list
  * @mrioc: Adapter instance reference
@@ -302,28 +331,25 @@ void mpi3mr_cleanup_fwevt_list(struct mpi3mr_ioc *mrioc)
 	    !mrioc->fwevt_worker_thread)
 		return;
 
-	while ((fwevt = mpi3mr_dequeue_fwevt(mrioc)) ||
-	    (fwevt = mrioc->current_event)) {
+	while ((fwevt = mpi3mr_dequeue_fwevt(mrioc)))
+		mpi3mr_cancel_work(fwevt);
+
+	if (mrioc->current_event) {
+		fwevt = mrioc->current_event;
 		/*
-		 * Wait on the fwevt to complete. If this returns 1, then
-		 * the event was never executed, and we need a put for the
-		 * reference the work had on the fwevt.
-		 *
-		 * If it did execute, we wait for it to finish, and the put will
-		 * happen from mpi3mr_process_fwevt()
+		 * Don't call cancel_work_sync() API for the
+		 * fwevt work if the controller reset is
+		 * get called as part of processing the
+		 * same fwevt work (or) when worker thread is
+		 * waiting for device add/remove APIs to complete.
+		 * Otherwise we will see deadlock.
 		 */
-		if (cancel_work_sync(&fwevt->work)) {
-			/*
-			 * Put fwevt reference count after
-			 * dequeuing it from worker queue
-			 */
-			mpi3mr_fwevt_put(fwevt);
-			/*
-			 * Put fwevt reference count to neutralize
-			 * kref_init increment
-			 */
-			mpi3mr_fwevt_put(fwevt);
+		if (current_work() == &fwevt->work || fwevt->pending_at_sml) {
+			fwevt->discard = 1;
+			return;
 		}
+
+		mpi3mr_cancel_work(fwevt);
 	}
 }
 
@@ -690,6 +716,24 @@ static struct mpi3mr_tgt_dev  *__mpi3mr_get_tgtdev_from_tgtpriv(
 	return tgtdev;
 }
 
+/**
+ * mpi3mr_print_device_event_notice - print notice related to post processing of
+ *					device event after controller reset.
+ *
+ * @mrioc: Adapter instance reference
+ * @device_add: true for device add event and false for device removal event
+ *
+ * Return: None.
+ */
+static void mpi3mr_print_device_event_notice(struct mpi3mr_ioc *mrioc,
+	bool device_add)
+{
+	ioc_notice(mrioc, "Device %s was in progress before the reset and\n",
+	    (device_add ? "addition" : "removal"));
+	ioc_notice(mrioc, "completed after reset, verify whether the exposed devices\n");
+	ioc_notice(mrioc, "are matched with attached devices for correctness\n");
+}
+
 /**
  * mpi3mr_remove_tgtdev_from_host - Remove dev from upper layers
  * @mrioc: Adapter instance reference
@@ -714,8 +758,17 @@ static void mpi3mr_remove_tgtdev_from_host(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (tgtdev->starget) {
+		if (mrioc->current_event)
+			mrioc->current_event->pending_at_sml = 1;
 		scsi_remove_target(&tgtdev->starget->dev);
 		tgtdev->host_exposed = 0;
+		if (mrioc->current_event) {
+			mrioc->current_event->pending_at_sml = 0;
+			if (mrioc->current_event->discard) {
+				mpi3mr_print_device_event_notice(mrioc, false);
+				return;
+			}
+		}
 	}
 	ioc_info(mrioc, "%s :Removed handle(0x%04x), wwid(0x%016llx)\n",
 	    __func__, tgtdev->dev_handle, (unsigned long long)tgtdev->wwid);
@@ -749,11 +802,20 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3mr_ioc *mrioc,
 	}
 	if (!tgtdev->host_exposed && !mrioc->reset_in_progress) {
 		tgtdev->host_exposed = 1;
+		if (mrioc->current_event)
+			mrioc->current_event->pending_at_sml = 1;
 		scsi_scan_target(&mrioc->shost->shost_gendev, 0,
 		    tgtdev->perst_id,
 		    SCAN_WILD_CARD, SCSI_SCAN_INITIAL);
 		if (!tgtdev->starget)
 			tgtdev->host_exposed = 0;
+		if (mrioc->current_event) {
+			mrioc->current_event->pending_at_sml = 0;
+			if (mrioc->current_event->discard) {
+				mpi3mr_print_device_event_notice(mrioc, true);
+				goto out;
+			}
+		}
 	}
 out:
 	if (tgtdev)
@@ -1193,6 +1255,8 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
 
 	for (i = 0; i < event_data->num_entries; i++) {
+		if (fwevt->discard)
+			return;
 		handle = le16_to_cpu(event_data->phy_entry[i].attached_dev_handle);
 		if (!handle)
 			continue;
@@ -1324,6 +1388,8 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	mpi3mr_pcietopochg_evt_debug(mrioc, event_data);
 
 	for (i = 0; i < event_data->num_entries; i++) {
+		if (fwevt->discard)
+			return;
 		handle =
 		    le16_to_cpu(event_data->port_entry[i].attached_dev_handle);
 		if (!handle)
@@ -1362,8 +1428,8 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr_ioc *mrioc,
 static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
 	struct mpi3mr_fwevt *fwevt)
 {
-	mrioc->current_event = fwevt;
 	mpi3mr_fwevt_del_from_list(mrioc, fwevt);
+	mrioc->current_event = fwevt;
 
 	if (mrioc->stop_drv_processing)
 		goto out;
-- 
2.35.1



