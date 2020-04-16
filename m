Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3878F1AC2D7
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896296AbgDPNeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896829AbgDPNeB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:34:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97479208E4;
        Thu, 16 Apr 2020 13:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044040;
        bh=kRzMbY3EgV4E6Qm3X/KDl19rd8PRqtZJwSZTVXijMQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ggbYCiF1rHQBihcdtTZvwrlJhKOTAInp8HXdUU7JVullaixcgqmdTspZKwyOOL0/l
         wSz98hOvkujRoord+DrjAWl1ytuv0Ykg5MXzNLWqj6oBtreqTQZ47qiVpT3hbKqHFa
         3QquMNfsL4YP15X4wDrlehr9at5OrM/2z5cjky84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, cki-project@redhat.com,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 056/257] block, bfq: move forward the getting of an extra ref in bfq_bfqq_move
Date:   Thu, 16 Apr 2020 15:21:47 +0200
Message-Id: <20200416131332.980922688@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

[ Upstream commit fd1bb3ae54a9a2e0c42709de861c69aa146b8955 ]

Commit ecedd3d7e199 ("block, bfq: get extra ref to prevent a queue
from being freed during a group move") gets an extra reference to a
bfq_queue before possibly deactivating it (temporarily), in
bfq_bfqq_move(). This prevents the bfq_queue from disappearing before
being reactivated in its new group.

Yet, the bfq_queue may also be expired (i.e., its service may be
stopped) before the bfq_queue is deactivated. And also an expiration
may lead to a premature freeing. This commit fixes this issue by
simply moving forward the getting of the extra reference already
introduced by commit ecedd3d7e199 ("block, bfq: get extra ref to
prevent a queue from being freed during a group move").

Reported-by: cki-project@redhat.com
Tested-by: cki-project@redhat.com
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bfq-cgroup.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/block/bfq-cgroup.c b/block/bfq-cgroup.c
index 5a64607ce7744..a6d42339fb342 100644
--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -641,6 +641,12 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 {
 	struct bfq_entity *entity = &bfqq->entity;
 
+	/*
+	 * Get extra reference to prevent bfqq from being freed in
+	 * next possible expire or deactivate.
+	 */
+	bfqq->ref++;
+
 	/* If bfqq is empty, then bfq_bfqq_expire also invokes
 	 * bfq_del_bfqq_busy, thereby removing bfqq and its entity
 	 * from data structures related to current group. Otherwise we
@@ -651,12 +657,6 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 		bfq_bfqq_expire(bfqd, bfqd->in_service_queue,
 				false, BFQQE_PREEMPTED);
 
-	/*
-	 * get extra reference to prevent bfqq from being freed in
-	 * next possible deactivate
-	 */
-	bfqq->ref++;
-
 	if (bfq_bfqq_busy(bfqq))
 		bfq_deactivate_bfqq(bfqd, bfqq, false, false);
 	else if (entity->on_st)
@@ -676,7 +676,7 @@ void bfq_bfqq_move(struct bfq_data *bfqd, struct bfq_queue *bfqq,
 
 	if (!bfqd->in_service_queue && !bfqd->rq_in_driver)
 		bfq_schedule_dispatch(bfqd);
-	/* release extra ref taken above */
+	/* release extra ref taken above, bfqq may happen to be freed now */
 	bfq_put_queue(bfqq);
 }
 
-- 
2.20.1



