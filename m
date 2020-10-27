Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA01E29AEAC
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1753925AbgJ0ODB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753919AbgJ0OC7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:02:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 832602222C;
        Tue, 27 Oct 2020 14:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807377;
        bh=Ais++pG+6XB4fGN/0vqtAOeM30gpQ2mRGJXGrBxiqac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mjt3wHtI7SGbhRW0M+8hilSpUEG7Yv5HSABRWM7/gWqvgW9drBCzCmmbJvYp1jN91
         dTNI7ptnviO5tOJMNjswDofmD1xJnbYa3fZVdoSkdHzCv5+3PR8Hc/mx2a65wdDjHZ
         NlxHTiSpUFZUOcdLcj1zftMJpqbg866ZEbce4nnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        "Sunmeet Gill (Sunny)" <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH 4.9 003/139] net/ipv4: always honour route mtu during forwarding
Date:   Tue, 27 Oct 2020 14:48:17 +0100
Message-Id: <20201027134902.306481654@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Maciej Żenczykowski" <maze@google.com>

[ Upstream commit 02a1b175b0e92d9e0fa5df3957ade8d733ceb6a0 ]

Documentation/networking/ip-sysctl.txt:46 says:
  ip_forward_use_pmtu - BOOLEAN
    By default we don't trust protocol path MTUs while forwarding
    because they could be easily forged and can lead to unwanted
    fragmentation by the router.
    You only need to enable this if you have user-space software
    which tries to discover path mtus by itself and depends on the
    kernel honoring this information. This is normally not the case.
    Default: 0 (disabled)
    Possible values:
    0 - disabled
    1 - enabled

Which makes it pretty clear that setting it to 1 is a potential
security/safety/DoS issue, and yet it is entirely reasonable to want
forwarded traffic to honour explicitly administrator configured
route mtus (instead of defaulting to device mtu).

Indeed, I can't think of a single reason why you wouldn't want to.
Since you configured a route mtu you probably know better...

It is pretty common to have a higher device mtu to allow receiving
large (jumbo) frames, while having some routes via that interface
(potentially including the default route to the internet) specify
a lower mtu.

Note that ipv6 forwarding uses device mtu unless the route is locked
(in which case it will use the route mtu).

This approach is not usable for IPv4 where an 'mtu lock' on a route
also has the side effect of disabling TCP path mtu discovery via
disabling the IPv4 DF (don't frag) bit on all outgoing frames.

I'm not aware of a way to lock a route from an IPv6 RA, so that also
potentially seems wrong.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Sunmeet Gill (Sunny) <sgill@quicinc.com>
Cc: Vinay Paradkar <vparadka@qti.qualcomm.com>
Cc: Tyler Wear <twear@quicinc.com>
Cc: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -342,12 +342,18 @@ static inline unsigned int ip_dst_mtu_ma
 						    bool forwarding)
 {
 	struct net *net = dev_net(dst->dev);
+	unsigned int mtu;
 
 	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding)
 		return dst_mtu(dst);
 
+	/* 'forwarding = true' case should always honour route mtu */
+	mtu = dst_metric_raw(dst, RTAX_MTU);
+	if (mtu)
+		return mtu;
+
 	return min(READ_ONCE(dst->dev->mtu), IP_MAX_MTU);
 }
 


