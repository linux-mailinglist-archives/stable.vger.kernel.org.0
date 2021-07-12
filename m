Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDBE3C4E58
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244286AbhGLHSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243890AbhGLHRO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:17:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0F20613C7;
        Mon, 12 Jul 2021 07:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074066;
        bh=XaQZ0XQD2eP1yxK53Olecp/BSIHLA/SIbHYYmo0iXsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ymIVjhtpjDPSxmqgAYEa4OZ2MDEJDX8nMzC3cI77q2tZNDVamq28zhLRC/+8IAXj7
         H04Td26bGf9/Mtq7xk08C1HyuqMzNqxAB4FN3SpnXucbvLslyP+YrLD/VSda8srDZJ
         W1IVCLp75pT5HQTV0KwA3/jX2nq05DDj8TfIHYNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 454/700] netfilter: nf_tables: do not allow to delete table with owner by handle
Date:   Mon, 12 Jul 2021 08:08:57 +0200
Message-Id: <20210712061024.851491677@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e31f072ffab0397a328b31a9589dcf9733dc9c72 ]

nft_table_lookup_byhandle() also needs to validate the netlink PortID
owner when deleting a table by handle.

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3705086d43f5..6b79fa357bfe 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -533,14 +533,19 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 
 static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 						   const struct nlattr *nla,
-						   u8 genmask)
+						   u8 genmask, u32 nlpid)
 {
 	struct nft_table *table;
 
 	list_for_each_entry(table, &net->nft.tables, list) {
 		if (be64_to_cpu(nla_get_be64(nla)) == table->handle &&
-		    nft_active_genmask(table, genmask))
+		    nft_active_genmask(table, genmask)) {
+			if (nft_table_has_owner(table) &&
+			    nlpid && table->nlpid != nlpid)
+				return ERR_PTR(-EPERM);
+
 			return table;
+		}
 	}
 
 	return ERR_PTR(-ENOENT);
@@ -1213,7 +1218,8 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 
 	if (nla[NFTA_TABLE_HANDLE]) {
 		attr = nla[NFTA_TABLE_HANDLE];
-		table = nft_table_lookup_byhandle(net, attr, genmask);
+		table = nft_table_lookup_byhandle(net, attr, genmask,
+						  NETLINK_CB(skb).portid);
 	} else {
 		attr = nla[NFTA_TABLE_NAME];
 		table = nft_table_lookup(net, attr, family, genmask,
-- 
2.30.2



