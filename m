Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33ECB216F9B
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgGGPEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgGGPEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 11:04:37 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2700C061755;
        Tue,  7 Jul 2020 08:04:36 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e13so38396157qkg.5;
        Tue, 07 Jul 2020 08:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=1sdiGbveFaT49tOO4Q9qYVxS3eQWzjAvrAW+jAKSq60=;
        b=aNd87Dfpm7MRIZqvU6FpIQNEz08V9eSu8+EHB7fC4c6gfOxgXQMBciUM9PdZXj3ygd
         2tYTooU0sdmGt7gnjvq/dJUcGt84X6k4wxyMj5ZQAfp9QJcxY9YWNELkhRcHwtDTINLJ
         J2v9aHZ8muayj/fOBTUL36eKV0yl0kaEs/CBCAFuEnssiEk0ZgPI+iHdQxKQEOZJNYmm
         l69CN2ZrmLpkWQQEzwwS1Cyn2/pGGUHHztBgDM02SxhbTokir3SRKIdkGw4bpie8l98q
         tXco5Jun+Yw3vMoq9LQSujzZDl/L062s0dtp5vR8kIQ8ju6Kvv74RRBUTH5bzNyHRXnu
         1fPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=1sdiGbveFaT49tOO4Q9qYVxS3eQWzjAvrAW+jAKSq60=;
        b=Qf17tnMgkyqR8NQRpzULSjY+c10wXCtXwhb4z3fPuvcmOSCiSjCmaexrOPIrqlmA3F
         dmH0vku2N46jSrdUrdlkuHoigcl3MvPTZTJs8u1fO/HFIvaWepsDN4Tq9G3SXeN1wjPY
         Th57UM3+D3hcJFiCXC5ucVmxFYpj7xxvGk/Bt9efnsaPjlOCxuUO/nUho0vmz10Isbxq
         JhTNAXfHoDzWNhxZtxBwrp8uQuEJk7UI2Q8ki0Yo3jZa0WdNWcKj4u7B9JVN2E11b1h2
         uqZ3yXYT8kRsy+GHdnY+yN4w+ENsdadUs9MQyrCQIW23FWrnlT1QgjGwC/dc3B2J/tdD
         p98w==
X-Gm-Message-State: AOAM530ZxpFicSbnMY3WpkS05fyK9X/CxM8E/lkIGX/98WVcLJB5U4A9
        WrgBE6PVruB5vf+Z9G7f7pcaxOUo
X-Google-Smtp-Source: ABdhPJzNU09L70s+DnlC72WKlG6/VZXcFKlZJCP+hPgECtW9dK1uhkidNNre7gq/w70u6rXybFaE7g==
X-Received: by 2002:a37:27c2:: with SMTP id n185mr49499562qkn.459.1594134275629;
        Tue, 07 Jul 2020 08:04:35 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id c7sm28538179qta.95.2020.07.07.08.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 08:04:34 -0700 (PDT)
From:   Mike Snitzer <snitzer@redhat.com>
To:     linux-block@vger.kernel.org, axboe@kernel.dk
Cc:     dm-devel@redhat.com, stable@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] blk-mq: consider non-idle request as "inflight" in blk_mq_rq_inflight()
Date:   Tue,  7 Jul 2020 11:04:33 -0400
Message-Id: <20200707150433.39480-1-snitzer@redhat.com>
X-Mailer: git-send-email 2.15.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

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
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4f57d27bfa73..e6219c27fc65 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -828,10 +828,10 @@ static bool blk_mq_rq_inflight(struct blk_mq_hw_ctx *hctx, struct request *rq,
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
-- 
2.15.0

