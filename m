Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E012E451412
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348951AbhKOUBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:01:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344192AbhKOTYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96C12633BE;
        Mon, 15 Nov 2021 18:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002411;
        bh=SnTJ/WPBp361M+zgmvx6CElUGGmJEkA5OqYUPn2vcE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xmrGtcaJoQAY6x8PwDWU47pbyq/9mqtyiE241za57oav60pozZVaaAjuu8rdBQyJk
         b33xRYk9esyMvjDdoXwCu9qQpYdHMa65L3QJManbGEtOdrY28eNmG84k5nl1zya0xj
         HyCJaEYTV5SQMPjSdtj4aPvJGvtBP8VLm0rl2gvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, Xintong Hu <huxintong@fb.com>
Subject: [PATCH 5.15 555/917] udp6: allow SO_MARK ctrl msg to affect routing
Date:   Mon, 15 Nov 2021 18:00:50 +0100
Message-Id: <20211115165447.610850268@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 8d785232b4796..be6dc64ece29f 100644
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



