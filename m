Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5283D42104B
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238696AbhJDNmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238438AbhJDNk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:40:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 210D56324C;
        Mon,  4 Oct 2021 13:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353521;
        bh=EMV0BO4WkbCyK2UzgFMNMPCHKceVyxffuyrhsxFJhnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2DHWFlNzipHlBwtMj4UqlCHMDOQ+U4d6BPmZEzhuV1T1vNhtEoDQD/f9WuxbuJjo
         Oq3gXeTlCs87MYRyYDyWA1Z4PD6xSLjIVXeiDjihJkW+AFmvo3hH0DfXPcRuMP9hdH
         L2+cq5Aeb6Zv9mX/Hjy5DWRsS3aFDZ8bdYp4///g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.14 160/172] net: udp: annotate data race around udp_sk(sk)->corkflag
Date:   Mon,  4 Oct 2021 14:53:30 +0200
Message-Id: <20211004125050.135125962@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit a9f5970767d11eadc805d5283f202612c7ba1f59 upstream.

up->corkflag field can be read or written without any lock.
Annotate accesses to avoid possible syzbot/KCSAN reports.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |   10 +++++-----
 net/ipv6/udp.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1053,7 +1053,7 @@ int udp_sendmsg(struct sock *sk, struct
 	__be16 dport;
 	u8  tos;
 	int err, is_udplite = IS_UDPLITE(sk);
-	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 	struct sk_buff *skb;
 	struct ip_options_data opt_copy;
@@ -1361,7 +1361,7 @@ int udp_sendpage(struct sock *sk, struct
 	}
 
 	up->len += size;
-	if (!(up->corkflag || (flags&MSG_MORE)))
+	if (!(READ_ONCE(up->corkflag) || (flags&MSG_MORE)))
 		ret = udp_push_pending_frames(sk);
 	if (!ret)
 		ret = size;
@@ -2662,9 +2662,9 @@ int udp_lib_setsockopt(struct sock *sk,
 	switch (optname) {
 	case UDP_CORK:
 		if (val != 0) {
-			up->corkflag = 1;
+			WRITE_ONCE(up->corkflag, 1);
 		} else {
-			up->corkflag = 0;
+			WRITE_ONCE(up->corkflag, 0);
 			lock_sock(sk);
 			push_pending_frames(sk);
 			release_sock(sk);
@@ -2787,7 +2787,7 @@ int udp_lib_getsockopt(struct sock *sk,
 
 	switch (optname) {
 	case UDP_CORK:
-		val = up->corkflag;
+		val = READ_ONCE(up->corkflag);
 		break;
 
 	case UDP_ENCAP:
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1303,7 +1303,7 @@ int udpv6_sendmsg(struct sock *sk, struc
 	int addr_len = msg->msg_namelen;
 	bool connected = false;
 	int ulen = len;
-	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int err;
 	int is_udplite = IS_UDPLITE(sk);
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);


