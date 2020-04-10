Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B51331A4146
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgDJDsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728086AbgDJDsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:48:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D6AF20936;
        Fri, 10 Apr 2020 03:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490494;
        bh=zndEF5nbEyrafOSfKLd+VqjCVDUNvwtQObFN7ypRggA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XedX5TzBrbXu5gcy6jnx0XaJVFYJj8cI5QD4hl0Q4Xof7JwltC4qECDiffU+jTYX6
         XmVUPBtG+Je+G431nuGSKpibgEfck7+0YY0hOcaHT4tDvOJbIHGM+Ccb1DsAcQuQA7
         4j97ER2rOyifbhH4z/wm8EGGpS3MgPV+0iZdBWOQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Johannes Thumshirn <jth@kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 11/56] blk-mq: Fix a recently introduced regression in blk_mq_realloc_hw_ctxs()
Date:   Thu,  9 Apr 2020 23:47:15 -0400
Message-Id: <20200410034800.8381-11-sashal@kernel.org>
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
index 329df7986bf60..51ff4852d34bc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2766,7 +2766,6 @@ static void blk_mq_realloc_hw_ctxs(struct blk_mq_tag_set *set,
 			memcpy(new_hctxs, hctxs, q->nr_hw_queues *
 			       sizeof(*hctxs));
 		q->queue_hw_ctx = new_hctxs;
-		q->nr_hw_queues = set->nr_hw_queues;
 		kfree(hctxs);
 		hctxs = new_hctxs;
 	}
-- 
2.20.1

