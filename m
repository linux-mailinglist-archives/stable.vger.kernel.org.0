Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C1F40E3D5
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbhIPQwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345653AbhIPQua (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:50:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F4B9615E0;
        Thu, 16 Sep 2021 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809696;
        bh=ZSD/t6GBczhauPcf8YTa/40vg1sr0JwCZIBauU0hziI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbkO4Pk/iBxrza/WRQ2T7m/1tFyq36AY8PCSnz1/Y+ijSxY/v8Fg6CF0NoVIAYJE0
         fgOCvAOSSt4OzdvWwlMu1WWUKLTU0AqqQRpgF/ChSv3TzVTs+jBiSBz/oMRuSEJd9F
         58NBBNPncZPkTTrnPVqf6zAEZPet/hqTlRJcbwi4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 217/380] netfilter: nft_compat: use nfnetlink_unicast()
Date:   Thu, 16 Sep 2021 17:59:34 +0200
Message-Id: <20210916155811.470177270@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 241d1af4c11a75d4c17ecc0193a6ab60553efbfc ]

Use nfnetlink_unicast() which already translates EAGAIN to ENOBUFS,
since EAGAIN is reserved to report missing module dependencies to the
nfnetlink core.

e0241ae6ac59 ("netfilter: use nfnetlink_unicast() forgot to update
this spot.

Reported-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 5415ab14400d..31e6da30da5f 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -680,14 +680,12 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
 		goto out_put;
 	}
 
-	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
-			      MSG_DONTWAIT);
-	if (ret > 0)
-		ret = 0;
+	ret = nfnetlink_unicast(skb2, info->net, NETLINK_CB(skb).portid);
 out_put:
 	rcu_read_lock();
 	module_put(THIS_MODULE);
-	return ret == -EAGAIN ? -ENOBUFS : ret;
+
+	return ret;
 }
 
 static const struct nla_policy nfnl_compat_policy_get[NFTA_COMPAT_MAX+1] = {
-- 
2.30.2



