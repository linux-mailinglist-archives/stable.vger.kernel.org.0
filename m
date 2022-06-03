Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C801353D02D
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345003AbiFCSBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346326AbiFCSAM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:00:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11980580FB;
        Fri,  3 Jun 2022 10:56:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AD5A2B82189;
        Fri,  3 Jun 2022 17:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A3EC385A9;
        Fri,  3 Jun 2022 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278969;
        bh=aoUjbgcq58r/JunbedBzWXG5Q2u5FFyKsXE1IlujZss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=By2NfNdrHNUfeXeQRmeokeUANEvVk1XIOwqWIhQGYnDqc0AhSEFN9AOCHk7vsS1+J
         PPDLkJVxiV/CUGe2zKILlTyT1Bjp3djjc1po+SIy69k6WZD5EoW23meWTZfk6YY3Z+
         IA58uKwLlyf+PIUGIFG7919Q6FTapkl0YQjTaW7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhangziming.zzm@antgroup.com,
        Stefano Brivio <sbrivio@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.18 11/67] netfilter: nf_tables: sanitize nft_set_desc_concat_parse()
Date:   Fri,  3 Jun 2022 19:43:12 +0200
Message-Id: <20220603173821.057219025@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit fecf31ee395b0295f2d7260aa29946b7605f7c85 upstream.

Add several sanity checks for nft_set_desc_concat_parse():

- validate desc->field_count not larger than desc->field_len array.
- field length cannot be larger than desc->field_len (ie. U8_MAX)
- total length of the concatenation cannot be larger than register array.

Joint work with Florian Westphal.

Fixes: f3a2181e16f1 ("netfilter: nf_tables: Support for sets with multiple ranged fields")
Reported-by: <zhangziming.zzm@antgroup.com>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4246,6 +4246,9 @@ static int nft_set_desc_concat_parse(con
 	u32 len;
 	int err;
 
+	if (desc->field_count >= ARRAY_SIZE(desc->field_len))
+		return -E2BIG;
+
 	err = nla_parse_nested_deprecated(tb, NFTA_SET_FIELD_MAX, attr,
 					  nft_concat_policy, NULL);
 	if (err < 0)
@@ -4255,9 +4258,8 @@ static int nft_set_desc_concat_parse(con
 		return -EINVAL;
 
 	len = ntohl(nla_get_be32(tb[NFTA_SET_FIELD_LEN]));
-
-	if (len * BITS_PER_BYTE / 32 > NFT_REG32_COUNT)
-		return -E2BIG;
+	if (!len || len > U8_MAX)
+		return -EINVAL;
 
 	desc->field_len[desc->field_count++] = len;
 
@@ -4268,7 +4270,8 @@ static int nft_set_desc_concat(struct nf
 			       const struct nlattr *nla)
 {
 	struct nlattr *attr;
-	int rem, err;
+	u32 num_regs = 0;
+	int rem, err, i;
 
 	nla_for_each_nested(attr, nla, rem) {
 		if (nla_type(attr) != NFTA_LIST_ELEM)
@@ -4279,6 +4282,12 @@ static int nft_set_desc_concat(struct nf
 			return err;
 	}
 
+	for (i = 0; i < desc->field_count; i++)
+		num_regs += DIV_ROUND_UP(desc->field_len[i], sizeof(u32));
+
+	if (num_regs > NFT_REG32_COUNT)
+		return -E2BIG;
+
 	return 0;
 }
 


