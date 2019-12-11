Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBE111B7A2
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbfLKQJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:09:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730703AbfLKPMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 643E522B48;
        Wed, 11 Dec 2019 15:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077128;
        bh=II8nkJraDvslJudv4jma/RouXM7QGwblB9oSjvMRg2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4BkSiNTo1IJTPZ4BG1TGtFnYEofgwJ78TaDaGMTe0GwqYQka2Ff4VZBVV4g6RjVC
         lCPQp4O2dqxtQ+n5Gv3FjAeyiURQAYlf+kvjwgZRZGAFV4ekXp/5WYk16SbD6CFdv3
         1tG07t9EEcdvyFw0THeD5do85p7gdYk/n/krt7LE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Junichi Nomura <j-nomura@ce.jp.nec.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 027/105] block: check bi_size overflow before merge
Date:   Wed, 11 Dec 2019 16:05:16 +0100
Message-Id: <20191211150229.642179241@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junichi Nomura <j-nomura@ce.jp.nec.com>

[ Upstream commit e3a5d8e386c3fb973fa75f2403622a8f3640ec06 ]

__bio_try_merge_page() may merge a page to bio without bio_full() check
and cause bi_size overflow.

The overflow typically ends up with sd_init_command() warning on zero
segment request with call trace like this:

    ------------[ cut here ]------------
    WARNING: CPU: 2 PID: 1986 at drivers/scsi/scsi_lib.c:1025 scsi_init_io+0x156/0x180
    CPU: 2 PID: 1986 Comm: kworker/2:1H Kdump: loaded Not tainted 5.4.0-rc7 #1
    Workqueue: kblockd blk_mq_run_work_fn
    RIP: 0010:scsi_init_io+0x156/0x180
    RSP: 0018:ffffa11487663bf0 EFLAGS: 00010246
    RAX: 00000000002be0a0 RBX: ffff8e6e9ff30118 RCX: 0000000000000000
    RDX: 00000000ffffffe1 RSI: 0000000000000000 RDI: ffff8e6e9ff30118
    RBP: ffffa11487663c18 R08: ffffa11487663d28 R09: ffff8e6e9ff30150
    R10: 0000000000000001 R11: 0000000000000000 R12: ffff8e6e9ff30000
    R13: 0000000000000001 R14: ffff8e74a1cf1800 R15: ffff8e6e9ff30000
    FS:  0000000000000000(0000) GS:ffff8e6ea7680000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: 00007fff18cf0fe8 CR3: 0000000659f0a001 CR4: 00000000001606e0
    Call Trace:
     sd_init_command+0x326/0xb40 [sd_mod]
     scsi_queue_rq+0x502/0xaa0
     ? blk_mq_get_driver_tag+0xe7/0x120
     blk_mq_dispatch_rq_list+0x256/0x5a0
     ? elv_rb_del+0x24/0x30
     ? deadline_remove_request+0x7b/0xc0
     blk_mq_do_dispatch_sched+0xa3/0x140
     blk_mq_sched_dispatch_requests+0xfb/0x170
     __blk_mq_run_hw_queue+0x81/0x130
     blk_mq_run_work_fn+0x1b/0x20
     process_one_work+0x179/0x390
     worker_thread+0x4f/0x3e0
     kthread+0x105/0x140
     ? max_active_store+0x80/0x80
     ? kthread_bind+0x20/0x20
     ret_from_fork+0x35/0x40
    ---[ end trace f9036abf5af4a4d3 ]---
    blk_update_request: I/O error, dev sdd, sector 2875552 op 0x1:(WRITE) flags 0x0 phys_seg 0 prio class 0
    XFS (sdd1): writeback error on sector 2875552

__bio_try_merge_page() should check the overflow before actually doing
merge.

Fixes: 07173c3ec276c ("block: enable multipage bvecs")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 299a0e7651ec0..31d56e7e2ce05 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -769,7 +769,7 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return false;
 
-	if (bio->bi_vcnt > 0) {
+	if (bio->bi_vcnt > 0 && !bio_full(bio, len)) {
 		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
 
 		if (page_is_mergeable(bv, page, len, off, same_page)) {
-- 
2.20.1



