Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 911E2676DCD
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjAVOvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbjAVOvR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:51:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2D51B550
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:51:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1171AB80AEE
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68291C433D2;
        Sun, 22 Jan 2023 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674399073;
        bh=FdkWmqpv/hh+KgbK43uaX5RgeLPX79UFgdGbhhNzUg4=;
        h=Subject:To:Cc:From:Date:From;
        b=maIhdG5UaPmzXI4Hf5Ubu82fjc3F5N1r4or3emtg5E7cv4picIGBNHd7W+OMPf5hp
         xc8bMp81yYpWWlmqOG+wTKsnTP+qekDnGMjUeUFdC7rKZBXGUno7lvainsD3DWyM4W
         Y+5pfVl/SSWYh3HUvSsB1RIk9CQ99SGFy4DTxSwo=
Subject: FAILED: patch "[PATCH] octeontx2-pf: Avoid use of GFP_KERNEL in atomic context" failed to apply to 5.15-stable tree
To:     gakula@marvell.com, davem@davemloft.net, leonro@nvidia.com,
        sgoutham@marvell.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 15:51:11 +0100
Message-ID: <1674399071110156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

87b93b678e95 ("octeontx2-pf: Avoid use of GFP_KERNEL in atomic context")
4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura free")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 87b93b678e95c7d93fe6a55b0e0fbda26d8c7760 Mon Sep 17 00:00:00 2001
From: Geetha sowjanya <gakula@marvell.com>
Date: Fri, 13 Jan 2023 11:49:02 +0530
Subject: [PATCH] octeontx2-pf: Avoid use of GFP_KERNEL in atomic context

Using GFP_KERNEL in preemption disable context, causing below warning
when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.

[   32.542271] BUG: sleeping function called from invalid context at include/linux/sched/mm.h:274
[   32.550883] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
[   32.558707] preempt_count: 1, expected: 0
[   32.562710] RCU nest depth: 0, expected: 0
[   32.566800] CPU: 3 PID: 1 Comm: swapper/0 Tainted: G        W          6.2.0-rc2-00269-gae9dcb91c606 #7
[   32.576188] Hardware name: Marvell CN106XX board (DT)
[   32.581232] Call trace:
[   32.583670]  dump_backtrace.part.0+0xe0/0xf0
[   32.587937]  show_stack+0x18/0x30
[   32.591245]  dump_stack_lvl+0x68/0x84
[   32.594900]  dump_stack+0x18/0x34
[   32.598206]  __might_resched+0x12c/0x160
[   32.602122]  __might_sleep+0x48/0xa0
[   32.605689]  __kmem_cache_alloc_node+0x2b8/0x2e0
[   32.610301]  __kmalloc+0x58/0x190
[   32.613610]  otx2_sq_aura_pool_init+0x1a8/0x314
[   32.618134]  otx2_open+0x1d4/0x9d0

To avoid use of GFP_ATOMIC for memory allocation, disable preemption
after all memory allocation is done.

Fixes: 4af1b64f80fb ("octeontx2-pf: Fix lmtst ID used in aura free")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 88f8772a61cd..497b777b6a34 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1370,7 +1370,6 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
-	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
 		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
@@ -1388,13 +1387,14 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
 			if (err)
 				goto err_mem;
+			get_cpu();
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
+			put_cpu();
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
 	}
 
 err_mem:
-	put_cpu();
 	return err ? -ENOMEM : 0;
 
 fail:

