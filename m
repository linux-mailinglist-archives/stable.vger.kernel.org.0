Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725D959BC14
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiHVIxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbiHVIxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:53:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A5615A0C
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 01:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CB7861083
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 08:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D1FC433D6;
        Mon, 22 Aug 2022 08:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661158379;
        bh=R6xZRM4jWTEgoF0BHfIu4KXolAAg55OAo86WDqJBHwM=;
        h=Subject:To:Cc:From:Date:From;
        b=pa9tvdTrWOv6ujpLCADf/0mL+svRMgHKtDrKEmfBPZXPQpLN5klD7sN8lquo8ySGX
         x+IFYIZKFUte9LLSxN03LRJAjevIpTRmyzr52CMAsD9x/uvqG9D6er0izEjeRrlLl8
         kJAjAKttINLuATi/U/C2KncMqS1JyReLgE0qImJ0=
Subject: FAILED: patch "[PATCH] vsock: Set socket state back to SS_UNCONNECTED in" failed to apply to 4.9-stable tree
To:     peilin.ye@bytedance.com, davem@davemloft.net, sgarzare@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 10:52:57 +0200
Message-ID: <1661158377231223@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a3e7b29e30854ed67be0d17687e744ad0c769c4b Mon Sep 17 00:00:00 2001
From: Peilin Ye <peilin.ye@bytedance.com>
Date: Mon, 8 Aug 2022 11:05:25 -0700
Subject: [PATCH] vsock: Set socket state back to SS_UNCONNECTED in
 vsock_connect_timeout()

Imagine two non-blocking vsock_connect() requests on the same socket.
The first request schedules @connect_work, and after it times out,
vsock_connect_timeout() sets *sock* state back to TCP_CLOSE, but keeps
*socket* state as SS_CONNECTING.

Later, the second request returns -EALREADY, meaning the socket "already
has a pending connection in progress", even though the first request has
already timed out.

As suggested by Stefano, fix it by setting *socket* state back to
SS_UNCONNECTED, so that the second request will return -ETIMEDOUT.

Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4d68681f5abe..b4ee163154a6 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1286,6 +1286,7 @@ static void vsock_connect_timeout(struct work_struct *work)
 	if (sk->sk_state == TCP_SYN_SENT &&
 	    (sk->sk_shutdown != SHUTDOWN_MASK)) {
 		sk->sk_state = TCP_CLOSE;
+		sk->sk_socket->state = SS_UNCONNECTED;
 		sk->sk_err = ETIMEDOUT;
 		sk_error_report(sk);
 		vsock_transport_cancel_pkt(vsk);

