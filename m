Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4128261697
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfGGTlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:41:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57886 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727655AbfGGTiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:15 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzD-0006kM-Cc; Sun, 07 Jul 2019 20:38:11 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0005g7-8Y; Sun, 07 Jul 2019 20:38:07 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Xin Long" <lucien.xin@gmail.com>, "Xiumei Mu" <xmu@redhat.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.656970295@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 120/129] pptp: dst_release sk_dst_cache in
 pptp_sock_destruct
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

commit 9417d81f4f8adfe20a12dd1fadf73a618cbd945d upstream.

sk_setup_caps() is called to set sk->sk_dst_cache in pptp_connect,
so we have to dst_release(sk->sk_dst_cache) in pptp_sock_destruct,
otherwise, the dst refcnt will leak.

It can be reproduced by this syz log:

  r1 = socket$pptp(0x18, 0x1, 0x2)
  bind$pptp(r1, &(0x7f0000000100)={0x18, 0x2, {0x0, @local}}, 0x1e)
  connect$pptp(r1, &(0x7f0000000000)={0x18, 0x2, {0x3, @remote}}, 0x1e)

Consecutive dmesg warnings will occur:

  unregister_netdevice: waiting for lo to become free. Usage count = 1

v1->v2:
  - use rcu_dereference_protected() instead of rcu_dereference_check(),
    as suggested by Eric.

Fixes: 00959ade36ac ("PPTP: PPP over IPv4 (Point-to-Point Tunneling Protocol)")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ppp/pptp.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -579,6 +579,7 @@ static void pptp_sock_destruct(struct so
 		pppox_unbind_sock(sk);
 	}
 	skb_queue_purge(&sk->sk_receive_queue);
+	dst_release(rcu_dereference_protected(sk->sk_dst_cache, 1));
 }
 
 static int pptp_create(struct net *net, struct socket *sock)

