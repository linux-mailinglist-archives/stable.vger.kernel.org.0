Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F242C156607
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgBHSbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:31:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34784 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727969AbgBHS3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:50 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003iN-K9; Sat, 08 Feb 2020 18:29:42 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrN-000CX7-08; Sat, 08 Feb 2020 18:29:41 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Florian Westphal" <fw@strlen.de>,
        "Eric Dumazet" <edumazet@google.com>,
        "Yuchung Cheng" <ycheng@google.com>
Date:   Sat, 08 Feb 2020 18:21:20 +0000
Message-ID: <lsq.1581185941.885658072@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 141/148] tcp: syncookies: extend validity range
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 264ea103a7473f51aced838e68ed384ea2c759f5 upstream.

Now we allow storing more request socks per listener, we might
hit syncookie mode less often and hit following bug in our stack :

When we send a burst of syncookies, then exit this mode,
tcp_synq_no_recent_overflow() can return false if the ACK packets coming
from clients are coming three seconds after the end of syncookie
episode.

This is a way too strong requirement and conflicts with rest of
syncookie code which allows ACK to be aged up to 2 minutes.

Perfectly valid ACK packets are dropped just because clients might be
in a crowded wifi environment or on another planet.

So let's fix this, and also change tcp_synq_overflow() to not
dirty a cache line for every syncookie we send, as we are under attack.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Florian Westphal <fw@strlen.de>
Acked-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/net/tcp.h | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -326,18 +326,6 @@ static inline bool tcp_too_many_orphans(
 
 bool tcp_check_oom(struct sock *sk, int shift);
 
-/* syncookies: remember time of last synqueue overflow */
-static inline void tcp_synq_overflow(struct sock *sk)
-{
-	tcp_sk(sk)->rx_opt.ts_recent_stamp = jiffies;
-}
-
-/* syncookies: no recent synqueue overflow on this listening socket? */
-static inline bool tcp_synq_no_recent_overflow(const struct sock *sk)
-{
-	unsigned long last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
-	return time_after(jiffies, last_overflow + TCP_TIMEOUT_FALLBACK);
-}
 
 extern struct proto tcp_prot;
 
@@ -485,13 +473,35 @@ struct sock *cookie_v4_check(struct sock
  * i.e. a sent cookie is valid only at most for 2*60 seconds (or less if
  * the counter advances immediately after a cookie is generated).
  */
-#define MAX_SYNCOOKIE_AGE 2
+#define MAX_SYNCOOKIE_AGE	2
+#define TCP_SYNCOOKIE_PERIOD	(60 * HZ)
+#define TCP_SYNCOOKIE_VALID	(MAX_SYNCOOKIE_AGE * TCP_SYNCOOKIE_PERIOD)
+
+/* syncookies: remember time of last synqueue overflow
+ * But do not dirty this field too often (once per second is enough)
+ */
+static inline void tcp_synq_overflow(struct sock *sk)
+{
+	unsigned long last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
+	unsigned long now = jiffies;
+
+	if (time_after(now, last_overflow + HZ))
+		tcp_sk(sk)->rx_opt.ts_recent_stamp = now;
+}
+
+/* syncookies: no recent synqueue overflow on this listening socket? */
+static inline bool tcp_synq_no_recent_overflow(const struct sock *sk)
+{
+	unsigned long last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
+
+	return time_after(jiffies, last_overflow + TCP_SYNCOOKIE_VALID);
+}
 
 static inline u32 tcp_cookie_time(void)
 {
 	u64 val = get_jiffies_64();
 
-	do_div(val, 60 * HZ);
+	do_div(val, TCP_SYNCOOKIE_PERIOD);
 	return val;
 }
 

