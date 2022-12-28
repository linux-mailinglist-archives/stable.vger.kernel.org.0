Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE9A6582D2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbiL1QmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:42:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234892AbiL1Qla (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:41:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6256A1403E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:35:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C32EB81707
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9130C433D2;
        Wed, 28 Dec 2022 16:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245356;
        bh=uDorpQ+jvXyiKodZwc1Qzokg5j+zVX948Cb/FLcavMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUJpN6lsAHfyciNSw73zaBw/aBQ/G7O8p/w1KBx5Din6KXrMS3aNDHM/MrqbeUo1R
         CZ4M/ktFWTE1cjUtYQVDQx2+Mb/bTD6KjAk08GNCxbZyykSeN+sGce2xC3e9Im2hqV
         +qV3tC+I5WLVF7MSb8YbeWsTcDb5Gb/8Hv/yskkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0856/1073] block: fix error unwinding in blk_register_queue
Date:   Wed, 28 Dec 2022 15:40:44 +0100
Message-Id: <20221228144351.269645767@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 40602997be26887bdfa3d58659c3acb4579099e9 ]

blk_register_queue fails to handle errors from blk_mq_sysfs_register,
leaks various resources on errors and accidentally sets queue refs percpu
refcount to percpu mode on kobject_add failure.  Fix all that by
properly unwinding on errors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20221114042637.1009333-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: d36a9ea5e776 ("block: fix use-after-free of q->q_usage_counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-sysfs.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 4825eaa4363a..02931b6f25c5 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -820,13 +820,15 @@ int blk_register_queue(struct gendisk *disk)
 	int ret;
 
 	mutex_lock(&q->sysfs_dir_lock);
-
 	ret = kobject_add(&q->kobj, &disk_to_dev(disk)->kobj, "queue");
 	if (ret < 0)
-		goto unlock;
+		goto out_unlock_dir;
 
-	if (queue_is_mq(q))
-		blk_mq_sysfs_register(disk);
+	if (queue_is_mq(q)) {
+		ret = blk_mq_sysfs_register(disk);
+		if (ret)
+			goto out_del_queue_kobj;
+	}
 	mutex_lock(&q->sysfs_lock);
 
 	mutex_lock(&q->debugfs_mutex);
@@ -838,17 +840,17 @@ int blk_register_queue(struct gendisk *disk)
 
 	ret = disk_register_independent_access_ranges(disk);
 	if (ret)
-		goto put_dev;
+		goto out_debugfs_remove;
 
 	if (q->elevator) {
 		ret = elv_register_queue(q, false);
 		if (ret)
-			goto put_dev;
+			goto out_unregister_ia_ranges;
 	}
 
 	ret = blk_crypto_sysfs_register(disk);
 	if (ret)
-		goto put_dev;
+		goto out_elv_unregister;
 
 	blk_queue_flag_set(QUEUE_FLAG_REGISTERED, q);
 	wbt_enable_default(q);
@@ -859,8 +861,6 @@ int blk_register_queue(struct gendisk *disk)
 	if (q->elevator)
 		kobject_uevent(&q->elevator->kobj, KOBJ_ADD);
 	mutex_unlock(&q->sysfs_lock);
-
-unlock:
 	mutex_unlock(&q->sysfs_dir_lock);
 
 	/*
@@ -879,13 +879,17 @@ int blk_register_queue(struct gendisk *disk)
 
 	return ret;
 
-put_dev:
+out_elv_unregister:
 	elv_unregister_queue(q);
+out_unregister_ia_ranges:
 	disk_unregister_independent_access_ranges(disk);
+out_debugfs_remove:
+	blk_debugfs_remove(disk);
 	mutex_unlock(&q->sysfs_lock);
-	mutex_unlock(&q->sysfs_dir_lock);
+out_del_queue_kobj:
 	kobject_del(&q->kobj);
-
+out_unlock_dir:
+	mutex_unlock(&q->sysfs_dir_lock);
 	return ret;
 }
 
-- 
2.35.1



