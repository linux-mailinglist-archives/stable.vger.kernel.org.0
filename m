Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5984F2608
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiDEHyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbiDEHxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:53:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0451CFFD;
        Tue,  5 Apr 2022 00:49:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74DB0B81BAD;
        Tue,  5 Apr 2022 07:49:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29E7C340EE;
        Tue,  5 Apr 2022 07:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144940;
        bh=y/dOPOyA4dfPlcTmnZf/Hbni5qykNSUEa1ZZchx0lKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHkhjDA/kSoBT/9DHw+z/3TU298bCVyzXhGEzJuvcWXCZmTCweujZ1wpfBugEoZEE
         xNSzzcA+ooY5rMtCEOuxYAUgn59xws7gMn+L+gX+ShgWpyvltHV40jipIWpUi70eEo
         02f754Tajmn2SV+0oEJYjY4728PMkea532TgHNVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Wensheng <zhangwensheng5@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0227/1126] block: update io_ticks when io hang
Date:   Tue,  5 Apr 2022 09:16:14 +0200
Message-Id: <20220405070414.271720515@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Zhang Wensheng <zhangwensheng5@huawei.com>

[ Upstream commit 86d7331299fda7634b11c1b7c911432679d525a5 ]

When the inflight IOs are slow and no new IOs are issued, we expect
iostat could manifest the IO hang problem. However after
commit 5b18b5a73760 ("block: delete part_round_stats and switch to less
precise counting"), io_tick and time_in_queue will not be updated until
the end of IO, and the avgqu-sz and %util columns of iostat will be zero.

Because it has using stat.nsecs accumulation to express time_in_queue
which is not suitable to change, and may %util will express the status
better when io hang occur. To fix io_ticks, we use update_io_ticks and
inflight to update io_ticks when diskstats_show and part_stat_show
been called.

Fixes: 5b18b5a73760 ("block: delete part_round_stats and switch to less precise counting")
Signed-off-by: Zhang Wensheng <zhangwensheng5@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220217064247.4041435-1-zhangwensheng5@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 9eca1f7d35c9..6fa8b2068cc2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -927,12 +927,17 @@ ssize_t part_stat_show(struct device *dev,
 	struct disk_stats stat;
 	unsigned int inflight;
 
-	part_stat_read_all(bdev, &stat);
 	if (queue_is_mq(q))
 		inflight = blk_mq_in_flight(q, bdev);
 	else
 		inflight = part_in_flight(bdev);
 
+	if (inflight) {
+		part_stat_lock();
+		update_io_ticks(bdev, jiffies, true);
+		part_stat_unlock();
+	}
+	part_stat_read_all(bdev, &stat);
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
@@ -1188,12 +1193,17 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	xa_for_each(&gp->part_tbl, idx, hd) {
 		if (bdev_is_partition(hd) && !bdev_nr_sectors(hd))
 			continue;
-		part_stat_read_all(hd, &stat);
 		if (queue_is_mq(gp->queue))
 			inflight = blk_mq_in_flight(gp->queue, hd);
 		else
 			inflight = part_in_flight(hd);
 
+		if (inflight) {
+			part_stat_lock();
+			update_io_ticks(hd, jiffies, true);
+			part_stat_unlock();
+		}
+		part_stat_read_all(hd, &stat);
 		seq_printf(seqf, "%4d %7d %pg "
 			   "%lu %lu %lu %u "
 			   "%lu %lu %lu %u "
-- 
2.34.1



