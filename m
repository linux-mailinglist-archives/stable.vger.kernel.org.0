Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5631A4178
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgDJDss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728321AbgDJDsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:48:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9A0920CC7;
        Fri, 10 Apr 2020 03:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490527;
        bh=ILBexfunqW4Rk3vCQKONkC5vXgBaBzCpnGtoBUoYB6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIDM+/Fl7kVPyZdVyK/52PGGKlQ6Dr32yoCX2tTewwc0uLcAaxM9Mf6Hp2QepGivZ
         PHk7egE9PSoZtrbP71yXckkdojTzD5CM9R1Q+JYTV0JtpCx+kF2CQ563kVCKlOh78Y
         bQ/yrLeArMZkjLahRHq45hOkUHJ2RZ2VZlyJUIIk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        syzbot+d44e1b26ce5c3e77458d@syzkaller.appspotmail.com,
        Ming Lei <ming.lei@redhat.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 40/56] blk-mq: Keep set->nr_hw_queues and set->map[].nr_queues in sync
Date:   Thu,  9 Apr 2020 23:47:44 -0400
Message-Id: <20200410034800.8381-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034800.8381-1-sashal@kernel.org>
References: <20200410034800.8381-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 6e66b49392419f3fe134e1be583323ef75da1e4b ]

blk_mq_map_queues() and multiple .map_queues() implementations expect that
set->map[HCTX_TYPE_DEFAULT].nr_queues is set to the number of hardware
queues. Hence set .nr_queues before calling these functions. This patch
fixes the following kernel warning:

WARNING: CPU: 0 PID: 2501 at include/linux/cpumask.h:137
Call Trace:
 blk_mq_run_hw_queue+0x19d/0x350 block/blk-mq.c:1508
 blk_mq_run_hw_queues+0x112/0x1a0 block/blk-mq.c:1525
 blk_mq_requeue_work+0x502/0x780 block/blk-mq.c:775
 process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
 worker_thread+0x98/0xe40 kernel/workqueue.c:2415
 kthread+0x361/0x430 kernel/kthread.c:255

Fixes: ed76e329d74a ("blk-mq: abstract out queue map") # v5.0
Reported-by: syzbot+d44e1b26ce5c3e77458d@syzkaller.appspotmail.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 51ff4852d34bc..8391e8e2a5044 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2964,6 +2964,14 @@ static int blk_mq_alloc_rq_maps(struct blk_mq_tag_set *set)
 
 static int blk_mq_update_queue_map(struct blk_mq_tag_set *set)
 {
+	/*
+	 * blk_mq_map_queues() and multiple .map_queues() implementations
+	 * expect that set->map[HCTX_TYPE_DEFAULT].nr_queues is set to the
+	 * number of hardware queues.
+	 */
+	if (set->nr_maps == 1)
+		set->map[HCTX_TYPE_DEFAULT].nr_queues = set->nr_hw_queues;
+
 	if (set->ops->map_queues && !is_kdump_kernel()) {
 		int i;
 
-- 
2.20.1

