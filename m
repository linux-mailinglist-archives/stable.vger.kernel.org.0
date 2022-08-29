Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BDE5A4826
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiH2LG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiH2LFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:05:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E37642F3;
        Mon, 29 Aug 2022 04:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48855B80EF6;
        Mon, 29 Aug 2022 11:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D004C433D6;
        Mon, 29 Aug 2022 11:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771058;
        bh=J2SB5bmPljpkP9lpMCL8I+guc1tT+i/fXt5y9INNn24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKj0lzmY7Ap6c4tyY7S8G2GUdVO8X2Tx/vuPgiQgjthH1ZTG8M2cjYHTE341C6Q4M
         M+Q6xuqT4tImxYgyMaSSXg/lnpNmjPZWbeokOift0KIlEczbdAyO2rXeBa3rMjSvG9
         L88CmToM7zTDOHCcC7EiWHIL/m1p4mLhM1Z751F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/136] netfilter: nf_tables: disallow updates of implicit chain
Date:   Mon, 29 Aug 2022 12:58:42 +0200
Message-Id: <20220829105806.886843813@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

[ Upstream commit 5dc52d83baac30decf5f3b371d5eb41dfa1d1412 ]

Updates on existing implicit chain make no sense, disallow this.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2f22a172a27e1..58f9513bd1419 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2479,6 +2479,9 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	if (chain != NULL) {
+		if (chain->flags & NFT_CHAIN_BINDING)
+			return -EINVAL;
+
 		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return -EEXIST;
-- 
2.35.1



