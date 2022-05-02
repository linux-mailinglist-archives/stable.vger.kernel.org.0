Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435B75176E9
	for <lists+stable@lfdr.de>; Mon,  2 May 2022 20:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiEBS4l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 May 2022 14:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiEBS4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 May 2022 14:56:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D951360E4
        for <stable@vger.kernel.org>; Mon,  2 May 2022 11:53:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96144B819C9
        for <stable@vger.kernel.org>; Mon,  2 May 2022 18:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB04C385A4;
        Mon,  2 May 2022 18:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651517587;
        bh=sw0yvnSTkchFjqDRFiQ92+kQlE301yv8SUq4P2TbevA=;
        h=Subject:To:Cc:From:Date:From;
        b=AEuJE+abWwQGRwN5taBN01Z/1K/C0gZBZ3x9plLCuMcHNaXhg9B7+1RFH1TaipkKj
         Gq1OO1UxILE43yWn9KeCxM7R8SLq72lkvELWZxWbYsipp4SDI9Occh+qhbt+1HyncL
         rWYVrpI0vc4TG64FVAJ27lJolq0aM/nEf5hdbTGQ=
Subject: FAILED: patch "[PATCH] net/smc: Only save the original clcsock callback functions" failed to apply to 5.17-stable tree
To:     guwen@linux.alibaba.com, kgraul@linux.ibm.com, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 May 2022 20:53:06 +0200
Message-ID: <165151758614844@kroah.com>
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

From 97b9af7a70936e331170c79040cc9bf20071b566 Mon Sep 17 00:00:00 2001
From: Wen Gu <guwen@linux.alibaba.com>
Date: Fri, 22 Apr 2022 15:56:18 +0800
Subject: [PATCH] net/smc: Only save the original clcsock callback functions

Both listen and fallback process will save the current clcsock
callback functions and establish new ones. But if both of them
happen, the saved callback functions will be overwritten.

So this patch introduces some helpers to ensure that only save
the original callback functions of clcsock.

Fixes: 341adeec9ada ("net/smc: Forward wakeup to smc socket waitqueue after fallback")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Acked-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index bbb1a4ce5050..d8433f17c5c9 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -373,6 +373,7 @@ static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
 	sk->sk_prot->hash(sk);
 	sk_refcnt_debug_inc(sk);
 	mutex_init(&smc->clcsock_release_lock);
+	smc_init_saved_callbacks(smc);
 
 	return sk;
 }
@@ -782,9 +783,24 @@ static void smc_fback_error_report(struct sock *clcsk)
 	smc_fback_forward_wakeup(smc, clcsk, smc->clcsk_error_report);
 }
 
+static void smc_fback_replace_callbacks(struct smc_sock *smc)
+{
+	struct sock *clcsk = smc->clcsock->sk;
+
+	clcsk->sk_user_data = (void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+
+	smc_clcsock_replace_cb(&clcsk->sk_state_change, smc_fback_state_change,
+			       &smc->clcsk_state_change);
+	smc_clcsock_replace_cb(&clcsk->sk_data_ready, smc_fback_data_ready,
+			       &smc->clcsk_data_ready);
+	smc_clcsock_replace_cb(&clcsk->sk_write_space, smc_fback_write_space,
+			       &smc->clcsk_write_space);
+	smc_clcsock_replace_cb(&clcsk->sk_error_report, smc_fback_error_report,
+			       &smc->clcsk_error_report);
+}
+
 static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 {
-	struct sock *clcsk;
 	int rc = 0;
 
 	mutex_lock(&smc->clcsock_release_lock);
@@ -792,10 +808,7 @@ static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		rc = -EBADF;
 		goto out;
 	}
-	clcsk = smc->clcsock->sk;
 
-	if (smc->use_fallback)
-		goto out;
 	smc->use_fallback = true;
 	smc->fallback_rsn = reason_code;
 	smc_stat_fallback(smc);
@@ -810,18 +823,7 @@ static int smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
 		 * in smc sk->sk_wq and they should be woken up
 		 * as clcsock's wait queue is woken up.
 		 */
-		smc->clcsk_state_change = clcsk->sk_state_change;
-		smc->clcsk_data_ready = clcsk->sk_data_ready;
-		smc->clcsk_write_space = clcsk->sk_write_space;
-		smc->clcsk_error_report = clcsk->sk_error_report;
-
-		clcsk->sk_state_change = smc_fback_state_change;
-		clcsk->sk_data_ready = smc_fback_data_ready;
-		clcsk->sk_write_space = smc_fback_write_space;
-		clcsk->sk_error_report = smc_fback_error_report;
-
-		smc->clcsock->sk->sk_user_data =
-			(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+		smc_fback_replace_callbacks(smc);
 	}
 out:
 	mutex_unlock(&smc->clcsock_release_lock);
@@ -1596,6 +1598,19 @@ static int smc_clcsock_accept(struct smc_sock *lsmc, struct smc_sock **new_smc)
 	 * function; switch it back to the original sk_data_ready function
 	 */
 	new_clcsock->sk->sk_data_ready = lsmc->clcsk_data_ready;
+
+	/* if new clcsock has also inherited the fallback-specific callback
+	 * functions, switch them back to the original ones.
+	 */
+	if (lsmc->use_fallback) {
+		if (lsmc->clcsk_state_change)
+			new_clcsock->sk->sk_state_change = lsmc->clcsk_state_change;
+		if (lsmc->clcsk_write_space)
+			new_clcsock->sk->sk_write_space = lsmc->clcsk_write_space;
+		if (lsmc->clcsk_error_report)
+			new_clcsock->sk->sk_error_report = lsmc->clcsk_error_report;
+	}
+
 	(*new_smc)->clcsock = new_clcsock;
 out:
 	return rc;
@@ -2397,10 +2412,10 @@ static int smc_listen(struct socket *sock, int backlog)
 	/* save original sk_data_ready function and establish
 	 * smc-specific sk_data_ready function
 	 */
-	smc->clcsk_data_ready = smc->clcsock->sk->sk_data_ready;
-	smc->clcsock->sk->sk_data_ready = smc_clcsock_data_ready;
 	smc->clcsock->sk->sk_user_data =
 		(void *)((uintptr_t)smc | SK_USER_DATA_NOCOPY);
+	smc_clcsock_replace_cb(&smc->clcsock->sk->sk_data_ready,
+			       smc_clcsock_data_ready, &smc->clcsk_data_ready);
 
 	/* save original ops */
 	smc->ori_af_ops = inet_csk(smc->clcsock->sk)->icsk_af_ops;
@@ -2415,7 +2430,9 @@ static int smc_listen(struct socket *sock, int backlog)
 
 	rc = kernel_listen(smc->clcsock, backlog);
 	if (rc) {
-		smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
+		smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
+				       &smc->clcsk_data_ready);
+		smc->clcsock->sk->sk_user_data = NULL;
 		goto out;
 	}
 	sk->sk_max_ack_backlog = backlog;
diff --git a/net/smc/smc.h b/net/smc/smc.h
index ea0620529ebe..5ed765ea0c73 100644
--- a/net/smc/smc.h
+++ b/net/smc/smc.h
@@ -288,12 +288,41 @@ static inline struct smc_sock *smc_sk(const struct sock *sk)
 	return (struct smc_sock *)sk;
 }
 
+static inline void smc_init_saved_callbacks(struct smc_sock *smc)
+{
+	smc->clcsk_state_change	= NULL;
+	smc->clcsk_data_ready	= NULL;
+	smc->clcsk_write_space	= NULL;
+	smc->clcsk_error_report	= NULL;
+}
+
 static inline struct smc_sock *smc_clcsock_user_data(const struct sock *clcsk)
 {
 	return (struct smc_sock *)
 	       ((uintptr_t)clcsk->sk_user_data & ~SK_USER_DATA_NOCOPY);
 }
 
+/* save target_cb in saved_cb, and replace target_cb with new_cb */
+static inline void smc_clcsock_replace_cb(void (**target_cb)(struct sock *),
+					  void (*new_cb)(struct sock *),
+					  void (**saved_cb)(struct sock *))
+{
+	/* only save once */
+	if (!*saved_cb)
+		*saved_cb = *target_cb;
+	*target_cb = new_cb;
+}
+
+/* restore target_cb to saved_cb, and reset saved_cb to NULL */
+static inline void smc_clcsock_restore_cb(void (**target_cb)(struct sock *),
+					  void (**saved_cb)(struct sock *))
+{
+	if (!*saved_cb)
+		return;
+	*target_cb = *saved_cb;
+	*saved_cb = NULL;
+}
+
 extern struct workqueue_struct	*smc_hs_wq;	/* wq for handshake work */
 extern struct workqueue_struct	*smc_close_wq;	/* wq for close work */
 
diff --git a/net/smc/smc_close.c b/net/smc/smc_close.c
index 676cb2333d3c..7bd1ef55b9df 100644
--- a/net/smc/smc_close.c
+++ b/net/smc/smc_close.c
@@ -214,7 +214,8 @@ int smc_close_active(struct smc_sock *smc)
 		sk->sk_state = SMC_CLOSED;
 		sk->sk_state_change(sk); /* wake up accept */
 		if (smc->clcsock && smc->clcsock->sk) {
-			smc->clcsock->sk->sk_data_ready = smc->clcsk_data_ready;
+			smc_clcsock_restore_cb(&smc->clcsock->sk->sk_data_ready,
+					       &smc->clcsk_data_ready);
 			smc->clcsock->sk->sk_user_data = NULL;
 			rc = kernel_sock_shutdown(smc->clcsock, SHUT_RDWR);
 		}

