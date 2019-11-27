Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A45AD10BD26
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731244AbfK0VB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731806AbfK0VB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:01:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01F7F2084B;
        Wed, 27 Nov 2019 21:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888517;
        bh=w0/xY84kePr1FeSz8bEq9jbc2HkpuXp4oF3+DxCx8oU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o868asB1Kc7rkBDXn3Uj+c6JmAb4EcXN3BRRA4f1LPBHSX91cXSqjdziq7RE9rR8h
         +IeQEJYA7jRGZBNxfurTltMHbSTAme61ukaRTzrPowQrsdnCP1Z6SoeSj98FCWLC0m
         USWihsUHdHlSQE90h98PgJmU75mKCPr/sVJs3gUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 165/306] block: call rq_qos_exit() after queue is frozen
Date:   Wed, 27 Nov 2019 21:30:15 +0100
Message-Id: <20191127203127.492254648@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit c57cdf7a9e51d97a43e29b8f4a04157875104000 ]

rq_qos_exit() removes the current q->rq_qos, this action has to be
done after queue is frozen, otherwise the IO queue path may never
be waken up, then IO hang is caused.

So fixes this issue by moving rq_qos_exit() after queue is frozen.

Cc: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c  | 3 +++
 block/blk-sysfs.c | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 074ae9376189b..ea33d6abdcfc9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -784,6 +784,9 @@ void blk_cleanup_queue(struct request_queue *q)
 	 * prevent that q->request_fn() gets invoked after draining finished.
 	 */
 	blk_freeze_queue(q);
+
+	rq_qos_exit(q);
+
 	spin_lock_irq(lock);
 	queue_flag_set(QUEUE_FLAG_DEAD, q);
 	spin_unlock_irq(lock);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index bab47a17b96f4..8286640d4d663 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -997,8 +997,6 @@ void blk_unregister_queue(struct gendisk *disk)
 	kobject_del(&q->kobj);
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 
-	rq_qos_exit(q);
-
 	mutex_lock(&q->sysfs_lock);
 	if (q->request_fn || (q->mq_ops && q->elevator))
 		elv_unregister_queue(q);
-- 
2.20.1



