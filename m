Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804184CFA5C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiCGKQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241304AbiCGKKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:10:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137522AC47;
        Mon,  7 Mar 2022 01:52:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B11C608C0;
        Mon,  7 Mar 2022 09:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76791C340F3;
        Mon,  7 Mar 2022 09:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646756;
        bh=QQZwPD84De21H+ZMZh51DFOVaela8nB1SraDpxQmZU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHFtMG0R3GbcaAdX2Nm93JP+4WQdaiXxYLyrlxucBmW2qP/9ReBvcQK1mjuY2ZRD0
         KoWrrNvcZwKOovRaL8bg7Ehj5dMRDkC6ULq9DNC9b6pUbo0D6ekmK+z8cnm4/jYirM
         M4h6nA53fImqLRidAFExnosfz6XOSPhWsUkCrz4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "D. Wythe" <alibuda@linux.alibaba.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 083/186] net/smc: fix connection leak
Date:   Mon,  7 Mar 2022 10:18:41 +0100
Message-Id: <20220307091656.407302327@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: D. Wythe <alibuda@linux.alibaba.com>

commit 9f1c50cf39167ff71dc5953a3234f3f6eeb8fcb5 upstream.

There's a potential leak issue under following execution sequence :

smc_release  				smc_connect_work
if (sk->sk_state == SMC_INIT)
					send_clc_confirim
	tcp_abort();
					...
					sk.sk_state = SMC_ACTIVE
smc_close_active
switch(sk->sk_state) {
...
case SMC_ACTIVE:
	smc_close_final()
	// then wait peer closed

Unfortunately, tcp_abort() may discard CLC CONFIRM messages that are
still in the tcp send buffer, in which case our connection token cannot
be delivered to the server side, which means that we cannot get a
passive close message at all. Therefore, it is impossible for the to be
disconnected at all.

This patch tries a very simple way to avoid this issue, once the state
has changed to SMC_ACTIVE after tcp_abort(), we can actively abort the
smc connection, considering that the state is SMC_INIT before
tcp_abort(), abandoning the complete disconnection process should not
cause too much problem.

In fact, this problem may exist as long as the CLC CONFIRM message is
not received by the server. Whether a timer should be added after
smc_close_final() needs to be discussed in the future. But even so, this
patch provides a faster release for connection in above case, it should
also be valuable.

Fixes: 39f41f367b08 ("net/smc: common release code for non-accepted sockets")
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/smc/af_smc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -183,7 +183,7 @@ static int smc_release(struct socket *so
 {
 	struct sock *sk = sock->sk;
 	struct smc_sock *smc;
-	int rc = 0;
+	int old_state, rc = 0;
 
 	if (!sk)
 		goto out;
@@ -191,8 +191,10 @@ static int smc_release(struct socket *so
 	sock_hold(sk); /* sock_put below */
 	smc = smc_sk(sk);
 
+	old_state = sk->sk_state;
+
 	/* cleanup for a dangling non-blocking connect */
-	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
+	if (smc->connect_nonblock && old_state == SMC_INIT)
 		tcp_abort(smc->clcsock->sk, ECONNABORTED);
 
 	if (cancel_work_sync(&smc->connect_work))
@@ -206,6 +208,10 @@ static int smc_release(struct socket *so
 	else
 		lock_sock(sk);
 
+	if (old_state == SMC_INIT && sk->sk_state == SMC_ACTIVE &&
+	    !smc->use_fallback)
+		smc_close_active_abort(smc);
+
 	rc = __smc_release(smc);
 
 	/* detach socket */


