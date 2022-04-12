Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DDD4FD9E5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377265AbiDLHt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358312AbiDLHlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A93B45AF0;
        Tue, 12 Apr 2022 00:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F01FD616B2;
        Tue, 12 Apr 2022 07:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A45C385A5;
        Tue, 12 Apr 2022 07:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747863;
        bh=elrvW3bnbgmA8t2/Ex3dnVBXPkdDaZXV0P4AvBUOFSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csHy5PLqwFSR3rp75KDz5UWKpxODg8a4zWdrtUV0UnClCYbAeRFBGnUL6BPGYUaSH
         sfmZbY3Y0n9wGmUoZbWnE8zEcShWPCtIl2A+UUO7bCTt/Eez3/Alnq0IhOA6WE+txp
         cbg4Neu4NhJvRzf4VhFnUNkkCGsydZ/tjTFNsfJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Sowden <jeremy@azazel.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 196/343] netfilter: bitwise: fix reduce comparisons
Date:   Tue, 12 Apr 2022 08:30:14 +0200
Message-Id: <20220412062957.013993867@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit 31818213170caa51d116eb5dc1167b88523b4fe1 ]

The `nft_bitwise_reduce` and `nft_bitwise_fast_reduce` functions should
compare the bitwise operation in `expr` with the tracked operation
associated with the destination register of `expr`.  However, instead of
being called on `expr` and `track->regs[priv->dreg].selector`,
`nft_expr_priv` is called on `expr` twice, so both reduce functions
return true even when the operations differ.

Fixes: be5650f8f47e ("netfilter: nft_bitwise: track register operations")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_bitwise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 7b727d3ebf9d..04bd2f89afe8 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -287,7 +287,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	if (!track->regs[priv->sreg].selector)
 		return false;
 
-	bitwise = nft_expr_priv(expr);
+	bitwise = nft_expr_priv(track->regs[priv->dreg].selector);
 	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
 	    track->regs[priv->dreg].bitwise &&
 	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
@@ -434,7 +434,7 @@ static bool nft_bitwise_fast_reduce(struct nft_regs_track *track,
 	if (!track->regs[priv->sreg].selector)
 		return false;
 
-	bitwise = nft_expr_priv(expr);
+	bitwise = nft_expr_priv(track->regs[priv->dreg].selector);
 	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
 	    track->regs[priv->dreg].bitwise &&
 	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
-- 
2.35.1



