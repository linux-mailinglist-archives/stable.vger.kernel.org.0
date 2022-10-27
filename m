Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C0B60FE33
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiJ0RDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiJ0RDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:03:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B0C1911CB
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10BC0623D7
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E62C433D6;
        Thu, 27 Oct 2022 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890185;
        bh=D1goD+RYI0bhFhSW/L9OXH1paxVk9/5A2l/PQswuSYw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mij17RMTda5iJKhJGDHBicZv34QwKWTY5W3qvZxna4GdTOlpfMYivFmbhpoKH7/IB
         t4XAumcF/iibFhd9sasnBg1W1BEtDUHBedIX6qAsBqySKBUx4bbSYT3DUxPqPzUIH+
         4cHvQoohwJzXZSfj5hTzFpN68VkFevQDRot/4xMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 53/79] netfilter: nf_tables: relax NFTA_SET_ELEM_KEY_END set flags requirements
Date:   Thu, 27 Oct 2022 18:55:51 +0200
Message-Id: <20221027165056.678170043@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 96df8360dbb435cc69f7c3c8db44bf8b1c24cd7b ]

Otherwise EINVAL is bogusly reported to userspace when deleting a set
element. NFTA_SET_ELEM_KEY_END does not need to be set in case of:

- insertion: if not present, start key is used as end key.
- deletion: only start key needs to be specified, end key is ignored.

Hence, relax the sanity check.

Fixes: 88cccd908d51 ("netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 460ad341d160..f7a5b8414423 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5720,8 +5720,9 @@ static bool nft_setelem_valid_key_end(const struct nft_set *set,
 			  (NFT_SET_CONCAT | NFT_SET_INTERVAL)) {
 		if (flags & NFT_SET_ELEM_INTERVAL_END)
 			return false;
-		if (!nla[NFTA_SET_ELEM_KEY_END] &&
-		    !(flags & NFT_SET_ELEM_CATCHALL))
+
+		if (nla[NFTA_SET_ELEM_KEY_END] &&
+		    flags & NFT_SET_ELEM_CATCHALL)
 			return false;
 	} else {
 		if (nla[NFTA_SET_ELEM_KEY_END])
-- 
2.35.1



