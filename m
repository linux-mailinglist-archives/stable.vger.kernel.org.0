Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21FED31BCA9
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbhBOPdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:33:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:46856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhBOPbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:31:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B40E064E96;
        Mon, 15 Feb 2021 15:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402967;
        bh=PiW0QxYcvN9x0HBY7fA4+AbVQ6ht9bkIF/2x22Ewvmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HN7JMRUWpXLigEgqkhx3W3icoAd6WSCyLmoLi7yCuXPmPZm4TZvir6IumMXVn+e4b
         ISxIM2Dq3Ej91L6ZmMqaHl9s27ZGcgwxWlPAAsQX+Qs7LRDqdvro5+JHkl/ldCKtJ+
         gyzlmhNm6JqblwfKr71dv1DiFICNSwIpeXrwCe8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/60] netfilter: conntrack: skip identical origin tuple in same zone only
Date:   Mon, 15 Feb 2021 16:27:25 +0100
Message-Id: <20210215152716.540051184@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 07998281c268592963e1cd623fe6ab0270b65ae4 ]

The origin skip check needs to re-test the zone. Else, we might skip
a colliding tuple in the reply direction.

This only occurs when using 'directional zones' where origin tuples
reside in different zones but the reply tuples share the same zone.

This causes the new conntrack entry to be dropped at confirmation time
because NAT clash resolution was elided.

Fixes: 4e35c1cb9460240 ("netfilter: nf_nat: skip nat clash resolution for same-origin entries")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 200cdad3ff3ab..9a40312b1f161 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1091,7 +1091,8 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			 * Let nf_ct_resolve_clash() deal with this later.
 			 */
 			if (nf_ct_tuple_equal(&ignored_conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
-					      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple))
+					      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple) &&
+					      nf_ct_zone_equal(ct, zone, IP_CT_DIR_ORIGINAL))
 				continue;
 
 			NF_CT_STAT_INC_ATOMIC(net, found);
-- 
2.27.0



