Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825BC200B96
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgFSOfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726960AbgFSOfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:35:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08BAC206F1;
        Fri, 19 Jun 2020 14:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577332;
        bh=8K0DiG5m3/Kac9wy/hVtWgjJWdFjzTJoSPEQSyGP45k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mrqcYwsipb1oa6ReeSoYFTB3V9PTuoICR/wzid1rcP2LcW4ulNsQ94qe7kln8RzMg
         LD4QqJ38zLboxNIipL0P1utbG6AtPcajuitOHpZKDaWOqY42e4wgLpInwH/lXi+MIq
         he0dIDDngA8l8FQi7qjsCEQMLmUh+s62L9IOJnmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 001/101] ipv6: fix IPV6_ADDRFORM operation logic
Date:   Fri, 19 Jun 2020 16:31:50 +0200
Message-Id: <20200619141614.089740532@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 79a1f0ccdbb4ad700590f61b00525b390cb53905 ]

Socket option IPV6_ADDRFORM supports UDP/UDPLITE and TCP at present.
Previously the checking logic looks like:
if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
	do_some_check;
else if (sk->sk_protocol != IPPROTO_TCP)
	break;

After commit b6f6118901d1 ("ipv6: restrict IPV6_ADDRFORM operation"), TCP
was blocked as the logic changed to:
if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
	do_some_check;
else if (sk->sk_protocol == IPPROTO_TCP)
	do_some_check;
	break;
else
	break;

Then after commit 82c9ae440857 ("ipv6: fix restrict IPV6_ADDRFORM operation")
UDP/UDPLITE were blocked as the logic changed to:
if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
	do_some_check;
if (sk->sk_protocol == IPPROTO_TCP)
	do_some_check;

if (sk->sk_protocol != IPPROTO_TCP)
	break;

Fix it by using Eric's code and simply remove the break in TCP check, which
looks like:
if (sk->sk_protocol == IPPROTO_UDP || sk->sk_protocol == IPPROTO_UDPLITE)
	do_some_check;
else if (sk->sk_protocol == IPPROTO_TCP)
	do_some_check;
else
	break;

Fixes: 82c9ae440857 ("ipv6: fix restrict IPV6_ADDRFORM operation")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ipv6_sockglue.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -185,14 +185,15 @@ static int do_ipv6_setsockopt(struct soc
 					retv = -EBUSY;
 					break;
 				}
-			}
-			if (sk->sk_protocol == IPPROTO_TCP &&
-			    sk->sk_prot != &tcpv6_prot) {
-				retv = -EBUSY;
+			} else if (sk->sk_protocol == IPPROTO_TCP) {
+				if (sk->sk_prot != &tcpv6_prot) {
+					retv = -EBUSY;
+					break;
+				}
+			} else {
 				break;
 			}
-			if (sk->sk_protocol != IPPROTO_TCP)
-				break;
+
 			if (sk->sk_state != TCP_ESTABLISHED) {
 				retv = -ENOTCONN;
 				break;


