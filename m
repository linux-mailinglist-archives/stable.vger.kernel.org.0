Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D74623B9
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390658AbfGHPhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:37:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389966AbfGHPbw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:31:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18EA3216C4;
        Mon,  8 Jul 2019 15:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599911;
        bh=EMd2/EMEbomDp/HYQ44yrWt9W+8QT59uhc6NBw2ZYe4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSh3b6yhn37nohj71HrHxUFTqcJ9LUOsKJlpTwF31DJoPoUql06PoaWFNFd091WeF
         aVW9SnM2jtZWid49ESN7Oy8GV56WFas2Yl04XNVC4Dlvs4P9K6hr+fWdpFKY4aZ2Sb
         rCCAUX8lFfW1bCzXP7TtxXV/q2SwRbr7LeTAfuZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.1 03/96] netfilter: nf_flow_table: ignore DF bit setting
Date:   Mon,  8 Jul 2019 17:12:35 +0200
Message-Id: <20190708150526.452638247@linuxfoundation.org>
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

commit e75b3e1c9bc5b997d09bdf8eb72ab3dd3c1a7072 upstream.

Its irrelevant if the DF bit is set or not, we must pass packet to
stack in either case.

If the DF bit is set, we must pass it to stack so the appropriate
ICMP error can be generated.

If the DF is not set, we must pass it to stack for fragmentation.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_flow_table_ip.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -246,8 +246,7 @@ nf_flow_offload_ip_hook(void *priv, stru
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
 
-	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)) &&
-	    (ip_hdr(skb)->frag_off & htons(IP_DF)) != 0)
+	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
 		return NF_ACCEPT;
 
 	if (skb_try_make_writable(skb, sizeof(*iph)))


