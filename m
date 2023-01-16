Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED866CA88
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbjAPREK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbjAPRD3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:03:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E5230189
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:45:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6056B80E95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113F8C433EF;
        Mon, 16 Jan 2023 16:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887547;
        bh=TuP5N/LGYDNxviG+wtdwvVRu/AbuKOV5IMR/UtPvAso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2t5Al8mzYV78nw4JOSVlbDdB+ItA6gNQiJO5054c20ewBkUghuycZRwrRFJhcf8E
         jSXJnovyB9SWeIytPUsu3kfn4TcRmCVmSEztZFppfadLbN97nPqeNGg+8/jsYc9r0k
         H7dd77jGZxVBmi8/LiXYoTq/uf9cuRAgPZ6qV5y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Justin Lindley <justin.lindley@microsemi.com>,
        David Carroll <david.carroll@microsemi.com>,
        Scott Teel <scott.teel@microsemi.com>,
        Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 190/521] scsi: hpsa: use local workqueues instead of system workqueues
Date:   Mon, 16 Jan 2023 16:47:32 +0100
Message-Id: <20230116154855.554842586@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Don Brace <don.brace@microsemi.com>

[ Upstream commit 0119208885b3faf2459de6d3fcc6d090580b906f ]

Avoid system stalls by switching to local workqueue.

Reviewed-by: Justin Lindley <justin.lindley@microsemi.com>
Reviewed-by: David Carroll <david.carroll@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 9c9ff300e0de ("scsi: hpsa: Fix possible memory leak in hpsa_init_one()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.c | 22 +++++++++++++++++++---
 drivers/scsi/hpsa.h |  1 +
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 0fe21cbdf0ca..19d9c30be09d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8133,6 +8133,11 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
 		destroy_workqueue(h->rescan_ctlr_wq);
 		h->rescan_ctlr_wq = NULL;
 	}
+	if (h->monitor_ctlr_wq) {
+		destroy_workqueue(h->monitor_ctlr_wq);
+		h->monitor_ctlr_wq = NULL;
+	}
+
 	kfree(h);				/* init_one 1 */
 }
 
@@ -8481,8 +8486,8 @@ static void hpsa_event_monitor_worker(struct work_struct *work)
 
 	spin_lock_irqsave(&h->lock, flags);
 	if (!h->remove_in_progress)
-		schedule_delayed_work(&h->event_monitor_work,
-					HPSA_EVENT_MONITOR_INTERVAL);
+		queue_delayed_work(h->monitor_ctlr_wq, &h->event_monitor_work,
+				HPSA_EVENT_MONITOR_INTERVAL);
 	spin_unlock_irqrestore(&h->lock, flags);
 }
 
@@ -8527,7 +8532,7 @@ static void hpsa_monitor_ctlr_worker(struct work_struct *work)
 
 	spin_lock_irqsave(&h->lock, flags);
 	if (!h->remove_in_progress)
-		schedule_delayed_work(&h->monitor_ctlr_work,
+		queue_delayed_work(h->monitor_ctlr_wq, &h->monitor_ctlr_work,
 				h->heartbeat_sample_interval);
 	spin_unlock_irqrestore(&h->lock, flags);
 }
@@ -8695,6 +8700,12 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto clean7;	/* aer/h */
 	}
 
+	h->monitor_ctlr_wq = hpsa_create_controller_wq(h, "monitor");
+	if (!h->monitor_ctlr_wq) {
+		rc = -ENOMEM;
+		goto clean7;
+	}
+
 	/*
 	 * At this point, the controller is ready to take commands.
 	 * Now, if reset_devices and the hard reset didn't work, try
@@ -8826,6 +8837,10 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		destroy_workqueue(h->rescan_ctlr_wq);
 		h->rescan_ctlr_wq = NULL;
 	}
+	if (h->monitor_ctlr_wq) {
+		destroy_workqueue(h->monitor_ctlr_wq);
+		h->monitor_ctlr_wq = NULL;
+	}
 	kfree(h);
 	return rc;
 }
@@ -8973,6 +8988,7 @@ static void hpsa_remove_one(struct pci_dev *pdev)
 	cancel_delayed_work_sync(&h->event_monitor_work);
 	destroy_workqueue(h->rescan_ctlr_wq);
 	destroy_workqueue(h->resubmit_wq);
+	destroy_workqueue(h->monitor_ctlr_wq);
 
 	hpsa_delete_sas_host(h);
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 59e023696fff..7aa7378f70dd 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -300,6 +300,7 @@ struct ctlr_info {
 	int	needs_abort_tags_swizzled;
 	struct workqueue_struct *resubmit_wq;
 	struct workqueue_struct *rescan_ctlr_wq;
+	struct workqueue_struct *monitor_ctlr_wq;
 	atomic_t abort_cmds_available;
 	wait_queue_head_t event_sync_wait_queue;
 	struct mutex reset_mutex;
-- 
2.35.1



