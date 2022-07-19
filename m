Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A96579E07
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242320AbiGSM5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242317AbiGSM4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:56:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A325C951;
        Tue, 19 Jul 2022 05:22:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1969618CF;
        Tue, 19 Jul 2022 12:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABD5C341C6;
        Tue, 19 Jul 2022 12:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233359;
        bh=TxSvIfCPAWAUFoR92x9f5Kk9Nbz45mlHnmPjtMhuEKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVUogf3i5tJd8UEo7qnZ1TJ7qqvLThrKRCUeo8p7YGwTTSkFHDtbzEZEB8vUPuaT8
         xuJKZ/o/E+ujWDgJhrXyU6ZtvGkeweTwu5sgfis8JsA8FGAvGNmVbIRBtnAAA26JC5
         noxnwn+LSCo+IvQfZBOnSS1wYG43uByzfShJ1+bY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 088/231] netfilter: nf_tables: replace BUG_ON by element length check
Date:   Tue, 19 Jul 2022 13:52:53 +0200
Message-Id: <20220719114722.184024484@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c39ba4de6b0a843bec5d46c2b6f2064428dada5e ]

BUG_ON can be triggered from userspace with an element with a large
userdata area. Replace it by length check and return EINVAL instead.
Over time extensions have been growing in size.

Pick a sufficiently old Fixes: tag to propagate this fix.

Fixes: 7d7402642eaf ("netfilter: nf_tables: variable sized set element keys / data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |   14 ++++---
 net/netfilter/nf_tables_api.c     |   72 ++++++++++++++++++++++++++------------
 2 files changed, 60 insertions(+), 26 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -657,18 +657,22 @@ static inline void nft_set_ext_prepare(s
 	tmpl->len = sizeof(struct nft_set_ext);
 }
 
-static inline void nft_set_ext_add_length(struct nft_set_ext_tmpl *tmpl, u8 id,
-					  unsigned int len)
+static inline int nft_set_ext_add_length(struct nft_set_ext_tmpl *tmpl, u8 id,
+					 unsigned int len)
 {
 	tmpl->len	 = ALIGN(tmpl->len, nft_set_ext_types[id].align);
-	BUG_ON(tmpl->len > U8_MAX);
+	if (tmpl->len > U8_MAX)
+		return -EINVAL;
+
 	tmpl->offset[id] = tmpl->len;
 	tmpl->len	+= nft_set_ext_types[id].len + len;
+
+	return 0;
 }
 
-static inline void nft_set_ext_add(struct nft_set_ext_tmpl *tmpl, u8 id)
+static inline int nft_set_ext_add(struct nft_set_ext_tmpl *tmpl, u8 id)
 {
-	nft_set_ext_add_length(tmpl, id, 0);
+	return nft_set_ext_add_length(tmpl, id, 0);
 }
 
 static inline void nft_set_ext_init(struct nft_set_ext *ext,
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5831,8 +5831,11 @@ static int nft_add_set_elem(struct nft_c
 	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
 		return -EINVAL;
 
-	if (flags != 0)
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+	if (flags != 0) {
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+		if (err < 0)
+			return err;
+	}
 
 	if (set->flags & NFT_SET_MAP) {
 		if (nla[NFTA_SET_ELEM_DATA] == NULL &&
@@ -5941,7 +5944,9 @@ static int nft_add_set_elem(struct nft_c
 		if (err < 0)
 			goto err_set_elem_expr;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		if (err < 0)
+			goto err_parse_key;
 	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
@@ -5950,22 +5955,31 @@ static int nft_add_set_elem(struct nft_c
 		if (err < 0)
 			goto err_parse_key;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (timeout > 0) {
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
-		if (timeout != set->timeout)
-			nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
+		if (err < 0)
+			goto err_parse_key_end;
+
+		if (timeout != set->timeout) {
+			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
+			if (err < 0)
+				goto err_parse_key_end;
+		}
 	}
 
 	if (num_exprs) {
 		for (i = 0; i < num_exprs; i++)
 			size += expr_array[i]->ops->size;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPRESSIONS,
-				       sizeof(struct nft_set_elem_expr) +
-				       size);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPRESSIONS,
+					     sizeof(struct nft_set_elem_expr) + size);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
@@ -5980,7 +5994,9 @@ static int nft_add_set_elem(struct nft_c
 			err = PTR_ERR(obj);
 			goto err_parse_key_end;
 		}
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
@@ -6014,7 +6030,9 @@ static int nft_add_set_elem(struct nft_c
 							  NFT_VALIDATE_NEED);
 		}
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
+		if (err < 0)
+			goto err_parse_data;
 	}
 
 	/* The full maximum length of userdata can exceed the maximum
@@ -6024,9 +6042,12 @@ static int nft_add_set_elem(struct nft_c
 	ulen = 0;
 	if (nla[NFTA_SET_ELEM_USERDATA] != NULL) {
 		ulen = nla_len(nla[NFTA_SET_ELEM_USERDATA]);
-		if (ulen > 0)
-			nft_set_ext_add_length(&tmpl, NFT_SET_EXT_USERDATA,
-					       ulen);
+		if (ulen > 0) {
+			err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_USERDATA,
+						     ulen);
+			if (err < 0)
+				goto err_parse_data;
+		}
 	}
 
 	err = -ENOMEM;
@@ -6252,8 +6273,11 @@ static int nft_del_setelem(struct nft_ct
 
 	nft_set_ext_prepare(&tmpl);
 
-	if (flags != 0)
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+	if (flags != 0) {
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+		if (err < 0)
+			return err;
+	}
 
 	if (nla[NFTA_SET_ELEM_KEY]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key.val,
@@ -6261,16 +6285,20 @@ static int nft_del_setelem(struct nft_ct
 		if (err < 0)
 			return err;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		if (err < 0)
+			goto fail_elem;
 	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
 					    nla[NFTA_SET_ELEM_KEY_END]);
 		if (err < 0)
-			return err;
+			goto fail_elem;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		if (err < 0)
+			goto fail_elem_key_end;
 	}
 
 	err = -ENOMEM;
@@ -6278,7 +6306,7 @@ static int nft_del_setelem(struct nft_ct
 				      elem.key_end.val.data, NULL, 0, 0,
 				      GFP_KERNEL_ACCOUNT);
 	if (elem.priv == NULL)
-		goto fail_elem;
+		goto fail_elem_key_end;
 
 	ext = nft_set_elem_ext(set, elem.priv);
 	if (flags)
@@ -6302,6 +6330,8 @@ fail_ops:
 	kfree(trans);
 fail_trans:
 	kfree(elem.priv);
+fail_elem_key_end:
+	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
 fail_elem:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 	return err;


