Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCF45318CA
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239873AbiEWRRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240142AbiEWRP0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:15:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF3211A03;
        Mon, 23 May 2022 10:12:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E340614E5;
        Mon, 23 May 2022 17:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BB8C385A9;
        Mon, 23 May 2022 17:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325959;
        bh=lIwMAvvut7ndMdEen037betf53Ozq/OmMdPtw0ev+Jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=01FWANk4q/ewHhX4GVQ21cpxh/aGwhFTmR3F+q8Uup4Iv9yaBfDwNnvkIIjUmoeWa
         wzb993GJVgBlFej8AbMuYmeS9qmcgyV0FsIQt/om/YAdnBGFkfyk4IjGbHuyRyIH6m
         GUbDCYErkmgdE+skEVwEPWltd3sR6FzF6+MWBj3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Meena Shanmugam <meenashanmugam@google.com>
Subject: [PATCH 5.4 22/68] SUNRPC: Clean up scheduling of autoclose
Date:   Mon, 23 May 2022 19:04:49 +0200
Message-Id: <20220523165806.308236890@linuxfoundation.org>
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

commit e26d9972720e2484f44cdd94ca4e31cc372ed2ed upstream.

Consolidate duplicated code in xprt_force_disconnect() and
xprt_conditional_disconnect().

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Meena Shanmugam <meenashanmugam@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprt.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -717,21 +717,29 @@ void xprt_disconnect_done(struct rpc_xpr
 EXPORT_SYMBOL_GPL(xprt_disconnect_done);
 
 /**
- * xprt_force_disconnect - force a transport to disconnect
+ * xprt_schedule_autoclose_locked - Try to schedule an autoclose RPC call
  * @xprt: transport to disconnect
- *
  */
-void xprt_force_disconnect(struct rpc_xprt *xprt)
+static void xprt_schedule_autoclose_locked(struct rpc_xprt *xprt)
 {
-	/* Don't race with the test_bit() in xprt_clear_locked() */
-	spin_lock(&xprt->transport_lock);
 	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
-	/* Try to schedule an autoclose RPC call */
 	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
 		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
 	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
 		rpc_wake_up_queued_task_set_status(&xprt->pending,
 						   xprt->snd_task, -ENOTCONN);
+}
+
+/**
+ * xprt_force_disconnect - force a transport to disconnect
+ * @xprt: transport to disconnect
+ *
+ */
+void xprt_force_disconnect(struct rpc_xprt *xprt)
+{
+	/* Don't race with the test_bit() in xprt_clear_locked() */
+	spin_lock(&xprt->transport_lock);
+	xprt_schedule_autoclose_locked(xprt);
 	spin_unlock(&xprt->transport_lock);
 }
 EXPORT_SYMBOL_GPL(xprt_force_disconnect);
@@ -771,11 +779,7 @@ void xprt_conditional_disconnect(struct
 		goto out;
 	if (test_bit(XPRT_CLOSING, &xprt->state))
 		goto out;
-	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
-	/* Try to schedule an autoclose RPC call */
-	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
-		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
-	xprt_wake_pending_tasks(xprt, -EAGAIN);
+	xprt_schedule_autoclose_locked(xprt);
 out:
 	spin_unlock(&xprt->transport_lock);
 }


