Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4332A10BCFC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbfK0U7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:51462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731472AbfK0U7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:59:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F23D620678;
        Wed, 27 Nov 2019 20:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888389;
        bh=Dj2rTLwWDO1pOTVTST4jx2q+awzIqfqNPlMUZC3OWqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsznlbmbr25NJNYex7DI6GjxOVfLlugucqdLSRlzS1cqbvcztppSFlRlryd6B0G6m
         k0Kj+xAUQbuPg/nu97AwZOYfnSkJ6X1WvICLULGi+YPc0Mb7GAAAYd/J17UlHD0yon
         z+zmY5qidxyPAlLYLHDYesYpNU6CV4oOiC0qGmkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/306] sctp: use sk_wmem_queued to check for writable space
Date:   Wed, 27 Nov 2019 21:29:08 +0100
Message-Id: <20191127203122.043655005@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit cd305c74b0f8b49748a79a8f67fc8e5e3e0c4794 ]

sk->sk_wmem_queued is used to count the size of chunks in out queue
while sk->sk_wmem_alloc is for counting the size of chunks has been
sent. sctp is increasing both of them before enqueuing the chunks,
and using sk->sk_wmem_alloc to check for writable space.

However, sk_wmem_alloc is also increased by 1 for the skb allocked
for sending in sctp_packet_transmit() but it will not wake up the
waiters when sk_wmem_alloc is decreased in this skb's destructor.

If msg size is equal to sk_sndbuf and sendmsg is waiting for sndbuf,
the check 'msg_len <= sctp_wspace(asoc)' in sctp_wait_for_sndbuf()
will keep waiting if there's a skb allocked in sctp_packet_transmit,
and later even if this skb got freed, the waiting thread will never
get waked up.

This issue has been there since very beginning, so we change to use
sk->sk_wmem_queued to check for writable space as sk_wmem_queued is
not increased for the skb allocked for sending, also as TCP does.

SOCK_SNDBUF_LOCK check is also removed here as it's for tx buf auto
tuning which I will add in another patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 38 +++++++++-----------------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index c766315527226..e7a11cd7633f5 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -83,7 +83,7 @@
 #include <net/sctp/stream_sched.h>
 
 /* Forward declarations for internal helper functions. */
-static int sctp_writeable(struct sock *sk);
+static bool sctp_writeable(struct sock *sk);
 static void sctp_wfree(struct sk_buff *skb);
 static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 				size_t msg_len);
@@ -119,25 +119,10 @@ static void sctp_enter_memory_pressure(struct sock *sk)
 /* Get the sndbuf space available at the time on the association.  */
 static inline int sctp_wspace(struct sctp_association *asoc)
 {
-	int amt;
+	struct sock *sk = asoc->base.sk;
 
-	if (asoc->ep->sndbuf_policy)
-		amt = asoc->sndbuf_used;
-	else
-		amt = sk_wmem_alloc_get(asoc->base.sk);
-
-	if (amt >= asoc->base.sk->sk_sndbuf) {
-		if (asoc->base.sk->sk_userlocks & SOCK_SNDBUF_LOCK)
-			amt = 0;
-		else {
-			amt = sk_stream_wspace(asoc->base.sk);
-			if (amt < 0)
-				amt = 0;
-		}
-	} else {
-		amt = asoc->base.sk->sk_sndbuf - amt;
-	}
-	return amt;
+	return asoc->ep->sndbuf_policy ? sk->sk_sndbuf - asoc->sndbuf_used
+				       : sk_stream_wspace(sk);
 }
 
 /* Increment the used sndbuf space count of the corresponding association by
@@ -1928,10 +1913,10 @@ static int sctp_sendmsg_to_asoc(struct sctp_association *asoc,
 		asoc->pmtu_pending = 0;
 	}
 
-	if (sctp_wspace(asoc) < msg_len)
+	if (sctp_wspace(asoc) < (int)msg_len)
 		sctp_prsctp_prune(asoc, sinfo, msg_len - sctp_wspace(asoc));
 
-	if (!sctp_wspace(asoc)) {
+	if (sctp_wspace(asoc) <= 0) {
 		timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 		err = sctp_wait_for_sndbuf(asoc, &timeo, msg_len);
 		if (err)
@@ -8516,7 +8501,7 @@ static int sctp_wait_for_sndbuf(struct sctp_association *asoc, long *timeo_p,
 			goto do_error;
 		if (signal_pending(current))
 			goto do_interrupted;
-		if (msg_len <= sctp_wspace(asoc))
+		if ((int)msg_len <= sctp_wspace(asoc))
 			break;
 
 		/* Let another process have a go.  Since we are going
@@ -8591,14 +8576,9 @@ void sctp_write_space(struct sock *sk)
  * UDP-style sockets or TCP-style sockets, this code should work.
  *  - Daisy
  */
-static int sctp_writeable(struct sock *sk)
+static bool sctp_writeable(struct sock *sk)
 {
-	int amt = 0;
-
-	amt = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
-	if (amt < 0)
-		amt = 0;
-	return amt;
+	return sk->sk_sndbuf > sk->sk_wmem_queued;
 }
 
 /* Wait for an association to go into ESTABLISHED state. If timeout is 0,
-- 
2.20.1



