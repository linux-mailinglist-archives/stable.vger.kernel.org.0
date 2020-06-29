Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C395D20D880
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgF2Tjl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:39:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733011AbgF2Tad (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4123252DD;
        Mon, 29 Jun 2020 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445106;
        bh=lKaoxD5baWqBra+UjxTPw0o4s09kf96wr0Lu7J2gTcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCY+1uHOIrU5zc4T198b0f1DOnnRLSLQpgF/DJf9VRRNSrkBJ5ljpQlo5ThwU0wnJ
         VyUJQbJQM1Z6bZeDHYYmy3kvqiGMZ91Re3ZUpUMj3lwj5aMcWbbq3Le6mdq5cqf3Jx
         IWCUzdgDmsbylthNXIJ6AjK+Oij/sPj/z/hbxD+4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Corey Minyard <cminyard@mvista.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 14/78] sctp: Don't advertise IPv4 addresses if ipv6only is set on the socket
Date:   Mon, 29 Jun 2020 11:37:02 -0400
Message-Id: <20200629153806.2494953-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
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
index deaafa9b09cbe..d4da07048aa3e 100644
--- a/include/net/sctp/constants.h
+++ b/include/net/sctp/constants.h
@@ -361,11 +361,13 @@ enum {
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
index dd1a3bd80be5f..0a5764016721b 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1598,12 +1598,15 @@ void sctp_assoc_rwnd_decrease(struct sctp_association *asoc, unsigned int len)
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
index 7df3704982f54..38d01cfb313e5 100644
--- a/net/sctp/bind_addr.c
+++ b/net/sctp/bind_addr.c
@@ -453,6 +453,7 @@ static int sctp_copy_one_addr(struct net *net, struct sctp_bind_addr *dest,
 		 * well as the remote peer.
 		 */
 		if ((((AF_INET == addr->sa.sa_family) &&
+		      (flags & SCTP_ADDR4_ALLOWED) &&
 		      (flags & SCTP_ADDR4_PEERSUPP))) ||
 		    (((AF_INET6 == addr->sa.sa_family) &&
 		      (flags & SCTP_ADDR6_ALLOWED) &&
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 785456df75051..8fe9c06462052 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -213,7 +213,8 @@ int sctp_copy_local_addr_list(struct net *net, struct sctp_bind_addr *bp,
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

