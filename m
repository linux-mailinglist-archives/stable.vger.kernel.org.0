Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A25A62416
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389237AbfGHPkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:40:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731881AbfGHP2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:28:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D1A520645;
        Mon,  8 Jul 2019 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599685;
        bh=H0IXspXxI/zpi03RBWqNoqskzumzNpuQhM1IWR1zcxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nivxegxz233IrVNIReUtPO1iP7nXVKeV06Qh/pL6tgru4OHfnnmhO6+nl1ALfHwjA
         /33Lke+/2t9Qi3xUbJ0jYbftcP5AyCWszse2YNtkD4usDvcrNnHRZcjhvRqEXKTbQV
         5vSG+SzQDrLQjB3oW9bcgMVX9aoTiTlTJnGUmGak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 07/90] netfilter: nft_flow_offload: IPCB is only valid for ipv4 family
Date:   Mon,  8 Jul 2019 17:12:34 +0200
Message-Id: <20190708150522.821819621@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 69aeb538587e087bfc81dd1f465eab3558ff3158 upstream.

Guard this with a check vs. ipv4, IPCB isn't valid in ipv6 case.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nft_flow_offload.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -48,15 +48,20 @@ static int nft_flow_route(const struct n
 	return 0;
 }
 
-static bool nft_flow_offload_skip(struct sk_buff *skb)
+static bool nft_flow_offload_skip(struct sk_buff *skb, int family)
 {
-	struct ip_options *opt  = &(IPCB(skb)->opt);
-
-	if (unlikely(opt->optlen))
-		return true;
 	if (skb_sec_path(skb))
 		return true;
 
+	if (family == NFPROTO_IPV4) {
+		const struct ip_options *opt;
+
+		opt = &(IPCB(skb)->opt);
+
+		if (unlikely(opt->optlen))
+			return true;
+	}
+
 	return false;
 }
 
@@ -74,7 +79,7 @@ static void nft_flow_offload_eval(const
 	struct nf_conn *ct;
 	int ret;
 
-	if (nft_flow_offload_skip(pkt->skb))
+	if (nft_flow_offload_skip(pkt->skb, nft_pf(pkt)))
 		goto out;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);


