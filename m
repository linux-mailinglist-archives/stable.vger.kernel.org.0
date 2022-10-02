Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDAD5F2658
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiJBWw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiJBWvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:51:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0E21BE9D;
        Sun,  2 Oct 2022 15:50:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ACF8B80924;
        Sun,  2 Oct 2022 22:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2375C43146;
        Sun,  2 Oct 2022 22:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751013;
        bh=XGe0DHnO7vYyv1CsRvz6jbA63RSiOfcg9ioBXlsRxQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cjIT1DCjpTOweqEtTCLZu/6+CC85SmC/JWV5cJa7tRT8rs5Xs2Zpxiidszo78R5gK
         xeivqht/0JEpHyH/ZhzsLp5fp/0qZsUKD40a0GegeAKQzYqjYbNIWnn9YytTv7LBoJ
         3gZJW3rdrhfS46MsH5f3GS08CuWYVXn8/Vqr9h1rJUL/iVO08Np9148qQz6BeM9TQE
         5zjIXOerE2157Y+Jqo9tfs0VTgX574ks9gQ+FLWzgPQsy5MH4GSl7NTP4jBDaHrFpi
         iwtLcC8FrVySCHcYJv2jewEA3/luC2+TqH2RIfGEIqQHTh/RI6eHZjYqZsItB3wY2a
         UGQx40CFeI0cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 19/29] Revert "block: freeze the queue earlier in del_gendisk"
Date:   Sun,  2 Oct 2022 18:49:12 -0400
Message-Id: <20221002224922.238837-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002224922.238837-1-sashal@kernel.org>
References: <20221002224922.238837-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit 4c66a326b5ab784cddd72de07ac5b6210e9e1b06 ]

This reverts commit a09b314005f3a0956ebf56e01b3b80339df577cc.

Dusty Mabe reported consistent hang during CoreOS shutdown with a MD
RAID1 setup.  Although apparently similar hangs happened before,
and this patch most likely is not the root cause it made it much
more severe.  Revert it until we can figure out what is going on
with the md driver.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220919144049.978907-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 278227ba1d53..e0675772178b 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -623,7 +623,6 @@ void del_gendisk(struct gendisk *disk)
 	 * Prevent new I/O from crossing bio_queue_enter().
 	 */
 	blk_queue_start_drain(q);
-	blk_mq_freeze_queue_wait(q);
 
 	if (!(disk->flags & GENHD_FL_HIDDEN)) {
 		sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
@@ -647,6 +646,8 @@ void del_gendisk(struct gendisk *disk)
 	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
 	device_del(disk_to_dev(disk));
 
+	blk_mq_freeze_queue_wait(q);
+
 	blk_throtl_cancel_bios(disk->queue);
 
 	blk_sync_queue(q);
-- 
2.35.1

