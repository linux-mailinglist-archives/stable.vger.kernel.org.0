Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C841AC419
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898756AbgDPNyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:54:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898837AbgDPNyM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:54:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C54420786;
        Thu, 16 Apr 2020 13:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045251;
        bh=LBquVlZwgHuaDyiSkDMRNRKwv5wGXh4d1PQXRvfv3FQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I3gxSI71XWOhAFO5piXyfA866xuoGEVOLVaZm/UPkas5hG6Ibiyny3yoxN0vtgvhx
         9Dz71hOXHnJPPyFgcWJ30tqo3XdHSNxIogvSnkKThGAxY//54gGkgXGkLW8Enz4thU
         GrjBqmgSsWor+Rs6lH5iR5ADcmW6TrUKLTyCqJ0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Johannes Thumshirn <jth@kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 017/254] null_blk: Fix the null_add_dev() error path
Date:   Thu, 16 Apr 2020 15:21:46 +0200
Message-Id: <20200416131327.956939445@linuxfoundation.org>
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

[ Upstream commit 2004bfdef945fe55196db6b9cdf321fbc75bb0de ]

If null_add_dev() fails, clear dev->nullb.

This patch fixes the following KASAN complaint:

BUG: KASAN: use-after-free in nullb_device_submit_queues_store+0xcf/0x160 [null_blk]
Read of size 8 at addr ffff88803280fc30 by task check/8409

Call Trace:
 dump_stack+0xa5/0xe6
 print_address_description.constprop.0+0x26/0x260
 __kasan_report.cold+0x7b/0x99
 kasan_report+0x16/0x20
 __asan_load8+0x58/0x90
 nullb_device_submit_queues_store+0xcf/0x160 [null_blk]
 configfs_write_file+0x1c4/0x250 [configfs]
 __vfs_write+0x4c/0x90
 vfs_write+0x145/0x2c0
 ksys_write+0xd7/0x180
 __x64_sys_write+0x47/0x50
 do_syscall_64+0x6f/0x2f0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x7ff370926317
Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
RSP: 002b:00007fff2dd2da48 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007ff370926317
RDX: 0000000000000002 RSI: 0000559437ef23f0 RDI: 0000000000000001
RBP: 0000559437ef23f0 R08: 000000000000000a R09: 0000000000000001
R10: 0000559436703471 R11: 0000000000000246 R12: 0000000000000002
R13: 00007ff370a006a0 R14: 00007ff370a014a0 R15: 00007ff370a008a0

Allocated by task 8409:
 save_stack+0x23/0x90
 __kasan_kmalloc.constprop.0+0xcf/0xe0
 kasan_kmalloc+0xd/0x10
 kmem_cache_alloc_node_trace+0x129/0x4c0
 null_add_dev+0x24a/0xe90 [null_blk]
 nullb_device_power_store+0x1b6/0x270 [null_blk]
 configfs_write_file+0x1c4/0x250 [configfs]
 __vfs_write+0x4c/0x90
 vfs_write+0x145/0x2c0
 ksys_write+0xd7/0x180
 __x64_sys_write+0x47/0x50
 do_syscall_64+0x6f/0x2f0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 8409:
 save_stack+0x23/0x90
 __kasan_slab_free+0x112/0x160
 kasan_slab_free+0x12/0x20
 kfree+0xdf/0x250
 null_add_dev+0xaf3/0xe90 [null_blk]
 nullb_device_power_store+0x1b6/0x270 [null_blk]
 configfs_write_file+0x1c4/0x250 [configfs]
 __vfs_write+0x4c/0x90
 vfs_write+0x145/0x2c0
 ksys_write+0xd7/0x180
 __x64_sys_write+0x47/0x50
 do_syscall_64+0x6f/0x2f0
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 2984c8684f96 ("nullb: factor disk parameters")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 133060431dbdb..8ada43b3eca13 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1788,6 +1788,7 @@ out_cleanup_queues:
 	cleanup_queues(nullb);
 out_free_nullb:
 	kfree(nullb);
+	dev->nullb = NULL;
 out:
 	return rv;
 }
-- 
2.20.1



