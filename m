Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B454E63DE8B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiK3SiH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:38:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiK3Sh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:37:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26E323175
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:37:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5044661D74
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64768C433D6;
        Wed, 30 Nov 2022 18:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833469;
        bh=Vl+l30PNm7DGAvMfDdo/f6LIv20ZQSLQ2bzBnUgKRR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cLOvqMVauLsHXWk+8A7/Wqa+QSQ75gNd+So5R2fA4Q6nyTe6H825DWxaCGchbPC3g
         xzhXVM51NGy3w/s1Or5hqrE3rbORP85iu67V+0UDAles5jsx+kEyAgP4WvcfNaxX7n
         r3/nxBHv6LQJ+Mb+yg6+KbbkJXVM4fnhhVKL9/sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/206] netfilter: ipset: restore allowing 64 clashing elements in hash:net,iface
Date:   Wed, 30 Nov 2022 19:22:49 +0100
Message-Id: <20221130180536.020980920@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 6a66ce44a51bdfc47721f0c591137df2d4b21247 ]

The commit 510841da1fcc ("netfilter: ipset: enforce documented limit to
prevent allocating huge memory") was too strict and prevented to add up to
64 clashing elements to a hash:net,iface type of set. This patch fixes the
issue and now the type behaves as documented.

Fixes: 510841da1fcc ("netfilter: ipset: enforce documented limit to prevent allocating huge memory")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 3adc291d9ce1..7499192af586 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -916,7 +916,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 #ifdef IP_SET_HASH_WITH_MULTI
 		if (h->bucketsize >= AHASH_MAX_TUNED)
 			goto set_full;
-		else if (h->bucketsize < multi)
+		else if (h->bucketsize <= multi)
 			h->bucketsize += AHASH_INIT_SIZE;
 #endif
 		if (n->size >= AHASH_MAX(h)) {
-- 
2.35.1



