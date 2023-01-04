Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6255465D90C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbjADQVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239410AbjADQUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:20:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E6A6253
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 631FE61798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1B6C433D2;
        Wed,  4 Jan 2023 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849250;
        bh=97HiME8cGgVtB8O4l7xmcpEse3tiNYZQ8uavi8nhiko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yn1jcD5ceL2F5YZXWx4pxY3UAqFs/8q53QfBVFB+iijCGxnb60riW0iZAlTC+WW3X
         gGg1f0+nndrOEHd9S+9Ded+B/L6qT3lAYM5H7wfnJ8LObr/zcj0XiHIT76uERWwBje
         TFDNDDVqd766bTQArMQAYMjEN4bt7tRfCfCQk6uA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 089/177] block: mq-deadline: Do not break sequential write streams to zoned HDDs
Date:   Wed,  4 Jan 2023 17:06:20 +0100
Message-Id: <20230104160510.338985602@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 015d02f48537cf2d1a65eeac50717566f9db6eec upstream.

mq-deadline ensures an in order dispatching of write requests to zoned
block devices using a per zone lock (a bit). This implies that for any
purely sequential write workload, the drive is exercised most of the
time at a maximum queue depth of one.

However, when such sequential write workload crosses a zone boundary
(when sequentially writing multiple contiguous zones), zone write
locking may prevent the last write to one zone to be issued (as the
previous write is still being executed) but allow the first write to the
following zone to be issued (as that zone is not yet being writen and
not locked). This result in an out of order delivery of the sequential
write commands to the device every time a zone boundary is crossed.

While such behavior does not break the sequential write constraint of
zoned block devices (and does not generate any write error), some zoned
hard-disks react badly to seeing these out of order writes, resulting in
lower write throughput.

This problem can be addressed by always dispatching the first request
of a stream of sequential write requests, regardless of the zones
targeted by these sequential writes. To do so, the function
deadline_skip_seq_writes() is introduced and used in
deadline_next_request() to select the next write command to issue if the
target device is an HDD (blk_queue_nonrot() being false).
deadline_fifo_request() is modified using the new
deadline_earlier_request() and deadline_is_seq_write() helpers to ignore
requests in the fifo list that have a preceding request in lba order
that is sequential.

With this fix, a sequential write workload executed with the following
fio command:

fio  --name=seq-write --filename=/dev/sda --zonemode=zbd --direct=1 \
     --size=68719476736  --ioengine=libaio --iodepth=32 --rw=write \
     --bs=65536

results in an increase from 225 MB/s to 250 MB/s of the write throughput
of an SMR HDD (11% increase).

Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20221124021208.242541-3-damien.lemoal@opensource.wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/mq-deadline.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 62 insertions(+), 4 deletions(-)

--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -131,6 +131,20 @@ static u8 dd_rq_ioclass(struct request *
 }
 
 /*
+ * get the request before `rq' in sector-sorted order
+ */
+static inline struct request *
+deadline_earlier_request(struct request *rq)
+{
+	struct rb_node *node = rb_prev(&rq->rb_node);
+
+	if (node)
+		return rb_entry_rq(node);
+
+	return NULL;
+}
+
+/*
  * get the request after `rq' in sector-sorted order
  */
 static inline struct request *
@@ -278,6 +292,39 @@ static inline int deadline_check_fifo(st
 }
 
 /*
+ * Check if rq has a sequential request preceding it.
+ */
+static bool deadline_is_seq_writes(struct deadline_data *dd, struct request *rq)
+{
+	struct request *prev = deadline_earlier_request(rq);
+
+	if (!prev)
+		return false;
+
+	return blk_rq_pos(prev) + blk_rq_sectors(prev) == blk_rq_pos(rq);
+}
+
+/*
+ * Skip all write requests that are sequential from @rq, even if we cross
+ * a zone boundary.
+ */
+static struct request *deadline_skip_seq_writes(struct deadline_data *dd,
+						struct request *rq)
+{
+	sector_t pos = blk_rq_pos(rq);
+	sector_t skipped_sectors = 0;
+
+	while (rq) {
+		if (blk_rq_pos(rq) != pos + skipped_sectors)
+			break;
+		skipped_sectors += blk_rq_sectors(rq);
+		rq = deadline_latter_request(rq);
+	}
+
+	return rq;
+}
+
+/*
  * For the specified data direction, return the next request to
  * dispatch using arrival ordered lists.
  */
@@ -297,11 +344,16 @@ deadline_fifo_request(struct deadline_da
 
 	/*
 	 * Look for a write request that can be dispatched, that is one with
-	 * an unlocked target zone.
+	 * an unlocked target zone. For some HDDs, breaking a sequential
+	 * write stream can lead to lower throughput, so make sure to preserve
+	 * sequential write streams, even if that stream crosses into the next
+	 * zones and these zones are unlocked.
 	 */
 	spin_lock_irqsave(&dd->zone_lock, flags);
 	list_for_each_entry(rq, &per_prio->fifo_list[DD_WRITE], queuelist) {
-		if (blk_req_can_dispatch_to_zone(rq))
+		if (blk_req_can_dispatch_to_zone(rq) &&
+		    (blk_queue_nonrot(rq->q) ||
+		     !deadline_is_seq_writes(dd, rq)))
 			goto out;
 	}
 	rq = NULL;
@@ -331,13 +383,19 @@ deadline_next_request(struct deadline_da
 
 	/*
 	 * Look for a write request that can be dispatched, that is one with
-	 * an unlocked target zone.
+	 * an unlocked target zone. For some HDDs, breaking a sequential
+	 * write stream can lead to lower throughput, so make sure to preserve
+	 * sequential write streams, even if that stream crosses into the next
+	 * zones and these zones are unlocked.
 	 */
 	spin_lock_irqsave(&dd->zone_lock, flags);
 	while (rq) {
 		if (blk_req_can_dispatch_to_zone(rq))
 			break;
-		rq = deadline_latter_request(rq);
+		if (blk_queue_nonrot(rq->q))
+			rq = deadline_latter_request(rq);
+		else
+			rq = deadline_skip_seq_writes(dd, rq);
 	}
 	spin_unlock_irqrestore(&dd->zone_lock, flags);
 


