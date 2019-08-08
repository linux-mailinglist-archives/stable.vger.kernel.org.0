Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9364C86A41
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404716AbfHHTHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:07:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404713AbfHHTHj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:07:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D85BA218A4;
        Thu,  8 Aug 2019 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291259;
        bh=dBj3rOiVMKozMP5s+ljrpfpFrI7VYhQabjg66rnUpw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePAvmAlJXttDJGB+3LJ1RyX/J8q6b8AK4Iockd8GBJqoBm36ZAB0qHvXbUVcX2Phv
         uv8LOHUCY3IwXYlw9ZosERTAmP0WZf+bNicETpIEWxLM22Bj6ZQnDemRJfn+zfNoTz
         guikWsCE5wlSPfO4dgfqhv1Q0Cil6wmpQiuFjb+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+bd8cc73d665590a1fcad@syzkaller.appspotmail.com,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 48/56] net/smc: avoid fallback in case of non-blocking connect
Date:   Thu,  8 Aug 2019 21:05:14 +0200
Message-Id: <20190808190455.120071274@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

[ Upstream commit cd2063604ea6a8c2683b4eb9b5f4c4da74592d87 ]

FASTOPEN is not possible with SMC. sendmsg() with msg_flag MSG_FASTOPEN
triggers a fallback to TCP if the socket is in state SMC_INIT.
But if a nonblocking connect is already started, fallback to TCP
is no longer possible, even though the socket may still be in state
SMC_INIT.
And if a nonblocking connect is already started, a listen() call
does not make sense.

Reported-by: syzbot+bd8cc73d665590a1fcad@syzkaller.appspotmail.com
Fixes: 50717a37db032 ("net/smc: nonblocking connect rework")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -253,7 +253,7 @@ static int smc_bind(struct socket *sock,
 
 	/* Check if socket is already active */
 	rc = -EINVAL;
-	if (sk->sk_state != SMC_INIT)
+	if (sk->sk_state != SMC_INIT || smc->connect_nonblock)
 		goto out_rel;
 
 	smc->clcsock->sk->sk_reuse = sk->sk_reuse;
@@ -1399,7 +1399,8 @@ static int smc_listen(struct socket *soc
 	lock_sock(sk);
 
 	rc = -EINVAL;
-	if ((sk->sk_state != SMC_INIT) && (sk->sk_state != SMC_LISTEN))
+	if ((sk->sk_state != SMC_INIT && sk->sk_state != SMC_LISTEN) ||
+	    smc->connect_nonblock)
 		goto out;
 
 	rc = 0;
@@ -1527,7 +1528,7 @@ static int smc_sendmsg(struct socket *so
 		goto out;
 
 	if (msg->msg_flags & MSG_FASTOPEN) {
-		if (sk->sk_state == SMC_INIT) {
+		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
 			smc_switch_to_fallback(smc);
 			smc->fallback_rsn = SMC_CLC_DECL_OPTUNSUPP;
 		} else {


