Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9B028B90C
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390334AbgJLN5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:57:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389365AbgJLNnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:43:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F2A22251;
        Mon, 12 Oct 2020 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510210;
        bh=beGJu3rWvTpblMJs/GmKYmVmzuSd2vlgK2kh3X3A9rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0W13JXoGHMjhk38Hkz31/TiDWwZyMVkUFFj9tWxJmQmXDPnGamwj4pYZ1uTfTbfz6
         18PuqRVCBq/UIRs3q2rRJ0o4ody83riHkNo0tcxT1oA7PaKPVnD/j4vgeFBaftwsYu
         7S/Op2nZLIHwt47oZXqPX2e1wThLLmY2ZLQn1CPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 79/85] net/core: check length before updating Ethertype in skb_mpls_{push,pop}
Date:   Mon, 12 Oct 2020 15:27:42 +0200
Message-Id: <20201012132636.643978471@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

commit 4296adc3e32f5d544a95061160fe7e127be1b9ff upstream.

Openvswitch allows to drop a packet's Ethernet header, therefore
skb_mpls_push() and skb_mpls_pop() might be called with ethernet=true
and mac_len=0. In that case the pointer passed to skb_mod_eth_type()
doesn't point to an Ethernet header and the new Ethertype is written at
unexpected locations.

Fix this by verifying that mac_len is big enough to contain an Ethernet
header.

Fixes: fa4e0f8855fc ("net/sched: fix corrupted L2 header with MPLS 'push' and 'pop' actions")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Acked-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/skbuff.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5515,7 +5515,7 @@ int skb_mpls_push(struct sk_buff *skb, _
 	lse->label_stack_entry = mpls_lse;
 	skb_postpush_rcsum(skb, lse, MPLS_HLEN);
 
-	if (ethernet)
+	if (ethernet && mac_len >= ETH_HLEN)
 		skb_mod_eth_type(skb, eth_hdr(skb), mpls_proto);
 	skb->protocol = mpls_proto;
 
@@ -5555,7 +5555,7 @@ int skb_mpls_pop(struct sk_buff *skb, __
 	skb_reset_mac_header(skb);
 	skb_set_network_header(skb, mac_len);
 
-	if (ethernet) {
+	if (ethernet && mac_len >= ETH_HLEN) {
 		struct ethhdr *hdr;
 
 		/* use mpls_hdr() to get ethertype to account for VLANs. */


