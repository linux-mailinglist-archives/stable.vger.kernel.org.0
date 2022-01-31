Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97104A4409
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376915AbiAaLZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:25:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56280 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378073AbiAaLXj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:23:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C362B61207;
        Mon, 31 Jan 2022 11:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BA3C340E8;
        Mon, 31 Jan 2022 11:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628218;
        bh=wOrCoH8cZQ5RYeR+TboB30xbv1JXHCedW2gBQ1rg2yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ij4a6dZ8ao4+TDG8XjGgKB012/4x2zTueVNTgZla/bG1+O0iM7y2YWMBCrPdwF/hN
         GGsj65LrwDnggUKEgcax1aP/cZpw5a0+X6Z4o6kSRNCgZOgqXCjap+Q2lQYxoUOJMJ
         phM3tQaXWoF9hoqYCrPTBFQREPalCyOoId5IyzV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, caixf <ooppublic@163.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 161/200] ipv4: fix ip option filtering for locally generated fragments
Date:   Mon, 31 Jan 2022 11:57:04 +0100
Message-Id: <20220131105238.972317214@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 27a8caa59babb96c5890569e131bc0eb6d45daee ]

During IP fragmentation we sanitize IP options. This means overwriting
options which should not be copied with NOPs. Only the first fragment
has the original, full options.

ip_fraglist_prepare() copies the IP header and options from previous
fragment to the next one. Commit 19c3401a917b ("net: ipv4: place control
buffer handling away from fragmentation iterators") moved sanitizing
options before ip_fraglist_prepare() which means options are sanitized
and then overwritten again with the old values.

Fixing this is not enough, however, nor did the sanitization work
prior to aforementioned commit.

ip_options_fragment() (which does the sanitization) uses ipcb->opt.optlen
for the length of the options. ipcb->opt of fragments is not populated
(it's 0), only the head skb has the state properly built. So even when
called at the right time ip_options_fragment() does nothing. This seems
to date back all the way to v2.5.44 when the fast path for pre-fragmented
skbs had been introduced. Prior to that ip_options_build() would have been
called for every fragment (in fact ever since v2.5.44 the fragmentation
handing in ip_options_build() has been dead code, I'll clean it up in
-next).

In the original patch (see Link) caixf mentions fixing the handling
for fragments other than the second one, but I'm not sure how _any_
fragment could have had their options sanitized with the code
as it stood.

Tested with python (MTU on lo lowered to 1000 to force fragmentation):

  import socket
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
  s.setsockopt(socket.IPPROTO_IP, socket.IP_OPTIONS,
               bytearray([7,4,5,192, 20|0x80,4,1,0]))
  s.sendto(b'1'*2000, ('127.0.0.1', 1234))

Before:

IP (tos 0x0, ttl 64, id 1053, offset 0, flags [+], proto UDP (17), length 996, options (RR [bad length 4] [bad ptr 5] 192.148.4.1,,RA value 256))
    localhost.36500 > localhost.search-agent: UDP, length 2000
IP (tos 0x0, ttl 64, id 1053, offset 968, flags [+], proto UDP (17), length 996, options (RR [bad length 4] [bad ptr 5] 192.148.4.1,,RA value 256))
    localhost > localhost: udp
IP (tos 0x0, ttl 64, id 1053, offset 1936, flags [none], proto UDP (17), length 100, options (RR [bad length 4] [bad ptr 5] 192.148.4.1,,RA value 256))
    localhost > localhost: udp

After:

IP (tos 0x0, ttl 96, id 42549, offset 0, flags [+], proto UDP (17), length 996, options (RR [bad length 4] [bad ptr 5] 192.148.4.1,,RA value 256))
    localhost.51607 > localhost.search-agent: UDP, bad length 2000 > 960
IP (tos 0x0, ttl 96, id 42549, offset 968, flags [+], proto UDP (17), length 996, options (NOP,NOP,NOP,NOP,RA value 256))
    localhost > localhost: udp
IP (tos 0x0, ttl 96, id 42549, offset 1936, flags [none], proto UDP (17), length 100, options (NOP,NOP,NOP,NOP,RA value 256))
    localhost > localhost: udp

RA (20 | 0x80) is now copied as expected, RR (7) is "NOPed out".

Link: https://lore.kernel.org/netdev/20220107080559.122713-1-ooppublic@163.com/
Fixes: 19c3401a917b ("net: ipv4: place control buffer handling away from fragmentation iterators")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: caixf <ooppublic@163.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 9bca57ef8b838..ff38b46bd4b0f 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -826,15 +826,24 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		/* Everything is OK. Generate! */
 		ip_fraglist_init(skb, iph, hlen, &iter);
 
-		if (iter.frag)
-			ip_options_fragment(iter.frag);
-
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
 			if (iter.frag) {
+				bool first_frag = (iter.offset == 0);
+
 				IPCB(iter.frag)->flags = IPCB(skb)->flags;
 				ip_fraglist_prepare(skb, &iter);
+				if (first_frag && IPCB(skb)->opt.optlen) {
+					/* ipcb->opt is not populated for frags
+					 * coming from __ip_make_skb(),
+					 * ip_options_fragment() needs optlen
+					 */
+					IPCB(iter.frag)->opt.optlen =
+						IPCB(skb)->opt.optlen;
+					ip_options_fragment(iter.frag);
+					ip_send_check(iter.iph);
+				}
 			}
 
 			skb->tstamp = tstamp;
-- 
2.34.1



