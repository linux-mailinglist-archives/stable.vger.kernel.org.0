Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7C94A403
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbfFRO3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:29:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50506 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729395AbfFRO3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 10:29:07 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6e-0007nL-6i; Tue, 18 Jun 2019 15:29:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6d-0000Hl-LZ; Tue, 18 Jun 2019 15:29:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Lemon" <jonathan.lemon@gmail.com>,
        "Jonathan Looney" <jtl@netflix.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Bruce Curtis" <brucec@netflix.com>
Date:   Tue, 18 Jun 2019 15:28:02 +0100
Message-ID: <lsq.1560868082.489417250@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 08/10] tcp: tcp_fragment() should apply sane memory
 limits
In-Reply-To: <lsq.1560868079.359853905@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.69-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit f070ef2ac66716357066b683fb0baf55f8191a2e upstream.

Jonathan Looney reported that a malicious peer can force a sender
to fragment its retransmit queue into tiny skbs, inflating memory
usage and/or overflow 32bit counters.

TCP allows an application to queue up to sk_sndbuf bytes,
so we need to give some allowance for non malicious splitting
of retransmit queue.

A new SNMP counter is added to monitor how many times TCP
did not allow to split an skb if the allowance was exceeded.

Note that this counter might increase in the case applications
use SO_SNDBUF socket option to lower sk_sndbuf.

CVE-2019-11478 : tcp_fragment, prevent fragmenting a packet when the
	socket is already using more than half the allowed space

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jonathan Looney <jtl@netflix.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Bruce Curtis <brucec@netflix.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Salvatore Bonaccorso: Adjust context for backport to 4.9.168]
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/uapi/linux/snmp.h | 1 +
 net/ipv4/proc.c           | 1 +
 net/ipv4/tcp_output.c     | 5 +++++
 3 files changed, 7 insertions(+)

--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -265,6 +265,7 @@ enum
 	LINUX_MIB_TCPWANTZEROWINDOWADV,		/* TCPWantZeroWindowAdv */
 	LINUX_MIB_TCPSYNRETRANS,		/* TCPSynRetrans */
 	LINUX_MIB_TCPORIGDATASENT,		/* TCPOrigDataSent */
+	LINUX_MIB_TCPWQUEUETOOBIG,		/* TCPWqueueTooBig */
 	__LINUX_MIB_MAX
 };
 
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -286,6 +286,7 @@ static const struct snmp_mib snmp4_net_l
 	SNMP_MIB_ITEM("TCPWantZeroWindowAdv", LINUX_MIB_TCPWANTZEROWINDOWADV),
 	SNMP_MIB_ITEM("TCPSynRetrans", LINUX_MIB_TCPSYNRETRANS),
 	SNMP_MIB_ITEM("TCPOrigDataSent", LINUX_MIB_TCPORIGDATASENT),
+	SNMP_MIB_ITEM("TCPWqueueTooBig", LINUX_MIB_TCPWQUEUETOOBIG),
 	SNMP_MIB_SENTINEL
 };
 
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1090,6 +1090,11 @@ int tcp_fragment(struct sock *sk, struct
 	if (nsize < 0)
 		nsize = 0;
 
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
+		return -ENOMEM;
+	}
+
 	if (skb_unclone(skb, gfp))
 		return -ENOMEM;
 

