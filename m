Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316995AAFB7
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbiIBMml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237031AbiIBMls (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:41:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AD3E869C;
        Fri,  2 Sep 2022 05:31:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BCFF620B6;
        Fri,  2 Sep 2022 12:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DBEC433C1;
        Fri,  2 Sep 2022 12:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121760;
        bh=P+jaSS/ABgscCL7bOLfDbwgtwfZD4mI/GtjODIiIDI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yanoOMFn4dFi/Cxec7xHng3g9FSG8EFKrICf2gHm7NwGcyBmctgsFGOoyIu4A6ha+
         3yfQt87+UrIsAMmlkoBD2RcrLBmbNMcu7oQRvix+EUd1W30YwJnTe1Y8ymZf6ekxQ2
         Y0ZNrWB3CtkLVO/tN5WgMU6EW9AMN9oQIdV7xclA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 25/77] netfilter: nft_tunnel: restrict it to netdev family
Date:   Fri,  2 Sep 2022 14:18:34 +0200
Message-Id: <20220902121404.488271284@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 01e4092d53bc4fe122a6e4b6d664adbd57528ca3 ]

Only allow to use this expression from NFPROTO_NETDEV family.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 1effd4878619f..4e850c81ad8d8 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -134,6 +134,7 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
 	.name		= "tunnel",
+	.family		= NFPROTO_NETDEV,
 	.ops		= &nft_tunnel_get_ops,
 	.policy		= nft_tunnel_policy,
 	.maxattr	= NFTA_TUNNEL_MAX,
-- 
2.35.1



