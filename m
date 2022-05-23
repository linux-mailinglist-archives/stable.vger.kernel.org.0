Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CED5318EF
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240467AbiEWRRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240166AbiEWRP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:15:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FF062CE;
        Mon, 23 May 2022 10:12:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4D12614CA;
        Mon, 23 May 2022 17:12:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6571C385A9;
        Mon, 23 May 2022 17:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325963;
        bh=iaOavnu9uVLIPR/Pfk/FPb5GyxAQ7s5vYCI00gmarEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Yrg43+CiIjizx0a3kXSKPvqrxKSW2Lvk7PRNtECzXJyDlDM3wH8awXeNqumlvAYB
         JmdoAhAaGF5L9yNj6BrdsPzTyAL3B3+WG536gFlu97n1R8d0pWGShYn8CbvL5Uhok4
         CTrc33KHD58cHDVlb6uVzpFBZENEoMeXyegpkivc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Meena Shanmugam <meenashanmugam@google.com>
Subject: [PATCH 5.4 23/68] SUNRPC: Prevent immediate close+reconnect
Date:   Mon, 23 May 2022 19:04:50 +0200
Message-Id: <20220523165806.474707162@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Meena Shanmugam <meenashanmugam@google.com>

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 3be232f11a3cc9b0ef0795e39fa11bdb8e422a06 upstream.

If we have already set up the socket and are waiting for it to connect,
then don't immediately close and retry.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprt.c     |    3 ++-
 net/sunrpc/xprtsock.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -722,7 +722,8 @@ EXPORT_SYMBOL_GPL(xprt_disconnect_done);
  */
 static void xprt_schedule_autoclose_locked(struct rpc_xprt *xprt)
 {
-	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
+	if (test_and_set_bit(XPRT_CLOSE_WAIT, &xprt->state))
+		return;
 	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
 		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
 	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2469,7 +2469,7 @@ static void xs_connect(struct rpc_xprt *
 
 	WARN_ON_ONCE(!xprt_lock_connect(xprt, task, transport));
 
-	if (transport->sock != NULL) {
+	if (transport->sock != NULL && !xprt_connecting(xprt)) {
 		dprintk("RPC:       xs_connect delayed xprt %p for %lu "
 				"seconds\n",
 				xprt, xprt->reestablish_timeout / HZ);


