Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CD860AD51
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiJXOVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235458AbiJXOTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:19:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C2623EB4;
        Mon, 24 Oct 2022 05:56:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D8FB6121A;
        Mon, 24 Oct 2022 12:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5395FC433C1;
        Mon, 24 Oct 2022 12:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616196;
        bh=LaWtLEvCT2VdGcjH4+ExzTkc5aQ8UDmqchGx5p6nb+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYfuoLWEDzSnJ75NTX8gmUgbegDd3aruKMm1y3PwgfKEIiYb3bWXbjrvyf++9Un3q
         7EQ96YGBfqtLZgyC2558J/Lmd4plyOBgB1Ftx3TI4AII4SiyPtoNl6oRcSqgajijQP
         FvfJWVW6vlLbkY6+eGjl6HIjuBz3FEu0wN5Vjfi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Mendonca <rafaelmendsr@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 530/530] io-wq: Fix memory leak in worker creation
Date:   Mon, 24 Oct 2022 13:34:34 +0200
Message-Id: <20221024113109.004217718@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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
 fs/io-wq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1152,10 +1152,10 @@ struct io_wq *io_wq_create(unsigned boun
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


