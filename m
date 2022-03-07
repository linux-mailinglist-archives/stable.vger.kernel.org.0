Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA23D4CFA3E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239029AbiCGKMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242538AbiCGKLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7229F8B6F9;
        Mon,  7 Mar 2022 01:55:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76BA8B810BC;
        Mon,  7 Mar 2022 09:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8E4C340E9;
        Mon,  7 Mar 2022 09:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646919;
        bh=qj+6Zq47nzRvlAhK7B+0w7NYRpn+RlKjgo26dVjP3W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gB4YHGt/f9+TLSewfcoqjbc14ajnP4IXwo2DnM8De1o7qRnuSi4c4TAGGM8bTtFiJ
         CQAo2B3W6f5VbHWjqD4KKmIrdBQtRxkoGqC+fbOLpNUJctjbfPCIGgkAgOuWrL+zMs
         zS9JSCzwB05J+kb9aYGV4qxQnspKMqcnm5sLbE/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 134/186] netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant
Date:   Mon,  7 Mar 2022 10:19:32 +0100
Message-Id: <20220307091657.825344155@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ae089831ff28a115908b8d796f667c2dadef1637 ]

While kfree_rcu(ptr) _is_ supported, it has some limitations.

Given that 99.99% of kfree_rcu() users [1] use the legacy
two parameters variant, and @catchall objects do have an rcu head,
simply use it.

Choice of kfree_rcu(ptr) variant was probably not intentional.

[1] including calls from net/netfilter/nf_tables_api.c

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a65b530975f5..2b2e0210a7f9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4486,7 +4486,7 @@ static void nft_set_catchall_destroy(const struct nft_ctx *ctx,
 	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
 		list_del_rcu(&catchall->list);
 		nft_set_elem_destroy(set, catchall->elem, true);
-		kfree_rcu(catchall);
+		kfree_rcu(catchall, rcu);
 	}
 }
 
@@ -5653,7 +5653,7 @@ static void nft_setelem_catchall_remove(const struct net *net,
 	list_for_each_entry_safe(catchall, next, &set->catchall_list, list) {
 		if (catchall->elem == elem->priv) {
 			list_del_rcu(&catchall->list);
-			kfree_rcu(catchall);
+			kfree_rcu(catchall, rcu);
 			break;
 		}
 	}
-- 
2.34.1



