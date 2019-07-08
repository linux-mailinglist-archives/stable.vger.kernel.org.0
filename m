Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1673F623B0
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733173AbfGHPhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390164AbfGHPcf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:32:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4A38216F4;
        Mon,  8 Jul 2019 15:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599954;
        bh=H0IXspXxI/zpi03RBWqNoqskzumzNpuQhM1IWR1zcxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfQn6qURwjFU9RiU5QkLgUOLudQOWPm0cBCVbo9kOuYQbPQrjJOeGvotn5AQlNy9D
         e+MlVT3tMKe9h2hiKAOC2iBj8R7EnoxGtxVLeb4EEg5hEgNVqJURAHvOeOYxhQa7Sl
         vXOOp9ykrYkJiW46Y4KHs9FT4y61OQklH6LT4DI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.1 06/96] netfilter: nft_flow_offload: IPCB is only valid for ipv4 family
Date:   Mon,  8 Jul 2019 17:12:38 +0200
Message-Id: <20190708150526.644612063@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
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


