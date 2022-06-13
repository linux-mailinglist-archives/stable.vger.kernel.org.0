Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CB9549476
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357392AbiFMNCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:02:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358394AbiFMNAJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:00:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D80635DE3;
        Mon, 13 Jun 2022 04:18:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCA5C60B6B;
        Mon, 13 Jun 2022 11:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB13C34114;
        Mon, 13 Jun 2022 11:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119081;
        bh=tFd6vRnzTblSZJjJSTJSRhOuRJ6Nhzgy75wAP5XxB6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ErMS3D1+FZFo0YVs0TAqtJKWjRUe2AnO6qXIY5J62ewtT5+x8Tl681spyv3ySx7Qn
         KvLGAzGRoaVox1BDTrLiR7bSdzrYqfzQ3h1HSQvIPV9krKhrPnaJpAlfuL8eN4OTNH
         bgzUNDYBX0tazH4MuRK/bb8cJY1FV6pdHr9sJ71w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/247] netfilter: nf_tables: use kfree_rcu(ptr, rcu) to release hooks in clean_net path
Date:   Mon, 13 Jun 2022 12:10:35 +0200
Message-Id: <20220613094926.994030250@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit ab5e5c062f67c5ae8cd07f0632ffa62dc0e7d169 ]

Use kfree_rcu(ptr, rcu) variant instead as described by ae089831ff28
("netfilter: nf_tables: prefer kfree_rcu(ptr, rcu) variant").

Fixes: f9a43007d3f7 ("netfilter: nf_tables: double hook unregistration in netns path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 79e8fc687fdd..5833fe17be43 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7231,7 +7231,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 		nf_unregister_net_hook(net, &hook->ops);
 		if (release_netdev) {
 			list_del(&hook->list);
-			kfree_rcu(hook);
+			kfree_rcu(hook, rcu);
 		}
 	}
 }
-- 
2.35.1



