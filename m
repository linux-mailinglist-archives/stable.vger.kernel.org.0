Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535AE658355
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235017AbiL1Qqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbiL1QqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:46:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8E31DDCB
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:41:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BFCA3CE1367
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C03C433D2;
        Wed, 28 Dec 2022 16:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245679;
        bh=5cSXQd1kUirWD2KjvQIt7gsYW93YphZeCiFw9YuNZ8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBm2d9v2cCKd2bedYsNjWxSg8k8MdeMhZNMt1+ZgORcJxDH9ZrD2ybV+kcAH79hmV
         Nf2yCun+YfE3IXY7Hw2WHDeSrmPlx6u1eX9Uxvea0rRoS9P3PybYD6sLO43pYK74yo
         kehDJEf5Ramg2b7gi150gjeiRTaa36yINqtsv05c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0904/1146] block: factor out a blk_debugfs_remove helper
Date:   Wed, 28 Dec 2022 15:40:43 +0100
Message-Id: <20221228144354.769197269@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 6fc75f309d291d328b4ea2f91bef0ff56e4bc7c2 ]

Split the debugfs removal from blk_unregister_queue into a helper so that
the it can be reused for blk_register_queue error handling.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221114042637.1009333-3-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d36a9ea5e776 ("block: fix use-after-free of q->q_usage_counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 2b1cf0b2a5c7..3d6951a0b4e7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -797,6 +797,19 @@ struct kobj_type blk_queue_ktype = {
 	.release	= blk_release_queue,
 };
 
+static void blk_debugfs_remove(struct gendisk *disk)
+{
+	struct request_queue *q = disk->queue;
+
+	mutex_lock(&q->debugfs_mutex);
+	blk_trace_shutdown(q);
+	debugfs_remove_recursive(q->debugfs_dir);
+	q->debugfs_dir = NULL;
+	q->sched_debugfs_dir = NULL;
+	q->rqos_debugfs_dir = NULL;
+	mutex_unlock(&q->debugfs_mutex);
+}
+
 /**
  * blk_register_queue - register a block layer queue with sysfs
  * @disk: Disk of which the request queue should be registered with sysfs.
@@ -922,11 +935,5 @@ void blk_unregister_queue(struct gendisk *disk)
 	kobject_del(&q->kobj);
 	mutex_unlock(&q->sysfs_dir_lock);
 
-	mutex_lock(&q->debugfs_mutex);
-	blk_trace_shutdown(q);
-	debugfs_remove_recursive(q->debugfs_dir);
-	q->debugfs_dir = NULL;
-	q->sched_debugfs_dir = NULL;
-	q->rqos_debugfs_dir = NULL;
-	mutex_unlock(&q->debugfs_mutex);
+	blk_debugfs_remove(disk);
 }
-- 
2.35.1



