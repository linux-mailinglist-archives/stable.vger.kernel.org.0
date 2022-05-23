Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B79D531754
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241686AbiEWReB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241103AbiEWRcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:32:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0AB79825;
        Mon, 23 May 2022 10:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 523B860919;
        Mon, 23 May 2022 17:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50623C385A9;
        Mon, 23 May 2022 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326847;
        bh=z9KitDqnllZPX+NUcFczaCCn/qxRFGh1THplW/YBoOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XI+BuiScBJwhH+5+JAPCFdfTl+uFr0mLanvAPGdluYzfmHwi7WiSvXBlZqsj2KbE+
         0YePvuLudonDVrZpJnhC6cXtpeHOipIX48FLKF5AnFYjx6ogfG6qvNrBXTVwrYwy9P
         /JK9R6AuE5L80pchYV+hokykgh87RaQ5po5QhpWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 078/158] block/mq-deadline: Set the fifo_time member also if inserting at head
Date:   Mon, 23 May 2022 19:03:55 +0200
Message-Id: <20220523165843.956480333@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 725f22a1477c9c15aa67ad3af96fe28ec4fe72d2 ]

Before commit 322cff70d46c the fifo_time member of requests on a dispatch
list was not used. Commit 322cff70d46c introduces code that reads the
fifo_time member of requests on dispatch lists. Hence this patch that sets
the fifo_time member when adding a request to a dispatch list.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Fixes: 322cff70d46c ("block/mq-deadline: Prioritize high-priority requests")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20220513171307.32564-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/mq-deadline.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 3ed5eaf3446a..6ed602b2f80a 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -742,6 +742,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	if (at_head) {
 		list_add(&rq->queuelist, &per_prio->dispatch);
+		rq->fifo_time = jiffies;
 	} else {
 		deadline_add_rq_rb(per_prio, rq);
 
-- 
2.35.1



