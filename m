Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD871FB64B
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgFPPgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728917AbgFPPgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:36:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F9E02098B;
        Tue, 16 Jun 2020 15:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321768;
        bh=/kRiTW22n/YRbsgjLnLEa2C3qdhKObbL67ODnHqlvm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B/XYG42HpmJE3/yTQ56UBO1OfJDIun+8cQqT7ifprIBQZW+/8wOhhI0p0dqoHIuxZ
         AXFNRpADcpMHkiFVkwAsPhPrfXoYrCbQ4WY3Xmc4A/sUExf9239Ky/Y4ATXgfNfxRA
         7+euGdzs0K5sqqOdLmciGpbnU+fnZrQ+x+DbUsoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 001/134] ipv6: fix IPV6_ADDRFORM operation logic
Date:   Tue, 16 Jun 2020 17:33:05 +0200
Message-Id: <20200616153100.711684326@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
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
@@ -183,14 +183,15 @@ static int do_ipv6_setsockopt(struct soc
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


