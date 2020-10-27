Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D3E29B0A4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408601AbgJ0OWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:22:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901292AbgJ0OWC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:22:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39CDB206D4;
        Tue, 27 Oct 2020 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808521;
        bh=a8TMT6zGJU5fBSmEFyhh2jcPRVB55OUhJnfRmaLd8JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y1HXr8M9n1pZT7fQJFIot558HpJEDVi48keBq/rzxH1UdXaRW8OvSTSFLoIeoG4kh
         vRYbMWmfJZx18Ytw6bwoPfWEJNAfpRtqgglKBCv1XZ4LF7gMDzcAvjubhEHSQpgtjm
         CMGqKm23UI4ifvl146kzzxT3Qwzh2zhdYYthelyo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny B <abt-admin@mail.ru>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 124/264] ipvs: clear skb->tstamp in forwarding path
Date:   Tue, 27 Oct 2020 14:53:02 +0100
Message-Id: <20201027135436.514499495@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 7980d2eabde82be86c5be18aa3d07e88ec13c6a1 ]

fq qdisc requires tstamp to be cleared in forwarding path

Reported-by: Evgeny B <abt-admin@mail.ru>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209427
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: 8203e2d844d3 ("net: clear skb->tstamp in forwarding paths")
Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
Fixes: 80b14dee2bea ("net: Add a new socket option for a future transmit time.")
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 3f75cd947045e..11f7c546e57b3 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -586,6 +586,8 @@ static inline int ip_vs_tunnel_xmit_prepare(struct sk_buff *skb,
 	if (ret == NF_ACCEPT) {
 		nf_reset(skb);
 		skb_forward_csum(skb);
+		if (skb->dev)
+			skb->tstamp = 0;
 	}
 	return ret;
 }
@@ -626,6 +628,8 @@ static inline int ip_vs_nat_send_or_cont(int pf, struct sk_buff *skb,
 
 	if (!local) {
 		skb_forward_csum(skb);
+		if (skb->dev)
+			skb->tstamp = 0;
 		NF_HOOK(pf, NF_INET_LOCAL_OUT, cp->ipvs->net, NULL, skb,
 			NULL, skb_dst(skb)->dev, dst_output);
 	} else
@@ -646,6 +650,8 @@ static inline int ip_vs_send_or_cont(int pf, struct sk_buff *skb,
 	if (!local) {
 		ip_vs_drop_early_demux_sk(skb);
 		skb_forward_csum(skb);
+		if (skb->dev)
+			skb->tstamp = 0;
 		NF_HOOK(pf, NF_INET_LOCAL_OUT, cp->ipvs->net, NULL, skb,
 			NULL, skb_dst(skb)->dev, dst_output);
 	} else
-- 
2.25.1



