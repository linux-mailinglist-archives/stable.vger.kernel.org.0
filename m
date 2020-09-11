Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2975266643
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgIKRYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgIKNAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:00:10 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D30222263;
        Fri, 11 Sep 2020 12:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828969;
        bh=tutpJv4yPcYQeyqt2c+UyoR8XdKN6VrrzXnEMfV574s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kz2XP1OAQGuOKO4KF0LQu56cP4N+MpVabhdkkTcNWlaDynDj3bJOqfTg+NNvl9UTS
         HXT5GFEPzYIbQDIsz1zyBRjcUnh2q0QXnUD7+F9xMAvr9q9oMuRDvuJaamEkT+87Gd
         3m4u/5Z/1lNGL9wmQoRqrb43easQZB/DXNnZZZk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 15/71] netfilter: nf_tables: add NFTA_SET_USERDATA if not null
Date:   Fri, 11 Sep 2020 14:45:59 +0200
Message-Id: <20200911122505.705776891@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6f03bf43ee05b31d3822def2a80f11b3591c55b3 ]

Kernel sends an empty NFTA_SET_USERDATA attribute with no value if
userspace adds a set with no NFTA_SET_USERDATA attribute.

Fixes: e6d8ecac9e68 ("netfilter: nf_tables: Add new attributes into nft_set to store user data.")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2fa1c4f2e94e0..ec460aedfc617 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2592,7 +2592,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			goto nla_put_failure;
 	}
 
-	if (nla_put(skb, NFTA_SET_USERDATA, set->udlen, set->udata))
+	if (set->udata &&
+	    nla_put(skb, NFTA_SET_USERDATA, set->udlen, set->udata))
 		goto nla_put_failure;
 
 	desc = nla_nest_start(skb, NFTA_SET_DESC);
-- 
2.25.1



