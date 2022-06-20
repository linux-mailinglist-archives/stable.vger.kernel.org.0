Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE615519F8
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238416AbiFTNFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244839AbiFTNED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3936E192BD;
        Mon, 20 Jun 2022 05:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF6CEB811A3;
        Mon, 20 Jun 2022 12:58:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E09C3411C;
        Mon, 20 Jun 2022 12:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729929;
        bh=zF1v78wE+V4e5SLuD5aljk/ixD5fd8h/4NWR5z4xJPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x2j74huuUY0aZPS+bESw+2XaSSDrWjOrc9u2iNdsH4o7pxG8iKEOEDhZZ1EF6arc0
         0SSTGvJ/E9uUwm3qCnp1Eh65lwJbdAhgSHEWTXyB+Xo+5IoT83BfzCaj1zjF/QDNJB
         m2JOuCsc8BAmGeSJut5nClKAhpQEounH/BaWqxUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 087/141] block: Fix handling of offline queues in blk_mq_alloc_request_hctx()
Date:   Mon, 20 Jun 2022 14:50:25 +0200
Message-Id: <20220620124732.116921788@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 14dc7a18abbe4176f5626c13c333670da8e06aa1 ]

This patch prevents that test nvme/004 triggers the following:

UBSAN: array-index-out-of-bounds in block/blk-mq.h:135:9
index 512 is out of range for type 'long unsigned int [512]'
Call Trace:
 show_stack+0x52/0x58
 dump_stack_lvl+0x49/0x5e
 dump_stack+0x10/0x12
 ubsan_epilogue+0x9/0x3b
 __ubsan_handle_out_of_bounds.cold+0x44/0x49
 blk_mq_alloc_request_hctx+0x304/0x310
 __nvme_submit_sync_cmd+0x70/0x200 [nvme_core]
 nvmf_connect_io_queue+0x23e/0x2a0 [nvme_fabrics]
 nvme_loop_connect_io_queues+0x8d/0xb0 [nvme_loop]
 nvme_loop_create_ctrl+0x58e/0x7d0 [nvme_loop]
 nvmf_create_ctrl+0x1d7/0x4d0 [nvme_fabrics]
 nvmf_dev_write+0xae/0x111 [nvme_fabrics]
 vfs_write+0x144/0x560
 ksys_write+0xb7/0x140
 __x64_sys_write+0x42/0x50
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Fixes: 20e4d8139319 ("blk-mq: simplify queue mapping & schedule with each possisble CPU")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20220615210004.1031820-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index de7fc6957271..631fb87b4976 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -579,6 +579,8 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	if (!blk_mq_hw_queue_mapped(data.hctx))
 		goto out_queue_exit;
 	cpu = cpumask_first_and(data.hctx->cpumask, cpu_online_mask);
+	if (cpu >= nr_cpu_ids)
+		goto out_queue_exit;
 	data.ctx = __blk_mq_get_ctx(q, cpu);
 
 	if (!q->elevator)
-- 
2.35.1



