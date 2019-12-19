Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65FB9126C4B
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbfLSStD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:49:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbfLSStD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:49:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6AAF24683;
        Thu, 19 Dec 2019 18:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781342;
        bh=AymR5qxAwCK6CAvuXi2A7WqMJzdyKMalmH4cBmxL0W0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2EXe1ZHwkGlxbc9FII8hqTypEypDG3olnS5Tr+1Y2MXu+SkYI13iJddzxwJkWu5la
         PKy4mHISK9K7B1aCxfA8RggYxNgsRz7p1WG9mSeNJvZYuS7ytLnNzWMGBJHcSn1f4M
         wkuu138jGfYdJoFPQ4zllB+mje2sOyvOWyrkKd+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 183/199] tcp: tighten acceptance of ACKs not matching a child socket
Date:   Thu, 19 Dec 2019 19:34:25 +0100
Message-Id: <20191219183225.783038211@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit cb44a08f8647fd2e8db5cc9ac27cd8355fa392d8 ]

When no synflood occurs, the synflood timestamp isn't updated.
Therefore it can be so old that time_after32() can consider it to be
in the future.

That's a problem for tcp_synq_no_recent_overflow() as it may report
that a recent overflow occurred while, in fact, it's just that jiffies
has grown past 'last_overflow' + TCP_SYNCOOKIE_VALID + 2^31.

Spurious detection of recent overflows lead to extra syncookie
verification in cookie_v[46]_check(). At that point, the verification
should fail and the packet dropped. But we should have dropped the
packet earlier as we didn't even send a syncookie.

Let's refine tcp_synq_no_recent_overflow() to report a recent overflow
only if jiffies is within the
[last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval. This
way, no spurious recent overflow is reported when jiffies wraps and
'last_overflow' becomes in the future from the point of view of
time_after32().

However, if jiffies wraps and enters the
[last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval (with
'last_overflow' being a stale synflood timestamp), then
tcp_synq_no_recent_overflow() still erroneously reports an
overflow. In such cases, we have to rely on syncookie verification
to drop the packet. We unfortunately have no way to differentiate
between a fresh and a stale syncookie timestamp.

In practice, using last_overflow as lower bound is problematic.
If the synflood timestamp is concurrently updated between the time
we read jiffies and the moment we store the timestamp in
'last_overflow', then 'now' becomes smaller than 'last_overflow' and
tcp_synq_no_recent_overflow() returns true, potentially dropping a
valid syncookie.

Reading jiffies after loading the timestamp could fix the problem,
but that'd require a memory barrier. Let's just accommodate for
potential timestamp growth instead and extend the interval using
'last_overflow - HZ' as lower bound.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -506,7 +506,15 @@ static inline bool tcp_synq_no_recent_ov
 {
 	unsigned long last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
 
-	return time_after(jiffies, last_overflow + TCP_SYNCOOKIE_VALID);
+	/* If last_overflow <= jiffies <= last_overflow + TCP_SYNCOOKIE_VALID,
+	 * then we're under synflood. However, we have to use
+	 * 'last_overflow - HZ' as lower bound. That's because a concurrent
+	 * tcp_synq_overflow() could update .ts_recent_stamp after we read
+	 * jiffies but before we store .ts_recent_stamp into last_overflow,
+	 * which could lead to rejecting a valid syncookie.
+	 */
+	return !time_between32(jiffies, last_overflow - HZ,
+			       last_overflow + TCP_SYNCOOKIE_VALID);
 }
 
 static inline u32 tcp_cookie_time(void)


