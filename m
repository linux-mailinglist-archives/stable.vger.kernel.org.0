Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0950649FD8
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiLLNQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiLLNPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:15:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDBA10DD
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:15:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3836E6104A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C94C433D2;
        Mon, 12 Dec 2022 13:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850919;
        bh=YPZD4/48m0UiacKmHJ1+fDyEnaK8c4cD0nMC1KBesTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y//4XCrtS1FuKVKTmc1DMxGyhs1hYdtqykOFw4Gq6e8dJpKmBj4A+IpCxhMZEKh4b
         xWl59okOuWWaqWaTrQ5p6OzCOwfnR87M+axzODAR+WyikYAulal2L4/2qeWnXwFl+z
         3kVF5LGB9CMxkuHUjNKsaMqGXfFD1Dvxw9HAlDIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/106] netfilter: nft_set_pipapo: Actually validate intervals in fields after the first one
Date:   Mon, 12 Dec 2022 14:10:07 +0100
Message-Id: <20221212130927.679764389@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 97d4d394b58777f7056ebba8ffdb4002d0563259 ]

Embarrassingly, nft_pipapo_insert() checked for interval validity in
the first field only.

The start_p and end_p pointers were reset to key data from the first
field at every iteration of the loop which was supposed to go over
the set fields.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 949da87dbb06..30cf0673d6c1 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1162,6 +1162,7 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	struct nft_pipapo_match *m = priv->clone;
 	u8 genmask = nft_genmask_next(net);
 	struct nft_pipapo_field *f;
+	const u8 *start_p, *end_p;
 	int i, bsize_max, err = 0;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
@@ -1202,9 +1203,9 @@ static int nft_pipapo_insert(const struct net *net, const struct nft_set *set,
 	}
 
 	/* Validate */
+	start_p = start;
+	end_p = end;
 	nft_pipapo_for_each_field(f, i, m) {
-		const u8 *start_p = start, *end_p = end;
-
 		if (f->rules >= (unsigned long)NFT_PIPAPO_RULE0_MAX)
 			return -ENOSPC;
 
-- 
2.35.1



