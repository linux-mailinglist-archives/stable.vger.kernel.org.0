Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E09259BFB9
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233652AbiHVMvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbiHVMvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:51:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D454E2E9CA
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7351861147
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 12:51:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F20C433D7;
        Mon, 22 Aug 2022 12:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661172682;
        bh=BNTdpYAOW+XAoKSpgB1AcMvsfCYINzo15/tixnTZhvY=;
        h=Subject:To:Cc:From:Date:From;
        b=axxc9p4ZFJ/SbUWZTW0T9kvPc2ojWM/maOOgEz6hFLWPfv1Cysmfy9zjsICXAthyR
         hqZ+eH6+/xq0xp+QSnfaxuIjk+gvotBePDKNhlUt0Mj+fBZvF5ovbzdQHn9Ue6opnq
         fkTwoKI+SL9eeR6pggvkP/3hw7A9+MWmC5Nd8+5M=
Subject: FAILED: patch "[PATCH] netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on" failed to apply to 4.14-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 14:51:09 +0200
Message-ID: <1661172669236209@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5a2f3dc31811e93be15522d9eb13ed61460b76c8 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 12 Aug 2022 16:19:23 +0200
Subject: [PATCH] netfilter: nf_tables: validate NFTA_SET_ELEM_OBJREF based on
 NFT_SET_OBJECT flag

If the NFTA_SET_ELEM_OBJREF netlink attribute is present and
NFT_SET_OBJECT flag is set on, report EINVAL.

Move existing sanity check earlier to validate that NFT_SET_OBJECT
requires NFTA_SET_ELEM_OBJREF.

Fixes: 8aeff920dcc9 ("netfilter: nf_tables: add stateful object reference to set elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1b9459a364ba..bcfe8120e014 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5894,6 +5894,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return -EINVAL;
 	}
 
+	if (set->flags & NFT_SET_OBJECT) {
+		if (!nla[NFTA_SET_ELEM_OBJREF] &&
+		    !(flags & NFT_SET_ELEM_INTERVAL_END))
+			return -EINVAL;
+	} else {
+		if (nla[NFTA_SET_ELEM_OBJREF])
+			return -EINVAL;
+	}
+
 	if ((flags & NFT_SET_ELEM_INTERVAL_END) &&
 	     (nla[NFTA_SET_ELEM_DATA] ||
 	      nla[NFTA_SET_ELEM_OBJREF] ||
@@ -6032,10 +6041,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
-		if (!(set->flags & NFT_SET_OBJECT)) {
-			err = -EINVAL;
-			goto err_parse_key_end;
-		}
 		obj = nft_obj_lookup(ctx->net, ctx->table,
 				     nla[NFTA_SET_ELEM_OBJREF],
 				     set->objtype, genmask);

