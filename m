Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E3E10BAD3
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732064AbfK0VG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:06:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:32984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732522AbfK0VG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:06:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F4BC217AB;
        Wed, 27 Nov 2019 21:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888817;
        bh=Z8WLsowTzZsW31wmmoVRggCv92659igdD967f0ESUVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRVc7AVYcxZzwTO6LTjnxPhsabEmNyTBfZb+J0kFNhxWdwNpOQtWrK/QyhGA2uBSL
         bWDxEM2oI8hng6MeGuarbiRgNW4XlaWOCSuR5eN3yVMsocvayFmMc7GHK86+wen2nO
         LPCbdu3tbLNeZyYY3AOcv4UzYEGShsV+1CCex78A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        David Barmann <david.barmann@stackpath.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 239/306] sock: Reset dst when changing sk_mark via setsockopt
Date:   Wed, 27 Nov 2019 21:31:29 +0100
Message-Id: <20191127203132.445420037@linuxfoundation.org>
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

From: David Barmann <david.barmann@stackpath.com>

[ Upstream commit 50254256f382c56bde87d970f3d0d02fdb76ec70 ]

When setting the SO_MARK socket option, if the mark changes, the dst
needs to be reset so that a new route lookup is performed.

This fixes the case where an application wants to change routing by
setting a new sk_mark.  If this is done after some packets have already
been sent, the dst is cached and has no effect.

Signed-off-by: David Barmann <david.barmann@stackpath.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index ba4f843cdd1d1..948fd687292a6 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -951,10 +951,12 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			clear_bit(SOCK_PASSSEC, &sock->flags);
 		break;
 	case SO_MARK:
-		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+		if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
 			ret = -EPERM;
-		else
+		} else if (val != sk->sk_mark) {
 			sk->sk_mark = val;
+			sk_dst_reset(sk);
+		}
 		break;
 
 	case SO_RXQ_OVFL:
-- 
2.20.1



