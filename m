Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65224A402
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 16:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbfFRO3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 10:29:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50510 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729386AbfFRO3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jun 2019 10:29:07 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6e-0007nN-9x; Tue, 18 Jun 2019 15:29:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hdF6d-0000I1-Oy; Tue, 18 Jun 2019 15:29:03 +0100
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
        "Eric Dumazet" <edumazet@google.com>,
        "Yuchung Cheng" <ycheng@google.com>,
        "Bruce Curtis" <brucec@netflix.com>,
        "Neal Cardwell" <ncardwell@google.com>,
        "Tyler Hicks" <tyhicks@canonical.com>
Date:   Tue, 18 Jun 2019 15:28:02 +0100
Message-ID: <lsq.1560868082.100664112@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 10/10] tcp: enforce tcp_min_snd_mss in tcp_mtu_probing()
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

commit 967c05aee439e6e5d7d805e195b3a20ef5c433d6 upstream.

If mtu probing is enabled tcp_mtu_probing() could very well end up
with a too small MSS.

Use the new sysctl tcp_min_snd_mss to make sure MSS search
is performed in an acceptable range.

CVE-2019-11479 -- tcp mss hardcoded to 48

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: Jonathan Looney <jtl@netflix.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Bruce Curtis <brucec@netflix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Salvatore Bonaccorso: Backport for context changes in 4.9.168]
[bwh: Backported to 3.16: The sysctl is global]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/tcp_timer.c | 1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -113,6 +113,7 @@ static void tcp_mtu_probing(struct inet_
 			mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
 			mss = min(sysctl_tcp_base_mss, mss);
 			mss = max(mss, 68 - tp->tcp_header_len);
+			mss = max(mss, sysctl_tcp_min_snd_mss);
 			icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
 			tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
 		}

