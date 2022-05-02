Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396C15176EC
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 20:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiEBS5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 14:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230318AbiEBS47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 14:56:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9232B7EF
        for <stable@vger.kernel.org>; Mon,  2 May 2022 11:53:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9A2DB819C5
        for <stable@vger.kernel.org>; Mon,  2 May 2022 18:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A97C385A4;
        Mon,  2 May 2022 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651517606;
        bh=Jfsd4PUF0ciE5X1Wi7rW5eE0zJAxYmzwYypB397PGro=;
        h=Subject:To:Cc:From:Date:From;
        b=Ga6Ly4NwSqLglpHGa9HTK2Kp7H2XCTzamJHwYXb9gWP4bvY6XEH1Bz6nsfGKF42wm
         IsWc3g+92VD5AGNP7kUxnJqJ1/YUtSvqAQJdgyYIMx9Cxlkm7/L/dtFM+WbblCbYam
         z+nPqyqU6i4hnQU2mS7EKYIMEtmI4lmQSwsE5CGc=
Subject: FAILED: patch "[PATCH] net/smc: Fix slab-out-of-bounds issue in fallback" failed to apply to 5.17-stable tree
To:     guwen@linux.alibaba.com, kgraul@linux.ibm.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 May 2022 20:53:25 +0200
Message-ID: <1651517605157232@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0558226cebee256aa3f8ec0cc5a800a10bf120a6 Mon Sep 17 00:00:00 2001
From: Wen Gu <guwen@linux.alibaba.com>
Date: Fri, 22 Apr 2022 15:56:19 +0800
Subject: [PATCH] net/smc: Fix slab-out-of-bounds issue in fallback

syzbot reported a slab-out-of-bounds/use-after-free issue,
which was caused by accessing an already freed smc sock in
fallback-specific callback functions of clcsock.

This patch fixes the issue by restoring fallback-specific
callback functions to original ones and resetting clcsock
sk_user_data to NULL before freeing smc sock.

Meanwhile, this patch introduces sk_callback_lock to make
the access and assignment to sk_user_data mutually exclusive.

Reported-by: syzbot+b425899ed22c6943e00b@syzkaller.appspotmail.com
Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
Link: https://lore.kernel.org/r/00000000000013ca8105d7ae3ada@google.com/
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index d8433f17c5c9..fce16b9d6e1a 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -243,11 +243,27 @@ struct proto smc_proto6 = {
 };
 EXPORT_SYMBOL_GPL(smc_proto6);
 
+static void smc_fback_restore_callbacks(struct smc_sock *smc)
+{
+	struct sock *clcsk = smc->clcsock->sk;
+
+	write_lock_bh(&clcsk->sk_callback_lock);
+	clcsk->sk_user_data = NULL;
+
+	smc_clcsock_restore_cb(&clcsk->sk_state_change, &smc->clcsk_state_change);
+	smc_clcsock_restore_cb(&clcsk->sk_data_ready, &smc->clcsk_data_ready);
+	smc_clcsock_restore_cb(&clcsk->sk_write_space, &smc->clcsk_write_space);
+	smc_clcsock_restore_cb(&clcsk->sk_error_report, &smc->clcsk_error_report);
+
+	write_unlock_bh(&clcsk->sk_callback_lock);
+}
+
 static void smc_restore_fallback_changes(struct smc_sock *smc)
 {
 	if (smc->clcsock->file) { /* non-accepted sockets have no file yet */
 		smc->clcsock->file->private_data = smc->sk.sk_socket;
 		smc->clcsock->file = NULL;
+		smc_fback_restore_callbacks(smc);
 	}
 }
 
@@ -745,48 +761,57 @@ static void smc_fback_forward_wakeup(struct smc_sock *smc, struct sock *clcsk,
 
 static void smc_fback_state_change(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_state_change);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_state_change);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_data_ready(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_data_ready);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_data_ready);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_write_space(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_write_space);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_write_space);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_error_report(struct sock *clcsk)
 {
-	struct smc_sock *smc =
-		smc_clcsock_user_data(clcsk);
+	struct smc_sock *smc;
 
-	if (!smc)
-		return;
-	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_error_report);
+	read_lock_bh(&clcsk->sk_callback_lock);
+	smc = smc_clcsock_user_data(clcsk);
+	if (smc)
+		smc_fback_forward_wakeup(smc, clcsk,
+					 smc->clcsk_error_report);
+	read_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static void smc_fback_replace_callbacks(struct smc_sock *smc)
 {
 	struct sock *clcsk = smc->clcsock->sk;
 
+	write_lock_bh(&clcsk->sk_callback_lock);
 	clcsk->sk_user_data = (void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 
 	smc_clcsock_replace_cb(&clcsk->sk_state_change, smc_fback_state_change,
@@ -797,6 +822,8 @@ static void smc_fback_replace_callbacks(struct smc_sock *smc)
 			       &smc->clcsk_write_space);
 	smc_clcsock_replace_cb(&clcsk->sk_error_report, smc_fback_error_report,
 			       &smc->clcsk_error_report);
+
+	write_unlock_bh(&clcsk->sk_callback_lock);
 }
 
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
@@ -2370,17 +2397,20 @@ static void smc_tcp_listen_work(struct work_struct *work)
 
 static void smc_clcsock_data_ready(struct sock *listen_clcsock)
 {
-	struct smc_sock *lsmc =
-		smc_clcsock_user_data(listen_clcsock);
+	struct smc_sock *lsmc;
 
+	read_lock_bh(&listen_clcsock->sk_callback_lock);
+	lsmc = smc_clcsock_user_data(listen_clcsock);
 	if (!lsmc)
-		return;
+		goto out;
 	lsmc->clcsk_data_ready(listen_clcsock);
 	if (lsmc->sk.sk_state == SMC_LISTEN) {
 		sock_hold(&lsmc->sk); /* sock_put in smc_tcp_listen_work() */
 		if (!queue_work(smc_tcp_ls_wq, &lsmc->tcp_listen_work))
 			sock_put(&lsmc->sk);
 	}
+out:
+	read_unlock_bh(&listen_clcsock->sk_callback_lock);
 }
 
 static int smc_listen(struct socket *sock, int backlog)
@@ -2412,10 +2442,12 @@ static int smc_listen(struct socket *sock, int backlog)
 	/* save original sk_data_ready function and establish
 	 * smc-specific sk_data_ready function
 	 */
+	write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 	smc->clcsock->sk->sk_user_data =
 		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
 	smc_clcsock_replace_cb(&smc->clcsock->sk->sk_data_ready,
 			       smc_clcsock_data_ready, &smc->clcsk_data_ready);
+	write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 
 	/* save original ops */
 	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
@@ -2430,9 +2462,11 @@ static int smc_listen(struct socket *sock, int backlog)
 
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
+		write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 		smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
 				       &smc->clcsk_data_ready);
 		smc->clcsock->sk->sk_user_data = NULL;
+		write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 		goto out;
 	}
 	sk->sk_max_ack_backlog = backlog;
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 7bd1ef55b9df..31db7438857c 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -214,9 +214,11 @@ int smc_close_active(struct smc_sock *smc)
 		sk->sk_state = SMC_CLOSED;
 		sk->sk_state_change(sk); /* wake up accept */
 		if (smc->clcsock && smc->clcsock->sk) {
+			write_lock_bh(&smc->clcsock->sk->sk_callback_lock);
 			smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
 					       &smc->clcsk_data_ready);
 			smc->clcsock->sk->sk_user_data = NULL;
+			write_unlock_bh(&smc->clcsock->sk->sk_callback_lock);
 			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
 		}
 		smc_close_cleanup_listen(sk);

