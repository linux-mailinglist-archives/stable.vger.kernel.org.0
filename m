Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF18E47272D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhLMJ7A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40690 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238832AbhLMJym (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:54:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD7F5B80E0E;
        Mon, 13 Dec 2021 09:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F412BC34600;
        Mon, 13 Dec 2021 09:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389278;
        bh=IBrCAqU6b8G3ex5zgoUvdFT0MoXsawMC8ktNn28vmkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYWP79J8GdQBQRB+7RDgLM/BZh439kRonGUCmfbxex6Y6f5B2gT8JqD3BgkIqE4OZ
         0YWRo6sw+mG2lSzFfVcmyn6uC8TKEGIz5eBJ7x41dWwNtWVSJOfvo84CIUKPc0pe8q
         +TYivT2KE0Q9Paa1m0UEjnZPy/072031LBrVIkWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Mayer <andrea.mayer@uniroma2.it>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 044/171] seg6: fix the iif in the IPv6 socket control block
Date:   Mon, 13 Dec 2021 10:29:19 +0100
Message-Id: <20211213092946.561185060@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Mayer <andrea.mayer@uniroma2.it>

commit ae68d93354e5bf5191ee673982251864ea24dd5c upstream.

When an IPv4 packet is received, the ip_rcv_core(...) sets the receiving
interface index into the IPv4 socket control block (v5.16-rc4,
net/ipv4/ip_input.c line 510):

    IPCB(skb)->iif = skb->skb_iif;

If that IPv4 packet is meant to be encapsulated in an outer IPv6+SRH
header, the seg6_do_srh_encap(...) performs the required encapsulation.
In this case, the seg6_do_srh_encap function clears the IPv6 socket control
block (v5.16-rc4 net/ipv6/seg6_iptunnel.c line 163):

    memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));

The memset(...) was introduced in commit ef489749aae5 ("ipv6: sr: clear
IP6CB(skb) on SRH ip4ip6 encapsulation") a long time ago (2019-01-29).

Since the IPv6 socket control block and the IPv4 socket control block share
the same memory area (skb->cb), the receiving interface index info is lost
(IP6CB(skb)->iif is set to zero).

As a side effect, that condition triggers a NULL pointer dereference if
commit 0857d6f8c759 ("ipv6: When forwarding count rx stats on the orig
netdev") is applied.

To fix that issue, we set the IP6CB(skb)->iif with the index of the
receiving interface once again.

Fixes: ef489749aae5 ("ipv6: sr: clear IP6CB(skb) on SRH ip4ip6 encapsulation")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20211208195409.12169-1-andrea.mayer@uniroma2.it
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_iptunnel.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -161,6 +161,14 @@ int seg6_do_srh_encap(struct sk_buff *sk
 		hdr->hop_limit = ip6_dst_hoplimit(skb_dst(skb));
 
 		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
+
+		/* the control block has been erased, so we have to set the
+		 * iif once again.
+		 * We read the receiving interface index directly from the
+		 * skb->skb_iif as it is done in the IPv4 receiving path (i.e.:
+		 * ip_rcv_core(...)).
+		 */
+		IP6CB(skb)->iif = skb->skb_iif;
 	}
 
 	hdr->nexthdr = NEXTHDR_ROUTING;


