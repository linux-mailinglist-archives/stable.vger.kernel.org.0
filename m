Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9A1A511F
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728770AbgDKMTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728765AbgDKMTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:19:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E324206A1;
        Sat, 11 Apr 2020 12:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607561;
        bh=Zsa07Z6uzhOMssZ0/0MH153k2g1cGlURZpFxTOJBW0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmdQU4sWzhPqV799LmGQGs4LSlVwCZWUeQZwE+dK7EJPJFeQmlRZVuIIuXHAr1n3p
         CfJaaygwbaO/HTseVeEPAZDdYh7+3FQR9cvu3ZMpwzFO7I/5I2JJscbHeox46bfX2z
         8+utniuSlEi/Q61yGTQDUbYijspV1FxeZ3rzO0Wg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d44e1b26ce5c3e77458d@syzkaller.appspotmail.com,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 28/44] blk-mq: Keep set->nr_hw_queues and set->map[].nr_queues in sync
Date:   Sat, 11 Apr 2020 14:09:48 +0200
Message-Id: <20200411115459.523169319@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115456.934174282@linuxfoundation.org>
References: <20200411115456.934174282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 6e66b49392419f3fe134e1be583323ef75da1e4b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2965,6 +2965,14 @@ static int blk_mq_alloc_rq_maps(struct b
 
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
 


