Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2435C1F0FB
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730834AbfEOLWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731249AbfEOLWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:22:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E6E20818;
        Wed, 15 May 2019 11:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919367;
        bh=/ee50LFzLtCJJcQ/CBmCLb5opISI5VQiCJQ39RIQn5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pi4RQlAQXctDLkTRmVijUXhMbH3cWx4wgXlPHrzaBSljmS6yMxZH56F9qWG3eySdb
         Jk0R/pFEfelpVdavaoIAbrscfNARrsVMNbvziwNIwOHVE0KbvywZ94bgS4KTvXeZFK
         e4Ci/hy8yw8NrR2fhCkFdBw+tAhI0Z2dLy9SwdRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 049/113] netfilter: nf_tables: prevent shift wrap in nft_chain_parse_hook()
Date:   Wed, 15 May 2019 12:55:40 +0200
Message-Id: <20190515090657.374463262@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 33d1c018179d0a30c39cc5f1682b77867282694b ]

I believe that "hook->num" can be up to UINT_MAX.  Shifting more than
31 bits would is undefined in C but in practice it would lead to shift
wrapping.  That would lead to an array overflow in nf_tables_addchain():

	ops->hook       = hook.type->hooks[ops->hooknum];

Fixes: fe19c04ca137 ("netfilter: nf_tables: remove nhooks field from struct nft_af_info")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1af54119bafc7..f272f9538c44a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1496,7 +1496,7 @@ static int nft_chain_parse_hook(struct net *net,
 		if (IS_ERR(type))
 			return PTR_ERR(type);
 	}
-	if (!(type->hook_mask & (1 << hook->num)))
+	if (hook->num > NF_MAX_HOOKS || !(type->hook_mask & (1 << hook->num)))
 		return -EOPNOTSUPP;
 
 	if (type->type == NFT_CHAIN_T_NAT &&
-- 
2.20.1



