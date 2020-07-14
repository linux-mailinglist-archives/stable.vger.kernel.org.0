Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA60F21FB4B
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730786AbgGNTAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731372AbgGNTA3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 15:00:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D089122A99;
        Tue, 14 Jul 2020 19:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753229;
        bh=kbSlFT4yADAzoHau1CbFspp9DIIsUrsPcu87ugGuJaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szdsDkpJwvtxMpvruM90eeUpl2PtCfnI6516DOsYvL3co543rLMen4MeqVTY2UTg2
         i+ia7B4emYUZH0JSa9bX2M0gfYhou2MQW/KhE61yJppnl95cM1ZTvM+MrBXfEwgmfN
         T1LSOLlz/zmbxiu+U4kzJnxXew6xUFRGXuiS3KH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 160/166] blk-mq: consider non-idle request as "inflight" in blk_mq_rq_inflight()
Date:   Tue, 14 Jul 2020 20:45:25 +0200
Message-Id: <20200714184123.483980264@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 05a4fed69ff00a8bd83538684cb602a4636b07a7 upstream.

dm-multipath is the only user of blk_mq_queue_inflight().  When
dm-multipath calls blk_mq_queue_inflight() to check if it has
outstanding IO it can get a false negative.  The reason for this is
blk_mq_rq_inflight() doesn't consider requests that are no longer
MQ_RQ_IN_FLIGHT but that are now MQ_RQ_COMPLETE (->complete isn't
called or finished yet) as "inflight".

This causes request-based dm-multipath's dm_wait_for_completion() to
return before all outstanding dm-multipath requests have actually
completed.  This breaks DM multipath's suspend functionality because
blk-mq requests complete after DM's suspend has finished -- which
shouldn't happen.

Fix this by considering any request not in the MQ_RQ_IDLE state
(so either MQ_RQ_COMPLETE or MQ_RQ_IN_FLIGHT) as "inflight" in
blk_mq_rq_inflight().

Fixes: 3c94d83cb3526 ("blk-mq: change blk_mq_queue_busy() to blk_mq_queue_inflight()")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -803,10 +803,10 @@ static bool blk_mq_rq_inflight(struct bl
 			       void *priv, bool reserved)
 {
 	/*
-	 * If we find a request that is inflight and the queue matches,
+	 * If we find a request that isn't idle and the queue matches,
 	 * we know the queue is busy. Return false to stop the iteration.
 	 */
-	if (rq->state == MQ_RQ_IN_FLIGHT && rq->q == hctx->queue) {
+	if (blk_mq_request_started(rq) && rq->q == hctx->queue) {
 		bool *busy = priv;
 
 		*busy = true;


