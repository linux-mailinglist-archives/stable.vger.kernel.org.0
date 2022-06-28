Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D88755DF6D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243568AbiF1CUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243443AbiF1CUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F41E237F6;
        Mon, 27 Jun 2022 19:19:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4D22B81C11;
        Tue, 28 Jun 2022 02:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D0BC341CA;
        Tue, 28 Jun 2022 02:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382787;
        bh=qSbzU9cMoqsToQcjKkswl3hyOOIeTV7kPqGjieWb+Lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTL+6gnMIZf04rBB3LofzeEXzDd+IOQWf3xUFfkZNtwi3uHKqU0C/NWNaPNoTANtU
         ffX7kypVDcI3nEarcorl/esq+UGQSsmre0OeGooMgaxi7CzCgeFhkIkPDWISKQXMOc
         U19oYz15mB1Cm/7xnXz+4eVNivd52Yr1ZvdTKr1w1CPv72WgcQN0/YM0IrpTydsYS8
         vHMOJgLA8ohVL9rTo3sQFMaj+DMxbvTHJJbPcW2KAbnIUIzjinJXkwcqHUF4MsvJ6Y
         37cDDPnTUwz7qBASeR4uZlTdEMwgvzAd+jcPlIIcLb7pIcsO4ShbbMV+2d6LZN2Vy4
         /LXLxZmlFv30Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 23/53] block: freeze the queue earlier in del_gendisk
Date:   Mon, 27 Jun 2022 22:18:09 -0400
Message-Id: <20220628021839.594423-23-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit a09b314005f3a0956ebf56e01b3b80339df577cc ]

Freeze the queue earlier in del_gendisk so that the state does not
change while we remove debugfs and sysfs files.

Ming mentioned that being able to observer request in debugfs might
be useful while the queue is being frozen in del_gendisk, which is
made possible by this change.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220614074827.458955-5-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 3008ec213654..204ee91602c2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -623,6 +623,7 @@ void del_gendisk(struct gendisk *disk)
 	 * Prevent new I/O from crossing bio_queue_enter().
 	 */
 	blk_queue_start_drain(q);
+	blk_mq_freeze_queue_wait(q);
 
 	if (!(disk->flags & GENHD_FL_HIDDEN)) {
 		sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
@@ -646,8 +647,6 @@ void del_gendisk(struct gendisk *disk)
 	pm_runtime_set_memalloc_noio(disk_to_dev(disk), false);
 	device_del(disk_to_dev(disk));
 
-	blk_mq_freeze_queue_wait(q);
-
 	blk_throtl_cancel_bios(disk->queue);
 
 	blk_sync_queue(q);
-- 
2.35.1

