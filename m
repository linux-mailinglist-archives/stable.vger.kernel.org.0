Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC02A4FD534
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353867AbiDLHhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353669AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BBA10FDF;
        Tue, 12 Apr 2022 00:03:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DE0F60B65;
        Tue, 12 Apr 2022 07:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26091C385A6;
        Tue, 12 Apr 2022 07:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747000;
        bh=QoSKt1QfGOxXJk45hbuvdVdVfyISsG2D2JIrfiPHx8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLTrcL+NZBjJjN6ZEWtXDRATb3CkF4O5+uGW7opb07UJp2qSjtmy1imTfWUJchNM4
         VkjRFip49Um2/jTlZ95nybCy4binClzn3t1cuv59gatLlUR0ay2aVJZCHMvc08aVVH
         6TQT1Nj+15hsNCE0JSfxi8/uDsQbKKuAEpIPlV88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 157/285] scsi: core: Fix sbitmap depth in scsi_realloc_sdev_budget_map()
Date:   Tue, 12 Apr 2022 08:30:14 +0200
Message-Id: <20220412062948.203087039@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: John Garry <john.garry@huawei.com>

[ Upstream commit eaba83b5b8506bbc9ee7ca2f10aeab3fff3719e7 ]

In commit edb854a3680b ("scsi: core: Reallocate device's budget map on
queue depth change"), the sbitmap for the device budget map may be
reallocated after the slave device depth is configured.

When the sbitmap is reallocated we use the result from
scsi_device_max_queue_depth() for the sbitmap size, but don't resize to
match the actual device queue depth.

Fix by resizing the sbitmap after reallocating the budget sbitmap. We do
this instead of init'ing the sbitmap to the device queue depth as the user
may want to change the queue depth later via sysfs or other.

Link: https://lore.kernel.org/r/1647423870-143867-1-git-send-email-john.garry@huawei.com
Fixes: edb854a3680b ("scsi: core: Reallocate device's budget map on queue depth change")
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d0ce723299bf..6bc0f5f511e1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -223,6 +223,8 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 	int ret;
 	struct sbitmap sb_backup;
 
+	depth = min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev));
+
 	/*
 	 * realloc if new shift is calculated, which is caused by setting
 	 * up one new default queue depth after calling ->slave_configure
@@ -245,6 +247,9 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 				scsi_device_max_queue_depth(sdev),
 				new_shift, GFP_KERNEL,
 				sdev->request_queue->node, false, true);
+	if (!ret)
+		sbitmap_resize(&sdev->budget_map, depth);
+
 	if (need_free) {
 		if (ret)
 			sdev->budget_map = sb_backup;
-- 
2.35.1



