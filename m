Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B0B51FAD5
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 13:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiEILGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 07:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbiEILGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 07:06:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465A7233A6A
        for <stable@vger.kernel.org>; Mon,  9 May 2022 04:02:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 882F16100A
        for <stable@vger.kernel.org>; Mon,  9 May 2022 11:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B72C385A8;
        Mon,  9 May 2022 11:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652094175;
        bh=4kAVCzk53oaTSU4xa4eFUZlNf0yIsH0eD1DAcEAsUjI=;
        h=Subject:To:Cc:From:Date:From;
        b=qa4fFU7WeNcITAp2QXd7WgAAR/AcFiNIf1vrJj99/nL0sO7CAbVRT4Q8PNHvSsvGt
         9tPoP7wZBQkegDZfjjH5Z1QsCgjT7iSQhvxCKjYkjVvqZQaISlC8XKck9+3Y2PFMqF
         VZ3hj9cOYw8pK1/TGlzYXQwBubNjzkOBIeOavuZg=
Subject: FAILED: patch "[PATCH] net: rds: acquire refcount on TCP sockets" failed to apply to 4.9-stable tree
To:     penguin-kernel@I-love.SAKURA.ne.jp, pabeni@redhat.com,
        syzbot+694120e1002c117747ed@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 13:02:33 +0200
Message-ID: <165209415354112@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3a58f13a881ed351198ffab4cf9953cf19d2ab3a Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 2 May 2022 10:40:18 +0900
Subject: [PATCH] net: rds: acquire refcount on TCP sockets

syzbot is reporting use-after-free read in tcp_retransmit_timer() [1],
for TCP socket used by RDS is accessing sock_net() without acquiring a
refcount on net namespace. Since TCP's retransmission can happen after
a process which created net namespace terminated, we need to explicitly
acquire a refcount.

Link: https://syzkaller.appspot.com/bug?extid=694120e1002c117747ed [1]
Reported-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
Fixes: 26abe14379f8e2fa ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
Fixes: 8a68173691f03661 ("net: sk_clone_lock() should only do get_net() if the parent is not a kernel socket")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>
Link: https://lore.kernel.org/r/a5fb1fc4-2284-3359-f6a0-e4e390239d7b@I-love.SAKURA.ne.jp
Signed-off-by: Paolo Abeni <pabeni@redhat.com>

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 5327d130c4b5..2f638f8b7b1e 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -495,6 +495,14 @@ void rds_tcp_tune(struct socket *sock)
 
 	tcp_sock_set_nodelay(sock->sk);
 	lock_sock(sk);
+	/* TCP timer functions might access net namespace even after
+	 * a process which created this net namespace terminated.
+	 */
+	if (!sk->sk_net_refcnt) {
+		sk->sk_net_refcnt = 1;
+		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(net, 1);
+	}
 	if (rtn->sndbuf_size > 0) {
 		sk->sk_sndbuf = rtn->sndbuf_size;
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;

