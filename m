Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426C012C43F
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbfL2R15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:27:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728503AbfL2R14 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:27:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DFF6207FD;
        Sun, 29 Dec 2019 17:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640475;
        bh=mHelbzBaDL5sS0QeGBcuem0Qx333E3/P2yWgLrVpNtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XePQDMONurjlODieJm0WOCLMEEz7nPP831HyYbunJRaDMeoaW6ZlIP0VNNIX0EYLc
         1I4DiW4Que1SkGFQQ4Cy06HDgu61AjKn/N1dNVuev9xnu9dpiIk6eO0eytBiggdZxk
         zAQfXRZXfWCdyAKGkQRwGdBdXRZsTX8RhK92bYnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6dcbfea81cd3d4dd0b02@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 012/219] sctp: fully initialize v4 addr in some functions
Date:   Sun, 29 Dec 2019 18:16:54 +0100
Message-Id: <20191229162510.942428286@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit b6f3320b1d5267e7b583a6d0c88dda518101740c ]

Syzbot found a crash:

  BUG: KMSAN: uninit-value in crc32_body lib/crc32.c:112 [inline]
  BUG: KMSAN: uninit-value in crc32_le_generic lib/crc32.c:179 [inline]
  BUG: KMSAN: uninit-value in __crc32c_le_base+0x4fa/0xd30 lib/crc32.c:202
  Call Trace:
    crc32_body lib/crc32.c:112 [inline]
    crc32_le_generic lib/crc32.c:179 [inline]
    __crc32c_le_base+0x4fa/0xd30 lib/crc32.c:202
    chksum_update+0xb2/0x110 crypto/crc32c_generic.c:90
    crypto_shash_update+0x4c5/0x530 crypto/shash.c:107
    crc32c+0x150/0x220 lib/libcrc32c.c:47
    sctp_csum_update+0x89/0xa0 include/net/sctp/checksum.h:36
    __skb_checksum+0x1297/0x12a0 net/core/skbuff.c:2640
    sctp_compute_cksum include/net/sctp/checksum.h:59 [inline]
    sctp_packet_pack net/sctp/output.c:528 [inline]
    sctp_packet_transmit+0x40fb/0x4250 net/sctp/output.c:597
    sctp_outq_flush_transports net/sctp/outqueue.c:1146 [inline]
    sctp_outq_flush+0x1823/0x5d80 net/sctp/outqueue.c:1194
    sctp_outq_uncork+0xd0/0xf0 net/sctp/outqueue.c:757
    sctp_cmd_interpreter net/sctp/sm_sideeffect.c:1781 [inline]
    sctp_side_effects net/sctp/sm_sideeffect.c:1184 [inline]
    sctp_do_sm+0x8fe1/0x9720 net/sctp/sm_sideeffect.c:1155
    sctp_primitive_REQUESTHEARTBEAT+0x175/0x1a0 net/sctp/primitive.c:185
    sctp_apply_peer_addr_params+0x212/0x1d40 net/sctp/socket.c:2433
    sctp_setsockopt_peer_addr_params net/sctp/socket.c:2686 [inline]
    sctp_setsockopt+0x189bb/0x19090 net/sctp/socket.c:4672

The issue was caused by transport->ipaddr set with uninit addr param, which
was passed by:

  sctp_transport_init net/sctp/transport.c:47 [inline]
  sctp_transport_new+0x248/0xa00 net/sctp/transport.c:100
  sctp_assoc_add_peer+0x5ba/0x2030 net/sctp/associola.c:611
  sctp_process_param net/sctp/sm_make_chunk.c:2524 [inline]

where 'addr' is set by sctp_v4_from_addr_param(), and it doesn't initialize
the padding of addr->v4.

Later when calling sctp_make_heartbeat(), hbinfo.daddr(=transport->ipaddr)
will become the part of skb, and the issue occurs.

This patch is to fix it by initializing the padding of addr->v4 in
sctp_v4_from_addr_param(), as well as other functions that do the similar
thing, and these functions shouldn't trust that the caller initializes the
memory, as Marcelo suggested.

Reported-by: syzbot+6dcbfea81cd3d4dd0b02@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/protocol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -242,6 +242,7 @@ static void sctp_v4_from_skb(union sctp_
 		sa->sin_port = sh->dest;
 		sa->sin_addr.s_addr = ip_hdr(skb)->daddr;
 	}
+	memset(sa->sin_zero, 0, sizeof(sa->sin_zero));
 }
 
 /* Initialize an sctp_addr from a socket. */
@@ -250,6 +251,7 @@ static void sctp_v4_from_sk(union sctp_a
 	addr->v4.sin_family = AF_INET;
 	addr->v4.sin_port = 0;
 	addr->v4.sin_addr.s_addr = inet_sk(sk)->inet_rcv_saddr;
+	memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
 }
 
 /* Initialize sk->sk_rcv_saddr from sctp_addr. */
@@ -272,6 +274,7 @@ static void sctp_v4_from_addr_param(unio
 	addr->v4.sin_family = AF_INET;
 	addr->v4.sin_port = port;
 	addr->v4.sin_addr.s_addr = param->v4.addr.s_addr;
+	memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
 }
 
 /* Initialize an address parameter from a sctp_addr and return the length
@@ -296,6 +299,7 @@ static void sctp_v4_dst_saddr(union sctp
 	saddr->v4.sin_family = AF_INET;
 	saddr->v4.sin_port = port;
 	saddr->v4.sin_addr.s_addr = fl4->saddr;
+	memset(saddr->v4.sin_zero, 0, sizeof(saddr->v4.sin_zero));
 }
 
 /* Compare two addresses exactly. */
@@ -318,6 +322,7 @@ static void sctp_v4_inaddr_any(union sct
 	addr->v4.sin_family = AF_INET;
 	addr->v4.sin_addr.s_addr = htonl(INADDR_ANY);
 	addr->v4.sin_port = port;
+	memset(addr->v4.sin_zero, 0, sizeof(addr->v4.sin_zero));
 }
 
 /* Is this a wildcard address? */


