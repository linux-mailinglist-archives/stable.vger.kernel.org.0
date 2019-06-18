Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5614A3F8
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729689AbfFRO3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:29:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50502 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729398AbfFRO3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 10:29:07 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6e-0007nM-6s; Tue, 18 Jun 2019 15:29:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6d-0000Hv-NI; Tue, 18 Jun 2019 15:29:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jonathan Looney" <jtl@netflix.com>,
        "Jonathan Lemon" <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Bruce Curtis" <brucec@netflix.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Yuchung Cheng" <ycheng@google.com>
Date:   Tue, 18 Jun 2019 15:28:02 +0100
Message-ID: <lsq.1560868082.743305100@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 09/10] tcp: add tcp_min_snd_mss sysctl
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

commit 5f3e2bf008c2221478101ee72f5cb4654b9fc363 upstream.

Some TCP peers announce a very small MSS option in their SYN and/or
SYN/ACK messages.

This forces the stack to send packets with a very high network/cpu
overhead.

Linux has enforced a minimal value of 48. Since this value includes
the size of TCP options, and that the options can consume up to 40
bytes, this means that each segment can include only 8 bytes of payload.

In some cases, it can be useful to increase the minimal value
to a saner value.

We still let the default to 48 (TCP_MIN_SND_MSS), for compatibility
reasons.

Note that TCP_MAXSEG socket option enforces a minimal value
of (TCP_MIN_MSS). David Miller increased this minimal value
in commit c39508d6f118 ("tcp: Make TCP_MAXSEG minimum more correct.")
from 64 to 88.

We might in the future merge TCP_MIN_SND_MSS and TCP_MIN_MSS.

CVE-2019-11479 -- tcp mss hardcoded to 48

Signed-off-by: Eric Dumazet <edumazet@google.com>
Suggested-by: Jonathan Looney <jtl@netflix.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Bruce Curtis <brucec@netflix.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Salvatore Bonaccorso: Backport for context changes in 4.9.168]
[bwh: Backported to 3.16: Make the sysctl global, consistent with
 net.ipv4.tcp_base_mss]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -210,6 +210,14 @@ tcp_base_mss - INTEGER
 	Path MTU discovery (MTU probing).  If MTU probing is enabled,
 	this is the initial MSS used by the connection.
 
+tcp_min_snd_mss - INTEGER
+	TCP SYN and SYNACK messages usually advertise an ADVMSS option,
+	as described in RFC 1122 and RFC 6691.
+	If this ADVMSS option is smaller than tcp_min_snd_mss,
+	it is silently capped to tcp_min_snd_mss.
+
+	Default : 48 (at least 8 bytes of payload per segment)
+
 tcp_congestion_control - STRING
 	Set the congestion control algorithm to be used for new
 	connections. The algorithm "reno" is always available, but
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -34,6 +34,8 @@ static int tcp_retr1_max = 255;
 static int ip_local_port_range_min[] = { 1, 1 };
 static int ip_local_port_range_max[] = { 65535, 65535 };
 static int tcp_adv_win_scale_min = -31;
+static int tcp_min_snd_mss_min = TCP_MIN_SND_MSS;
+static int tcp_min_snd_mss_max = 65535;
 static int tcp_adv_win_scale_max = 31;
 static int ip_ttl_min = 1;
 static int ip_ttl_max = 255;
@@ -608,6 +610,15 @@ static struct ctl_table ipv4_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "tcp_min_snd_mss",
+		.data		= &sysctl_tcp_min_snd_mss,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &tcp_min_snd_mss_min,
+		.extra2		= &tcp_min_snd_mss_max,
+	},
+	{
 		.procname	= "tcp_workaround_signed_windows",
 		.data		= &sysctl_tcp_workaround_signed_windows,
 		.maxlen		= sizeof(int),
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -61,6 +61,7 @@ int sysctl_tcp_tso_win_divisor __read_mo
 
 int sysctl_tcp_mtu_probing __read_mostly = 0;
 int sysctl_tcp_base_mss __read_mostly = TCP_BASE_MSS;
+int sysctl_tcp_min_snd_mss __read_mostly = TCP_MIN_SND_MSS;
 
 /* By default, RFC2861 behavior.  */
 int sysctl_tcp_slow_start_after_idle __read_mostly = 1;
@@ -1259,8 +1260,7 @@ static inline int __tcp_mtu_to_mss(struc
 	mss_now -= icsk->icsk_ext_hdr_len;
 
 	/* Then reserve room for full set of TCP options and 8 bytes of data */
-	if (mss_now < TCP_MIN_SND_MSS)
-		mss_now = TCP_MIN_SND_MSS;
+	mss_now = max(mss_now, sysctl_tcp_min_snd_mss);
 	return mss_now;
 }
 
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -270,6 +270,7 @@ extern int sysctl_tcp_moderate_rcvbuf;
 extern int sysctl_tcp_tso_win_divisor;
 extern int sysctl_tcp_mtu_probing;
 extern int sysctl_tcp_base_mss;
+extern int sysctl_tcp_min_snd_mss;
 extern int sysctl_tcp_workaround_signed_windows;
 extern int sysctl_tcp_slow_start_after_idle;
 extern int sysctl_tcp_thin_linear_timeouts;

