Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40EF103F45
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732178AbfKTPma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:42:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52852 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730089AbfKTPkT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:19 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004bC-FJ; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004MK-8a; Wed, 20 Nov 2019 15:40:13 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Christophe JAILLET" <christophe.jaillet@wanadoo.fr>
Date:   Wed, 20 Nov 2019 15:38:21 +0000
Message-ID: <lsq.1574264230.856488270@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 71/83] ipv6: Fix the link time qualifier of
 'ping_v6_proc_exit_net()'
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit d23dbc479a8e813db4161a695d67da0e36557846 upstream.

The '.exit' functions from 'pernet_operations' structure should be marked
as __net_exit, not __net_init.

Fixes: d862e5461423 ("net: ipv6: Implement /proc/net/icmp6.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/ping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ping.c
+++ b/net/ipv6/ping.c
@@ -230,7 +230,7 @@ static int __net_init ping_v6_proc_init_
 	return ping_proc_register(net, &ping_v6_seq_afinfo);
 }
 
-static void __net_init ping_v6_proc_exit_net(struct net *net)
+static void __net_exit ping_v6_proc_exit_net(struct net *net)
 {
 	return ping_proc_unregister(net, &ping_v6_seq_afinfo);
 }

