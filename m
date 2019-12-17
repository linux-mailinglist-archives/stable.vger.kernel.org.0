Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEE7D12200E
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfLQAvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:51:45 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35398 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727101AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003M9-W4; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0005cm-GC; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thiemo Nagel" <tnagel@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>
Date:   Tue, 17 Dec 2019 00:47:28 +0000
Message-ID: <lsq.1576543535.259619921@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 114/136] dccp: do not leak jiffies on the wire
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

From: Eric Dumazet <edumazet@google.com>

commit 3d1e5039f5f87a8731202ceca08764ee7cb010d3 upstream.

For some reason I missed the case of DCCP passive
flows in my previous patch.

Fixes: a904a0693c18 ("inet: stop leaking jiffies on the wire")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Thiemo Nagel <tnagel@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/dccp/ipv4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -420,7 +420,7 @@ struct sock *dccp_v4_request_recv_sock(s
 	ireq->opt	   = NULL;
 	newinet->mc_index  = inet_iif(skb);
 	newinet->mc_ttl	   = ip_hdr(skb)->ttl;
-	newinet->inet_id   = jiffies;
+	newinet->inet_id   = prandom_u32();
 
 	if (dst == NULL && (dst = inet_csk_route_child_sock(sk, newsk, req)) == NULL)
 		goto put_and_exit;

