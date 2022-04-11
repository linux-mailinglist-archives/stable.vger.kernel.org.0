Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75D44FB77E
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 11:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344416AbiDKJaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 05:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235101AbiDKJaI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 05:30:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E35403C5
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 02:27:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D28D260F27
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 09:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1FDFC385A4;
        Mon, 11 Apr 2022 09:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649669274;
        bh=7yaExo9Qr6dhXK1pcmE9QbLzbPTqDzRCTuTjUbkm8TU=;
        h=Subject:To:Cc:From:Date:From;
        b=OaQbAMNTI0GxKUfwRtyvnnPJOmmVYyjtwVjP9qL0pjCEmJ3ohC02RTZvptPcjedha
         Pl7dexsS2IQYFClDWSLO5pwioryQghPFKlNSSPh1rWsHn4S2DSvs7c5ZRHWuXRlZ3j
         vEwbBfu8syqz/R0PWqm5GQ/0Ym/eznhUbLJtrKyI=
Subject: FAILED: patch "[PATCH] SUNRPC: Prevent immediate close+reconnect" failed to apply to 5.4-stable tree
To:     trond.myklebust@hammerspace.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 11:27:46 +0200
Message-ID: <1649669266156132@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

From 3be232f11a3cc9b0ef0795e39fa11bdb8e422a06 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <trond.myklebust@hammerspace.com>
Date: Tue, 26 Oct 2021 18:01:07 -0400
Subject: [PATCH] SUNRPC: Prevent immediate close+reconnect

If we have already set up the socket and are waiting for it to connect,
then don't immediately close and retry.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 691fe5a682b6..a02de2bddb28 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -767,7 +767,8 @@ EXPORT_SYMBOL_GPL(xprt_disconnect_done);
  */
 static void xprt_schedule_autoclose_locked(struct rpc_xprt *xprt)
 {
-	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
+	if (test_and_set_bit(XPRT_CLOSE_WAIT, &xprt->state))
+		return;
 	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
 		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
 	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 7fb302e202bc..ae48c9c84ee1 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2314,7 +2314,7 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 
 	WARN_ON_ONCE(!xprt_lock_connect(xprt, task, transport));
 
-	if (transport->sock != NULL) {
+	if (transport->sock != NULL && !xprt_connecting(xprt)) {
 		dprintk("RPC:       xs_connect delayed xprt %p for %lu "
 				"seconds\n",
 				xprt, xprt->reestablish_timeout / HZ);

