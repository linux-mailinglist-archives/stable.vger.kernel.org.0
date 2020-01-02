Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B847D12EC36
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgABWQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:16:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727664AbgABWQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:16:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B89222314;
        Thu,  2 Jan 2020 22:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003382;
        bh=k8aAuVRJ683WK/6R3uVaMaBtRvEM6na8sRTDflgRO4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2tulz9kuJJYJ0fDGf+rcpLZ+5OFcTIQThvY1TxkLTlUyCEJMqHZF0iP2yj1wXW1FZ
         kcN7PoN0yWV1rYJxOxM/HgaRvOZyKyD1l8jjZI+U1AUSSdmI1tIZL4aeg8mBoKTNpH
         SgcsOaKi2kml0+CdgcFrz9ftEG8LilGhxNXfP5qY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH 5.4 137/191] net/smc: add fallback check to connect()
Date:   Thu,  2 Jan 2020 23:06:59 +0100
Message-Id: <20200102215844.299599211@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>

commit 86434744fedf0cfe07a9eee3f4632c0e25c1d136 upstream.

FASTOPEN setsockopt() or sendmsg() may switch the SMC socket to fallback
mode. Once fallback mode is active, the native TCP socket functions are
called. Nevertheless there is a small race window, when FASTOPEN
setsockopt/sendmsg runs in parallel to a connect(), and switch the
socket into fallback mode before connect() takes the sock lock.
Make sure the SMC-specific connect setup is omitted in this case.

This way a syzbot-reported refcount problem is fixed, triggered by
different threads running non-blocking connect() and FASTOPEN_KEY
setsockopt.

Reported-by: syzbot+96d3f9ff6a86d37e44c8@syzkaller.appspotmail.com
Fixes: 6d6dd528d5af ("net/smc: fix refcount non-blocking connect() -part 2")
Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/smc/af_smc.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -854,6 +854,8 @@ static int smc_connect(struct socket *so
 		goto out;
 
 	sock_hold(&smc->sk); /* sock put in passive closing */
+	if (smc->use_fallback)
+		goto out;
 	if (flags & O_NONBLOCK) {
 		if (schedule_work(&smc->connect_work))
 			smc->connect_nonblock = 1;
@@ -1716,8 +1718,6 @@ static int smc_setsockopt(struct socket
 		sk->sk_err = smc->clcsock->sk->sk_err;
 		sk->sk_error_report(sk);
 	}
-	if (rc)
-		return rc;
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -1725,6 +1725,8 @@ static int smc_setsockopt(struct socket
 		return -EFAULT;
 
 	lock_sock(sk);
+	if (rc || smc->use_fallback)
+		goto out;
 	switch (optname) {
 	case TCP_ULP:
 	case TCP_FASTOPEN:
@@ -1736,15 +1738,14 @@ static int smc_setsockopt(struct socket
 			smc_switch_to_fallback(smc);
 			smc->fallback_rsn = SMC_CLC_DECL_OPTUNSUPP;
 		} else {
-			if (!smc->use_fallback)
-				rc = -EINVAL;
+			rc = -EINVAL;
 		}
 		break;
 	case TCP_NODELAY:
 		if (sk->sk_state != SMC_INIT &&
 		    sk->sk_state != SMC_LISTEN &&
 		    sk->sk_state != SMC_CLOSED) {
-			if (val && !smc->use_fallback)
+			if (val)
 				mod_delayed_work(system_wq, &smc->conn.tx_work,
 						 0);
 		}
@@ -1753,7 +1754,7 @@ static int smc_setsockopt(struct socket
 		if (sk->sk_state != SMC_INIT &&
 		    sk->sk_state != SMC_LISTEN &&
 		    sk->sk_state != SMC_CLOSED) {
-			if (!val && !smc->use_fallback)
+			if (!val)
 				mod_delayed_work(system_wq, &smc->conn.tx_work,
 						 0);
 		}
@@ -1764,6 +1765,7 @@ static int smc_setsockopt(struct socket
 	default:
 		break;
 	}
+out:
 	release_sock(sk);
 
 	return rc;


