Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A3F4FDA5D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351447AbiDLHUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351720AbiDLHMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CF5165AB;
        Mon, 11 Apr 2022 23:51:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84715B81B46;
        Tue, 12 Apr 2022 06:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2B7C385A8;
        Tue, 12 Apr 2022 06:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746317;
        bh=a0yLX0T6TEa0bit/jXiRG3kadDajY2XPRPzgFSSAFEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KayfRNynVsRafNeJeAJjo7+VAXCoMm7ah1mfL8Lhq3ZlJC1SO/uCUy44CxVxADTip
         Hzr9L/WPkj42EvmxdUhHEjp7QzUTahKzAcB6REUW+xdzKHrnZEsUNe+tiWZnQakzZE
         kBsDvZafOtjwKUWd0hjfpF/vDI9l3mi7adioJ288=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 240/277] SUNRPC: Prevent immediate close+reconnect
Date:   Tue, 12 Apr 2022 08:30:43 +0200
Message-Id: <20220412062948.990253262@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 3be232f11a3cc9b0ef0795e39fa11bdb8e422a06 upstream.

If we have already set up the socket and are waiting for it to connect,
then don't immediately close and retry.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprt.c     |    3 ++-
 net/sunrpc/xprtsock.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

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
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2365,7 +2365,7 @@ static void xs_connect(struct rpc_xprt *
 
 	WARN_ON_ONCE(!xprt_lock_connect(xprt, task, transport));
 
-	if (transport->sock != NULL) {
+	if (transport->sock != NULL && !xprt_connecting(xprt)) {
 		dprintk("RPC:       xs_connect delayed xprt %p for %lu "
 				"seconds\n",
 				xprt, xprt->reestablish_timeout / HZ);


