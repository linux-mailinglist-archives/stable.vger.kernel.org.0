Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6A74454E0
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhKDOS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:18:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231829AbhKDORq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:17:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C75CA611C3;
        Thu,  4 Nov 2021 14:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035308;
        bh=P0JoRFtC8uH/1xk5KwAJtSz7bKkQPkHQqH0P0N5RkdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bp+DOZxOGpwskoFzP3kXA6cZz5rxinQiOuM3zliSRhmAXcpm0l6IgtsjK3gFXvET8
         BLd3z8n/gmiENt6l86BU4YkOf9f0/Oyx55ZqhYVEN/Cdnjzm95ASjls4HYWdWednpn
         hL4OhrXNYjjhkmFCXwVHPAuAN76IwuiGMmtmWUZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugene Crosser <crosser@average.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.10 04/16] vrf: Revert "Reset skb conntrack connection..."
Date:   Thu,  4 Nov 2021 15:12:43 +0100
Message-Id: <20211104141159.710040537@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.561284732@linuxfoundation.org>
References: <20211104141159.561284732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugene Crosser <crosser@average.org>

commit 55161e67d44fdd23900be166a81e996abd6e3be9 upstream.

This reverts commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1.

When an interface is enslaved in a VRF, prerouting conntrack hook is
called twice: once in the context of the original input interface, and
once in the context of the VRF interface. If no special precausions are
taken, this leads to creation of two conntrack entries instead of one,
and breaks SNAT.

Commit above was intended to avoid creation of extra conntrack entries
when input interface is enslaved in a VRF. It did so by resetting
conntrack related data associated with the skb when it enters VRF context.

However it breaks netfilter operation. Imagine a use case when conntrack
zone must be assigned based on the original input interface, rather than
VRF interface (that would make original interfaces indistinguishable). One
could create netfilter rules similar to these:

        chain rawprerouting {
                type filter hook prerouting priority raw;
                iif realiface1 ct zone set 1 return
                iif realiface2 ct zone set 2 return
        }

This works before the mentioned commit, but not after: zone assignment
is "forgotten", and any subsequent NAT or filtering that is dependent
on the conntrack zone does not work.

Here is a reproducer script that demonstrates the difference in behaviour.

==========
#!/bin/sh

# This script demonstrates unexpected change of nftables behaviour
# caused by commit 09e856d54bda5f28 ""vrf: Reset skb conntrack
# connection on VRF rcv"
# https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=09e856d54bda5f288ef8437a90ab2b9b3eab83d1
#
# Before the commit, it was possible to assign conntrack zone to a
# packet (or mark it for `notracking`) in the prerouting chanin, raw
# priority, based on the `iif` (interface from which the packet
# arrived).
# After the change, # if the interface is enslaved in a VRF, such
# assignment is lost. Instead, assignment based on the `iif` matching
# the VRF master interface is honored. Thus it is impossible to
# distinguish packets based on the original interface.
#
# This script demonstrates this change of behaviour: conntrack zone 1
# or 2 is assigned depending on the match with the original interface
# or the vrf master interface. It can be observed that conntrack entry
# appears in different zone in the kernel versions before and after
# the commit.

IPIN=172.30.30.1
IPOUT=172.30.30.2
PFXL=30

ip li sh vein >/dev/null 2>&1 && ip li del vein
ip li sh tvrf >/dev/null 2>&1 && ip li del tvrf
nft list table testct >/dev/null 2>&1 && nft delete table testct

ip li add vein type veth peer veout
ip li add tvrf type vrf table 9876
ip li set veout master tvrf
ip li set vein up
ip li set veout up
ip li set tvrf up
/sbin/sysctl -w net.ipv4.conf.veout.accept_local=1
/sbin/sysctl -w net.ipv4.conf.veout.rp_filter=0
ip addr add $IPIN/$PFXL dev vein
ip addr add $IPOUT/$PFXL dev veout

nft -f - <<__END__
table testct {
	chain rawpre {
		type filter hook prerouting priority raw;
		iif { veout, tvrf } meta nftrace set 1
		iif veout ct zone set 1 return
		iif tvrf ct zone set 2 return
		notrack
	}
	chain rawout {
		type filter hook output priority raw;
		notrack
	}
}
__END__

uname -rv
conntrack -F
ping -W 1 -c 1 -I vein $IPOUT
conntrack -L

Signed-off-by: Eugene Crosser <crosser@average.org>
Acked-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1313,8 +1313,6 @@ static struct sk_buff *vrf_ip6_rcv(struc
 	bool need_strict = rt6_need_strict(&ipv6_hdr(skb)->daddr);
 	bool is_ndisc = ipv6_ndisc_frame(skb);
 
-	nf_reset_ct(skb);
-
 	/* loopback, multicast & non-ND link-local traffic; do not push through
 	 * packet taps again. Reset pkt_type for upper layers to process skb.
 	 * For strict packets with a source LLA, determine the dst using the
@@ -1371,8 +1369,6 @@ static struct sk_buff *vrf_ip_rcv(struct
 	skb->skb_iif = vrf_dev->ifindex;
 	IPCB(skb)->flags |= IPSKB_L3SLAVE;
 
-	nf_reset_ct(skb);
-
 	if (ipv4_is_multicast(ip_hdr(skb)->daddr))
 		goto out;
 


