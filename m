Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFBE677017
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjAVP23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjAVP21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:28:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724B715547
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29A9BB80B22
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B070C433D2;
        Sun, 22 Jan 2023 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401303;
        bh=PukU/otsWUKCWd3HPHpPKrKnKaLqpZLFdtm4jJiDoHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+SGSsALLg7o2p83pE987AigTcKPOWfP7Nxp5oR32Ko6yQHmjsC7tlxo0MuJyL6Bb
         ha+eIRSkiQHfzp+spUF2Mf24UKmsIJAw8Jru02SZ0CuCm5Wug/I5WEdo3g+suNURV5
         HkjWBFQiJiJ+zOvc7+TZVGqkAV2WSuaFnCAgU8rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geetha sowjanya <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 187/193] octeontx2-pf: Avoid use of GFP_KERNEL in atomic context
Date:   Sun, 22 Jan 2023 16:05:16 +0100
Message-Id: <20230122150254.966501285@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Geetha sowjanya <gakula@marvell.com>

commit 87b93b678e95c7d93fe6a55b0e0fbda26d8c7760 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1370,7 +1370,6 @@ int otx2_sq_aura_pool_init(struct otx2_n
 	if (err)
 		goto fail;
 
-	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (qidx = 0; qidx < hw->tot_tx_queues; qidx++) {
 		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
@@ -1388,13 +1387,14 @@ int otx2_sq_aura_pool_init(struct otx2_n
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


