Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E269E13F
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731044AbfH0IBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730543AbfH0IBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:01:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C485217F5;
        Tue, 27 Aug 2019 08:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892898;
        bh=N+EUED4CEye1GJwfGGA/084rL7SuGCiygi1EdidG1KI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8UEHOwjiP0XVysV5GtDpej5jyNfSG+MiKnvgJOqZvZZ4hRQKstuCGOZa9ZjExuyF
         mT0SPvTt7igsl4F5TpEJx5MlgT3vd7SMLsTDSMA+myIKd1oK+YAl/6AREQfATvFWvm
         CmugdZ7II0FjYcyohCEQRKr48bMxlCjc0ikS71Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yi <yiche@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 051/162] netfilter: ipset: Copy the right MAC address in bitmap:ip,mac and hash:ip,mac sets
Date:   Tue, 27 Aug 2019 09:49:39 +0200
Message-Id: <20190827072739.991540119@linuxfoundation.org>
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

[ Upstream commit 1b4a75108d5bc153daf965d334e77e8e94534f96 ]

In commit 8cc4ccf58379 ("ipset: Allow matching on destination MAC address
for mac and ipmac sets"), ipset.git commit 1543514c46a7, I added to the
KADT functions for sets matching on MAC addreses the copy of source or
destination MAC address depending on the configured match.

This was done correctly for hash:mac, but for hash:ip,mac and
bitmap:ip,mac, copying and pasting the same code block presents an
obvious problem: in these two set types, the MAC address is the second
dimension, not the first one, and we are actually selecting the MAC
address depending on whether the first dimension (IP address) specifies
source or destination.

Fix this by checking for the IPSET_DIM_TWO_SRC flag in option flags.

This way, mixing source and destination matches for the two dimensions
of ip,mac set types works as expected. With this setup:

  ip netns add A
  ip link add veth1 type veth peer name veth2 netns A
  ip addr add 192.0.2.1/24 dev veth1
  ip -net A addr add 192.0.2.2/24 dev veth2
  ip link set veth1 up
  ip -net A link set veth2 up

  dst=$(ip netns exec A cat /sys/class/net/veth2/address)

  ip netns exec A ipset create test_bitmap bitmap:ip,mac range 192.0.0.0/16
  ip netns exec A ipset add test_bitmap 192.0.2.1,${dst}
  ip netns exec A iptables -A INPUT -m set ! --match-set test_bitmap src,dst -j DROP

  ip netns exec A ipset create test_hash hash:ip,mac
  ip netns exec A ipset add test_hash 192.0.2.1,${dst}
  ip netns exec A iptables -A INPUT -m set ! --match-set test_hash src,dst -j DROP

ipset correctly matches a test packet:

  # ping -c1 192.0.2.2 >/dev/null
  # echo $?
  0

Reported-by: Chen Yi <yiche@redhat.com>
Fixes: 8cc4ccf58379 ("ipset: Allow matching on destination MAC address for mac and ipmac sets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_bitmap_ipmac.c | 2 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index b73c37b3a791f..cfe7b556775f1 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -227,7 +227,7 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 
 	e.id = ip_to_id(map, ip);
 
-	if (opt->flags & IPSET_DIM_ONE_SRC)
+	if (opt->flags & IPSET_DIM_TWO_SRC)
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
index eb14434083203..24d8f4df4230c 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmac.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
@@ -93,7 +93,7 @@ hash_ipmac4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	    (skb_mac_header(skb) + ETH_HLEN) > skb->data)
 		return -EINVAL;
 
-	if (opt->flags & IPSET_DIM_ONE_SRC)
+	if (opt->flags & IPSET_DIM_TWO_SRC)
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_source);
 	else
 		ether_addr_copy(e.ether, eth_hdr(skb)->h_dest);
-- 
2.20.1



