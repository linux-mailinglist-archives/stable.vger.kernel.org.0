Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3095653AB
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 13:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiGDLfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 07:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiGDLfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 07:35:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DC1FD08
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 04:35:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D88EB80EDF
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 11:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F55C3411E;
        Mon,  4 Jul 2022 11:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656934545;
        bh=HRK84s2j32KG81hoXTVf55cVum9lg6QO/pnJsueXTlc=;
        h=Subject:To:Cc:From:Date:From;
        b=upwZtOWN81wGWdGDUKAUyYT49qaLiajUfZ5XNJCu0uHza3DBZgY63VZTWXtXxu4qW
         F8UktFrul7h+GTSd2qlmeq7AOW5nFhLmGKz3I8rkxumoiU+6JItSB96IXmx9nJH+wN
         9LZn8F8qacTUsThWQP9zZ78u/helfDhHNv3PR9lQ=
Subject: FAILED: patch "[PATCH] net: tun: stop NAPI when detaching queues" failed to apply to 4.14-stable tree
To:     kuba@kernel.org, ppenkov@aviatrix.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 13:35:42 +0200
Message-ID: <165693454242194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a8fc8cb5692aebb9c6f7afd4265366d25dcd1d01 Mon Sep 17 00:00:00 2001
From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 22 Jun 2022 21:21:05 -0700
Subject: [PATCH] net: tun: stop NAPI when detaching queues

While looking at a syzbot report I noticed the NAPI only gets
disabled before it's deleted. I think that user can detach
the queue before destroying the device and the NAPI will never
be stopped.

Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
Acked-by: Petar Penkov <ppenkov@aviatrix.com>
Link: https://lore.kernel.org/r/20220623042105.2274812-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7fd0288c3789..e2eb35887394 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -273,6 +273,12 @@ static void tun_napi_init(struct tun_struct *tun, struct tun_file *tfile,
 	}
 }
 
+static void tun_napi_enable(struct tun_file *tfile)
+{
+	if (tfile->napi_enabled)
+		napi_enable(&tfile->napi);
+}
+
 static void tun_napi_disable(struct tun_file *tfile)
 {
 	if (tfile->napi_enabled)
@@ -653,8 +659,10 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		if (clean) {
 			RCU_INIT_POINTER(tfile->tun, NULL);
 			sock_put(&tfile->sk);
-		} else
+		} else {
 			tun_disable_queue(tun, tfile);
+			tun_napi_disable(tfile);
+		}
 
 		synchronize_net();
 		tun_flow_delete_by_queue(tun, tun->numqueues + 1);
@@ -808,6 +816,7 @@ static int tun_attach(struct tun_struct *tun, struct file *file,
 
 	if (tfile->detached) {
 		tun_enable_queue(tfile);
+		tun_napi_enable(tfile);
 	} else {
 		sock_hold(&tfile->sk);
 		tun_napi_init(tun, tfile, napi, napi_frags);

