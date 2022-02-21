Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2444BE30B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiBUJsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:48:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351964AbiBUJqw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:46:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824B126559;
        Mon, 21 Feb 2022 01:18:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EFDB0CE0E88;
        Mon, 21 Feb 2022 09:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FE1C340EB;
        Mon, 21 Feb 2022 09:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435128;
        bh=Y7PU9nIctUfDJ00JRJXuXbryh+lmsN8ZPwekM7XwEzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdWack+Jrtw36UzJ5YzfV3nAiICW8mJn9qZhMcoMf+OLhYnbH40hjaIUlcVYSdQ4L
         Bi28Ibgc/PHMiC0u3cV4ocEmdvoAgpFRvD03P0AbTE4T4/kc9DB3TDBvjFo92X1LjM
         fLtyehAYdZmHC8TCRLqGORJ4BSmTGqOihsS7KC84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <martin.wilck@suse.com>,
        Martin Wilck <mwilck@suse.com>, Ming Lei <ming.lei@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 055/227] scsi: core: Reallocate devices budget map on queue depth change
Date:   Mon, 21 Feb 2022 09:47:54 +0100
Message-Id: <20220221084936.706780839@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit edb854a3680bacc9ef9b91ec0c5ff6105886f6f3 ]

We currently use ->cmd_per_lun as initial queue depth for setting up the
budget_map. Martin Wilck reported that it is common for the queue_depth to
be subsequently updated in slave_configure() based on detected hardware
characteristics.

As a result, for some drivers, the static host template settings for
cmd_per_lun and can_queue won't actually get used in practice. And if the
default values are used to allocate the budget_map, memory may be consumed
unnecessarily.

Fix the issue by reallocating the budget_map after ->slave_configure()
returns. At that time the device queue_depth should accurately reflect what
the hardware needs.

Link: https://lore.kernel.org/r/20220127153733.409132-1-ming.lei@redhat.com
Cc: Bart Van Assche <bvanassche@acm.org>
Reported-by: Martin Wilck <martin.wilck@suse.com>
Suggested-by: Martin Wilck <martin.wilck@suse.com>
Tested-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 55 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 23e1c0acdeaee..d0ce723299bf7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -214,6 +214,48 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
 			 SCSI_TIMEOUT, 3, NULL);
 }
 
+static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
+					unsigned int depth)
+{
+	int new_shift = sbitmap_calculate_shift(depth);
+	bool need_alloc = !sdev->budget_map.map;
+	bool need_free = false;
+	int ret;
+	struct sbitmap sb_backup;
+
+	/*
+	 * realloc if new shift is calculated, which is caused by setting
+	 * up one new default queue depth after calling ->slave_configure
+	 */
+	if (!need_alloc && new_shift != sdev->budget_map.shift)
+		need_alloc = need_free = true;
+
+	if (!need_alloc)
+		return 0;
+
+	/*
+	 * Request queue has to be frozen for reallocating budget map,
+	 * and here disk isn't added yet, so freezing is pretty fast
+	 */
+	if (need_free) {
+		blk_mq_freeze_queue(sdev->request_queue);
+		sb_backup = sdev->budget_map;
+	}
+	ret = sbitmap_init_node(&sdev->budget_map,
+				scsi_device_max_queue_depth(sdev),
+				new_shift, GFP_KERNEL,
+				sdev->request_queue->node, false, true);
+	if (need_free) {
+		if (ret)
+			sdev->budget_map = sb_backup;
+		else
+			sbitmap_free(&sb_backup);
+		ret = 0;
+		blk_mq_unfreeze_queue(sdev->request_queue);
+	}
+	return ret;
+}
+
 /**
  * scsi_alloc_sdev - allocate and setup a scsi_Device
  * @starget: which target to allocate a &scsi_device for
@@ -306,11 +348,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 * default device queue depth to figure out sbitmap shift
 	 * since we use this queue depth most of times.
 	 */
-	if (sbitmap_init_node(&sdev->budget_map,
-				scsi_device_max_queue_depth(sdev),
-				sbitmap_calculate_shift(depth),
-				GFP_KERNEL, sdev->request_queue->node,
-				false, true)) {
+	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
 		put_device(&starget->dev);
 		kfree(sdev);
 		goto out;
@@ -1017,6 +1055,13 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			}
 			return SCSI_SCAN_NO_RESPONSE;
 		}
+
+		/*
+		 * The queue_depth is often changed in ->slave_configure.
+		 * Set up budget map again since memory consumption of
+		 * the map depends on actual queue depth.
+		 */
+		scsi_realloc_sdev_budget_map(sdev, sdev->queue_depth);
 	}
 
 	if (sdev->scsi_level >= SCSI_3)
-- 
2.34.1



