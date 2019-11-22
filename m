Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AADF106E2A
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbfKVLGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:35094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731013AbfKVLGk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:06:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6228E20885;
        Fri, 22 Nov 2019 11:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420799;
        bh=rl0J2kUgD8Q7v5xJ3ktPrZJwJ0UTuHJGEvm0mn5/a2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wRrhsAduIY8H87L7UEAIcC7ASXirk7MclJdUxtB9j/SqaaKKg/fc8NbvqXg8/TUWC
         tEi3b3JDXeVeSfgM5FLeRZDfeICy3/0FkruACP7JM9uE1fV9GrQNvYaOUlPmCOwIZn
         NrmbuB0/dsUDMOfu9629YMDNgKAl4reErSMiaJLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Evich <cevich@redhat.com>,
        Patrick Dung <patdung100@gmail.com>,
        Thorsten Schubert <tschubert@bafh.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Laura Abbott <labbott@redhat.com>
Subject: [PATCH 5.3 2/6] block, bfq: deschedule empty bfq_queues not referred by any process
Date:   Fri, 22 Nov 2019 11:30:04 +0100
Message-Id: <20191122100322.673010728@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100320.878809004@linuxfoundation.org>
References: <20191122100320.878809004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Valente <paolo.valente@linaro.org>

commit 478de3380c1c7dbb0f65f545ee0185848413f3fe upstream.

Since commit 3726112ec731 ("block, bfq: re-schedule empty queues if
they deserve I/O plugging"), to prevent the service guarantees of a
bfq_queue from being violated, the bfq_queue may be left busy, i.e.,
scheduled for service, even if empty (see comments in
__bfq_bfqq_expire() for details). But, if no process will send
requests to the bfq_queue any longer, then there is no point in
keeping the bfq_queue scheduled for service.

In addition, keeping the bfq_queue scheduled for service, but with no
process reference any longer, may cause the bfq_queue to be freed when
descheduled from service. But this is assumed to never happen, and
causes a UAF if it happens. This, in turn, caused crashes [1, 2].

This commit fixes this issue by descheduling an empty bfq_queue when
it remains with not process reference.

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1767539
[2] https://bugzilla.kernel.org/show_bug.cgi?id=205447

Fixes: 3726112ec731 ("block, bfq: re-schedule empty queues if they deserve I/O plugging")
Reported-by: Chris Evich <cevich@redhat.com>
Reported-by: Patrick Dung <patdung100@gmail.com>
Reported-by: Thorsten Schubert <tschubert@bafh.org>
Tested-by: Thorsten Schubert <tschubert@bafh.org>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Laura Abbott <labbott@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/bfq-iosched.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -2699,6 +2699,28 @@ static void bfq_bfqq_save_state(struct b
 	}
 }
 
+
+static
+void bfq_release_process_ref(struct bfq_data *bfqd, struct bfq_queue *bfqq)
+{
+	/*
+	 * To prevent bfqq's service guarantees from being violated,
+	 * bfqq may be left busy, i.e., queued for service, even if
+	 * empty (see comments in __bfq_bfqq_expire() for
+	 * details). But, if no process will send requests to bfqq any
+	 * longer, then there is no point in keeping bfqq queued for
+	 * service. In addition, keeping bfqq queued for service, but
+	 * with no process ref any longer, may have caused bfqq to be
+	 * freed when dequeued from service. But this is assumed to
+	 * never happen.
+	 */
+	if (bfq_bfqq_busy(bfqq) && RB_EMPTY_ROOT(&bfqq->sort_list) &&
+	    bfqq != bfqd->in_service_queue)
+		bfq_del_bfqq_busy(bfqd, bfqq, false);
+
+	bfq_put_queue(bfqq);
+}
+
 static void
 bfq_merge_bfqqs(struct bfq_data *bfqd, struct bfq_io_cq *bic,
 		struct bfq_queue *bfqq, struct bfq_queue *new_bfqq)
@@ -2769,8 +2791,7 @@ bfq_merge_bfqqs(struct bfq_data *bfqd, s
 	 */
 	new_bfqq->pid = -1;
 	bfqq->bic = NULL;
-	/* release process reference to bfqq */
-	bfq_put_queue(bfqq);
+	bfq_release_process_ref(bfqd, bfqq);
 }
 
 static bool bfq_allow_bio_merge(struct request_queue *q, struct request *rq,
@@ -4885,7 +4906,7 @@ static void bfq_exit_bfqq(struct bfq_dat
 
 	bfq_put_cooperator(bfqq);
 
-	bfq_put_queue(bfqq); /* release process reference */
+	bfq_release_process_ref(bfqd, bfqq);
 }
 
 static void bfq_exit_icq_bfqq(struct bfq_io_cq *bic, bool is_sync)
@@ -4987,8 +5008,7 @@ static void bfq_check_ioprio_change(stru
 
 	bfqq = bic_to_bfqq(bic, false);
 	if (bfqq) {
-		/* release process reference on this queue */
-		bfq_put_queue(bfqq);
+		bfq_release_process_ref(bfqd, bfqq);
 		bfqq = bfq_get_queue(bfqd, bio, BLK_RW_ASYNC, bic);
 		bic_set_bfqq(bic, bfqq, false);
 	}
@@ -5948,7 +5968,7 @@ bfq_split_bfqq(struct bfq_io_cq *bic, st
 
 	bfq_put_cooperator(bfqq);
 
-	bfq_put_queue(bfqq);
+	bfq_release_process_ref(bfqq->bfqd, bfqq);
 	return NULL;
 }
 


