Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A3429B370
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766581AbgJ0OtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766562AbgJ0OtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:49:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE46D21556;
        Tue, 27 Oct 2020 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810156;
        bh=nstPzUardyPZb8ENdyhzbw1WAnRVrR9xXGc9+0Og5QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBs7Um2FPQBnTO1aYEvItjXuwujlidt+ckzhPqtWXVjLL4Bq62qVJ2Vw2FcN/2ojF
         ZgVljkN1HoJrn5DgNaSpwQ5y5yaJS6cMvLwBHyeOPtBC8w4YnepoQMtxyZrGvj17CM
         8KDVQvjoB90EJsObA5wkE/rrTHZqrgG8z+C0rmWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Keyu Man <kman001@ucr.edu>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 039/633] icmp: randomize the global rate limiter
Date:   Tue, 27 Oct 2020 14:46:22 +0100
Message-Id: <20201027135524.529193341@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b38e7819cae946e2edf869e604af1e65a5d241c5 ]

Keyu Man reported that the ICMP rate limiter could be used
by attackers to get useful signal. Details will be provided
in an upcoming academic publication.

Our solution is to add some noise, so that the attackers
no longer can get help from the predictable token bucket limiter.

Fixes: 4cdf507d5452 ("icmp: add a global rate limitation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Keyu Man <kman001@ucr.edu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/ip-sysctl.rst |    4 +++-
 net/ipv4/icmp.c                        |    7 +++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1142,13 +1142,15 @@ icmp_ratelimit - INTEGER
 icmp_msgs_per_sec - INTEGER
 	Limit maximal number of ICMP packets sent per second from this host.
 	Only messages whose type matches icmp_ratemask (see below) are
-	controlled by this limit.
+	controlled by this limit. For security reasons, the precise count
+	of messages per second is randomized.
 
 	Default: 1000
 
 icmp_msgs_burst - INTEGER
 	icmp_msgs_per_sec controls number of ICMP packets sent per second,
 	while icmp_msgs_burst controls the burst size of these packets.
+	For security reasons, the precise burst size is randomized.
 
 	Default: 50
 
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -239,7 +239,7 @@ static struct {
 /**
  * icmp_global_allow - Are we allowed to send one more ICMP message ?
  *
- * Uses a token bucket to limit our ICMP messages to sysctl_icmp_msgs_per_sec.
+ * Uses a token bucket to limit our ICMP messages to ~sysctl_icmp_msgs_per_sec.
  * Returns false if we reached the limit and can not send another packet.
  * Note: called with BH disabled
  */
@@ -267,7 +267,10 @@ bool icmp_global_allow(void)
 	}
 	credit = min_t(u32, icmp_global.credit + incr, sysctl_icmp_msgs_burst);
 	if (credit) {
-		credit--;
+		/* We want to use a credit of one in average, but need to randomize
+		 * it for security reasons.
+		 */
+		credit = max_t(int, credit - prandom_u32_max(3), 0);
 		rc = true;
 	}
 	WRITE_ONCE(icmp_global.credit, credit);


