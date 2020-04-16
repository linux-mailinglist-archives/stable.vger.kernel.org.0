Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598211AC83D
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394923AbgDPPFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439819AbgDPNwc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:52:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F175B20786;
        Thu, 16 Apr 2020 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045151;
        bh=o/zhxWKrYxQOVMKe1OWh0TvBd4TNJW8cPkJoCHrfu9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1xEkBtqwLvjYRMB9rEPg0ZSZqBmkkr81NlL6RyVyn4j4dS74laypro9F6/VzXqKf
         HuZkjSFm0nWNLKrhqa86Zh0ebNZL9C39Zz711ViuEpSNwqJink35083r3o2Z6gst6Z
         xAh8W81oNGcwVVnFUadRhVnMikqiU6N9nc26UVHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 018/254] blk-mq: Fix a recently introduced regression in blk_mq_realloc_hw_ctxs()
Date:   Thu, 16 Apr 2020 15:21:47 +0200
Message-Id: <20200416131328.079987030@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit d0930bb8f46b8fb4a7d429c0bf1c91b3ed00a7cf ]

q->nr_hw_queues must only be updated once it is known that
blk_mq_realloc_hw_ctxs() has succeeded. Otherwise it can happen that
reallocation fails and that q->nr_hw_queues is larger than the number of
allocated hardware queues. This patch fixes the following crash if
increasing the number of hardware queues fails:

BUG: KASAN: null-ptr-deref in blk_mq_map_swqueue+0x775/0x810
Write of size 8 at addr 0000000000000118 by task check/977

CPU: 3 PID: 977 Comm: check Not tainted 5.6.0-rc1-dbg+ #8
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
Call Trace:
 dump_stack+0xa5/0xe6
 __kasan_report.cold+0x65/0x99
 kasan_report+0x16/0x20
 check_memory_region+0x140/0x1b0
 memset+0x28/0x40
 blk_mq_map_swqueue+0x775/0x810
 blk_mq_update_nr_hw_queues+0x468/0x710
 nullb_device_submit_queues_store+0xf7/0x1a0 [null_blk]
 configfs_write_file+0x1c4/0x250 [configfs]
 __vfs_write+0x4c/0x90
 vfs_write+0x145/0x2c0
 ksys_write+0xd7/0x180
 __x64_sys_write+0x47/0x50
 do_syscall_64+0x6f/0x2f0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: ac0d6b926e74 ("block: Reduce the amount of memory required per request queue")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d4bd9b961726a..37ff8dfb8ab9f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2824,7 +2824,6 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 			memcpy(new_hctxs, hctxs, q->nr_hw_queues *
 			       sizeof(*hctxs));
 		q->queue_hw_ctx = new_hctxs;
-		q->nr_hw_queues = set->nr_hw_queues;
 		kfree(hctxs);
 		hctxs = new_hctxs;
 	}
-- 
2.20.1



