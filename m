Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359E43C5411
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344176AbhGLH4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352006AbhGLHwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC162610D1;
        Mon, 12 Jul 2021 07:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076172;
        bh=SxLjBeVfaF42z3kHyPFG+kiCKFkbEBHS0ZMKqhM2zvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5Iik4N/YC+Bx0xbSPtMaP+qEEou+/vk7sn+IjXM5nStAC2KCPKwLZdCROWT9KqOr
         VTbdm2+dFswndpXsuMGkrPUu4IHy8njka4DHt2DWr1hoMkAKwbBz7mIcfMGrxLjCZf
         tBF2kZHa/4C5zDaPoibzMxLjtt4YRkIsibYOQRJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 530/800] netfilter: nf_tables: skip netlink portID validation if zero
Date:   Mon, 12 Jul 2021 08:09:13 +0200
Message-Id: <20210712061023.682544794@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 534799097a777e82910f77a4f9d289c815a9a64e ]

nft_table_lookup() allows us to obtain the table object by the name and
the family. The netlink portID validation needs to be skipped for the
dump path, since the ownership only applies to commands to update the
given table. Skip validation if the specified netlink PortID is zero
when calling nft_table_lookup().

Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ca9ec8721e6c..1d62b1a83299 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -571,7 +571,7 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 		    table->family == family &&
 		    nft_active_genmask(table, genmask)) {
 			if (nft_table_has_owner(table) &&
-			    table->nlpid != nlpid)
+			    nlpid && table->nlpid != nlpid)
 				return ERR_PTR(-EPERM);
 
 			return table;
-- 
2.30.2



