Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 163F4126ADF
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfLSSvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:51:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730164AbfLSSvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:51:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2D3F2064B;
        Thu, 19 Dec 2019 18:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781503;
        bh=DZJ1+5zyITuuq1C8r02iDkyg4E+zE+4C5zXfwDYQ2IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sHgkj7VxPHMk19qVQ6W8Ph4mFNM6xfPAw1tnL/hYaM5pe/r8s+PnL5GM0Nf4cSRfv
         CBzXu2V8lXoaMzpJFUozGeQicFQwJNREQko1qdcZdcG318tKnEsqGW3cefgt2s6X5y
         KTRU7e45bf9U/K/FVDfo97HuijFHc+bJ2wGDQyqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 12/47] tcp: fix rejected syncookies due to stale timestamps
Date:   Thu, 19 Dec 2019 19:34:26 +0100
Message-Id: <20191219182909.020019049@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
References: <20191219182857.659088743@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 04d26e7b159a396372646a480f4caa166d1b6720 ]

If no synflood happens for a long enough period of time, then the
synflood timestamp isn't refreshed and jiffies can advance so much
that time_after32() can't accurately compare them any more.

Therefore, we can end up in a situation where time_after32(now,
last_overflow + HZ) returns false, just because these two values are
too far apart. In that case, the synflood timestamp isn't updated as
it should be, which can trick tcp_synq_no_recent_overflow() into
rejecting valid syncookies.

For example, let's consider the following scenario on a system
with HZ=1000:

  * The synflood timestamp is 0, either because that's the timestamp
    of the last synflood or, more commonly, because we're working with
    a freshly created socket.

  * We receive a new SYN, which triggers synflood protection. Let's say
    that this happens when jiffies == 2147484649 (that is,
    'synflood timestamp' + HZ + 2^31 + 1).

  * Then tcp_synq_overflow() doesn't update the synflood timestamp,
    because time_after32(2147484649, 1000) returns false.
    With:
      - 2147484649: the value of jiffies, aka. 'now'.
      - 1000: the value of 'last_overflow' + HZ.

  * A bit later, we receive the ACK completing the 3WHS. But
    cookie_v[46]_check() rejects it because tcp_synq_no_recent_overflow()
    says that we're not under synflood. That's because
    time_after32(2147484649, 120000) returns false.
    With:
      - 2147484649: the value of jiffies, aka. 'now'.
      - 120000: the value of 'last_overflow' + TCP_SYNCOOKIE_VALID.

    Of course, in reality jiffies would have increased a bit, but this
    condition will last for the next 119 seconds, which is far enough
    to accommodate for jiffie's growth.

Fix this by updating the overflow timestamp whenever jiffies isn't
within the [last_overflow, last_overflow + HZ] range. That shouldn't
have any performance impact since the update still happens at most once
per second.

Now we're guaranteed to have fresh timestamps while under synflood, so
tcp_synq_no_recent_overflow() can safely use it with time_after32() in
such situations.

Stale timestamps can still make tcp_synq_no_recent_overflow() return
the wrong verdict when not under synflood. This will be handled in the
next patch.

For 64 bits architectures, the problem was introduced with the
conversion of ->tw_ts_recent_stamp to 32 bits integer by commit
cca9bab1b72c ("tcp: use monotonic timestamps for PAWS").
The problem has always been there on 32 bits architectures.

Fixes: cca9bab1b72c ("tcp: use monotonic timestamps for PAWS")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/time.h |   13 +++++++++++++
 include/net/tcp.h    |    5 +++--
 2 files changed, 16 insertions(+), 2 deletions(-)

--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -96,4 +96,17 @@ static inline bool itimerspec64_valid(co
  */
 #define time_after32(a, b)	((s32)((u32)(b) - (u32)(a)) < 0)
 #define time_before32(b, a)	time_after32(a, b)
+
+/**
+ * time_between32 - check if a 32-bit timestamp is within a given time range
+ * @t:	the time which may be within [l,h]
+ * @l:	the lower bound of the range
+ * @h:	the higher bound of the range
+ *
+ * time_before32(t, l, h) returns true if @l <= @t <= @h. All operands are
+ * treated as 32-bit integers.
+ *
+ * Equivalent to !(time_before32(@t, @l) || time_after32(@t, @h)).
+ */
+#define time_between32(t, l, h) ((u32)(h) - (u32)(l) >= (u32)(t) - (u32)(l))
 #endif
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -485,14 +485,15 @@ static inline void tcp_synq_overflow(con
 		reuse = rcu_dereference(sk->sk_reuseport_cb);
 		if (likely(reuse)) {
 			last_overflow = READ_ONCE(reuse->synq_overflow_ts);
-			if (time_after32(now, last_overflow + HZ))
+			if (!time_between32(now, last_overflow,
+					    last_overflow + HZ))
 				WRITE_ONCE(reuse->synq_overflow_ts, now);
 			return;
 		}
 	}
 
 	last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
-	if (time_after32(now, last_overflow + HZ))
+	if (!time_between32(now, last_overflow, last_overflow + HZ))
 		tcp_sk(sk)->rx_opt.ts_recent_stamp = now;
 }
 


