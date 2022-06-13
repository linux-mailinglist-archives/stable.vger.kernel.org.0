Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64BB549696
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384094AbiFMOcr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385525AbiFMObQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:31:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9887FABE76;
        Mon, 13 Jun 2022 04:49:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D80C76149A;
        Mon, 13 Jun 2022 11:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AD3C36AFE;
        Mon, 13 Jun 2022 11:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120897;
        bh=VXZhxryh72Og4GqGI4MTbJbRPGLEe+3cwrtMAV1XFcY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ilUniEpbzdLVpDzgiCwrnA4JofJ3yiu6hCxn3cq6/UeCOymvvLdIiQpuCyx0K0Wy
         TNaqSoUIbEhCqyHXaUO8muPWJMNIqscCxFC/2ge+WxNCulXdK9NLimmaodnizZqeOu
         9ovvptTyl9HSjxRkED468CCBJRrs9TlKF89w3bG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 165/298] netfilter: nf_tables: release new hooks on unsupported flowtable flags
Date:   Mon, 13 Jun 2022 12:10:59 +0200
Message-Id: <20220613094929.936874350@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c271cc9febaaa1bcbc0842d1ee30466aa6148ea8 ]

Release the list of new hooks that are pending to be registered in case
that unsupported flowtable flags are provided.

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ee7adb42a97d..2abad256f0aa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7348,11 +7348,15 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 
 	if (nla[NFTA_FLOWTABLE_FLAGS]) {
 		flags = ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
-		if (flags & ~NFT_FLOWTABLE_MASK)
-			return -EOPNOTSUPP;
+		if (flags & ~NFT_FLOWTABLE_MASK) {
+			err = -EOPNOTSUPP;
+			goto err_flowtable_update_hook;
+		}
 		if ((flowtable->data.flags & NFT_FLOWTABLE_HW_OFFLOAD) ^
-		    (flags & NFT_FLOWTABLE_HW_OFFLOAD))
-			return -EOPNOTSUPP;
+		    (flags & NFT_FLOWTABLE_HW_OFFLOAD)) {
+			err = -EOPNOTSUPP;
+			goto err_flowtable_update_hook;
+		}
 	} else {
 		flags = flowtable->data.flags;
 	}
-- 
2.35.1



