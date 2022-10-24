Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4955060A1BC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiJXLct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiJXLc0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:32:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F30955C52;
        Mon, 24 Oct 2022 04:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A15D661259;
        Mon, 24 Oct 2022 11:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B497CC433D6;
        Mon, 24 Oct 2022 11:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611124;
        bh=llE9/ab7USjw9FU0xU1iQ0h7h9m4CO1tKGvXo0cSFkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ilsTykeZRJSw53nWXpxQkxBahqUPy3yhzOGxinWDVNEWHh+G7LN8+xZQWGfuogFpj
         EgZRfvH7Q6O1P9CuogcbLAqjY5MS8WW3hEZCxF/y7Qrkud20Q89BGp/EAfv8iCSuWk
         RUkWufnVMsyKCnRFoDxefMsHOMpqSdkm4An2keeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.0 18/20] io-wq: Fix memory leak in worker creation
Date:   Mon, 24 Oct 2022 13:31:20 +0200
Message-Id: <20221024112935.134200294@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael Mendonca <rafaelmendsr@gmail.com>

commit 996d3efeb091c503afd3ee6b5e20eabf446fd955 upstream.

If the CPU mask allocation for a node fails, then the memory allocated for
the 'io_wqe' struct of the current node doesn't get freed on the error
handling path, since it has not yet been added to the 'wqes' array.

This was spotted when fuzzing v6.1-rc1 with Syzkaller:
BUG: memory leak
unreferenced object 0xffff8880093d5000 (size 1024):
  comm "syz-executor.2", pid 7701, jiffies 4295048595 (age 13.900s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000cb463369>] __kmem_cache_alloc_node+0x18e/0x720
    [<00000000147a3f9c>] kmalloc_node_trace+0x2a/0x130
    [<000000004e107011>] io_wq_create+0x7b9/0xdc0
    [<00000000c38b2018>] io_uring_alloc_task_context+0x31e/0x59d
    [<00000000867399da>] __io_uring_add_tctx_node.cold+0x19/0x1ba
    [<000000007e0e7a79>] io_uring_setup.cold+0x1b80/0x1dce
    [<00000000b545e9f6>] __x64_sys_io_uring_setup+0x5d/0x80
    [<000000008a8a7508>] do_syscall_64+0x5d/0x90
    [<000000004ac08bec>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 0e03496d1967 ("io-wq: use private CPU mask")
Cc: stable@vger.kernel.org
Signed-off-by: Rafael Mendonca <rafaelmendsr@gmail.com>
Link: https://lore.kernel.org/r/20221020014710.902201-1-rafaelmendsr@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1164,10 +1164,10 @@ struct io_wq *io_wq_create(unsigned boun
 		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
 		if (!wqe)
 			goto err;
+		wq->wqes[node] = wqe;
 		if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
 			goto err;
 		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
-		wq->wqes[node] = wqe;
 		wqe->node = alloc_node;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =


