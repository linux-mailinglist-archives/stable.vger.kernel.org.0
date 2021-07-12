Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052133C534D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352268AbhGLHy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349860AbhGLHuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A616147E;
        Mon, 12 Jul 2021 07:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075815;
        bh=qXNh1/Rl1JTG2UeSz/CwiwVyGA9YZ8IA4pSLYJBgW8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uCHDSdBAry7gPMNIe+QtV76Vs3RxtZPCYmMXkuej9o0nwkEfE50FjIkm26OXoii05
         lRQLiEUM9LFk6tnyC4QoWmeLQU2MHOpm8CcfeoXZrSjbi3b/RSOme4al9ToKm1H8at
         1Ag5zonkExUwMSoxlw6l39gRXVgzpzqMk+Gi3mZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 374/800] block, bfq: reset waker pointer with shared queues
Date:   Mon, 12 Jul 2021 08:06:37 +0200
Message-Id: <20210712061006.872749843@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit 9a2ac41b13c573703d6689f51f3e27dd658324be ]

Commit 85686d0dc194 ("block, bfq: keep shared queues out of the waker
mechanism") leaves shared bfq_queues out of the waker-detection
mechanism. It attains this goal by not updating the pointer
last_completed_rq_bfqq, if the last request completed belongs to a
shared bfq_queue (so that the pointer will not point to the shared
bfq_queue).

Yet this has a side effect: the pointer last_completed_rq_bfqq keeps
pointing, deceptively, to a bfq_queue that actually is not the last
one to have had a request completed. As a consequence, such a
bfq_queue may deceptively be considered as a waker of some bfq_queue,
even of some shared bfq_queue.

To address this issue, reset last_completed_rq_bfqq if the last
request completed belongs to a shared queue.

Fixes: 85686d0dc194 ("block, bfq: keep shared queues out of the waker mechanism")
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Link: https://lore.kernel.org/r/20210619140948.98712-8-paolo.valente@linaro.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-iosched.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 7c62bf093199..2a2e6e4ff0b4 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -6143,11 +6143,13 @@ static void bfq_completed_request(struct bfq_queue *bfqq, struct bfq_data *bfqd)
 	 * of other queues. But a false waker will unjustly steal
 	 * bandwidth to its supposedly woken queue. So considering
 	 * also shared queues in the waking mechanism may cause more
-	 * control troubles than throughput benefits. Then do not set
-	 * last_completed_rq_bfqq to bfqq if bfqq is a shared queue.
+	 * control troubles than throughput benefits. Then reset
+	 * last_completed_rq_bfqq if bfqq is a shared queue.
 	 */
 	if (!bfq_bfqq_coop(bfqq))
 		bfqd->last_completed_rq_bfqq = bfqq;
+	else
+		bfqd->last_completed_rq_bfqq = NULL;
 
 	/*
 	 * If we are waiting to discover whether the request pattern
-- 
2.30.2



