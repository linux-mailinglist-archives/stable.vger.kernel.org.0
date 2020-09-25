Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF262787FF
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgIYMvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:51:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbgIYMvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:51:54 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11FBB2072E;
        Fri, 25 Sep 2020 12:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038313;
        bh=FxJ6C7eb474ZPbTRHkZvfuv3o+nhcFshD6Gfbrc1PkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7mO9PwifhtDMl7vNI45N3Aw0iibW2Q5QnmE3sX0cThAQhhjgzcIscpB/VvcsYmSO
         OJNSQkMSLQcVPLLOtSbUCzEVXgFY9/CDPhw0lIbGVufvW0F04ir3xuVxCwjDRt2zVH
         lQDbb5ihFy7XVF6RjjMFf8EJKpFHvMhbLd9Qwwys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Ptasinski <hptasinski@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 24/43] net: sctp: Fix IPv6 ancestor_size calc in sctp_copy_descendant
Date:   Fri, 25 Sep 2020 14:48:36 +0200
Message-Id: <20200925124727.244835819@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Ptasinski <hptasinski@google.com>

[ Upstream commit fe81d9f6182d1160e625894eecb3d7ff0222cac5 ]

When calculating ancestor_size with IPv6 enabled, simply using
sizeof(struct ipv6_pinfo) doesn't account for extra bytes needed for
alignment in the struct sctp6_sock. On x86, there aren't any extra
bytes, but on ARM the ipv6_pinfo structure is aligned on an 8-byte
boundary so there were 4 pad bytes that were omitted from the
ancestor_size calculation.  This would lead to corruption of the
pd_lobby pointers, causing an oops when trying to free the sctp
structure on socket close.

Fixes: 636d25d557d1 ("sctp: not copy sctp_sock pd_lobby in sctp_copy_descendant")
Signed-off-by: Henry Ptasinski <hptasinski@google.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sctp/structs.h |    8 +++++---
 net/sctp/socket.c          |    9 +++------
 2 files changed, 8 insertions(+), 9 deletions(-)

--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -224,12 +224,14 @@ struct sctp_sock {
 		data_ready_signalled:1;
 
 	atomic_t pd_mode;
+
+	/* Fields after this point will be skipped on copies, like on accept
+	 * and peeloff operations
+	 */
+
 	/* Receive to here while partial delivery is in effect. */
 	struct sk_buff_head pd_lobby;
 
-	/* These must be the last fields, as they will skipped on copies,
-	 * like on accept and peeloff operations
-	 */
 	struct list_head auto_asconf_list;
 	int do_auto_asconf;
 };
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9337,13 +9337,10 @@ void sctp_copy_sock(struct sock *newsk,
 static inline void sctp_copy_descendant(struct sock *sk_to,
 					const struct sock *sk_from)
 {
-	int ancestor_size = sizeof(struct inet_sock) +
-			    sizeof(struct sctp_sock) -
-			    offsetof(struct sctp_sock, pd_lobby);
-
-	if (sk_from->sk_family == PF_INET6)
-		ancestor_size += sizeof(struct ipv6_pinfo);
+	size_t ancestor_size = sizeof(struct inet_sock);
 
+	ancestor_size += sk_from->sk_prot->obj_size;
+	ancestor_size -= offsetof(struct sctp_sock, pd_lobby);
 	__inet_sk_copy_descendant(sk_to, sk_from, ancestor_size);
 }
 


