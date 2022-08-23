Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B6D59DA12
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347955AbiHWKEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352777AbiHWKC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:02:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA557CA81;
        Tue, 23 Aug 2022 01:50:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 832A261386;
        Tue, 23 Aug 2022 08:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B80C433C1;
        Tue, 23 Aug 2022 08:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244653;
        bh=ucounPu0KryIe7wNIefBEZb4RTNpVTXgbubzAfyvxXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsKhDv3AUzB1DWvrfZPUaVCB5FfB0MNn1sGl7c2ucABHUYWAUe2EmPsniAyTqW+S1
         meVYiQalvTMN8CMKABnFjCQ1ab2xaJIGt/loomXd+xowu/1NQvI3QxPZfIMu5u7F2b
         eB81xdIhQAAwWrapVKZLSxsoeJiKhtutMtQA2X7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 129/244] netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags
Date:   Tue, 23 Aug 2022 10:24:48 +0200
Message-Id: <20220823080103.408525094@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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

commit 88cccd908d51397f9754f89a937cd13fa59dee37 upstream.

If the NFT_SET_CONCAT|NFT_SET_INTERVAL flags are set on, then the
netlink attribute NFTA_SET_ELEM_KEY_END must be specified. Otherwise,
NFTA_SET_ELEM_KEY_END should not be present.

For catch-all element, NFTA_SET_ELEM_KEY_END should not be present.
The NFT_SET_ELEM_INTERVAL_END is never used with this set flags
combination.

Fixes: 7b225d0b5c6d ("netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5711,6 +5711,24 @@ static void nft_setelem_remove(const str
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
@@ -5770,6 +5788,9 @@ static int nft_add_set_elem(struct nft_c
 			return -EINVAL;
 	}
 
+	if (!nft_setelem_valid_key_end(set, nla, flags))
+		return -EINVAL;
+
 	if ((flags & NFT_SET_ELEM_INTERVAL_END) &&
 	     (nla[NFTA_SET_ELEM_DATA] ||
 	      nla[NFTA_SET_ELEM_OBJREF] ||
@@ -6192,6 +6213,9 @@ static int nft_del_setelem(struct nft_ct
 	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
 		return -EINVAL;
 
+	if (!nft_setelem_valid_key_end(set, nla, flags))
+		return -EINVAL;
+
 	nft_set_ext_prepare(&tmpl);
 
 	if (flags != 0) {


