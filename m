Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA705AAEE8
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbiIBMby (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbiIBMbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:31:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D38E0FEA;
        Fri,  2 Sep 2022 05:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C24EB82A9B;
        Fri,  2 Sep 2022 12:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9D1C433C1;
        Fri,  2 Sep 2022 12:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121469;
        bh=XhSA6i78gRXQyA/gUEzf/4yuSlQlvNRY85EE198trDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4dYrNBggteu2XOwHl8UmJ3QpNS2elrWJqBIZaN4+wwgHQ/wc7mZTe/RcsL0odpq+
         s9eASFWSOVXl/Fcy0mhZRH05ZvxyA4oy5et5v+ej+dWZtH9xZ2G8SHfWcpyXNX9HEY
         U598Yml+ezZGbZVOM2ZGQ73YxPikSgzaNuMnAk64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/56] netfilter: nft_tunnel: restrict it to netdev family
Date:   Fri,  2 Sep 2022 14:18:38 +0200
Message-Id: <20220902121400.805271386@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121400.219861128@linuxfoundation.org>
References: <20220902121400.219861128@linuxfoundation.org>
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
index 8ae948fd9dcfc..3fc55c81f16ac 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -104,6 +104,7 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
 	.name		= "tunnel",
+	.family		= NFPROTO_NETDEV,
 	.ops		= &nft_tunnel_get_ops,
 	.policy		= nft_tunnel_policy,
 	.maxattr	= NFTA_TUNNEL_MAX,
-- 
2.35.1



