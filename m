Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D59162157D
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiKHOMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235298AbiKHOMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:12:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247D025C44
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:12:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5A90615C2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4231C433D7;
        Tue,  8 Nov 2022 14:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916728;
        bh=uokQhiI6qaeXLZpmRIgmq+g3A1e7eYFCVUhQHKFLIk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1kv02lz+MvTVSBDqeVHMPxOJVnpQmwv80IEPr/WuiFBkVms/etAsrVnZ847JAoJF
         Q/cG75BXYAXfSmkc8Ne6wOnsUoTHApzSuR36K1zqIGhv2Hwo9ioeWtK52Oaw9zFURp
         M+gnpy9PhP/dVEh/lbrZ5s5DohwaRLLvxu+IWQgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Chen Jun <chenjun102@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 114/197] blk-mq: Fix kmemleak in blk_mq_init_allocated_queue
Date:   Tue,  8 Nov 2022 14:39:12 +0100
Message-Id: <20221108133400.140192007@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jun <chenjun102@huawei.com>

[ Upstream commit 943f45b9399ed8b2b5190cbc797995edaa97f58f ]

There is a kmemleak caused by modprobe null_blk.ko

unreferenced object 0xffff8881acb1f000 (size 1024):
  comm "modprobe", pid 836, jiffies 4294971190 (age 27.068s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 00 53 99 9e ff ff ff ff  .........S......
  backtrace:
    [<000000004a10c249>] kmalloc_node_trace+0x22/0x60
    [<00000000648f7950>] blk_mq_alloc_and_init_hctx+0x289/0x350
    [<00000000af06de0e>] blk_mq_realloc_hw_ctxs+0x2fe/0x3d0
    [<00000000e00c1872>] blk_mq_init_allocated_queue+0x48c/0x1440
    [<00000000d16b4e68>] __blk_mq_alloc_disk+0xc8/0x1c0
    [<00000000d10c98c3>] 0xffffffffc450d69d
    [<00000000b9299f48>] 0xffffffffc4538392
    [<0000000061c39ed6>] do_one_initcall+0xd0/0x4f0
    [<00000000b389383b>] do_init_module+0x1a4/0x680
    [<0000000087cf3542>] load_module+0x6249/0x7110
    [<00000000beba61b8>] __do_sys_finit_module+0x140/0x200
    [<00000000fdcfff51>] do_syscall_64+0x35/0x80
    [<000000003c0f1f71>] entry_SYSCALL_64_after_hwframe+0x46/0xb0

That is because q->ma_ops is set to NULL before blk_release_queue is
called.

blk_mq_init_queue_data
  blk_mq_init_allocated_queue
    blk_mq_realloc_hw_ctxs
      for (i = 0; i < set->nr_hw_queues; i++) {
        old_hctx = xa_load(&q->hctx_table, i);
        if (!blk_mq_alloc_and_init_hctx(.., i, ..))		[1]
          if (!old_hctx)
	    break;

      xa_for_each_start(&q->hctx_table, j, hctx, j)
        blk_mq_exit_hctx(q, set, hctx, j); 			[2]

    if (!q->nr_hw_queues)					[3]
      goto err_hctxs;

  err_exit:
      q->mq_ops = NULL;			  			[4]

  blk_put_queue
    blk_release_queue
      if (queue_is_mq(q))					[5]
        blk_mq_release(q);

[1]: blk_mq_alloc_and_init_hctx failed at i != 0.
[2]: The hctxs allocated by [1] are moved to q->unused_hctx_list and
will be cleaned up in blk_mq_release.
[3]: q->nr_hw_queues is 0.
[4]: Set q->mq_ops to NULL.
[5]: queue_is_mq returns false due to [4]. And blk_mq_release
will not be called. The hctxs in q->unused_hctx_list are leaked.

To fix it, call blk_release_queue in exception path.

Fixes: 2f8f1336a48b ("blk-mq: always free hctx after request queue is freed")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20221031031242.94107-1-chenjun102@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index fe840536e6ac..edf41959a705 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4104,9 +4104,7 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	return 0;
 
 err_hctxs:
-	xa_destroy(&q->hctx_table);
-	q->nr_hw_queues = 0;
-	blk_mq_sysfs_deinit(q);
+	blk_mq_release(q);
 err_poll:
 	blk_stat_free_callback(q->poll_cb);
 	q->poll_cb = NULL;
-- 
2.35.1



