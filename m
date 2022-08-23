Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9C959DA18
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352220AbiHWKEw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348369AbiHWKDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:03:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805CC7C531;
        Tue, 23 Aug 2022 01:51:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A221EB81B90;
        Tue, 23 Aug 2022 08:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9518C433D6;
        Tue, 23 Aug 2022 08:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244669;
        bh=rkS/6bBSHpcEQLoJ0IzZ7yYlpoy/SAcnwtpgo7NGrQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWeeT8w3ZghT/5FnsGOhpkJE7zMaG7nvdjDDYBtjweZGYFT6zhchpFpVJPP91s7Ky
         OD+p8Irz2e2mL6/aswG9j/KMjXjt0c+GYsH/ZKZeDm0jRTdnF1lCiynsUTRpSqxZOo
         sfw4mTARYvEDiV44QzbgR9862GodpG1MfcoqV++w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 131/244] netfilter: nf_tables: check NFT_SET_CONCAT flag if field_count is specified
Date:   Tue, 23 Aug 2022 10:24:50 +0200
Message-Id: <20220823080103.481844592@linuxfoundation.org>
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

commit 1b6345d4160ecd3d04bd8cd75df90c67811e8cc9 upstream.

Since f3a2181e16f1 ("netfilter: nf_tables: Support for sets with
multiple ranged fields"), it possible to combine intervals and
concatenations. Later on, ef516e8625dd ("netfilter: nf_tables:
reintroduce the NFT_SET_CONCAT flag") provides the NFT_SET_CONCAT flag
for userspace to report that the set stores a concatenation.

Make sure NFT_SET_CONCAT is set on if field_count is specified for
consistency. Otherwise, if NFT_SET_CONCAT is specified with no
field_count, bail out with EINVAL.

Fixes: ef516e8625dd ("netfilter: nf_tables: reintroduce the NFT_SET_CONCAT flag")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4354,6 +4354,11 @@ static int nf_tables_newset(struct sk_bu
 		err = nf_tables_set_desc_parse(&desc, nla[NFTA_SET_DESC]);
 		if (err < 0)
 			return err;
+
+		if (desc.field_count > 1 && !(flags & NFT_SET_CONCAT))
+			return -EINVAL;
+	} else if (flags & NFT_SET_CONCAT) {
+		return -EINVAL;
 	}
 
 	if (nla[NFTA_SET_EXPR] || nla[NFTA_SET_EXPRESSIONS])


