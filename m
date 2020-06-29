Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F49520D948
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731252AbgF2TqO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387813AbgF2Tkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A344624823;
        Mon, 29 Jun 2020 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444342;
        bh=YYH9/9u8iEL/EHEETw3ni/LmyLLLRD42T2C8/d7nQi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RezSRzUPuKjkFMnZFQ2YDEgJICvBox3wIb7UG9KtVnN0Y57f1nbZ9wHtrc3USXtVJ
         wZ8u3uY6KCNiflLJGKrvo65uTOiSLCVXONhP3nQiCy27G5uzk8rX7JtGFqbh/Ibh51
         EL1/gUcDumqIPQv5FXhN7IOSBX7ldIlEjX4KZ4h8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Corey Minyard <cminyard@mvista.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 017/178] sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket
Date:   Mon, 29 Jun 2020 11:22:42 -0400
Message-Id: <20200629152523.2494198-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 471e39df96b9a4c4ba88a2da9e25a126624d7a9c ]

If a socket is set ipv6only, it will still send IPv4 addresses in the
INIT and INIT_ACK packets. This potentially misleads the peer into using
them, which then would cause association termination.

The fix is to not add IPv4 addresses to ipv6only sockets.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Tested-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sctp/constants.h | 8 +++++---
 net/sctp/associola.c         | 5 ++++-
 net/sctp/bind_addr.c         | 1 +
 net/sctp/protocol.c          | 3 ++-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/net/sctp/constants.h b/include/net/sctp/constants.h
index 823afc42a3aa1..06e1deeef4640 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -341,11 +341,13 @@ enum {
 	 ipv4_is_anycast_6to4(a))
 
 /* Flags used for the bind address copy functions.  */
-#define SCTP_ADDR6_ALLOWED	0x00000001	/* IPv6 address is allowed by
+#define SCTP_ADDR4_ALLOWED	0x00000001	/* IPv4 address is allowed by
 						   local sock family */
-#define SCTP_ADDR4_PEERSUPP	0x00000002	/* IPv4 address is supported by
+#define SCTP_ADDR6_ALLOWED	0x00000002	/* IPv6 address is allowed by
+						   local sock family */
+#define SCTP_ADDR4_PEERSUPP	0x00000004	/* IPv4 address is supported by
 						   peer */
-#define SCTP_ADDR6_PEERSUPP	0x00000004	/* IPv6 address is supported by
+#define SCTP_ADDR6_PEERSUPP	0x00000008	/* IPv6 address is supported by
 						   peer */
 
 /* Reasons to retransmit. */
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 41839b85c2686..fb6f62264e874 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1569,12 +1569,15 @@ void sctp_assoc_rwnd_decrease(struct sctp_association *asoc, unsigned int len)
 int sctp_assoc_set_bind_addr_from_ep(struct sctp_association *asoc,
 				     enum sctp_scope scope, gfp_t gfp)
 {
+	struct sock *sk = asoc->base.sk;
 	int flags;
 
 	/* Use scoping rules to determine the subset of addresses from
 	 * the endpoint.
 	 */
-	flags = (PF_INET6 == asoc->base.sk->sk_family) ? SCTP_ADDR6_ALLOWED : 0;
+	flags = (PF_INET6 == sk->sk_family) ? SCTP_ADDR6_ALLOWED : 0;
+	if (!inet_v6_ipv6only(sk))
+		flags |= SCTP_ADDR4_ALLOWED;
 	if (asoc->peer.ipv4_address)
 		flags |= SCTP_ADDR4_PEERSUPP;
 	if (asoc->peer.ipv6_address)
diff --git a/net/sctp/bind_addr.c b/net/sctp/bind_addr.c
index 53bc61537f44f..701c5a4e441d9 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -461,6 +461,7 @@ static int sctp_copy_one_addr(struct net *net, struct sctp_bind_addr *dest,
 		 * well as the remote peer.
 		 */
 		if ((((AF_INET == addr->sa.sa_family) &&
+		      (flags & SCTP_ADDR4_ALLOWED) &&
 		      (flags & SCTP_ADDR4_PEERSUPP))) ||
 		    (((AF_INET6 == addr->sa.sa_family) &&
 		      (flags & SCTP_ADDR6_ALLOWED) &&
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 237c88eeb538b..981c7cbca46ad 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -148,7 +148,8 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *bp,
 		 * sock as well as the remote peer.
 		 */
 		if (addr->a.sa.sa_family == AF_INET &&
-		    !(copy_flags & SCTP_ADDR4_PEERSUPP))
+		    (!(copy_flags & SCTP_ADDR4_ALLOWED) ||
+		     !(copy_flags & SCTP_ADDR4_PEERSUPP)))
 			continue;
 		if (addr->a.sa.sa_family == AF_INET6 &&
 		    (!(copy_flags & SCTP_ADDR6_ALLOWED) ||
-- 
2.25.1

