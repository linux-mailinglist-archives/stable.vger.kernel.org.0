Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB7A4CE4C0
	for <lists+stable@lfdr.de>; Sat,  5 Mar 2022 13:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiCEM27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Mar 2022 07:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbiCEM25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Mar 2022 07:28:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDE940929
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 04:28:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 271A2B80BE8
        for <stable@vger.kernel.org>; Sat,  5 Mar 2022 12:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF3BC004E1;
        Sat,  5 Mar 2022 12:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646483283;
        bh=BiN4nJmlies1YbnRHKlq/lKJlSL71H2p55v5w+ez0wY=;
        h=Subject:To:Cc:From:Date:From;
        b=mLh9gT7556IbcUYdTjwt7cmUSKnYPdEQ9pkeL0ws3Kmwixh17NND5JupLN8Fse61g
         V7i/TyrWi9BjFfm2Zxf9qyc89lC1zz5SGOytaIfL8ApG//T1I/bIWzmqCLBIkxw3tP
         3TpSSfwIioHkFnrReSq3KMG976MzIwMEQn5VntxI=
Subject: FAILED: patch "[PATCH] net/smc: fix connection leak" failed to apply to 5.4-stable tree
To:     alibuda@linux.alibaba.com, davem@davemloft.net,
        kgraul@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Mar 2022 13:28:00 +0100
Message-ID: <16464832802030@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9f1c50cf39167ff71dc5953a3234f3f6eeb8fcb5 Mon Sep 17 00:00:00 2001
From: "D. Wythe" <alibuda@linux.alibaba.com>
Date: Thu, 24 Feb 2022 23:26:19 +0800
Subject: [PATCH] net/smc: fix connection leak

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

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 306d9e8cd1dd..81984c1c0e78 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -183,7 +183,7 @@ static int smc_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	struct smc_sock *smc;
-	int rc = 0;
+	int old_state, rc = 0;
 
 	if (!sk)
 		goto out;
@@ -191,8 +191,10 @@ static int smc_release(struct socket *sock)
 	sock_hold(sk); /* sock_put below */
 	smc = smc_sk(sk);
 
+	old_state = sk->sk_state;
+
 	/* cleanup for a dangling non-blocking connect */
-	if (smc->connect_nonblock && sk->sk_state == SMC_INIT)
+	if (smc->connect_nonblock && old_state == SMC_INIT)
 		tcp_abort(smc->clcsock->sk, ECONNABORTED);
 
 	if (cancel_work_sync(&smc->connect_work))
@@ -206,6 +208,10 @@ static int smc_release(struct socket *sock)
 	else
 		lock_sock(sk);
 
+	if (old_state == SMC_INIT && sk->sk_state == SMC_ACTIVE &&
+	    !smc->use_fallback)
+		smc_close_active_abort(smc);
+
 	rc = __smc_release(smc);
 
 	/* detach socket */

