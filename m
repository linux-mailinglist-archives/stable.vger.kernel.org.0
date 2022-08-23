Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D22959D994
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243797AbiHWJ6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243274AbiHWJwk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:52:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646299F1BC;
        Tue, 23 Aug 2022 01:46:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C34DCB81C28;
        Tue, 23 Aug 2022 08:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33462C433D6;
        Tue, 23 Aug 2022 08:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244372;
        bh=RV1GZG+3t5zAS4U4itlLMWmm5qsJJCjklLgh5YNRoOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMnQwzXRamoeqai4giExtIg2mm9s8hBK33NP8gGZrN+I50Kf6U9cDN9dBUlN8TP8s
         6o7OZ1DpVcd7x+drWKa1LgO2l518wRih3jAZeZ5l5Kc3FZiQb2b8JLbxaP0k1rYwTD
         3PgukYOMbpwI4sQuYdvDInXLGR6WNZQNe2njkC9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+b03f55bf128f9a38f064@syzkaller.appspotmail.com
Subject: [PATCH 5.15 080/244] vsock: Fix memory leak in vsock_connect()
Date:   Tue, 23 Aug 2022 10:23:59 +0200
Message-Id: <20220823080101.719740852@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Peilin Ye <peilin.ye@bytedance.com>

commit 7e97cfed9929eaabc41829c395eb0d1350fccb9d upstream.

An O_NONBLOCK vsock_connect() request may try to reschedule
@connect_work.  Imagine the following sequence of vsock_connect()
requests:

  1. The 1st, non-blocking request schedules @connect_work, which will
     expire after 200 jiffies.  Socket state is now SS_CONNECTING;

  2. Later, the 2nd, blocking request gets interrupted by a signal after
     a few jiffies while waiting for the connection to be established.
     Socket state is back to SS_UNCONNECTED, but @connect_work is still
     pending, and will expire after 100 jiffies.

  3. Now, the 3rd, non-blocking request tries to schedule @connect_work
     again.  Since @connect_work is already scheduled,
     schedule_delayed_work() silently returns.  sock_hold() is called
     twice, but sock_put() will only be called once in
     vsock_connect_timeout(), causing a memory leak reported by syzbot:

  BUG: memory leak
  unreferenced object 0xffff88810ea56a40 (size 1232):
    comm "syz-executor756", pid 3604, jiffies 4294947681 (age 12.350s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      28 00 07 40 00 00 00 00 00 00 00 00 00 00 00 00  (..@............
    backtrace:
      [<ffffffff837c830e>] sk_prot_alloc+0x3e/0x1b0 net/core/sock.c:1930
      [<ffffffff837cbe22>] sk_alloc+0x32/0x2e0 net/core/sock.c:1989
      [<ffffffff842ccf68>] __vsock_create.constprop.0+0x38/0x320 net/vmw_vsock/af_vsock.c:734
      [<ffffffff842ce8f1>] vsock_create+0xc1/0x2d0 net/vmw_vsock/af_vsock.c:2203
      [<ffffffff837c0cbb>] __sock_create+0x1ab/0x2b0 net/socket.c:1468
      [<ffffffff837c3acf>] sock_create net/socket.c:1519 [inline]
      [<ffffffff837c3acf>] __sys_socket+0x6f/0x140 net/socket.c:1561
      [<ffffffff837c3bba>] __do_sys_socket net/socket.c:1570 [inline]
      [<ffffffff837c3bba>] __se_sys_socket net/socket.c:1568 [inline]
      [<ffffffff837c3bba>] __x64_sys_socket+0x1a/0x20 net/socket.c:1568
      [<ffffffff84512815>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
      [<ffffffff84512815>] do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
      [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
  <...>

Use mod_delayed_work() instead: if @connect_work is already scheduled,
reschedule it, and undo sock_hold() to keep the reference count
balanced.

Reported-and-tested-by: syzbot+b03f55bf128f9a38f064@syzkaller.appspotmail.com
Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Co-developed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1390,7 +1390,14 @@ static int vsock_connect(struct socket *
 			 * timeout fires.
 			 */
 			sock_hold(sk);
-			schedule_delayed_work(&vsk->connect_work, timeout);
+
+			/* If the timeout function is already scheduled,
+			 * reschedule it, then ungrab the socket refcount to
+			 * keep it balanced.
+			 */
+			if (mod_delayed_work(system_wq, &vsk->connect_work,
+					     timeout))
+				sock_put(sk);
 
 			/* Skip ahead to preserve error code set above. */
 			goto out_wait;


