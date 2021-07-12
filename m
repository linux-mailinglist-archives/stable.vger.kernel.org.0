Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EB33C46A8
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhGLG1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:27:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233704AbhGLG0Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:26:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 030F86115B;
        Mon, 12 Jul 2021 06:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626070999;
        bh=HEtL6vwoKalla3aGvjrHOEyczUxSRyu/QQj6RArDFPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrEd+LNo3VNarMHNlrtTK9jOAubUNEaagWTIXNN9ieka+XdxGe2XTJDjZyJ6kCR8V
         s8WOSJrvgNy0A4bB8nX71jefF03F/JBgLDH58DUYEtSPk9wUcDF7gVoi/CZmtMwpGr
         1uDhzkCRXS7owh1tDw7LJCL9vZImePZM9ZVj2C28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Tom Herbert <tom@quantonium.net>,
        Coco Li <lixiaoyan@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 231/348] ipv6: exthdrs: do not blindly use init_net
Date:   Mon, 12 Jul 2021 08:10:15 +0200
Message-Id: <20210712060732.767545395@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index ab5add0fe6b4..413a47ca43e9 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -305,7 +305,7 @@ fail_and_free:
 #endif
 
 	if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
-			  init_net.ipv6.sysctl.max_dst_opts_cnt)) {
+			  net->ipv6.sysctl.max_dst_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -844,7 +844,7 @@ fail_and_free:
 
 	opt->flags |= IP6SKB_HOPBYHOP;
 	if (ip6_parse_tlv(tlvprochopopt_lst, skb,
-			  init_net.ipv6.sysctl.max_hbh_opts_cnt)) {
+			  net->ipv6.sysctl.max_hbh_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 		opt->nhoff = sizeof(struct ipv6hdr);
-- 
2.30.2



