Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F96A9E038
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731362AbfH0IBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730695AbfH0IBg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:01:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC1E5206BA;
        Tue, 27 Aug 2019 08:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892895;
        bh=lpolk3mGplvQTYlSJ0kutQk3tJP6sDHc93EGxGC3MXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkpvPEpMrVxNH+VGw3OrKk956rwH95Yrk7kggwlV3xnOrcBKG/pfZOj8DHGd0fb2A
         G05iDg6R0vieEJEc7nU7Fpzirae7UZw7h87pa9ebWD0Ruz9CujxKumqxYmFPcbDHgG
         Vv1D1/voTimYJd9avmyL0u22uum+mXEFXgMGg+ms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yi <yiche@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 050/162] netfilter: ipset: Actually allow destination MAC address for hash:ip,mac sets too
Date:   Tue, 27 Aug 2019 09:49:38 +0200
Message-Id: <20190827072739.960706072@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b89d15480d0cacacae1a0fe0b3da01b529f2914f ]

In commit 8cc4ccf58379 ("ipset: Allow matching on destination MAC address
for mac and ipmac sets"), ipset.git commit 1543514c46a7, I removed the
KADT check that prevents matching on destination MAC addresses for
hash:mac sets, but forgot to remove the same check for hash:ip,mac set.

Drop this check: functionality is now commented in man pages and there's
no reason to restrict to source MAC address matching anymore.

Reported-by: Chen Yi <yiche@redhat.com>
Fixes: 8cc4ccf58379 ("ipset: Allow matching on destination MAC address for mac and ipmac sets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_ipmac.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index faf59b6a998fe..eb14434083203 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -89,10 +89,6 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	struct hash_ipmac4_elem e = { .ip = 0, { .foo[0] = 0, .foo[1] = 0 } };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
-	 /* MAC can be src only */
-	if (!(opt->flags & IPSET_DIM_TWO_SRC))
-		return 0;
-
 	if (skb_mac_header(skb) < skb->head ||
 	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
-- 
2.20.1



