Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAB418B692
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730967AbgCSN16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730963AbgCSN15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:27:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD414208D6;
        Thu, 19 Mar 2020 13:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624476;
        bh=bUaOVor2yx1FOOgO8uJd78Y2jDFUGYryKlGVpqN3LX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ixnl/9SDfI+udjt2Ulumf7qRzQlvWI1EB1MVIAVi02kj6VHcE3AzjSOVBsVVRQPso
         YE4r8/Ig4idFWnlLohbDeQQSivV6+yMwF9CHUn/uF//Ow3JkvB3PKYO5dD8MZP7RGv
         g689/b8UKh3Z//TiVCQFHuZdsJZA2DmHgLrmWC7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 58/65] blk-mq: insert flush request to the front of dispatch queue
Date:   Thu, 19 Mar 2020 14:04:40 +0100
Message-Id: <20200319123944.552521031@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit cc3200eac4c5eb11c3f34848a014d1f286316310 ]

commit 01e99aeca397 ("blk-mq: insert passthrough request into
hctx->dispatch directly") may change to add flush request to the tail
of dispatch by applying the 'add_head' parameter of
blk_mq_sched_insert_request.

Turns out this way causes performance regression on NCQ controller because
flush is non-NCQ command, which can't be queued when there is any in-flight
NCQ command. When adding flush rq to the front of hctx->dispatch, it is
easier to introduce extra time to flush rq's latency compared with adding
to the tail of dispatch queue because of S_SCHED_RESTART, then chance of
flush merge is increased, and less flush requests may be issued to
controller.

So always insert flush request to the front of dispatch queue just like
before applying commit 01e99aeca397 ("blk-mq: insert passthrough request
into hctx->dispatch directly").

Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: 01e99aeca397 ("blk-mq: insert passthrough request into hctx->dispatch directly")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-sched.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -398,6 +398,28 @@ void blk_mq_sched_insert_request(struct
 	WARN_ON(e && (rq->tag != -1));
 
 	if (blk_mq_sched_bypass_insert(hctx, !!e, rq)) {
+		/*
+		 * Firstly normal IO request is inserted to scheduler queue or
+		 * sw queue, meantime we add flush request to dispatch queue(
+		 * hctx->dispatch) directly and there is at most one in-flight
+		 * flush request for each hw queue, so it doesn't matter to add
+		 * flush request to tail or front of the dispatch queue.
+		 *
+		 * Secondly in case of NCQ, flush request belongs to non-NCQ
+		 * command, and queueing it will fail when there is any
+		 * in-flight normal IO request(NCQ command). When adding flush
+		 * rq to the front of hctx->dispatch, it is easier to introduce
+		 * extra time to flush rq's latency because of S_SCHED_RESTART
+		 * compared with adding to the tail of dispatch queue, then
+		 * chance of flush merge is increased, and less flush requests
+		 * will be issued to controller. It is observed that ~10% time
+		 * is saved in blktests block/004 on disk attached to AHCI/NCQ
+		 * drive when adding flush rq to the front of hctx->dispatch.
+		 *
+		 * Simply queue flush rq to the front of hctx->dispatch so that
+		 * intensive flush workloads can benefit in case of NCQ HW.
+		 */
+		at_head = (rq->rq_flags & RQF_FLUSH_SEQ) ? true : at_head;
 		blk_mq_request_bypass_insert(rq, at_head, false);
 		goto run;
 	}


