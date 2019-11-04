Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D16D4EEE9F
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388282AbfKDWEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:04:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389703AbfKDWEh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:04:37 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73B7A2084D;
        Mon,  4 Nov 2019 22:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905075;
        bh=p9C5sV/9RGDGSsR26ocpzESBcVa9EVNGwDLOF9hwdCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yFAyDeuwy15nv534N2GLbzogVEim6QN7Wq0QIjdqJ1CrnlcFJv+jHXxmP8r/w9Gl7
         MSl98eW2/SNTI5owbr/ETyQOZvEq7f1eLgSoY2alx7Uv+0nseN1NPiE7KY1A2T30dW
         jtaqRwvUKzxlsNAa17HEYC9EMsBI7Nvt1marS0F4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krishnamraju Eraparaju <krishna2@chelsio.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 021/163] RDMA/siw: Fix serialization issue in write_space()
Date:   Mon,  4 Nov 2019 22:43:31 +0100
Message-Id: <20191104212141.932422269@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishnamraju Eraparaju <krishna2@chelsio.com>

[ Upstream commit df791c54d627bae53c9be3be40a69594c55de487 ]

In siw_qp_llp_write_space(), 'sock' members should be accessed with
sk_callback_lock held, otherwise, it could race with
siw_sk_restore_upcalls(). And this could cause "NULL deref" panic.  Below
panic is due to the NULL cep returned from sk_to_cep(sk):

  Call Trace:
   <IRQ>    siw_qp_llp_write_space+0x11/0x40 [siw]
   tcp_check_space+0x4c/0xf0
   tcp_rcv_established+0x52b/0x630
   tcp_v4_do_rcv+0xf4/0x1e0
   tcp_v4_rcv+0x9b8/0xab0
   ip_protocol_deliver_rcu+0x2c/0x1c0
   ip_local_deliver_finish+0x44/0x50
   ip_local_deliver+0x6b/0xf0
   ? ip_protocol_deliver_rcu+0x1c0/0x1c0
   ip_rcv+0x52/0xd0
   ? ip_rcv_finish_core.isra.14+0x390/0x390
   __netif_receive_skb_one_core+0x83/0xa0
   netif_receive_skb_internal+0x73/0xb0
   napi_gro_frags+0x1ff/0x2b0
   t4_ethrx_handler+0x4a7/0x740 [cxgb4]
   process_responses+0x2c9/0x590 [cxgb4]
   ? t4_sge_intr_msix+0x1d/0x30 [cxgb4]
   ? handle_irq_event_percpu+0x51/0x70
   ? handle_irq_event+0x41/0x60
   ? handle_edge_irq+0x97/0x1a0
   napi_rx_handler+0x14/0xe0 [cxgb4]
   net_rx_action+0x2af/0x410
   __do_softirq+0xda/0x2a8
   do_softirq_own_stack+0x2a/0x40
   </IRQ>
   do_softirq+0x50/0x60
   __local_bh_enable_ip+0x50/0x60
   ip_finish_output2+0x18f/0x520
   ip_output+0x6e/0xf0
   ? __ip_finish_output+0x1f0/0x1f0
   __ip_queue_xmit+0x14f/0x3d0
   ? __slab_alloc+0x4b/0x58
   __tcp_transmit_skb+0x57d/0xa60
   tcp_write_xmit+0x23b/0xfd0
   __tcp_push_pending_frames+0x2e/0xf0
   tcp_sendmsg_locked+0x939/0xd50
   tcp_sendmsg+0x27/0x40
   sock_sendmsg+0x57/0x80
   siw_tx_hdt+0x894/0xb20 [siw]
   ? find_busiest_group+0x3e/0x5b0
   ? common_interrupt+0xa/0xf
   ? common_interrupt+0xa/0xf
   ? common_interrupt+0xa/0xf
   siw_qp_sq_process+0xf1/0xe60 [siw]
   ? __wake_up_common_lock+0x87/0xc0
   siw_sq_resume+0x33/0xe0 [siw]
   siw_run_sq+0xac/0x190 [siw]
   ? remove_wait_queue+0x60/0x60
   kthread+0xf8/0x130
   ? siw_sq_resume+0xe0/0xe0 [siw]
   ? kthread_bind+0x10/0x10
   ret_from_fork+0x35/0x40

Fixes: f29dd55b0236 ("rdma/siw: queue pair methods")
Link: https://lore.kernel.org/r/20190923101112.32685-1-krishna2@chelsio.com
Signed-off-by: Krishnamraju Eraparaju <krishna2@chelsio.com>
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp.c b/drivers/infiniband/sw/siw/siw_qp.c
index 430314c8abd94..52d402f39df93 100644
--- a/drivers/infiniband/sw/siw/siw_qp.c
+++ b/drivers/infiniband/sw/siw/siw_qp.c
@@ -182,12 +182,19 @@ void siw_qp_llp_close(struct siw_qp *qp)
  */
 void siw_qp_llp_write_space(struct sock *sk)
 {
-	struct siw_cep *cep = sk_to_cep(sk);
+	struct siw_cep *cep;
 
-	cep->sk_write_space(sk);
+	read_lock(&sk->sk_callback_lock);
+
+	cep  = sk_to_cep(sk);
+	if (cep) {
+		cep->sk_write_space(sk);
 
-	if (!test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
-		(void)siw_sq_start(cep->qp);
+		if (!test_bit(SOCK_NOSPACE, &sk->sk_socket->flags))
+			(void)siw_sq_start(cep->qp);
+	}
+
+	read_unlock(&sk->sk_callback_lock);
 }
 
 static int siw_qp_readq_init(struct siw_qp *qp, int irq_size, int orq_size)
-- 
2.20.1



