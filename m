Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB77521ACC
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242855AbiEJOEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242297AbiEJOAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:00:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294E52716B;
        Tue, 10 May 2022 06:39:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 233CC6195A;
        Tue, 10 May 2022 13:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C159C385A6;
        Tue, 10 May 2022 13:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189993;
        bh=ClrH9r6REJMY4gRv6YNSD6cNrPGYsFLSvLtpnlQJ+58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfUh+ogYROCs+P9YUO+g8D0w3vZXlZNLZLNgE26qrQjneWVz6wlnhykABp+cYCmDX
         dV+9MWruxmhSenhdqPML2e1KB9Afz9O5KbDGMK+y/whQYPG/MnWd3K0LDopNxQN/Ax
         PWBNAmFtYYCgUzrxvNWQIS8hSU+te7uX1BrwmwP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "wanghai (M)" <wanghai38@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.17 095/140] SUNRPC: Dont leak sockets in xs_local_connect()
Date:   Tue, 10 May 2022 15:08:05 +0200
Message-Id: <20220510130744.324350750@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit aad41a7d7cf6c6fa804c872a2480f8e541da37cf upstream.

If there is still a closed socket associated with the transport, then we
need to trigger an autoclose before we can set up a new connection.

Reported-by: wanghai (M) <wanghai38@huawei.com>
Fixes: f00432063db1 ("SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtsock.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1967,6 +1967,9 @@ static void xs_local_connect(struct rpc_
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
 	int ret;
 
+	if (transport->file)
+		goto force_disconnect;
+
 	if (RPC_IS_ASYNC(task)) {
 		/*
 		 * We want the AF_LOCAL connect to be resolved in the
@@ -1979,11 +1982,17 @@ static void xs_local_connect(struct rpc_
 		 */
 		task->tk_rpc_status = -ENOTCONN;
 		rpc_exit(task, -ENOTCONN);
-		return;
+		goto out_wake;
 	}
 	ret = xs_local_setup_socket(transport);
 	if (ret && !RPC_IS_SOFTCONN(task))
 		msleep_interruptible(15000);
+	return;
+force_disconnect:
+	xprt_force_disconnect(xprt);
+out_wake:
+	xprt_clear_connecting(xprt);
+	xprt_wake_pending_tasks(xprt, -ENOTCONN);
 }
 
 #if IS_ENABLED(CONFIG_SUNRPC_SWAP)


