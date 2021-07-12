Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5AA3C4A0A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbhGLGsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:48:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235533AbhGLGrb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:47:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCE1E61351;
        Mon, 12 Jul 2021 06:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072189;
        bh=fad3El4TMV6/X6bLf5IxJTDO83Q6j01YkJMsUnhOHiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xg44DegXvmV38JhreFeFee31MUjLoVSzQ21+4NzwBETtC380Qmlli02lYkSOMr/L3
         +ZmezzREU7NB9PiO5PKW/Ck3JKIsBVkLJ2fz1lUGMd4Ec8JZNO/pLEwunKWBrjUc/L
         HaiXj/xI93iSNir1Srx7WAi2zOVruxFqLCFhUO90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@quantonium.net>,
        Coco Li <lixiaoyan@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 393/593] ipv6: exthdrs: do not blindly use init_net
Date:   Mon, 12 Jul 2021 08:09:13 +0200
Message-Id: <20210712060930.604337769@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bcc3f2a829b9edbe3da5fb117ee5a63686d31834 ]

I see no reason why max_dst_opts_cnt and max_hbh_opts_cnt
are fetched from the initial net namespace.

The other sysctls (max_dst_opts_len & max_hbh_opts_len)
are in fact already using the current ns.

Note: it is not clear why ipv6_destopt_rcv() use two ways to
get to the netns :

 1) dev_net(dst->dev)
    Originally used to increment IPSTATS_MIB_INHDRERRORS

 2) dev_net(skb->dev)
     Tom used this variant in his patch.

Maybe this calls to use ipv6_skb_net() instead ?

Fixes: 47d3d7ac656a ("ipv6: Implement limits on Hop-by-Hop and Destination options")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tom Herbert <tom@quantonium.net>
Cc: Coco Li <lixiaoyan@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/exthdrs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 374105e4394f..15223451cd7f 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -306,7 +306,7 @@ fail_and_free:
 #endif
 
 	if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
-			  init_net.ipv6.sysctl.max_dst_opts_cnt)) {
+			  net->ipv6.sysctl.max_dst_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -1041,7 +1041,7 @@ fail_and_free:
 
 	opt->flags |= IP6SKB_HOPBYHOP;
 	if (ip6_parse_tlv(tlvprochopopt_lst, skb,
-			  init_net.ipv6.sysctl.max_hbh_opts_cnt)) {
+			  net->ipv6.sysctl.max_hbh_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 		opt->nhoff = sizeof(struct ipv6hdr);
-- 
2.30.2



