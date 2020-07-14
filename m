Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316B621FBCF
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730717AbgGNTEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:04:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:53854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729869AbgGNS4C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3F8A22A99;
        Tue, 14 Jul 2020 18:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752962;
        bh=WnLnhBxYGBLSoBRAFDvZl2ayQFZ5L0B/uZa6I0SALS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghf0kZ2NGGdBA5nVfjk2NUYOIpmu+Y3cBNyRYF1MoEqnlBuhuuMJ5/rsmKfxi9EaY
         zUpZ7smNXrSk45ml7I+rpaH9KaYj+6HuJ6cRnGNWpIr/kxDnE3lAdDJlwk55EpFF/d
         W2DUjQDzFwNX87Q8uL8QcociIvHI2JilF4L0Fw2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Indi <divya.indi@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 067/166] IB/sa: Resolv use-after-free in ib_nl_make_request()
Date:   Tue, 14 Jul 2020 20:43:52 +0200
Message-Id: <20200714184119.074467596@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Divya Indi <divya.indi@oracle.com>

[ Upstream commit f427f4d6214c183c474eeb46212d38e6c7223d6a ]

There is a race condition where ib_nl_make_request() inserts the request
data into the linked list but the timer in ib_nl_request_timeout() can see
it and destroy it before ib_nl_send_msg() is done touching it. This could
happen, for instance, if there is a long delay allocating memory during
nlmsg_new()

This causes a use-after-free in the send_mad() thread:

  [<ffffffffa02f43cb>] ? ib_pack+0x17b/0x240 [ib_core]
  [ <ffffffffa032aef1>] ib_sa_path_rec_get+0x181/0x200 [ib_sa]
  [<ffffffffa0379db0>] rdma_resolve_route+0x3c0/0x8d0 [rdma_cm]
  [<ffffffffa0374450>] ? cma_bind_port+0xa0/0xa0 [rdma_cm]
  [<ffffffffa040f850>] ? rds_rdma_cm_event_handler_cmn+0x850/0x850 [rds_rdma]
  [<ffffffffa040f22c>] rds_rdma_cm_event_handler_cmn+0x22c/0x850 [rds_rdma]
  [<ffffffffa040f860>] rds_rdma_cm_event_handler+0x10/0x20 [rds_rdma]
  [<ffffffffa037778e>] addr_handler+0x9e/0x140 [rdma_cm]
  [<ffffffffa026cdb4>] process_req+0x134/0x190 [ib_addr]
  [<ffffffff810a02f9>] process_one_work+0x169/0x4a0
  [<ffffffff810a0b2b>] worker_thread+0x5b/0x560
  [<ffffffff810a0ad0>] ? flush_delayed_work+0x50/0x50
  [<ffffffff810a68fb>] kthread+0xcb/0xf0
  [<ffffffff816ec49a>] ? __schedule+0x24a/0x810
  [<ffffffff816ec49a>] ? __schedule+0x24a/0x810
  [<ffffffff810a6830>] ? kthread_create_on_node+0x180/0x180
  [<ffffffff816f25a7>] ret_from_fork+0x47/0x90
  [<ffffffff810a6830>] ? kthread_create_on_node+0x180/0x180

The ownership rule is once the request is on the list, ownership transfers
to the list and the local thread can't touch it any more, just like for
the normal MAD case in send_mad().

Thus, instead of adding before send and then trying to delete after on
errors, move the entire thing under the spinlock so that the send and
update of the lists are atomic to the conurrent threads. Lightly reoganize
things so spinlock safe memory allocations are done in the final NL send
path and the rest of the setup work is done before and outside the lock.

Fixes: 3ebd2fd0d011 ("IB/sa: Put netlink request into the request list before sending")
Link: https://lore.kernel.org/r/1592964789-14533-1-git-send-email-divya.indi@oracle.com
Signed-off-by: Divya Indi <divya.indi@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/sa_query.c | 38 +++++++++++++-----------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 74e0058fcf9e1..0c14ab2244d47 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -829,13 +829,20 @@ static int ib_nl_get_path_rec_attrs_len(ib_sa_comp_mask comp_mask)
 	return len;
 }
 
-static int ib_nl_send_msg(struct ib_sa_query *query, gfp_t gfp_mask)
+static int ib_nl_make_request(struct ib_sa_query *query, gfp_t gfp_mask)
 {
 	struct sk_buff *skb = NULL;
 	struct nlmsghdr *nlh;
 	void *data;
 	struct ib_sa_mad *mad;
 	int len;
+	unsigned long flags;
+	unsigned long delay;
+	gfp_t gfp_flag;
+	int ret;
+
+	INIT_LIST_HEAD(&query->list);
+	query->seq = (u32)atomic_inc_return(&ib_nl_sa_request_seq);
 
 	mad = query->mad_buf->mad;
 	len = ib_nl_get_path_rec_attrs_len(mad->sa_hdr.comp_mask);
@@ -860,36 +867,25 @@ static int ib_nl_send_msg(struct ib_sa_query *query, gfp_t gfp_mask)
 	/* Repair the nlmsg header length */
 	nlmsg_end(skb, nlh);
 
-	return rdma_nl_multicast(&init_net, skb, RDMA_NL_GROUP_LS, gfp_mask);
-}
+	gfp_flag = ((gfp_mask & GFP_ATOMIC) == GFP_ATOMIC) ? GFP_ATOMIC :
+		GFP_NOWAIT;
 
-static int ib_nl_make_request(struct ib_sa_query *query, gfp_t gfp_mask)
-{
-	unsigned long flags;
-	unsigned long delay;
-	int ret;
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	ret = rdma_nl_multicast(&init_net, skb, RDMA_NL_GROUP_LS, gfp_flag);
 
-	INIT_LIST_HEAD(&query->list);
-	query->seq = (u32)atomic_inc_return(&ib_nl_sa_request_seq);
+	if (ret)
+		goto out;
 
-	/* Put the request on the list first.*/
-	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	/* Put the request on the list.*/
 	delay = msecs_to_jiffies(sa_local_svc_timeout_ms);
 	query->timeout = delay + jiffies;
 	list_add_tail(&query->list, &ib_nl_request_list);
 	/* Start the timeout if this is the only request */
 	if (ib_nl_request_list.next == &query->list)
 		queue_delayed_work(ib_nl_wq, &ib_nl_timed_work, delay);
-	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
 
-	ret = ib_nl_send_msg(query, gfp_mask);
-	if (ret) {
-		ret = -EIO;
-		/* Remove the request */
-		spin_lock_irqsave(&ib_nl_request_lock, flags);
-		list_del(&query->list);
-		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
-	}
+out:
+	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
 
 	return ret;
 }
-- 
2.25.1



