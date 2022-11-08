Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F002562145B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbiKHOA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234923AbiKHOAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:00:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6423623B6
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 739A3615B3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA13C433D6;
        Tue,  8 Nov 2022 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916013;
        bh=khwbRxXbb7pT3tKUtownAvzFLULUPVoqFKZPBYqRJDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5bgRRyKF7sW5UjB6EIM42OeQKIaPPW3u7+dN1VY2BeJdMZe9lfJWr7jNB+F85CCI
         mFh7/OPW9CgjknAK8j7Jfw/fCFoTPywZZ/k1xdGTiXc4PUVySstDYc/s20vt9ZT5dh
         eHvZf4UibFNrhexE+mgHxA0n03zuy/p40vV4WYi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/144] netfilter: nf_tables: release flow rule object from commit path
Date:   Tue,  8 Nov 2022 14:38:34 +0100
Message-Id: <20221108133346.848205949@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 26b5934ff4194e13196bedcba373cd4915071d0e ]

No need to postpone this to the commit release path, since no packets
are walking over this object, this is accessed from control plane only.
This helped uncovered UAF triggered by races with the netlink notifier.

Fixes: 9dd732e0bdf5 ("netfilter: nf_tables: memleak flow rule from commit path")
Reported-by: syzbot+8f747f62763bc6c32916@syzkaller.appspotmail.com
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8cd11a7e5a3e..899f01c6c26c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8308,9 +8308,6 @@ static void nft_commit_release(struct nft_trans *trans)
 		nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELRULE:
-		if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
-			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
-
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_DELSET:
@@ -8767,6 +8764,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nft_rule_expr_deactivate(&trans->ctx,
 						 nft_trans_rule(trans),
 						 NFT_TRANS_COMMIT);
+
+			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_NEWSET:
 			nft_clear(net, nft_trans_set(trans));
-- 
2.35.1



