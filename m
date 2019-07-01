Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7008F4A3F7
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729692AbfFRO3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:29:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50504 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729394AbfFRO3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 10:29:07 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6e-0007nJ-5U; Tue, 18 Jun 2019 15:29:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6d-0000Hh-Jm; Tue, 18 Jun 2019 15:29:03 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jonathan Lemon" <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Looney" <jtl@netflix.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Bruce Curtis" <brucec@netflix.com>
Date:   Tue, 18 Jun 2019 15:28:02 +0100
Message-ID: <lsq.1560868082.58770032@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 07/10] tcp: limit payload size of sacked skbs
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

commit 3b4929f65b0d8249f19a50245cd88ed1a2f78cff upstream.

Jonathan Looney reported that TCP can trigger the following crash
in tcp_shifted_skb() :

	BUG_ON(tcp_skb_pcount(skb) < pcount);

This can happen if the remote peer has advertized the smallest
MSS that linux TCP accepts : 48

An skb can hold 17 fragments, and each fragment can hold 32KB
on x86, or 64KB on PowerPC.

This means that the 16bit witdh of TCP_SKB_CB(skb)->tcp_gso_segs
can overflow.

Note that tcp_sendmsg() builds skbs with less than 64KB
of payload, so this problem needs SACK to be enabled.
SACK blocks allow TCP to coalesce multiple skbs in the retransmit
queue, thus filling the 17 fragments to maximal capacity.

CVE-2019-11477 -- u16 overflow of TCP_SKB_CB(skb)->tcp_gso_segs

Backport notes, provided by Joao Martins <joao.m.martins@oracle.com>

v4.15 or since commit 737ff314563 ("tcp: use sequence distance to
detect reordering") had switched from the packet-based FACK tracking and
switched to sequence-based.

v4.14 and older still have the old logic and hence on
tcp_skb_shift_data() needs to retain its original logic and have
@fack_count in sync. In other words, we keep the increment of pcount with
tcp_skb_pcount(skb) to later used that to update fack_count. To make it
more explicit we track the new skb that gets incremented to pcount in
@next_pcount, and we get to avoid the constant invocation of
tcp_skb_pcount(skb) all together.

Fixes: 832d11c5cd07 ("tcp: Try to restore large SKBs while SACK processing")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jonathan Looney <jtl@netflix.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Tyler Hicks <tyhicks@canonical.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Bruce Curtis <brucec@netflix.com>
Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Salvatore Bonaccorso: Adjust for context changes to backport to
4.9.168]
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/tcp.h   |  4 ++++
 include/net/tcp.h     |  2 ++
 net/ipv4/tcp.c        |  1 +
 net/ipv4/tcp_input.c  | 26 ++++++++++++++++++++------
 net/ipv4/tcp_output.c |  6 +++---
 5 files changed, 30 insertions(+), 9 deletions(-)

--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -394,4 +394,7 @@ static inline int fastopen_init_queue(st
 	return 0;
 }
 
+int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from, int pcount,
+		  int shiftlen);
+
 #endif	/* _LINUX_TCP_H */
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -55,6 +55,8 @@ void tcp_time_wait(struct sock *sk, int
 
 #define MAX_TCP_HEADER	(128 + MAX_HEADER)
 #define MAX_TCP_OPTION_SPACE 40
+#define TCP_MIN_SND_MSS		48
+#define TCP_MIN_GSO_SIZE	(TCP_MIN_SND_MSS - MAX_TCP_OPTION_SPACE)
 
 /* 
  * Never offer a window over 32767 without using window scaling. Some
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3169,6 +3169,7 @@ void __init tcp_init(void)
 	int max_rshare, max_wshare, cnt;
 	unsigned int i;
 
+	BUILD_BUG_ON(TCP_MIN_SND_MSS <= MAX_TCP_OPTION_SPACE);
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) > sizeof(skb->cb));
 
 	percpu_counter_init(&tcp_sockets_allocated, 0);
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1296,7 +1296,7 @@ static bool tcp_shifted_skb(struct sock
 	TCP_SKB_CB(skb)->seq += shifted;
 
 	skb_shinfo(prev)->gso_segs += pcount;
-	BUG_ON(skb_shinfo(skb)->gso_segs < pcount);
+	WARN_ON_ONCE(tcp_skb_pcount(skb) < pcount);
 	skb_shinfo(skb)->gso_segs -= pcount;
 
 	/* When we're adding to gso_segs == 1, gso_size will be zero,
@@ -1362,6 +1362,21 @@ static int skb_can_shift(const struct sk
 	return !skb_headlen(skb) && skb_is_nonlinear(skb);
 }
 
+int tcp_skb_shift(struct sk_buff *to, struct sk_buff *from,
+		  int pcount, int shiftlen)
+{
+	/* TCP min gso_size is 8 bytes (TCP_MIN_GSO_SIZE)
+	 * Since TCP_SKB_CB(skb)->tcp_gso_segs is 16 bits, we need
+	 * to make sure not storing more than 65535 * 8 bytes per skb,
+	 * even if current MSS is bigger.
+	 */
+	if (unlikely(to->len + shiftlen >= 65535 * TCP_MIN_GSO_SIZE))
+		return 0;
+	if (unlikely(tcp_skb_pcount(to) + pcount > 65535))
+		return 0;
+	return skb_shift(to, from, shiftlen);
+}
+
 /* Try collapsing SACK blocks spanning across multiple skbs to a single
  * skb.
  */
@@ -1373,6 +1388,7 @@ static struct sk_buff *tcp_shift_skb_dat
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *prev;
 	int mss;
+	int next_pcount;
 	int pcount = 0;
 	int len;
 	int in_sack;
@@ -1467,7 +1483,7 @@ static struct sk_buff *tcp_shift_skb_dat
 	if (!after(TCP_SKB_CB(skb)->seq + len, tp->snd_una))
 		goto fallback;
 
-	if (!skb_shift(prev, skb, len))
+	if (!tcp_skb_shift(prev, skb, pcount, len))
 		goto fallback;
 	if (!tcp_shifted_skb(sk, skb, state, pcount, len, mss, dup_sack))
 		goto out;
@@ -1486,9 +1502,10 @@ static struct sk_buff *tcp_shift_skb_dat
 		goto out;
 
 	len = skb->len;
-	if (skb_shift(prev, skb, len)) {
-		pcount += tcp_skb_pcount(skb);
-		tcp_shifted_skb(sk, skb, state, tcp_skb_pcount(skb), len, mss, 0);
+	next_pcount = tcp_skb_pcount(skb);
+	if (tcp_skb_shift(prev, skb, next_pcount, len)) {
+		pcount += next_pcount;
+		tcp_shifted_skb(sk, skb, state, next_pcount, len, mss, 0);
 	}
 
 out:
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1254,8 +1254,8 @@ static inline int __tcp_mtu_to_mss(struc
 	mss_now -= icsk->icsk_ext_hdr_len;
 
 	/* Then reserve room for full set of TCP options and 8 bytes of data */
-	if (mss_now < 48)
-		mss_now = 48;
+	if (mss_now < TCP_MIN_SND_MSS)
+		mss_now = TCP_MIN_SND_MSS;
 	return mss_now;
 }
 

