Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB9531A4FAF
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgDKMKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726715AbgDKMKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:10:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A0B42084D;
        Sat, 11 Apr 2020 12:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607046;
        bh=Lq+c0hsqiUVZu7vthld/EVB7dfPYmMTCezE13xmjMxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vbNNlrpRROXFUKWVnsCve8ghTQVG1FPONMsRuHeRobC0Fkb+05PaVv0sk1UNk+L5g
         1FLzDl13tVf5CIUbljHpwi1zLl3spvrK1AYeS6wV2rvcqeIV1ixu4jC7qrVuPrCjTr
         8Z8E2oPbfesbn0q2yIEMbHAYTwH7FuaQX4lcoMOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Turnbull <phil.turnbull@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 4.4 05/29] l2tp: Correctly return -EBADF from pppol2tp_getname.
Date:   Sat, 11 Apr 2020 14:08:35 +0200
Message-Id: <20200411115408.341698005@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115407.651296755@linuxfoundation.org>
References: <20200411115407.651296755@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: phil.turnbull@oracle.com <phil.turnbull@oracle.com>

commit 4ac36a4adaf80013a60013d6f829f5863d5d0e05 upstream.

If 'tunnel' is NULL we should return -EBADF but the 'end_put_sess' path
unconditionally sets 'error' back to zero. Rework the error path so it
more closely matches pppol2tp_sendmsg.

Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/l2tp/l2tp_ppp.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -889,10 +889,8 @@ static int pppol2tp_getname(struct socke
 
 	pls = l2tp_session_priv(session);
 	tunnel = l2tp_sock_to_tunnel(pls->tunnel_sock);
-	if (tunnel == NULL) {
-		error = -EBADF;
+	if (tunnel == NULL)
 		goto end_put_sess;
-	}
 
 	inet = inet_sk(tunnel->sock);
 	if ((tunnel->version == 2) && (tunnel->sock->sk_family == AF_INET)) {
@@ -970,12 +968,11 @@ static int pppol2tp_getname(struct socke
 	}
 
 	*usockaddr_len = len;
+	error = 0;
 
 	sock_put(pls->tunnel_sock);
 end_put_sess:
 	sock_put(sk);
-	error = 0;
-
 end:
 	return error;
 }


