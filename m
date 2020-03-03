Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53B4177FF1
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbgCCRxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732101AbgCCRxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:53:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45E7A20728;
        Tue,  3 Mar 2020 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258028;
        bh=GWuUrhosaMkp3+xGKPMnYKEDkAsJtfQyw4gsf0saGCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbdO1WZdCfP8Aw+1U4ScXf3dFLlyPSzpkvaQKJRjPtYg5NBQQQEwGVLpSRvUUPSJ3
         KpHO9mBs+cPn+RKwR+pjVi+A9Lv3lHAFRS+6WZfW0M0xqXzKbn5WBbNEBh/yCSp9U3
         IlYVzHk8Mv3H2bF5F6k2tztrY4xzze1R+s0I79vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Krishnamraju Eraparaju <krishna2@chelsio.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/152] RDMA/siw: Remove unwanted WARN_ON in siw_cm_llp_data_ready()
Date:   Tue,  3 Mar 2020 18:42:20 +0100
Message-Id: <20200303174307.179723706@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krishnamraju Eraparaju <krishna2@chelsio.com>

[ Upstream commit 663218a3e715fd9339d143a3e10088316b180f4f ]

Warnings like below can fill up the dmesg while disconnecting RDMA
connections.
Hence, remove the unwanted WARN_ON.

  WARNING: CPU: 6 PID: 0 at drivers/infiniband/sw/siw/siw_cm.c:1229 siw_cm_llp_data_ready+0xc1/0xd0 [siw]
  RIP: 0010:siw_cm_llp_data_ready+0xc1/0xd0 [siw]
  Call Trace:
   <IRQ>
   tcp_data_queue+0x226/0xb40
   tcp_rcv_established+0x220/0x620
   tcp_v4_do_rcv+0x12a/0x1e0
   tcp_v4_rcv+0xb05/0xc00
   ip_local_deliver_finish+0x69/0x210
   ip_local_deliver+0x6b/0xe0
   ip_rcv+0x273/0x362
   __netif_receive_skb_core+0xb35/0xc30
   netif_receive_skb_internal+0x3d/0xb0
   napi_gro_frags+0x13b/0x200
   t4_ethrx_handler+0x433/0x7d0 [cxgb4]
   process_responses+0x318/0x580 [cxgb4]
   napi_rx_handler+0x14/0x100 [cxgb4]
   net_rx_action+0x149/0x3b0
   __do_softirq+0xe3/0x30a
   irq_exit+0x100/0x110
   do_IRQ+0x7f/0xe0
   common_interrupt+0xf/0xf
   </IRQ>

Link: https://lore.kernel.org/r/20200207141429.27927-1-krishna2@chelsio.com
Signed-off-by: Krishnamraju Eraparaju <krishna2@chelsio.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
index 0454561718d95..31aa41d85ccff 100644
--- a/drivers/infiniband/sw/siw/siw_cm.c
+++ b/drivers/infiniband/sw/siw/siw_cm.c
@@ -1225,10 +1225,9 @@ static void siw_cm_llp_data_ready(struct sock *sk)
 	read_lock(&sk->sk_callback_lock);
 
 	cep = sk_to_cep(sk);
-	if (!cep) {
-		WARN_ON(1);
+	if (!cep)
 		goto out;
-	}
+
 	siw_dbg_cep(cep, "state: %d\n", cep->state);
 
 	switch (cep->state) {
-- 
2.20.1



