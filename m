Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0A4717F508
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 11:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgCJK2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 06:28:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55505 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725845AbgCJK2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 06:28:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 5410621F55;
        Tue, 10 Mar 2020 06:28:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 06:28:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1rh/k5
        L0UePdtxRpcYjeVvwR0byDfMpVDibBpcLLhCc=; b=NY1SB5QFORClTPfz/yYmgS
        Kz9RTGW74h1VO/l0pJAKtyZ0EI529mT3Fk8cXMU9y79/p95ojCTjRFP8DyAp3iP+
        yyvAYl1IBroFJzBklS0jCcQpSQw4xRmuWU+kpjPsMeTdFImNxnX0Dkvnwa/l5CKq
        fRMhphz58x9bbBt9fliz5e4nbbMTmnuH97diS1/3STGK9uCMqH7EScASSdaTTx/U
        8Kad5GFsqpiALDDObN9yC5qlReJ73VGvEpJj2d1AJKr4fS8ROOH74USj1mlAu1bG
        TV3Sw3fKJOjx+H2BtnQmhmO/1BiQJaYkG7lEHZAqRlKCizfka6uR4OkTKcZSOl1Q
        ==
X-ME-Sender: <xms:xGtnXl8wZJZN5kXa16Bbs6v_j5Qi0DEkdWQoy7A-1vDr7sltqyqLhg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:xGtnXt_n1qYvPwN7iQZM-HCJpwWjR3Kh59FlfeEoUgh6OEchzUO-Ug>
    <xmx:xGtnXuAAEgPpsSOBKquKDSySFlQAsYWX68K4OFiemJ0pDlLHM-1mJw>
    <xmx:xGtnXtyo8pi_mh2PWLFCGW5DcRflc9I5mST6YqBpAcAUUg2UE3_ooA>
    <xmx:xWtnXptu5VugBxQmucDgLhVKWZmuYIzsgEgaAKXivFlTXkR51-PoJA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A592A3280065;
        Tue, 10 Mar 2020 06:28:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/hfi1, qib: Ensure RCU is locked when accessing list" failed to apply to 4.9-stable tree
To:     dennis.dalessandro@intel.com, jgg@mellanox.com,
        mike.marciniszyn@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 11:28:18 +0100
Message-ID: <158383609881204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 817a68a6584aa08e323c64283fec5ded7be84759 Mon Sep 17 00:00:00 2001
From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Date: Tue, 25 Feb 2020 14:54:45 -0500
Subject: [PATCH] IB/hfi1, qib: Ensure RCU is locked when accessing list

The packet handling function, specifically the iteration of the qp list
for mad packet processing misses locking RCU before running through the
list. Not only is this incorrect, but the list_for_each_entry_rcu() call
can not be called with a conditional check for lock dependency. Remedy
this by invoking the rcu lock and unlock around the critical section.

This brings MAD packet processing in line with what is done for non-MAD
packets.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20200225195445.140896.41873.stgit@awfm-01.aw.intel.com
Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 089e201d7550..2f6323ad9c59 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -515,10 +515,11 @@ static inline void hfi1_handle_packet(struct hfi1_packet *packet,
 				       opa_get_lid(packet->dlid, 9B));
 		if (!mcast)
 			goto drop;
+		rcu_read_lock();
 		list_for_each_entry_rcu(p, &mcast->qp_list, list) {
 			packet->qp = p->qp;
 			if (hfi1_do_pkey_check(packet))
-				goto drop;
+				goto unlock_drop;
 			spin_lock_irqsave(&packet->qp->r_lock, flags);
 			packet_handler = qp_ok(packet);
 			if (likely(packet_handler))
@@ -527,6 +528,7 @@ static inline void hfi1_handle_packet(struct hfi1_packet *packet,
 				ibp->rvp.n_pkt_drops++;
 			spin_unlock_irqrestore(&packet->qp->r_lock, flags);
 		}
+		rcu_read_unlock();
 		/*
 		 * Notify rvt_multicast_detach() if it is waiting for us
 		 * to finish.
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 33778d451b82..5ef93f8f17a1 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -329,8 +329,10 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 		if (mcast == NULL)
 			goto drop;
 		this_cpu_inc(ibp->pmastats->n_multicast_rcv);
+		rcu_read_lock();
 		list_for_each_entry_rcu(p, &mcast->qp_list, list)
 			qib_qp_rcv(rcd, hdr, 1, data, tlen, p->qp);
+		rcu_read_unlock();
 		/*
 		 * Notify rvt_multicast_detach() if it is waiting for us
 		 * to finish.

