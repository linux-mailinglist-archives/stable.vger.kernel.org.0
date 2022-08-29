Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB655A49CB
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbiH2L37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiH2L3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC8379EE5;
        Mon, 29 Aug 2022 04:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DE72611F3;
        Mon, 29 Aug 2022 11:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EA2C433C1;
        Mon, 29 Aug 2022 11:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771246;
        bh=nBwKVtuE3HX+ZqecDlfmmiUBj5o2lt46TJHtL3RZv7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ClkpduBsz32ynnRsIn/V03xoTWKCCGbVS4JiiZvJIBmy91pqEH8SZF9PmihfkS3ve
         pg5nacr1IUsKeg+jotnCBp0B0cubZ7uHC0pMfcI9+HQkRVKlPZh61ekjT5w8PrcwgL
         9kYSd8n7gnDzJecJz7Nf/iF+9Ft+EViaKeFmBBxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwangun Jung <exsociety@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 43/86] netfilter: nf_tables: disallow binding to already bound chain
Date:   Mon, 29 Aug 2022 12:59:09 +0200
Message-Id: <20220829105758.306654273@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105756.500128871@linuxfoundation.org>
References: <20220829105756.500128871@linuxfoundation.org>
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

[ Upstream commit e02f0d3970404bfea385b6edb86f2d936db0ea2b ]

Update nft_data_init() to report EINVAL if chain is already bound.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Reported-by: Gwangun Jung <exsociety@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b36728cfc5d81..1b039476e4d6a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8678,6 +8678,8 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 			return PTR_ERR(chain);
 		if (nft_is_base_chain(chain))
 			return -EOPNOTSUPP;
+		if (nft_chain_is_bound(chain))
+			return -EINVAL;
 		if (desc->flags & NFT_DATA_DESC_SETELEM &&
 		    chain->flags & NFT_CHAIN_BINDING)
 			return -EINVAL;
-- 
2.35.1



