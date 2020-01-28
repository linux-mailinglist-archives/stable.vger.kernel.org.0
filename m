Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A6A14B694
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgA1OGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728234AbgA1OFP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:05:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CD86205F4;
        Tue, 28 Jan 2020 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220315;
        bh=AdAeuX5VP2SyqUHm1TIqwAL6nRijuMWGMN9OphXvM6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3jwBmRQoBreWsjVFgmMi8oqUXnqjqWpe/gHzAYLKgXlsiV5HBTR7BnrptQU5hKqQ
         PfsnhpQyn5OaHsWYdCVP1nmYlMQAHX96tr1B0bMO7sFSOY1jRuENQMkanbqLW7Ieyu
         mQGSsMl+tOoR1ungB0TJULGZtlx79VZKRmB5aYAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 102/104] netfilter: nf_tables: add __nft_chain_type_get()
Date:   Tue, 28 Jan 2020 15:01:03 +0100
Message-Id: <20200128135831.012305689@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 826035498ec14b77b62a44f0cb6b94d45530db6f upstream.

This new helper function validates that unknown family and chain type
coming from userspace do not trigger an out-of-bound array access. Bail
out in case __nft_chain_type_get() returns NULL from
nft_chain_parse_hook().

Fixes: 9370761c56b6 ("netfilter: nf_tables: convert built-in tables/chains to chain types")
Reported-by: syzbot+156a04714799b1d480bc@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_tables_api.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -489,14 +489,27 @@ static inline u64 nf_tables_alloc_handle
 static const struct nft_chain_type *chain_type[NFPROTO_NUMPROTO][NFT_CHAIN_T_MAX];
 
 static const struct nft_chain_type *
+__nft_chain_type_get(u8 family, enum nft_chain_types type)
+{
+	if (family >= NFPROTO_NUMPROTO ||
+	    type >= NFT_CHAIN_T_MAX)
+		return NULL;
+
+	return chain_type[family][type];
+}
+
+static const struct nft_chain_type *
 __nf_tables_chain_type_lookup(const struct nlattr *nla, u8 family)
 {
+	const struct nft_chain_type *type;
 	int i;
 
 	for (i = 0; i < NFT_CHAIN_T_MAX; i++) {
-		if (chain_type[family][i] != NULL &&
-		    !nla_strcmp(nla, chain_type[family][i]->name))
-			return chain_type[family][i];
+		type = __nft_chain_type_get(family, i);
+		if (!type)
+			continue;
+		if (!nla_strcmp(nla, type->name))
+			return type;
 	}
 	return NULL;
 }
@@ -1095,11 +1108,8 @@ static void nf_tables_table_destroy(stru
 
 void nft_register_chain_type(const struct nft_chain_type *ctype)
 {
-	if (WARN_ON(ctype->family >= NFPROTO_NUMPROTO))
-		return;
-
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	if (WARN_ON(chain_type[ctype->family][ctype->type] != NULL)) {
+	if (WARN_ON(__nft_chain_type_get(ctype->family, ctype->type))) {
 		nfnl_unlock(NFNL_SUBSYS_NFTABLES);
 		return;
 	}
@@ -1551,7 +1561,10 @@ static int nft_chain_parse_hook(struct n
 	hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
 	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
-	type = chain_type[family][NFT_CHAIN_T_DEFAULT];
+	type = __nft_chain_type_get(family, NFT_CHAIN_T_DEFAULT);
+	if (!type)
+		return -EOPNOTSUPP;
+
 	if (nla[NFTA_CHAIN_TYPE]) {
 		type = nf_tables_chain_type_lookup(net, nla[NFTA_CHAIN_TYPE],
 						   family, autoload);


