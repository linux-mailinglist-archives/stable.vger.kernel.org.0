Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44A259D4D3
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243118AbiHWI1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244257AbiHWI0b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:26:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2C173921;
        Tue, 23 Aug 2022 01:14:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24A016129A;
        Tue, 23 Aug 2022 08:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30644C433C1;
        Tue, 23 Aug 2022 08:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242462;
        bh=w/ws2DL+rOAPKGt41HhTtwj8mh2+FQSFUgu3NzsRKgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEadTVknMWwBbQ1z6SmS9/MUcrCyn/so+gazDohkZyumaK9D0nPKatmpABE+zgwV/
         aZPZCMC0LWm3ZajY8pH1HIsa3+hRB1T/g7P1y2R4tCjRLO5BQqX5GnE4D6ddkCH1GQ
         kCHb44TRguP2n9zYLvBBpvgFUE1fL/JERxu59YFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+b03f55bf128f9a38f064@syzkaller.appspotmail.com
Subject: [PATCH 4.9 075/101] vsock: Fix memory leak in vsock_connect()
Date:   Tue, 23 Aug 2022 10:03:48 +0200
Message-Id: <20220823080037.435200290@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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
@@ -1205,7 +1205,14 @@ static int vsock_stream_connect(struct s
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


