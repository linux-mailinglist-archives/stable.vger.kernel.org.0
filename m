Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DB5452388
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356434AbhKPB1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243710AbhKOTCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:02:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EF8D63369;
        Mon, 15 Nov 2021 18:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000109;
        bh=fi8Cd5wB2TbvpvtarpaccJeR/zlfELi7dA2L/kZIHY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOUKDUwrBxksbxM885BObptAqjxH6jshaQ68a5YcK9ueWLrR4afA+IrrUKTfwLE0r
         cXiirqr3y32KuwkaUtMxNpgKBB1cgKm+4CR4EMYMJiG02H1reYcc6fu8L2blt2/AjD
         VZQakly1lOpZZeBzbaof+8HLdoK8TxkpxbLGPrrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, Xintong Hu <huxintong@fb.com>
Subject: [PATCH 5.14 541/849] udp6: allow SO_MARK ctrl msg to affect routing
Date:   Mon, 15 Nov 2021 18:00:24 +0100
Message-Id: <20211115165438.563050915@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 42dcfd850e514b229d616a53dec06d0f2533217c ]

Commit c6af0c227a22 ("ip: support SO_MARK cmsg")
added propagation of SO_MARK from cmsg to skb->mark.
For IPv4 and raw sockets the mark also affects route
lookup, but in case of IPv6 the flow info is
initialized before cmsg is parsed.

Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
Reported-and-tested-by: Xintong Hu <huxintong@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ba77955d75fbd..6a990afc2eee7 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1435,7 +1435,6 @@ do_udp_sendmsg:
 	if (!fl6.flowi6_oif)
 		fl6.flowi6_oif = np->sticky_pktinfo.ipi6_ifindex;
 
-	fl6.flowi6_mark = ipc6.sockc.mark;
 	fl6.flowi6_uid = sk->sk_uid;
 
 	if (msg->msg_controllen) {
@@ -1471,6 +1470,7 @@ do_udp_sendmsg:
 	ipc6.opt = opt;
 
 	fl6.flowi6_proto = sk->sk_protocol;
+	fl6.flowi6_mark = ipc6.sockc.mark;
 	fl6.daddr = *daddr;
 	if (ipv6_addr_any(&fl6.saddr) && !ipv6_addr_any(&np->saddr))
 		fl6.saddr = np->saddr;
-- 
2.33.0



