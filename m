Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941BE5498D8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383733AbiFMO1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384043AbiFMOYh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8018DF02;
        Mon, 13 Jun 2022 04:46:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14F2EB80EB2;
        Mon, 13 Jun 2022 11:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B210C34114;
        Mon, 13 Jun 2022 11:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120793;
        bh=uVB12VocQsbE+gPRI6s6gOgZctIrY/JOq64olD7xgiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0HfG+hFjbTkGKRLXSCc+0S4PNK6MjFF38C0WBPrKQrDePkECLtRX1pRHSLAOQnCB6
         1Lv8TIe+yCF639BAOqOWq01cpjwL3WnL/cG5Rp/lPz6Cz34vWkPdflTTa1/Li2UMeN
         +HPnNKMt7OBbtbRlfiNdkzXrRx0gOOPn/A8zxbHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 159/298] netfilter: nf_tables: use kfree_rcu(ptr, rcu) to release hooks in clean_net path
Date:   Mon, 13 Jun 2022 12:10:53 +0200
Message-Id: <20220613094929.758594341@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index 42cc703a68e5..07c842b65f6d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7247,7 +7247,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
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



