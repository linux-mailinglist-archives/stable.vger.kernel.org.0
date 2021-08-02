Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB5D3DD98E
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234935AbhHBOBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236439AbhHBN7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9473A61103;
        Mon,  2 Aug 2021 13:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912544;
        bh=tpqwPqZ4e4cMpqo6fbr9lU4eU/UzFrEs1TWJjKcclAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EXtSmybiEDNCbZHvk5HG1UZl6pi5OY9+HdMPmjWPu/baoWWW/YlJAicPew79vbAXo
         BcibTajbmzIJgoQgWR2mieRTZWO8NDR79UNZbY71vLgW/pOH//kRl4abqYN8DXX3FY
         wTI3cdfwzGZk7lecenH68oklmAFs1aY8PkslbF4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        kernel test robot <lkp@intel.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 040/104] netfilter: nf_tables: fix audit memory leak in nf_tables_commit
Date:   Mon,  2 Aug 2021 15:44:37 +0200
Message-Id: <20210802134345.336233969@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit cfbe3650dd3ef2ea9a4420ca89d9a4df98af3fb6 ]

In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
free the adp variable.

Fix this by adding nf_tables_commit_audit_free which frees
the linked list with the head node adl.

backtrace:
  kmalloc include/linux/slab.h:591 [inline]
  kzalloc include/linux/slab.h:721 [inline]
  nf_tables_commit_audit_alloc net/netfilter/nf_tables_api.c:8439 [inline]
  nf_tables_commit+0x16e/0x1760 net/netfilter/nf_tables_api.c:8508
  nfnetlink_rcv_batch+0x512/0xa80 net/netfilter/nfnetlink.c:562
  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:634 [inline]
  nfnetlink_rcv+0x1fa/0x220 net/netfilter/nfnetlink.c:652
  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
  netlink_unicast+0x2c7/0x3e0 net/netlink/af_netlink.c:1340
  netlink_sendmsg+0x36b/0x6b0 net/netlink/af_netlink.c:1929
  sock_sendmsg_nosec net/socket.c:702 [inline]
  sock_sendmsg+0x56/0x80 net/socket.c:722

Reported-by: syzbot <syzkaller@googlegroups.com>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: c520292f29b8 ("audit: log nftables configuration change events once per table")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a5db7c59ad4e..7512bb819dff 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8479,6 +8479,16 @@ static int nf_tables_commit_audit_alloc(struct list_head *adl,
 	return 0;
 }
 
+static void nf_tables_commit_audit_free(struct list_head *adl)
+{
+	struct nft_audit_data *adp, *adn;
+
+	list_for_each_entry_safe(adp, adn, adl, list) {
+		list_del(&adp->list);
+		kfree(adp);
+	}
+}
+
 static void nf_tables_commit_audit_collect(struct list_head *adl,
 					   struct nft_table *table, u32 op)
 {
@@ -8543,6 +8553,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		ret = nf_tables_commit_audit_alloc(&adl, trans->ctx.table);
 		if (ret) {
 			nf_tables_commit_chain_prepare_cancel(net);
+			nf_tables_commit_audit_free(&adl);
 			return ret;
 		}
 		if (trans->msg_type == NFT_MSG_NEWRULE ||
@@ -8552,6 +8563,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			ret = nf_tables_commit_chain_prepare(net, chain);
 			if (ret < 0) {
 				nf_tables_commit_chain_prepare_cancel(net);
+				nf_tables_commit_audit_free(&adl);
 				return ret;
 			}
 		}
-- 
2.30.2



