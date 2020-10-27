Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41BD629BE36
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794138AbgJ0PKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505295AbgJ0PJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:09:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AFC320657;
        Tue, 27 Oct 2020 15:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811397;
        bh=cCBaorZKmdqODlo4rM88rfT8ZNelAO1jCRQ8rpDgCTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RkUFd6Tw0g0XexzNus2WLjMoqgVeQV/ecjtp86VLtv7q15Yaf4hdmWz47r6q/8COw
         pmvLtlS4a5KZhOLMkzfTYD0IIK5C9wLllz67UyQaQu5dgafna+k0tZ72V3kkpW5yYs
         yHJP2t9WYopl+4izqnfJUkmOx/1nqpGazon8iF9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Timoth=C3=A9e=20COCAULT?= <timothee.cocault@orange.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 477/633] netfilter: ebtables: Fixes dropping of small packets in bridge nat
Date:   Tue, 27 Oct 2020 14:53:40 +0100
Message-Id: <20201027135545.115866452@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timothée COCAULT <timothee.cocault@orange.com>

[ Upstream commit 63137bc5882a1882c553d389fdeeeace86ee1741 ]

Fixes an error causing small packets to get dropped. skb_ensure_writable
expects the second parameter to be a length in the ethernet payload.=20
If we want to write the ethernet header (src, dst), we should pass 0.
Otherwise, packets with small payloads (< ETH_ALEN) will get dropped.

Fixes: c1a831167901 ("netfilter: bridge: convert skb_make_writable to skb_ensure_writable")
Signed-off-by: Timothée COCAULT <timothee.cocault@orange.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebt_dnat.c     | 2 +-
 net/bridge/netfilter/ebt_redirect.c | 2 +-
 net/bridge/netfilter/ebt_snat.c     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 12a4f4d936810..3fda71a8579d1 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -21,7 +21,7 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
 
-	if (skb_ensure_writable(skb, ETH_ALEN))
+	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
 
 	ether_addr_copy(eth_hdr(skb)->h_dest, info->mac);
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 0cad62a4052b9..307790562b492 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -21,7 +21,7 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_redirect_info *info = par->targinfo;
 
-	if (skb_ensure_writable(skb, ETH_ALEN))
+	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
 
 	if (xt_hooknum(par) != NF_BR_BROUTING)
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 27443bf229a3b..7dfbcdfc30e5d 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -22,7 +22,7 @@ ebt_snat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
 
-	if (skb_ensure_writable(skb, ETH_ALEN * 2))
+	if (skb_ensure_writable(skb, 0))
 		return EBT_DROP;
 
 	ether_addr_copy(eth_hdr(skb)->h_source, info->mac);
-- 
2.25.1



