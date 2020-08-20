Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119EC24B647
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbgHTKTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731369AbgHTKTQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:19:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D681820658;
        Thu, 20 Aug 2020 10:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918755;
        bh=RbLioRtwqIYvPCQRBQHY8oawWlkPDVdj5GuzGLh/pYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvr0vQpKed6GbDOCCLDQeOsfZSLoPJr8ZFXbVCBhQ2nEuWONiOwvO2ufo5qkI9dZn
         h++3nA1xOXTYEKYA95m037Y9Wd4WCDqESbkLBQKK7Hu1Ea2q6Ir0h4L6G110JabfsV
         Je/orPVtzWEQnJg/Z2kq5MLt0Ob5U/hMOEE3+DGc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 055/149] udp: drop corrupt packets earlier to avoid data corruption
Date:   Thu, 20 Aug 2020 11:22:12 +0200
Message-Id: <20200820092128.392955595@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

The v4.4 stable kernel lacks this bugfix:
commit 327868212381 ("make skb_copy_datagram_msg() et.al. preserve ->msg_iter on error").
As a result, the v4.4 kernel can deliver corrupt data to the application
when a corrupt UDP packet is closely followed by a valid UDP packet: the
same invocation of the recvmsg() syscall can deliver the corrupt packet's
UDP payload to the application with the UDP payload length and the
"from IP/Port" of the valid packet.

Details:

For a UDP packet longer than 76 bytes (see the v5.8-rc6 kernel's
include/linux/skbuff.h:3951), Linux delays the UDP checksum verification
until the application invokes the syscall recvmsg().

In the recvmsg() syscall handler, while Linux is copying the UDP payload
to the application's memory, it calculates the UDP checksum. If the
calculated checksum doesn't match the received checksum, Linux drops the
corrupt UDP packet, and then starts to process the next packet (if any),
and if the next packet is valid (i.e. the checksum is correct), Linux
will copy the valid UDP packet's payload to the application's receiver
buffer.

The bug is: before Linux starts to copy the valid UDP packet, the data
structure used to track how many more bytes should be copied to the
application memory is not reset to what it was when the application just
entered the kernel by the syscall! Consequently, only a small portion or
none of the valid packet's payload is copied to the application's
receive buffer, and later when the application exits from the kernel,
actually most of the application's receive buffer contains the payload
of the corrupt packet while recvmsg() returns the length of the UDP
payload of the valid packet.

For the mainline kernel, the bug was fixed in commit 327868212381,
but unluckily the bugfix is only backported to v4.9+. It turns out
backporting 327868212381 to v4.4 means that some supporting patches
must be backported first, so the overall changes seem too big, so the
alternative is performs the csum validation earlier and drops the
corrupt packets earlier.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 3 +--
 net/ipv6/udp.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 5464fd2102302..0d9f9d6251245 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1589,8 +1589,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
-	if (rcu_access_pointer(sk->sk_filter) &&
-	    udp_lib_checksum_complete(skb))
+	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
 
 	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 79c583004575a..be570cd7c9aed 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -686,10 +686,8 @@ int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		}
 	}
 
-	if (rcu_access_pointer(sk->sk_filter)) {
-		if (udp_lib_checksum_complete(skb))
-			goto csum_error;
-	}
+	if (udp_lib_checksum_complete(skb))
+		goto csum_error;
 
 	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
 		UDP6_INC_STATS_BH(sock_net(sk),
-- 
2.25.1



