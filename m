Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB06CB9262
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388334AbfITOcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:32:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36688 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388328AbfITOZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:13 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqP-0004xz-Vr; Fri, 20 Sep 2019 15:25:10 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqF-0007vF-Q8; Fri, 20 Sep 2019 15:24:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "David Ahern" <dsahern@gmail.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.560226731@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 083/132] ipv4: Fix raw socket lookup for local traffic
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@gmail.com>

commit 19e4e768064a87b073a4b4c138b55db70e0cfb9f upstream.

inet_iif should be used for the raw socket lookup. inet_iif considers
rt_iif which handles the case of local traffic.

As it stands, ping to a local address with the '-I <dev>' option fails
ever since ping was changed to use SO_BINDTODEVICE instead of
cmsg + IP_PKTINFO.

IPv6 works fine.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/raw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -167,6 +167,7 @@ static int icmp_filter(const struct sock
  */
 static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 {
+	int dif = inet_iif(skb);
 	struct sock *sk;
 	struct hlist_head *head;
 	int delivered = 0;
@@ -179,8 +180,7 @@ static int raw_v4_input(struct sk_buff *
 
 	net = dev_net(skb->dev);
 	sk = __raw_v4_lookup(net, __sk_head(head), iph->protocol,
-			     iph->saddr, iph->daddr,
-			     skb->dev->ifindex);
+			     iph->saddr, iph->daddr, dif);
 
 	while (sk) {
 		delivered = 1;

