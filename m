Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E888DB97
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbfHNR0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729275AbfHNREj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:04:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ABBA2084D;
        Wed, 14 Aug 2019 17:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802279;
        bh=+bHoaEyut0jt8XpJIrpUFxCbGOTtiDFobi2WIvPHMWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rfQWcmsIqysVZLCjNe/TXNZTnI4azphL8ZpW/sV1bzCS1/kf88wlaiQ0dqj9LOmcN
         LtGLczMwgKnyU4Pm259ZvcHvTj5KJTNhjB8Jh1m7IWs1Q2HV65c2UIOgXGn3cyzFxR
         fsGYQuFEFHr9s2zc+A8iA8TEV+9NrogvH7Pd4b9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Garcia Liebana <nevola@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 056/144] netfilter: nft_hash: fix symhash with modulus one
Date:   Wed, 14 Aug 2019 19:00:12 +0200
Message-Id: <20190814165802.173677704@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 28b1d6ef53e3303b90ca8924bb78f31fa527cafb ]

The rule below doesn't work as the kernel raises -ERANGE.

nft add rule netdev nftlb lb01 ip daddr set \
	symhash mod 1 map { 0 : 192.168.0.10 } fwd to "eth0"

This patch allows to use the symhash modulus with one
element, in the same way that the other types of hashes and
algorithms that uses the modulus parameter.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index fe93e731dc7fb..b836d550b9199 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -129,7 +129,7 @@ static int nft_symhash_init(const struct nft_ctx *ctx,
 	priv->dreg = nft_parse_register(tb[NFTA_HASH_DREG]);
 
 	priv->modulus = ntohl(nla_get_be32(tb[NFTA_HASH_MODULUS]));
-	if (priv->modulus <= 1)
+	if (priv->modulus < 1)
 		return -ERANGE;
 
 	if (priv->offset + priv->modulus - 1 < priv->offset)
-- 
2.20.1



