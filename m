Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF16D6C1697
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjCTPHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjCTPHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:07:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FF4618E
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:02:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A51C6157F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:02:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0E6C4339B;
        Mon, 20 Mar 2023 15:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324527;
        bh=Ug95ZF0Sr8/9AE2AGsfhk48LZ7cuIuVOz2j+Cl097bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ArK/H2Ub+EANniGvclwUemSJUKNQxPE/xzuFaxtbRFwICknN6iGgd0V7JnIi6Yy7N
         nKJ1tA9dP63l406nRBUdGsp6wqLZgwmcmHK+1zXLVb6b1lAViR3/4iEiDK9Yi7XyNo
         grrZHVzPMLxijGNwoDcokvzwzqA/IlIUFRaus6K4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jeremy Sowden <jeremy@azazel.net>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/99] netfilter: nft_redir: correct value of inet type `.maxattrs`
Date:   Mon, 20 Mar 2023 15:53:50 +0100
Message-Id: <20230320145443.863459008@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 493924519b1fe3faab13ee621a43b0d0939abab1 ]

`nft_redir_inet_type.maxattrs` was being set, presumably because of a
cut-and-paste error, to `NFTA_MASQ_MAX`, instead of `NFTA_REDIR_MAX`.

Fixes: 63ce3940f3ab ("netfilter: nft_redir: add inet support")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_redir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index deb7e65c8d82b..e64f531d66cfc 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -232,7 +232,7 @@ static struct nft_expr_type nft_redir_inet_type __read_mostly = {
 	.name		= "redir",
 	.ops		= &nft_redir_inet_ops,
 	.policy		= nft_redir_policy,
-	.maxattr	= NFTA_MASQ_MAX,
+	.maxattr	= NFTA_REDIR_MAX,
 	.owner		= THIS_MODULE,
 };
 
-- 
2.39.2



