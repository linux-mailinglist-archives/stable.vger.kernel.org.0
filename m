Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 229C7F7DF4
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfKKSyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:54:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730459AbfKKSyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:54:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04CEE21655;
        Mon, 11 Nov 2019 18:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498450;
        bh=Q/XKueGCDyekB63HVaQt7ZV4jBHWEAxlBh37GeUqtNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V9tnhjay80qPJwv69E9Q+EKBJf7KRR9Uh1EUIwjjfTzG5X+ofFrhLuVVKbPlphVdc
         mwFuW/cxAF2NYKbLL5VeZqk5Y9aDkt2pIEC1pKk6xtH2+BR+4J3O47EGv2V9wKKzz0
         KiTX6Uz99Qyh/lag4ruFR7Ag9DCo4/wragEJwv9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 124/193] netfilter: nf_flow_table: set timeout before insertion into hashes
Date:   Mon, 11 Nov 2019 19:28:26 +0100
Message-Id: <20191111181510.332120018@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit daf61b026f4686250e6afa619e6d7b49edc61df7 ]

Other garbage collector might remove an entry not fully set up yet.

[570953.958293] RIP: 0010:memcmp+0x9/0x50
[...]
[570953.958567]  flow_offload_hash_cmp+0x1e/0x30 [nf_flow_table]
[570953.958585]  flow_offload_lookup+0x8c/0x110 [nf_flow_table]
[570953.958606]  nf_flow_offload_ip_hook+0x135/0xb30 [nf_flow_table]
[570953.958624]  nf_flow_offload_inet_hook+0x35/0x37 [nf_flow_table_inet]
[570953.958646]  nf_hook_slow+0x3c/0xb0
[570953.958664]  __netif_receive_skb_core+0x90f/0xb10
[570953.958678]  ? ip_rcv_finish+0x82/0xa0
[570953.958692]  __netif_receive_skb_one_core+0x3b/0x80
[570953.958711]  __netif_receive_skb+0x18/0x60
[570953.958727]  netif_receive_skb_internal+0x45/0xf0
[570953.958741]  napi_gro_receive+0xcd/0xf0
[570953.958764]  ixgbe_clean_rx_irq+0x432/0xe00 [ixgbe]
[570953.958782]  ixgbe_poll+0x27b/0x700 [ixgbe]
[570953.958796]  net_rx_action+0x284/0x3c0
[570953.958817]  __do_softirq+0xcc/0x27c
[570953.959464]  irq_exit+0xe8/0x100
[570953.960097]  do_IRQ+0x59/0xe0
[570953.960734]  common_interrupt+0xf/0xf

Fixes: 43c8f131184f ("netfilter: nf_flow_table: fix missing error check for rhashtable_insert_fast")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index a0b4bf654de2d..4c2f8959de587 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -201,6 +201,8 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
 	int err;
 
+	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
+
 	err = rhashtable_insert_fast(&flow_table->rhashtable,
 				     &flow->tuplehash[0].node,
 				     nf_flow_offload_rhash_params);
@@ -217,7 +219,6 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 		return err;
 	}
 
-	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
-- 
2.20.1



