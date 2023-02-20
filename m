Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3A969CDBB
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjBTNwV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjBTNwU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:52:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5000E1E5F7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:52:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B96CCB80D44
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB73C433D2;
        Mon, 20 Feb 2023 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901129;
        bh=MwXDZzxAASX98Dz6VPm5my0X8jztwAeHzKpv4LQ+prY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1znUPKCH/NjsCsI5IP4FJ7MykS4lnCgUCSPjh/4BjmpoGMdDHYX0Dnn/G3Q6GKBt
         AXxFFzwN+AGoqW70s5ayqRntMLbGm3O/uohGpZY8DWW+9Lhpba++bpSfNHsMi4TtKC
         cYqzrqiSHGW2U/ghObLp59vHuVuIxACfBdaHxQE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shell Chen <xierch@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Qingfang DENG <dqfext@gmail.com>
Subject: [PATCH 5.15 41/83] netfilter: nft_tproxy: restrict to prerouting hook
Date:   Mon, 20 Feb 2023 14:36:14 +0100
Message-Id: <20230220133555.100693724@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit 18bbc3213383a82b05383827f4b1b882e3f0a5a5 upstream.

TPROXY is only allowed from prerouting, but nft_tproxy doesn't check this.
This fixes a crash (null dereference) when using tproxy from e.g. output.

Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Reported-by: Shell Chen <xierch@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Qingfang DENG <dqfext@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_tproxy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -312,6 +312,13 @@ static int nft_tproxy_dump(struct sk_buf
 	return 0;
 }
 
+static int nft_tproxy_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, 1 << NF_INET_PRE_ROUTING);
+}
+
 static struct nft_expr_type nft_tproxy_type;
 static const struct nft_expr_ops nft_tproxy_ops = {
 	.type		= &nft_tproxy_type,
@@ -320,6 +327,7 @@ static const struct nft_expr_ops nft_tpr
 	.init		= nft_tproxy_init,
 	.destroy	= nft_tproxy_destroy,
 	.dump		= nft_tproxy_dump,
+	.validate	= nft_tproxy_validate,
 };
 
 static struct nft_expr_type nft_tproxy_type __read_mostly = {


