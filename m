Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1572012E5
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392187AbgFSPTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:19:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392580AbgFSPSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:18:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B5B1206DB;
        Fri, 19 Jun 2020 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579886;
        bh=y7lqrBx/D7jiTGIX4ToNnfEsGw9sMUvRFXEY8rjU3Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u02SCYxedC8XWS9CEPTWX+S10ZSaDCo4XqjMkzxfDJa4VDGHMchQFymAp/4I+UXy6
         1yRm8phDoxQNXshlqDhaeUJdp4amG9lNwRleVZ4mvshErUYdVDiB5UyK2RKdbxEuL1
         lFZIey0zmBYHVIWYwVlJszAy68uOS3zoRec9S+mI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Weiping Zhang <zhangweiping@didiglobal.com>,
        Bart van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 041/376] block: reset mapping if failed to update hardware queue count
Date:   Fri, 19 Jun 2020 16:29:19 +0200
Message-Id: <20200619141712.301458749@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weiping Zhang <zhangweiping@didiglobal.com>

[ Upstream commit aa880ad690ab6d4c53934af85fb5a43e69ecb0f5 ]

When we increase hardware queue count, blk_mq_update_queue_map will
reset the mapping between cpu and hardware queue base on the hardware
queue count(set->nr_hw_queues). The mapping cannot be reset if it
encounters error in blk_mq_realloc_hw_ctxs, but the fallback flow will
continue using it, then blk_mq_map_swqueue will touch a invalid memory,
because the mapping points to a wrong hctx.

blktest block/030:

null_blk: module loaded
Increasing nr_hw_queues to 8 fails, fallback to 1
==================================================================
BUG: KASAN: null-ptr-deref in blk_mq_map_swqueue+0x2f2/0x830
Read of size 8 at addr 0000000000000128 by task nproc/8541

CPU: 5 PID: 8541 Comm: nproc Not tainted 5.7.0-rc4-dbg+ #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-0-gf21b5a4-rebuilt.opensuse.org 04/01/2014
Call Trace:
dump_stack+0xa5/0xe6
__kasan_report.cold+0x65/0xbb
kasan_report+0x45/0x60
check_memory_region+0x15e/0x1c0
__kasan_check_read+0x15/0x20
blk_mq_map_swqueue+0x2f2/0x830
__blk_mq_update_nr_hw_queues+0x3df/0x690
blk_mq_update_nr_hw_queues+0x32/0x50
nullb_device_submit_queues_store+0xde/0x160 [null_blk]
configfs_write_file+0x1c4/0x250 [configfs]
__vfs_write+0x4c/0x90
vfs_write+0x14b/0x2d0
ksys_write+0xdd/0x180
__x64_sys_write+0x47/0x50
do_syscall_64+0x6f/0x310
entry_SYSCALL_64_after_hwframe+0x49/0xb3

Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
Tested-by: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b1772de26a74..98a702761e2c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3353,8 +3353,8 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 
 	prev_nr_hw_queues = set->nr_hw_queues;
 	set->nr_hw_queues = nr_hw_queues;
-	blk_mq_update_queue_map(set);
 fallback:
+	blk_mq_update_queue_map(set);
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
 		blk_mq_realloc_hw_ctxs(set, q);
 		if (q->nr_hw_queues != set->nr_hw_queues) {
-- 
2.25.1



