Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B41134BB4
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730460AbgAHTqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43558 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730430AbgAHTqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:03 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006oc-1l; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dmc-1Z; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Lorenzo Colitti" <lorenzo@google.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "Arnd Bergmann" <arnd@arndb.de>
Date:   Wed, 08 Jan 2020 19:43:25 +0000
Message-ID: <lsq.1578512578.936131181@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 27/63] net: diag: support v4mapped sockets in
 inet_diag_find_one_icsk()
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 7c1306723ee916ea9f1fa7d9e4c7a6d029ca7aaf upstream.

Lorenzo reported that we could not properly find v4mapped sockets
in inet_diag_find_one_icsk(). This patch fixes the issue.

Reported-by: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -318,12 +318,18 @@ int inet_diag_dump_one_icsk(struct inet_
 	}
 #if IS_ENABLED(CONFIG_IPV6)
 	else if (req->sdiag_family == AF_INET6) {
-		sk = inet6_lookup(net, hashinfo,
-				  (struct in6_addr *)req->id.idiag_dst,
-				  req->id.idiag_dport,
-				  (struct in6_addr *)req->id.idiag_src,
-				  req->id.idiag_sport,
-				  req->id.idiag_if);
+		if (ipv6_addr_v4mapped((struct in6_addr *)req->id.idiag_dst) &&
+		    ipv6_addr_v4mapped((struct in6_addr *)req->id.idiag_src))
+			sk = inet_lookup(net, hashinfo, req->id.idiag_dst[3],
+					 req->id.idiag_dport, req->id.idiag_src[3],
+					 req->id.idiag_sport, req->id.idiag_if);
+		else
+			sk = inet6_lookup(net, hashinfo,
+					  (struct in6_addr *)req->id.idiag_dst,
+					  req->id.idiag_dport,
+					  (struct in6_addr *)req->id.idiag_src,
+					  req->id.idiag_sport,
+					  req->id.idiag_if);
 	}
 #endif
 	else {

