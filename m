Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6BB3A6E3
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729136AbfFIQoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729135AbfFIQoL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:44:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B71732081C;
        Sun,  9 Jun 2019 16:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098651;
        bh=I7Kk0Jin7ZsRnXf5hqPiwaGo5gOFhZwM88vfYT0Ko5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWrKsOQ/HUaq9U/vtS67y5Eg9Z92pDDiPCqjsD9st4vOueuzJiSeoQpiCm8e9ZI7E
         thuKxwoiCHwBpftoyJi+xDvCm2FcGllnZDfjJVaxF4rap/F5hFONoyK6sulfeWGbzJ
         E9U8MSH4Z9HN+uyeGHS+T1AupA1uq7NhUs5l80sU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Beale <timbeale@catalyst.net.nz>,
        David Ahern <dsahern@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 12/70] udp: only choose unbound UDP socket for multicast when not in a VRF
Date:   Sun,  9 Jun 2019 18:41:23 +0200
Message-Id: <20190609164128.181383274@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Beale <timbeale@catalyst.net.nz>

[ Upstream commit 82ba25c6de200d7a9e9c970c998cdd6dfa8637ae ]

By default, packets received in another VRF should not be passed to an
unbound socket in the default VRF. This patch updates the IPv4 UDP
multicast logic to match the unicast VRF logic (in compute_score()),
as well as the IPv6 mcast logic (in __udp_v6_is_mcast_sock()).

The particular case I noticed was DHCP discover packets going
to the 255.255.255.255 address, which are handled by
__udp4_lib_mcast_deliver(). The previous code meant that running
multiple different DHCP server or relay agent instances across VRFs
did not work correctly - any server/relay agent in the default VRF
received DHCP discover packets for all other VRFs.

Fixes: 6da5b0f027a8 ("net: ensure unbound datagram socket to be chosen when not in a VRF")
Signed-off-by: Tim Beale <timbeale@catalyst.net.nz>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -538,8 +538,7 @@ static inline bool __udp_is_mcast_sock(s
 	    (inet->inet_dport != rmt_port && inet->inet_dport) ||
 	    (inet->inet_rcv_saddr && inet->inet_rcv_saddr != loc_addr) ||
 	    ipv6_only_sock(sk) ||
-	    (sk->sk_bound_dev_if && sk->sk_bound_dev_if != dif &&
-	     sk->sk_bound_dev_if != sdif))
+	    !udp_sk_bound_dev_eq(net, sk->sk_bound_dev_if, dif, sdif))
 		return false;
 	if (!ip_mc_sf_allow(sk, loc_addr, rmt_addr, dif, sdif))
 		return false;


