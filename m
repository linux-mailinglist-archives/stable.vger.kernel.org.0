Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 110B31220E9
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfLQA7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:59:02 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34760 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbfLQAvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:37 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0003Ky-J7; Tue, 17 Dec 2019 00:51:31 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0005UJ-MJ; Tue, 17 Dec 2019 00:51:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Lorenzo Bianconi" <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date:   Tue, 17 Dec 2019 00:46:12 +0000
Message-ID: <lsq.1576543535.858518471@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 038/136] net: ipv4: use a dedicated counter for
 icmp_v4 redirect packets
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

commit c09551c6ff7fe16a79a42133bcecba5fc2fc3291 upstream.

According to the algorithm described in the comment block at the
beginning of ip_rt_send_redirect, the host should try to send
'ip_rt_redirect_number' ICMP redirect packets with an exponential
backoff and then stop sending them at all assuming that the destination
ignores redirects.
If the device has previously sent some ICMP error packets that are
rate-limited (e.g TTL expired) and continues to receive traffic,
the redirect packets will never be transmitted. This happens since
peer->rate_tokens will be typically greater than 'ip_rt_redirect_number'
and so it will never be reset even if the redirect silence timeout
(ip_rt_redirect_silence) has elapsed without receiving any packet
requiring redirects.

Fix it by using a dedicated counter for the number of ICMP redirect
packets that has been sent by the host

I have not been able to identify a given commit that introduced the
issue since ip_rt_send_redirect implements the same rate-limiting
algorithm from commit 1da177e4c3f4 ("Linux-2.6.12-rc2")

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 3.16: adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/inetpeer.h | 1 +
 net/ipv4/inetpeer.c    | 1 +
 net/ipv4/route.c       | 7 +++++--
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -35,6 +35,7 @@ struct inet_peer {
 
 	u32			metrics[RTAX_MAX];
 	u32			rate_tokens;	/* rate limiting for ICMP */
+	u32			n_redirects;
 	unsigned long		rate_last;
 	union {
 		struct list_head	gc_list;
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -485,6 +485,7 @@ relookup:
 		atomic_set(&p->rid, 0);
 		p->metrics[RTAX_LOCK-1] = INETPEER_METRICS_NEW;
 		p->rate_tokens = 0;
+		p->n_redirects = 0;
 		/* 60*HZ is arbitrary, but chosen enough high so that the first
 		 * calculation of tokens is at its maximum.
 		 */
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -872,13 +872,15 @@ void ip_rt_send_redirect(struct sk_buff
 	/* No redirected packets during ip_rt_redirect_silence;
 	 * reset the algorithm.
 	 */
-	if (time_after(jiffies, peer->rate_last + ip_rt_redirect_silence))
+	if (time_after(jiffies, peer->rate_last + ip_rt_redirect_silence)) {
 		peer->rate_tokens = 0;
+		peer->n_redirects = 0;
+	}
 
 	/* Too many ignored redirects; do not send anything
 	 * set dst.rate_last to the last seen redirected packet.
 	 */
-	if (peer->rate_tokens >= ip_rt_redirect_number) {
+	if (peer->n_redirects >= ip_rt_redirect_number) {
 		peer->rate_last = jiffies;
 		goto out_put_peer;
 	}
@@ -895,6 +897,7 @@ void ip_rt_send_redirect(struct sk_buff
 		icmp_send(skb, ICMP_REDIRECT, ICMP_REDIR_HOST, gw);
 		peer->rate_last = jiffies;
 		++peer->rate_tokens;
+		++peer->n_redirects;
 #ifdef CONFIG_IP_ROUTE_VERBOSE
 		if (log_martians &&
 		    peer->rate_tokens == ip_rt_redirect_number)

