Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F48112180C
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfLPSBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:01:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729165AbfLPSBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:01:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41FD62072D;
        Mon, 16 Dec 2019 18:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519291;
        bh=rT3S8LmnIhDXVtIv59nKqnU/7vcYn/2MEcD2L1YLdNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JC8zdBMLymjKyg1cKcsIoUYdqXErUsKx/MP2cWNJWDQMtBksP1ttxOo5gmSS6xFTp
         /FYWbA22H/xLDAoVs3MOS06bKIzZ7gU6UooZ+GYRMj2bsLAcOpB4Gc6iQdf4191wR3
         Qu7wHZzusQmNCcCtViEoRl/2ejBDatwz2hTWflSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Guangwu Zhang <guazhang@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Jianchao Wang <jianchao.w.wang@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, Andre Tomt <andre@tomt.net>,
        Jack Wang <jack.wang.usish@gmail.com>
Subject: [PATCH 4.14 237/267] block: fix single range discard merge
Date:   Mon, 16 Dec 2019 18:49:23 +0100
Message-Id: <20191216174915.536375247@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 2a5cf35cd6c56b2924bce103413ad3381bdc31fa upstream.

There are actually two kinds of discard merge:

- one is the normal discard merge, just like normal read/write request,
and call it single-range discard

- another is the multi-range discard, queue_max_discard_segments(rq->q) > 1

For the former case, queue_max_discard_segments(rq->q) is 1, and we
should handle this kind of discard merge like the normal read/write
request.

This patch fixes the following kernel panic issue[1], which is caused by
not removing the single-range discard request from elevator queue.

Guangwu has one raid discard test case, in which this issue is a bit
easier to trigger, and I verified that this patch can fix the kernel
panic issue in Guangwu's test case.

[1] kernel panic log from Jens's report

 BUG: unable to handle kernel NULL pointer dereference at 0000000000000148
 PGD 0 P4D 0.
 Oops: 0000 [#1] SMP PTI
 CPU: 37 PID: 763 Comm: kworker/37:1H Not tainted \
4.20.0-rc3-00649-ge64d9a554a91-dirty #14  Hardware name: Wiwynn \
Leopard-Orv2/Leopard-DDR BW, BIOS LBM08   03/03/2017       Workqueue: kblockd \
blk_mq_run_work_fn                                            RIP: \
0010:blk_mq_get_driver_tag+0x81/0x120                                       Code: 24 \
10 48 89 7c 24 20 74 21 83 fa ff 0f 95 c0 48 8b 4c 24 28 65 48 33 0c 25 28 00 00 00 \
0f 85 96 00 00 00 48 83 c4 30 5b 5d c3 <48> 8b 87 48 01 00 00 8b 40 04 39 43 20 72 37 \
f6 87 b0 00 00 00 02  RSP: 0018:ffffc90004aabd30 EFLAGS: 00010246                     \
  RAX: 0000000000000003 RBX: ffff888465ea1300 RCX: ffffc90004aabde8
 RDX: 00000000ffffffff RSI: ffffc90004aabde8 RDI: 0000000000000000
 RBP: 0000000000000000 R08: ffff888465ea1348 R09: 0000000000000000
 R10: 0000000000001000 R11: 00000000ffffffff R12: ffff888465ea1300
 R13: 0000000000000000 R14: ffff888465ea1348 R15: ffff888465d10000
 FS:  0000000000000000(0000) GS:ffff88846f9c0000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000148 CR3: 000000000220a003 CR4: 00000000003606e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  blk_mq_dispatch_rq_list+0xec/0x480
  ? elv_rb_del+0x11/0x30
  blk_mq_do_dispatch_sched+0x6e/0xf0
  blk_mq_sched_dispatch_requests+0xfa/0x170
  __blk_mq_run_hw_queue+0x5f/0xe0
  process_one_work+0x154/0x350
  worker_thread+0x46/0x3c0
  kthread+0xf5/0x130
  ? process_one_work+0x350/0x350
  ? kthread_destroy_worker+0x50/0x50
  ret_from_fork+0x1f/0x30
 Modules linked in: sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel \
kvm switchtec irqbypass iTCO_wdt iTCO_vendor_support efivars cdc_ether usbnet mii \
cdc_acm i2c_i801 lpc_ich mfd_core ipmi_si ipmi_devintf ipmi_msghandler acpi_cpufreq \
button sch_fq_codel nfsd nfs_acl lockd grace auth_rpcgss oid_registry sunrpc nvme \
nvme_core fuse sg loop efivarfs autofs4  CR2: 0000000000000148                        \

 ---[ end trace 340a1fb996df1b9b ]---
 RIP: 0010:blk_mq_get_driver_tag+0x81/0x120
 Code: 24 10 48 89 7c 24 20 74 21 83 fa ff 0f 95 c0 48 8b 4c 24 28 65 48 33 0c 25 28 \
00 00 00 0f 85 96 00 00 00 48 83 c4 30 5b 5d c3 <48> 8b 87 48 01 00 00 8b 40 04 39 43 \
20 72 37 f6 87 b0 00 00 00 02

Fixes: 445251d0f4d329a ("blk-mq: fix discard merge with scheduler attached")
Reported-by: Jens Axboe <axboe@kernel.dk>
Cc: Guangwu Zhang <guazhang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jianchao Wang <jianchao.w.wang@oracle.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Andre Tomt <andre@tomt.net>
Cc: Jack Wang <jack.wang.usish@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-merge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -765,7 +765,7 @@ static struct request *attempt_merge(str
 
 	req->__data_len += blk_rq_bytes(next);
 
-	if (req_op(req) != REQ_OP_DISCARD)
+	if (!blk_discard_mergable(req))
 		elv_merge_requests(q, req, next);
 
 	/*


