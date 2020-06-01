Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DA61EAE70
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbgFASCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729900AbgFASCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:02:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 286D32073B;
        Mon,  1 Jun 2020 18:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034532;
        bh=CF/6RAc/H1vUJ3Q0XZsd6asmMAfIVyfNxYNu0uUyfrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxq0QpMMFoHxw8ajjBfdsLwEZEfnkin+MJ04ha2eUam+LoxeiBldYbODmh9qDQZTw
         nEdRZTVJ3mqv87dgG+Z1XJMDX1e1QnVxTKuVOO/gsuzRRET2yhGsOJHmlaCSkO2lIv
         RtnzBg53wu0z44Tbec8JQvjYv+G0cC3KGDgRtsm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.14 74/77] rxrpc: Fix transport sockopts to get IPv4 errors on an IPv6 socket
Date:   Mon,  1 Jun 2020 19:54:19 +0200
Message-Id: <20200601174029.015066757@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 37a675e768d7606fe8a53e0c459c9b53e121ac20 upstream.

It seems that enabling IPV6_RECVERR on an IPv6 socket doesn't also turn on
IP_RECVERR, so neither local errors nor ICMP-transported remote errors from
IPv4 peer addresses are returned to the AF_RXRPC protocol.

Make the sockopt setting code in rxrpc_open_socket() fall through from the
AF_INET6 case to the AF_INET case to turn on all the AF_INET options too in
the AF_INET6 case.

Fixes: f2aeed3a591f ("rxrpc: Fix error reception on AF_INET6 sockets")
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/rxrpc/local_object.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -134,10 +134,10 @@ static int rxrpc_open_socket(struct rxrp
 	}
 
 	switch (local->srx.transport.family) {
-	case AF_INET:
-		/* we want to receive ICMP errors */
+	case AF_INET6:
+		/* we want to receive ICMPv6 errors */
 		opt = 1;
-		ret = kernel_setsockopt(local->socket, SOL_IP, IP_RECVERR,
+		ret = kernel_setsockopt(local->socket, SOL_IPV6, IPV6_RECVERR,
 					(char *) &opt, sizeof(opt));
 		if (ret < 0) {
 			_debug("setsockopt failed");
@@ -145,19 +145,22 @@ static int rxrpc_open_socket(struct rxrp
 		}
 
 		/* we want to set the don't fragment bit */
-		opt = IP_PMTUDISC_DO;
-		ret = kernel_setsockopt(local->socket, SOL_IP, IP_MTU_DISCOVER,
+		opt = IPV6_PMTUDISC_DO;
+		ret = kernel_setsockopt(local->socket, SOL_IPV6, IPV6_MTU_DISCOVER,
 					(char *) &opt, sizeof(opt));
 		if (ret < 0) {
 			_debug("setsockopt failed");
 			goto error;
 		}
-		break;
 
-	case AF_INET6:
+		/* Fall through and set IPv4 options too otherwise we don't get
+		 * errors from IPv4 packets sent through the IPv6 socket.
+		 */
+
+	case AF_INET:
 		/* we want to receive ICMP errors */
 		opt = 1;
-		ret = kernel_setsockopt(local->socket, SOL_IPV6, IPV6_RECVERR,
+		ret = kernel_setsockopt(local->socket, SOL_IP, IP_RECVERR,
 					(char *) &opt, sizeof(opt));
 		if (ret < 0) {
 			_debug("setsockopt failed");
@@ -165,8 +168,8 @@ static int rxrpc_open_socket(struct rxrp
 		}
 
 		/* we want to set the don't fragment bit */
-		opt = IPV6_PMTUDISC_DO;
-		ret = kernel_setsockopt(local->socket, SOL_IPV6, IPV6_MTU_DISCOVER,
+		opt = IP_PMTUDISC_DO;
+		ret = kernel_setsockopt(local->socket, SOL_IP, IP_MTU_DISCOVER,
 					(char *) &opt, sizeof(opt));
 		if (ret < 0) {
 			_debug("setsockopt failed");


