Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016D650F45B
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiDZIfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345676AbiDZIe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38EE7B13E;
        Tue, 26 Apr 2022 01:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EEDC6185C;
        Tue, 26 Apr 2022 08:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B3DC385A0;
        Tue, 26 Apr 2022 08:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961683;
        bh=E+8EVVtblN1qeO36f48MGdHo2JYSkCiA/9t20WgLgEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mO1mG6KfSZUjiGIK7xkfVXSDWC/UNanygIYy2de6/GFO555VxQjWQT56N6PCN6rSG
         EhjFfEukSQwdm8fclP9szWS3jqPmfrILzIz7kU9eQxzYbuXgIjy0bnqCjX+B4+9fG5
         OwshILBv2c1WXUtLTVXVIUSi4/n5aEdh1dciuo4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Duoming Zhou <duoming@zju.edu.cn>,
        Paolo Abeni <pabeni@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 49/53] ax25: fix UAF bug in ax25_send_control()
Date:   Tue, 26 Apr 2022 10:21:29 +0200
Message-Id: <20220426081737.090471368@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081735.651926456@linuxfoundation.org>
References: <20220426081735.651926456@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 5352a761308397a0e6250fdc629bb3f615b94747 upstream.

There are UAF bugs in ax25_send_control(), when we call ax25_release()
to deallocate ax25_dev. The possible race condition is shown below:

      (Thread 1)              |     (Thread 2)
ax25_dev_device_up() //(1)    |
                              | ax25_kill_by_device()
ax25_bind()          //(2)    |
ax25_connect()                | ...
 ax25->state = AX25_STATE_1   |
 ...                          | ax25_dev_device_down() //(3)

      (Thread 3)
ax25_release()                |
 ax25_dev_put()  //(4) FREE   |
 case AX25_STATE_1:           |
  ax25_send_control()         |
   alloc_skb()       //USE    |

The refcount of ax25_dev increases in position (1) and (2), and
decreases in position (3) and (4). The ax25_dev will be freed
before dereference sites in ax25_send_control().

The following is part of the report:

[  102.297448] BUG: KASAN: use-after-free in ax25_send_control+0x33/0x210
[  102.297448] Read of size 8 at addr ffff888009e6e408 by task ax25_close/602
[  102.297448] Call Trace:
[  102.303751]  ax25_send_control+0x33/0x210
[  102.303751]  ax25_release+0x356/0x450
[  102.305431]  __sock_release+0x6d/0x120
[  102.305431]  sock_close+0xf/0x20
[  102.305431]  __fput+0x11f/0x420
[  102.305431]  task_work_run+0x86/0xd0
[  102.307130]  get_signal+0x1075/0x1220
[  102.308253]  arch_do_signal_or_restart+0x1df/0xc00
[  102.308253]  exit_to_user_mode_prepare+0x150/0x1e0
[  102.308253]  syscall_exit_to_user_mode+0x19/0x50
[  102.308253]  do_syscall_64+0x48/0x90
[  102.308253]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  102.308253] RIP: 0033:0x405ae7

This patch defers the free operation of ax25_dev and net_device after
all corresponding dereference sites in ax25_release() to avoid UAF.

Fixes: 9fd75b66b8f6 ("ax25: Fix refcount leaks caused by ax25_cb_del()")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[OP: backport to 4.19: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -993,10 +993,6 @@ static int ax25_release(struct socket *s
 	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
 	ax25_dev = ax25->ax25_dev;
-	if (ax25_dev) {
-		dev_put(ax25_dev->dev);
-		ax25_dev_put(ax25_dev);
-	}
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
@@ -1058,6 +1054,10 @@ static int ax25_release(struct socket *s
 		sk->sk_state_change(sk);
 		ax25_destroy_socket(ax25);
 	}
+	if (ax25_dev) {
+		dev_put(ax25_dev->dev);
+		ax25_dev_put(ax25_dev);
+	}
 
 	sock->sk   = NULL;
 	release_sock(sk);


