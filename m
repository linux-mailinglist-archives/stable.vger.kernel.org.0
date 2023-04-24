Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26D676ECE29
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjDXN34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbjDXN3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:29:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4676E8F
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:29:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAC5862322
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD43EC433EF;
        Mon, 24 Apr 2023 13:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342964;
        bh=GWbofcBYotdY4oby4aCzbMJnTAYFD3xvuCeiXXOdGeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnS+8wuhCS+E/abslCuv7h8/PwWwm7Po565CghEWGnTehqAbeJxgnLBFolHR2+AIs
         WNATM5OmEK/RhsD3XvwoIxp9xlutQ7lCOLA4QOunHoosl+EtvyqMNlnVuMynWVeOV1
         Jqxk1l9+ZT5bXr8IBllG04UePRcNKDaj6fJZOZ6A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 025/110] netfilter: nf_tables: tighten netlink attribute requirements for catch-all elements
Date:   Mon, 24 Apr 2023 15:16:47 +0200
Message-Id: <20230424131137.077241688@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit d4eb7e39929a3b1ff30fb751b4859fc2410702a0 ]

If NFT_SET_ELEM_CATCHALL is set on, then userspace provides no set element
key. Otherwise, bail out with -EINVAL.

Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 94ad50ac91602..ce8a047ef8306 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6088,7 +6088,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
-	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
+	if (((flags & NFT_SET_ELEM_CATCHALL) && nla[NFTA_SET_ELEM_KEY]) ||
+	    (!(flags & NFT_SET_ELEM_CATCHALL) && !nla[NFTA_SET_ELEM_KEY]))
 		return -EINVAL;
 
 	if (flags != 0) {
-- 
2.39.2



