Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 688C219C811
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 19:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389279AbgDBRdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 13:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388855AbgDBRc7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Apr 2020 13:32:59 -0400
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE4102078E;
        Thu,  2 Apr 2020 17:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585848779;
        bh=xEeA4td2khRhOha3SqO0h7+R3X1qiiXqEieDH6MS70I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIVd+1voyknPjPAkkWZNGW0S6uoaSNhffYlMxawIqE3fowTetS+Jvqf5KFA1lKmZ7
         DFyJX08SWYt6apK7Qq2ThcGQrkg4MprS/9Kb9QAoaoQR70QR9y7ydw5SUUVS2UMDOa
         T8GHW4iKM+Gko+5zrrocFzBUIaFR6Czou+NAV8YM=
From:   Will Deacon <will@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, g.nault@alphalink.fr,
        "phil.turnbull@oracle.com" <phil.turnbull@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 1/8] l2tp: Correctly return -EBADF from pppol2tp_getname.
Date:   Thu,  2 Apr 2020 18:32:43 +0100
Message-Id: <20200402173250.7858-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200402173250.7858-1-will@kernel.org>
References: <20200402173250.7858-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "phil.turnbull@oracle.com" <phil.turnbull@oracle.com>

commit 4ac36a4adaf80013a60013d6f829f5863d5d0e05 upstream.

If 'tunnel' is NULL we should return -EBADF but the 'end_put_sess' path
unconditionally sets 'error' back to zero. Rework the error path so it
more closely matches pppol2tp_sendmsg.

Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Will Deacon <will@kernel.org>
---
 net/l2tp/l2tp_ppp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index d3f1222c1a8c..bc5fca07d2ee 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -889,10 +889,8 @@ static int pppol2tp_getname(struct socket *sock, struct sockaddr *uaddr,
 
 	pls = l2tp_session_priv(session);
 	tunnel = l2tp_sock_to_tunnel(pls->tunnel_sock);
-	if (tunnel == NULL) {
-		error = -EBADF;
+	if (tunnel == NULL)
 		goto end_put_sess;
-	}
 
 	inet = inet_sk(tunnel->sock);
 	if ((tunnel->version == 2) && (tunnel->sock->sk_family == AF_INET)) {
@@ -970,12 +968,11 @@ static int pppol2tp_getname(struct socket *sock, struct sockaddr *uaddr,
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
-- 
2.26.0.rc2.310.g2932bb562d-goog

