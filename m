Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F5B5B6FBD
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiIMOR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiIMORR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:17:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB4A63F3E;
        Tue, 13 Sep 2022 07:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94881614B3;
        Tue, 13 Sep 2022 14:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F1C6C433C1;
        Tue, 13 Sep 2022 14:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078302;
        bh=fRU2UlDLzUVY30/oxLcHwnEXkrBEstw/oR3Dw9PWh6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wYEp46N36XRPbRvQdy1XU6B5N4rxvJucVciWh5lNBBWOh8LHfeZefLooWAvRY0o0U
         V7oed1izpm/VLgc5zXC4SFQ7z26nsVvi+OUzLofI4giZCiAberJ1nxTV9CbEc88fNc
         +nBJusF/bQZFc74pGGP8M1vrN76VfeIteQqdHimM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 088/192] RDMA/irdma: Fix drain SQ hang with no completion
Date:   Tue, 13 Sep 2022 16:03:14 +0200
Message-Id: <20220913140414.349201796@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit ead54ced6321099978d30d62dc49c282a6e70574 ]

SW generated completions for outstanding WRs posted on SQ
after QP is in error target the wrong CQ. This causes the
ib_drain_sq to hang with no completion.

Fix this to generate completions on the right CQ.

[  863.969340] INFO: task kworker/u52:2:671 blocked for more than 122 seconds.
[  863.979224]       Not tainted 5.14.0-130.el9.x86_64 #1
[  863.986588] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  863.996997] task:kworker/u52:2   state:D stack:    0 pid:  671 ppid:     2 flags:0x00004000
[  864.007272] Workqueue: xprtiod xprt_autoclose [sunrpc]
[  864.014056] Call Trace:
[  864.017575]  __schedule+0x206/0x580
[  864.022296]  schedule+0x43/0xa0
[  864.026736]  schedule_timeout+0x115/0x150
[  864.032185]  __wait_for_common+0x93/0x1d0
[  864.037717]  ? usleep_range_state+0x90/0x90
[  864.043368]  __ib_drain_sq+0xf6/0x170 [ib_core]
[  864.049371]  ? __rdma_block_iter_next+0x80/0x80 [ib_core]
[  864.056240]  ib_drain_sq+0x66/0x70 [ib_core]
[  864.062003]  rpcrdma_xprt_disconnect+0x82/0x3b0 [rpcrdma]
[  864.069365]  ? xprt_prepare_transmit+0x5d/0xc0 [sunrpc]
[  864.076386]  xprt_rdma_close+0xe/0x30 [rpcrdma]
[  864.082593]  xprt_autoclose+0x52/0x100 [sunrpc]
[  864.088718]  process_one_work+0x1e8/0x3c0
[  864.094170]  worker_thread+0x50/0x3b0
[  864.099109]  ? rescuer_thread+0x370/0x370
[  864.104473]  kthread+0x149/0x170
[  864.109022]  ? set_kthread_struct+0x40/0x40
[  864.114713]  ret_from_fork+0x22/0x30

Fixes: 81091d7696ae ("RDMA/irdma: Add SW mechanism to generate completions on error")
Link: https://lore.kernel.org/r/20220824154358.117-1-shiraz.saleem@intel.com
Reported-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index ab3c5208a1231..7b15faadfef5c 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2597,7 +2597,7 @@ void irdma_generate_flush_completions(struct irdma_qp *iwqp)
 		spin_unlock_irqrestore(&iwqp->lock, flags2);
 		spin_unlock_irqrestore(&iwqp->iwscq->lock, flags1);
 		if (compl_generated)
-			irdma_comp_handler(iwqp->iwrcq);
+			irdma_comp_handler(iwqp->iwscq);
 	} else {
 		spin_unlock_irqrestore(&iwqp->iwscq->lock, flags1);
 		mod_delayed_work(iwqp->iwdev->cleanup_wq, &iwqp->dwork_flush,
-- 
2.35.1



