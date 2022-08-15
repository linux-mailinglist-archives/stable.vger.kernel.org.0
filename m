Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41985943B0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348393AbiHOWad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348287AbiHOWYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:24:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63759125D73;
        Mon, 15 Aug 2022 12:44:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F724B80EAB;
        Mon, 15 Aug 2022 19:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E440CC433C1;
        Mon, 15 Aug 2022 19:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592658;
        bh=sWem4P/NPWh3xaM32TtZWFwItHMbGgeKGUW+8VSoeHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBJSlpB9CC2IdruCRC4QImZVt3fYWMqmlbZlEXVph1i2w5f9FiffLSqCGMgJSVMnm
         +tPjF2i6MDWYQJWSM4NcEqtySImO+nPPR6MUdi58q+fRx1Bv5jcIHA2rUrQKTRlk+c
         TRJr/uVPN+mLmLYTWV64lrehVodWw6MCmwzpOXE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.19 0144/1157] netfilter: nf_tables: disallow jump to implicit chain from set element
Date:   Mon, 15 Aug 2022 19:51:40 +0200
Message-Id: <20220815180445.395122647@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

commit f323ef3a0d49e147365284bc1f02212e617b7f09 upstream.

Extend struct nft_data_desc to add a flag field that specifies
nft_data_init() is being called for set element data.

Use it to disallow jump to implicit chain from set element, only jump
to chain via immediate expression is allowed.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    5 +++++
 net/netfilter/nf_tables_api.c     |    4 ++++
 2 files changed, 9 insertions(+)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -206,10 +206,15 @@ struct nft_ctx {
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
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5226,6 +5226,7 @@ static int nft_setelem_parse_data(struct
 	desc->type = dtype;
 	desc->size = NFT_DATA_VALUE_MAXLEN;
 	desc->len = set->dlen;
+	desc->flags = NFT_DATA_DESC_SETELEM;
 
 	return nft_data_init(ctx, data, desc, attr);
 }
@@ -9611,6 +9612,9 @@ static int nft_verdict_init(const struct
 			return PTR_ERR(chain);
 		if (nft_is_base_chain(chain))
 			return -EOPNOTSUPP;
+		if (desc->flags & NFT_DATA_DESC_SETELEM &&
+		    chain->flags & NFT_CHAIN_BINDING)
+			return -EINVAL;
 
 		chain->use++;
 		data->verdict.chain = chain;


