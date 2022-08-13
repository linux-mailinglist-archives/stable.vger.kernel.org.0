Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F88591B45
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 17:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbiHMPO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 11:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239634AbiHMPO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 11:14:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DF213CE6
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 08:14:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A2DCC60EB4
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 15:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA830C433D6;
        Sat, 13 Aug 2022 15:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660403695;
        bh=Cmf6najkGKSEStQ7DktNY6L98Fr9qxN4vJpgnmRg0h4=;
        h=Subject:To:Cc:From:Date:From;
        b=soFt4f4mrX6Qlz1Fqo9DEihqK/Iav2Dsz00+JiexqXuMIfeRDO0tlV7lOug05Gcpb
         hCrtqnkuN5csDR5pJXAos14ZF3FbH2S7tC0do5+KOOJQRBX0mopHTT7JM609Ql27C5
         5zVrYbx5e+JpqCbqDgtdb2e05IKQBW18eb9P1OTs=
Subject: FAILED: patch "[PATCH] netfilter: nf_tables: disallow jump to implicit chain from" failed to apply to 5.15-stable tree
To:     pablo@netfilter.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Aug 2022 17:14:44 +0200
Message-ID: <166040368451168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f323ef3a0d49e147365284bc1f02212e617b7f09 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 8 Aug 2022 19:30:07 +0200
Subject: [PATCH] netfilter: nf_tables: disallow jump to implicit chain from
 set element

Extend struct nft_data_desc to add a flag field that specifies
nft_data_init() is being called for set element data.

Use it to disallow jump to implicit chain from set element, only jump
to chain via immediate expression is allowed.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1554f1e7215b..99aae36c04b9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -221,10 +221,15 @@ struct nft_ctx {
 	bool				report;
 };
 
+enum nft_data_desc_flags {
+	NFT_DATA_DESC_SETELEM	= (1 << 0),
+};
+
 struct nft_data_desc {
 	enum nft_data_types		type;
 	unsigned int			size;
 	unsigned int			len;
+	unsigned int			flags;
 };
 
 int nft_data_init(const struct nft_ctx *ctx, struct nft_data *data,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 05896765c68f..460b0925ea60 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5226,6 +5226,7 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 	desc->type = dtype;
 	desc->size = NFT_DATA_VALUE_MAXLEN;
 	desc->len = set->dlen;
+	desc->flags = NFT_DATA_DESC_SETELEM;
 
 	return nft_data_init(ctx, data, desc, attr);
 }
@@ -9665,6 +9666,9 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 			return PTR_ERR(chain);
 		if (nft_is_base_chain(chain))
 			return -EOPNOTSUPP;
+		if (desc->flags & NFT_DATA_DESC_SETELEM &&
+		    chain->flags & NFT_CHAIN_BINDING)
+			return -EINVAL;
 
 		chain->use++;
 		data->verdict.chain = chain;

