Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A02676F51
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjAVPUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjAVPUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F1F2203D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F99460C43
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7459AC433EF;
        Sun, 22 Jan 2023 15:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400804;
        bh=LjJuK/tkDFUQaJ3L4JDTNnroWDZsql2pY7GXQzrX0VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JZo+RYmdJ9X6E5ngN+i70A5g1hkliJ7AL+XQUH0ZJXJZdKaIkG5fF/5umICBWZPf+
         oiswVRNONlEFf/6/VyAwT+P9WUzi0JOO4D3mvhItsGZJA1IQEoYt8jJH44OxyBKCvN
         TL3bNQb9IumiucgOz07I24AlxThy8DRx8POyh4O4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 115/117] block: mq-deadline: Rename deadline_is_seq_writes()
Date:   Sun, 22 Jan 2023 16:05:05 +0100
Message-Id: <20230122150237.595780837@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 3692fec8bb476e8583e559ff5783a6adef306cf2 upstream.

Rename deadline_is_seq_writes() to deadline_is_seq_write() (remove the
"s" plural) to more correctly reflect the fact that this function tests
a single request, not multiple requests.

Fixes: 015d02f48537 ("block: mq-deadline: Do not break sequential write streams to zoned HDDs")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20221126025550.967914-2-damien.lemoal@opensource.wdc.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/mq-deadline.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -305,7 +305,7 @@ static inline int deadline_check_fifo(st
 /*
  * Check if rq has a sequential request preceding it.
  */
-static bool deadline_is_seq_writes(struct deadline_data *dd, struct request *rq)
+static bool deadline_is_seq_write(struct deadline_data *dd, struct request *rq)
 {
 	struct request *prev = deadline_earlier_request(rq);
 
@@ -364,7 +364,7 @@ deadline_fifo_request(struct deadline_da
 	list_for_each_entry(rq, &per_prio->fifo_list[DD_WRITE], queuelist) {
 		if (blk_req_can_dispatch_to_zone(rq) &&
 		    (blk_queue_nonrot(rq->q) ||
-		     !deadline_is_seq_writes(dd, rq)))
+		     !deadline_is_seq_write(dd, rq)))
 			goto out;
 	}
 	rq = NULL;


