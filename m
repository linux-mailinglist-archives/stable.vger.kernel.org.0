Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C1D4CF90A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbiCGKD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238784AbiCGJ44 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:56:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5992D7A997;
        Mon,  7 Mar 2022 01:45:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC44661380;
        Mon,  7 Mar 2022 09:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84AFC340E9;
        Mon,  7 Mar 2022 09:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646351;
        bh=qj+6Zq47nzRvlAhK7B+0w7NYRpn+RlKjgo26dVjP3W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtXiylEk6QyS/JujNylBWHJDwEl7JSlLJfZpHY7YvKZzsjMZMljG3jG5JapdIoTtF
         LJkJSW5mBndC2TD0v3a4haXmWEezVYgtScQRfSlu/Q9Kt1nSv+KQefAnsWnY39hrkZ
         2jnGzzote00AecV7t2OcI45qeURF+AmA6HOkPW/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/262] netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant
Date:   Mon,  7 Mar 2022 10:19:17 +0100
Message-Id: <20220307091708.929533453@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
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



