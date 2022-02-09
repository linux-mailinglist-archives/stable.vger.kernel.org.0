Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275474AFAD6
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbiBISkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240229AbiBISkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EA8C03326C;
        Wed,  9 Feb 2022 10:39:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94C1EB82384;
        Wed,  9 Feb 2022 18:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40096C340E9;
        Wed,  9 Feb 2022 18:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644431973;
        bh=lBS1PiFdP3yxD/PYLR6hsDp3zi/r/zvvJWP4zHDftYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E4/fJfWCPRe+3tKhdIvn5p4zsZvksEfSG856g/jED4VaEwfBye+NZOU8OQEYs3GLF
         XfPLKRnZQSJcNPaa71OkCgcRXUtg1b33fuh/JnfkrJzB8TgYj1mafKyQg60i3isust
         gTq51CXiKp9GOaWOKRkH2dSsC6bNqTMLRT2t5LFKW/4hF+evPq5Yi3QFnCTo+7i7PM
         qztMzIDJ7ModIchaGtPRSsFynjTPRrgcbURtqCpRQkGK0BW8wUKt0hVCFgUVUlUPqa
         wNfEWbfmkker24vGXV1CDadnnsvybKc7JHuKbW0iSyu24WAxYcGWKP93j1eeucL+3I
         C0oLYvc1gzwBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <martin.wilck@suse.com>,
        Martin Wilck <mwilck@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 22/36] scsi: core: Reallocate device's budget map on queue depth change
Date:   Wed,  9 Feb 2022 13:37:45 -0500
Message-Id: <20220209183759.47134-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209183759.47134-1-sashal@kernel.org>
References: <20220209183759.47134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index fe22191522a3b..7266880c70c21 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -198,6 +198,48 @@ static void scsi_unlock_floptical(struct scsi_device *sdev,
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
@@ -291,11 +333,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
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
@@ -1001,6 +1039,13 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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

