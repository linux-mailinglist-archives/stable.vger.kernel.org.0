Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82CE5B7005
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbiIMOUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbiIMOTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA7E647DF;
        Tue, 13 Sep 2022 07:14:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C114B80F99;
        Tue, 13 Sep 2022 14:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F13C433C1;
        Tue, 13 Sep 2022 14:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078458;
        bh=5fQ2Z5RZkzHUVlMHHdw7M/dVv4ZmYr3kERm7OG0OxWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRx3ZHiHxRxOmWBznuIcGXqpwnUqhEBATjlUKSVw2zzfu6Xtdzurwk857L8gjOGSH
         59DWRtASKQIktCQ95YtVviaeO/TVIF4KRpw5OQmw4nU2Cb23FoQuHxNpeGAsWeREX1
         eGjU9JLbao+DCsoub5bxZsqFGuxZ1yCJzXEidiYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yacan Liu <liuyacan@corp.netease.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 148/192] net/smc: Fix possible access to freed memory in link clear
Date:   Tue, 13 Sep 2022 16:04:14 +0200
Message-Id: <20220913140417.396498544@linuxfoundation.org>
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

From: Yacan Liu <liuyacan@corp.netease.com>

[ Upstream commit e9b1a4f867ae9c1dbd1d71cd09cbdb3239fb4968 ]

After modifying the QP to the Error state, all RX WR would be completed
with WC in IB_WC_WR_FLUSH_ERR status. Current implementation does not
wait for it is done, but destroy the QP and free the link group directly.
So there is a risk that accessing the freed memory in tasklet context.

Here is a crash example:

 BUG: unable to handle page fault for address: ffffffff8f220860
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD f7300e067 P4D f7300e067 PUD f7300f063 PMD 8c4e45063 PTE 800ffff08c9df060
 Oops: 0002 [#1] SMP PTI
 CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G S         OE     5.10.0-0607+ #23
 Hardware name: Inspur NF5280M4/YZMB-00689-101, BIOS 4.1.20 07/09/2018
 RIP: 0010:native_queued_spin_lock_slowpath+0x176/0x1b0
 Code: f3 90 48 8b 32 48 85 f6 74 f6 eb d5 c1 ee 12 83 e0 03 83 ee 01 48 c1 e0 05 48 63 f6 48 05 00 c8 02 00 48 03 04 f5 00 09 98 8e <48> 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 85 c0 74 f7 48 8b 32
 RSP: 0018:ffffb3b6c001ebd8 EFLAGS: 00010086
 RAX: ffffffff8f220860 RBX: 0000000000000246 RCX: 0000000000080000
 RDX: ffff91db1f86c800 RSI: 000000000000173c RDI: ffff91db62bace00
 RBP: ffff91db62bacc00 R08: 0000000000000000 R09: c00000010000028b
 R10: 0000000000055198 R11: ffffb3b6c001ea58 R12: ffff91db80e05010
 R13: 000000000000000a R14: 0000000000000006 R15: 0000000000000040
 FS:  0000000000000000(0000) GS:ffff91db1f840000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffffffff8f220860 CR3: 00000001f9580004 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  <IRQ>
  _raw_spin_lock_irqsave+0x30/0x40
  mlx5_ib_poll_cq+0x4c/0xc50 [mlx5_ib]
  smc_wr_rx_tasklet_fn+0x56/0xa0 [smc]
  tasklet_action_common.isra.21+0x66/0x100
  __do_softirq+0xd5/0x29c
  asm_call_irq_on_stack+0x12/0x20
  </IRQ>
  do_softirq_own_stack+0x37/0x40
  irq_exit_rcu+0x9d/0xa0
  sysvec_call_function_single+0x34/0x80
  asm_sysvec_call_function_single+0x12/0x20

Fixes: bd4ad57718cc ("smc: initialize IB transport incl. PD, MR, QP, CQ, event, WR")
Signed-off-by: Yacan Liu <liuyacan@corp.netease.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_core.c | 1 +
 net/smc/smc_core.h | 2 ++
 net/smc/smc_wr.c   | 5 +++++
 net/smc/smc_wr.h   | 5 +++++
 4 files changed, 13 insertions(+)

diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index f40f6ed0fbdb4..1f3bb1f6b1f7b 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -755,6 +755,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
 	lnk->lgr = lgr;
 	smc_lgr_hold(lgr); /* lgr_put in smcr_link_clear() */
 	lnk->link_idx = link_idx;
+	lnk->wr_rx_id_compl = 0;
 	smc_ibdev_cnt_inc(lnk);
 	smcr_copy_dev_info_to_link(lnk);
 	atomic_set(&lnk->conn_cnt, 0);
diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index 4cb03e9423648..7b43a78c7f73a 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -115,8 +115,10 @@ struct smc_link {
 	dma_addr_t		wr_rx_dma_addr;	/* DMA address of wr_rx_bufs */
 	dma_addr_t		wr_rx_v2_dma_addr; /* DMA address of v2 rx buf*/
 	u64			wr_rx_id;	/* seq # of last recv WR */
+	u64			wr_rx_id_compl; /* seq # of last completed WR */
 	u32			wr_rx_cnt;	/* number of WR recv buffers */
 	unsigned long		wr_rx_tstamp;	/* jiffies when last buf rx */
+	wait_queue_head_t       wr_rx_empty_wait; /* wait for RQ empty */
 
 	struct ib_reg_wr	wr_reg;		/* WR register memory region */
 	wait_queue_head_t	wr_reg_wait;	/* wait for wr_reg result */
diff --git a/net/smc/smc_wr.c b/net/smc/smc_wr.c
index 26f8f240d9e84..b0678a417e09d 100644
--- a/net/smc/smc_wr.c
+++ b/net/smc/smc_wr.c
@@ -454,6 +454,7 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
 
 	for (i = 0; i < num; i++) {
 		link = wc[i].qp->qp_context;
+		link->wr_rx_id_compl = wc[i].wr_id;
 		if (wc[i].status == IB_WC_SUCCESS) {
 			link->wr_rx_tstamp = jiffies;
 			smc_wr_rx_demultiplex(&wc[i]);
@@ -465,6 +466,8 @@ static inline void smc_wr_rx_process_cqes(struct ib_wc wc[], int num)
 			case IB_WC_RNR_RETRY_EXC_ERR:
 			case IB_WC_WR_FLUSH_ERR:
 				smcr_link_down_cond_sched(link);
+				if (link->wr_rx_id_compl == link->wr_rx_id)
+					wake_up(&link->wr_rx_empty_wait);
 				break;
 			default:
 				smc_wr_rx_post(link); /* refill WR RX */
@@ -639,6 +642,7 @@ void smc_wr_free_link(struct smc_link *lnk)
 		return;
 	ibdev = lnk->smcibdev->ibdev;
 
+	smc_wr_drain_cq(lnk);
 	smc_wr_wakeup_reg_wait(lnk);
 	smc_wr_wakeup_tx_wait(lnk);
 
@@ -889,6 +893,7 @@ int smc_wr_create_link(struct smc_link *lnk)
 	atomic_set(&lnk->wr_tx_refcnt, 0);
 	init_waitqueue_head(&lnk->wr_reg_wait);
 	atomic_set(&lnk->wr_reg_refcnt, 0);
+	init_waitqueue_head(&lnk->wr_rx_empty_wait);
 	return rc;
 
 dma_unmap:
diff --git a/net/smc/smc_wr.h b/net/smc/smc_wr.h
index a54e90a1110fd..45e9b894d3f8a 100644
--- a/net/smc/smc_wr.h
+++ b/net/smc/smc_wr.h
@@ -73,6 +73,11 @@ static inline void smc_wr_tx_link_put(struct smc_link *link)
 		wake_up_all(&link->wr_tx_wait);
 }
 
+static inline void smc_wr_drain_cq(struct smc_link *lnk)
+{
+	wait_event(lnk->wr_rx_empty_wait, lnk->wr_rx_id_compl == lnk->wr_rx_id);
+}
+
 static inline void smc_wr_wakeup_tx_wait(struct smc_link *lnk)
 {
 	wake_up_all(&lnk->wr_tx_wait);
-- 
2.35.1



