Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9657E1B3F77
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731282AbgDVKh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:37:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729953AbgDVKWZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E660221556;
        Wed, 22 Apr 2020 10:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550938;
        bh=aWAXO2NOidbzbTCCk/CUCUqwMnMHKbmmDl/JPB73t+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKS+H8/JjjVNU0lV7jLy1l0d0rQXveT150W7Z4G1f2DScZLzq35Ct1fMwOYUtWhYb
         CQXg/fUDiuMB0vvfOAQ10BXWh8RJR1+UYS0CVs3UB6UCx16/8hvB6GFA0mbxeymEp+
         GTfWovOxzFyMKgpocsPaFLS+AWdNJzl3Wq1nspAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, cki-project@redhat.com,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.6 036/166] block, bfq: turn put_queue into release_process_ref in __bfq_bic_change_cgroup
Date:   Wed, 22 Apr 2020 11:56:03 +0200
Message-Id: <20200422095052.694362148@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

commit c8997736650060594845e42c5d01d3118aec8d25 upstream.

A bfq_put_queue() may be invoked in __bfq_bic_change_cgroup(). The
goal of this put is to release a process reference to a bfq_queue. But
process-reference releases may trigger also some extra operation, and,
to this goal, are handled through bfq_release_process_ref(). So, turn
the invocation of bfq_put_queue() into an invocation of
bfq_release_process_ref().

Tested-by: cki-project@redhat.com
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bfq-cgroup.c  |    5 +----
 block/bfq-iosched.c |    2 --
 block/bfq-iosched.h |    1 +
 3 files changed, 2 insertions(+), 6 deletions(-)

--- a/block/bfq-cgroup.c
+++ b/block/bfq-cgroup.c
@@ -714,10 +714,7 @@ static struct bfq_group *__bfq_bic_chang
 
 		if (entity->sched_data != &bfqg->sched_data) {
 			bic_set_bfqq(bic, NULL, 0);
-			bfq_log_bfqq(bfqd, async_bfqq,
-				     "bic_change_group: %p %d",
-				     async_bfqq, async_bfqq->ref);
-			bfq_put_queue(async_bfqq);
+			bfq_release_process_ref(bfqd, async_bfqq);
 		}
 	}
 
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2716,8 +2716,6 @@ static void bfq_bfqq_save_state(struct b
 	}
 }
 
-
-static
 void bfq_release_process_ref(struct bfq_data *bfqd, struct bfq_queue *bfqq)
 {
 	/*
--- a/block/bfq-iosched.h
+++ b/block/bfq-iosched.h
@@ -955,6 +955,7 @@ void bfq_bfqq_expire(struct bfq_data *bf
 		     bool compensate, enum bfqq_expiration reason);
 void bfq_put_queue(struct bfq_queue *bfqq);
 void bfq_end_wr_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg);
+void bfq_release_process_ref(struct bfq_data *bfqd, struct bfq_queue *bfqq);
 void bfq_schedule_dispatch(struct bfq_data *bfqd);
 void bfq_put_async_queues(struct bfq_data *bfqd, struct bfq_group *bfqg);
 


