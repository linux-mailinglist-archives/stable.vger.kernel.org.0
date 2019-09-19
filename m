Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BC2B870C
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389171AbfISWKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:10:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405583AbfISWKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:10:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DAB5218AF;
        Thu, 19 Sep 2019 22:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931005;
        bh=d4SIohXQNvARrAc4/XY4cpPn0pLAAyDtVryElAjLMhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZIh+lzHc42eraaFwnPZaup5o6oo6Vp1R+Wpz+MpuvXbV1Q7BDl821CLdt5v8F/U4
         3FAizNkv13ToYYRlCeNcOsO8VEiyPuuAgHJ58yxW4ShtRqSRz7d6UIxydMQr1gUiPx
         J+P7EBXoTLkU0h74Fh76nfBfviMVcQLdFIhcm6+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 093/124] netfilter: nf_flow_table: clear skb tstamp before xmit
Date:   Fri, 20 Sep 2019 00:03:01 +0200
Message-Id: <20190919214822.436912552@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit de20900fbe1c4fd36de25a7a5a43223254ecf0d0 ]

If 'fq' qdisc is used and a program has requested timestamps,
skb->tstamp needs to be cleared, else fq will treat these as
'transmit time'.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index d68c801dd614b..b9e7dd6e60ce2 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -228,7 +228,6 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 {
 	skb_orphan(skb);
 	skb_dst_set_noref(skb, dst);
-	skb->tstamp = 0;
 	dst_output(state->net, state->sk, skb);
 	return NF_STOLEN;
 }
@@ -284,6 +283,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
 	iph = ip_hdr(skb);
 	ip_decrease_ttl(iph);
+	skb->tstamp = 0;
 
 	if (unlikely(dst_xfrm(&rt->dst))) {
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
@@ -512,6 +512,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
 	ip6h = ipv6_hdr(skb);
 	ip6h->hop_limit--;
+	skb->tstamp = 0;
 
 	if (unlikely(dst_xfrm(&rt->dst))) {
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
-- 
2.20.1



