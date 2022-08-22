Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC3859C034
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 15:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbiHVNJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 09:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231960AbiHVNJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 09:09:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D751140F1
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED63F61168
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 13:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16B5C433C1;
        Mon, 22 Aug 2022 13:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661173783;
        bh=H0X0Fd3jgtAchSLi0/5M1fU3UOM3BV3wQrhIZryuKBc=;
        h=Subject:To:Cc:From:Date:From;
        b=iESXN4sGApqu3Hk84RO1o9ULOyBqDZ3ohtFlE7REue+x+F3YOQMsgGo+kXR/9MWPe
         4mutfr6HBKVjMU2Jn5MTbAcaiwa/IIm80Tq/ril1bu3H2fgh1G0GHqXFgb5C+Otai8
         gBfJzFd2J0y5WBEUIzymm/Kih9tbz4/wyrGhZKEA=
Subject: FAILED: patch "[PATCH] netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat" failed to apply to 5.10-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 15:09:40 +0200
Message-ID: <1661173780154125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 88cccd908d51397f9754f89a937cd13fa59dee37 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 12 Aug 2022 16:21:28 +0200
Subject: [PATCH] netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat
 and interval flags

If the NFT_SET_CONCAT|NFT_SET_INTERVAL flags are set on, then the
netlink attribute NFTA_SET_ELEM_KEY_END must be specified. Otherwise,
NFTA_SET_ELEM_KEY_END should not be present.

For catch-all element, NFTA_SET_ELEM_KEY_END should not be present.
The NFT_SET_ELEM_INTERVAL_END is never used with this set flags
combination.

Fixes: 7b225d0b5c6d ("netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bcfe8120e014..1d14d694f654 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5844,6 +5844,24 @@ static void nft_setelem_remove(const struct net *net,
 		set->ops->remove(net, set, elem);
 }
 
+static bool nft_setelem_valid_key_end(const struct nft_set *set,
+				      struct nlattr **nla, u32 flags)
+{
+	if ((set->flags & (NFT_SET_CONCAT | NFT_SET_INTERVAL)) ==
+			  (NFT_SET_CONCAT | NFT_SET_INTERVAL)) {
+		if (flags & NFT_SET_ELEM_INTERVAL_END)
+			return false;
+		if (!nla[NFTA_SET_ELEM_KEY_END] &&
+		    !(flags & NFT_SET_ELEM_CATCHALL))
+			return false;
+	} else {
+		if (nla[NFTA_SET_ELEM_KEY_END])
+			return false;
+	}
+
+	return true;
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
@@ -5903,6 +5921,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return -EINVAL;
 	}
 
+	if (!nft_setelem_valid_key_end(set, nla, flags))
+		return -EINVAL;
+
 	if ((flags & NFT_SET_ELEM_INTERVAL_END) &&
 	     (nla[NFTA_SET_ELEM_DATA] ||
 	      nla[NFTA_SET_ELEM_OBJREF] ||
@@ -6333,6 +6354,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
 		return -EINVAL;
 
+	if (!nft_setelem_valid_key_end(set, nla, flags))
+		return -EINVAL;
+
 	nft_set_ext_prepare(&tmpl);
 
 	if (flags != 0) {

