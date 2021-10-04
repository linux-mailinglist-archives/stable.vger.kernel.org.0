Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7113D420EB4
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbhJDN1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:27:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236208AbhJDNZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:25:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA49861C14;
        Mon,  4 Oct 2021 13:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353081;
        bh=Zir6WWtaZQgjcbiLvfVuEMCCOq2lBqseqnqrAjomzKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KP3e7oKjy8XvSM+8NIlbvGyUFW0kDjOAYEuFV3AATLPthmWe62/DB0p9F47IjpLWv
         xEdCYCfv7aORdd5IYUcsIfcQYKNUC9I5sqI9xzzGMFvOsMT+/5YZJ8NxGdWb1nvgP7
         VvXpLHWlusQGWt6qnFHh3VrJqXdYgkX7+anWQCQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 82/93] net: udp: annotate data race around udp_sk(sk)->corkflag
Date:   Mon,  4 Oct 2021 14:53:20 +0200
Message-Id: <20211004125037.316344203@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
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
@@ -1035,7 +1035,7 @@ int udp_sendmsg(struct sock *sk, struct
 	__be16 dport;
 	u8  tos;
 	int err, is_udplite = IS_UDPLITE(sk);
-	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 	struct sk_buff *skb;
 	struct ip_options_data opt_copy;
@@ -1343,7 +1343,7 @@ int udp_sendpage(struct sock *sk, struct
 	}
 
 	up->len += size;
-	if (!(up->corkflag || (flags&MSG_MORE)))
+	if (!(READ_ONCE(up->corkflag) || (flags&MSG_MORE)))
 		ret = udp_push_pending_frames(sk);
 	if (!ret)
 		ret = size;
@@ -2609,9 +2609,9 @@ int udp_lib_setsockopt(struct sock *sk,
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
@@ -2734,7 +2734,7 @@ int udp_lib_getsockopt(struct sock *sk,
 
 	switch (optname) {
 	case UDP_CORK:
-		val = up->corkflag;
+		val = READ_ONCE(up->corkflag);
 		break;
 
 	case UDP_ENCAP:
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1288,7 +1288,7 @@ int udpv6_sendmsg(struct sock *sk, struc
 	int addr_len = msg->msg_namelen;
 	bool connected = false;
 	int ulen = len;
-	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int err;
 	int is_udplite = IS_UDPLITE(sk);
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);


