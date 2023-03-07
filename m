Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42F816AEDE3
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbjCGSII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232057AbjCGSHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:07:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC8397FF6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:01:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DC616151D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04031C433D2;
        Tue,  7 Mar 2023 18:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212085;
        bh=CpUr+PbcGYWrMt6j6e3IRoIvTDGzYJAE4UKwKhNc3VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3d4cS6A5IBs0O7YUFpPTrEQKGP1ImsZ6FtKA1lklSSFlS/1dqAj73ovGah7aNoJO
         kPH1MReqc39mvcScrSuv+n/YkocicMd/EKR790VrhtrEZe9vEOLoEZl47u00zy0bLo
         +FXfDCMG2zEGP4okn9KZINJltu5aLof9OUt3YHr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/885] ublk_drv: dont probe partitions if the ubq daemon isnt trusted
Date:   Tue,  7 Mar 2023 17:50:06 +0100
Message-Id: <20230307170004.907945269@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 73a166d9749230d598320fdae3b687cdc0e2e205 ]

If any ubq daemon is unprivileged, the ublk char device is allowed
for unprivileged user actually, and we can't trust the current user,
so not probe partitions.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Reviewed-by: ZiyangZhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230106041711.914434-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index f44b9467720c9..450bd54fd0061 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -159,6 +159,7 @@ struct ublk_device {
 
 	struct completion	completion;
 	unsigned int		nr_queues_ready;
+	unsigned int		nr_privileged_daemon;
 
 	/*
 	 * Our ubq->daemon may be killed without any notification, so
@@ -1178,6 +1179,9 @@ static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
 		ubq->ubq_daemon = current;
 		get_task_struct(ubq->ubq_daemon);
 		ub->nr_queues_ready++;
+
+		if (capable(CAP_SYS_ADMIN))
+			ub->nr_privileged_daemon++;
 	}
 	if (ub->nr_queues_ready == ub->dev_info.nr_hw_queues)
 		complete_all(&ub->completion);
@@ -1534,6 +1538,10 @@ static int ublk_ctrl_start_dev(struct io_uring_cmd *cmd)
 	if (ret)
 		goto out_put_disk;
 
+	/* don't probe partitions if any one ubq daemon is un-trusted */
+	if (ub->nr_privileged_daemon != ub->nr_queues_ready)
+		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
+
 	get_device(&ub->cdev_dev);
 	ret = add_disk(disk);
 	if (ret) {
@@ -1935,6 +1943,7 @@ static int ublk_ctrl_start_recovery(struct io_uring_cmd *cmd)
 	/* set to NULL, otherwise new ubq_daemon cannot mmap the io_cmd_buf */
 	ub->mm = NULL;
 	ub->nr_queues_ready = 0;
+	ub->nr_privileged_daemon = 0;
 	init_completion(&ub->completion);
 	ret = 0;
  out_unlock:
-- 
2.39.2



