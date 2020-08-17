Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A8A247530
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387436AbgHQTUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730517AbgHQPgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:36:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7DC32310F;
        Mon, 17 Aug 2020 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678609;
        bh=/omsBwg8Yyncdrw92Temo+2BdmMOicqXhOUwneH6NX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ykN/sySLLZISY9YpjYMmxlU7V6ak5oMxO+LvzOUvTwRqSo9CUfL7QteL7SbZDJitx
         SqSXI60uojad3G/Ss+IoqtAxQumDjvSmm0pMe8pkzadQ6t44UbtOOTVzNjLqesB+sj
         /aBhOiiXFpPl44r6u7OWiivkGkGFQNT319QRo1vs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com
Subject: [PATCH 5.8 394/464] vsock: fix potential null pointer dereference in vsock_poll()
Date:   Mon, 17 Aug 2020 17:15:47 +0200
Message-Id: <20200817143852.652250005@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

[ Upstream commit 1980c05844830a44708c98c96d600833aa3fae08 ]

syzbot reported this issue where in the vsock_poll() we find the
socket state at TCP_ESTABLISHED, but 'transport' is null:
  general protection fault, probably for non-canonical address 0xdffffc0000000012: 0000 [#1] PREEMPT SMP KASAN
  KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
  CPU: 0 PID: 8227 Comm: syz-executor.2 Not tainted 5.8.0-rc7-syzkaller #0
  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
  RIP: 0010:vsock_poll+0x75a/0x8e0 net/vmw_vsock/af_vsock.c:1038
  Call Trace:
   sock_poll+0x159/0x460 net/socket.c:1266
   vfs_poll include/linux/poll.h:90 [inline]
   do_pollfd fs/select.c:869 [inline]
   do_poll fs/select.c:917 [inline]
   do_sys_poll+0x607/0xd40 fs/select.c:1011
   __do_sys_poll fs/select.c:1069 [inline]
   __se_sys_poll fs/select.c:1057 [inline]
   __x64_sys_poll+0x18c/0x440 fs/select.c:1057
   do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
   entry_SYSCALL_64_after_hwframe+0x44/0xa9

This issue can happen if the TCP_ESTABLISHED state is set after we read
the vsk->transport in the vsock_poll().

We could put barriers to synchronize, but this can only happen during
connection setup, so we can simply check that 'transport' is valid.

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Reported-and-tested-by: syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Jorgen Hansen <jhansen@vmware.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1032,7 +1032,7 @@ static __poll_t vsock_poll(struct file *
 		}
 
 		/* Connected sockets that can produce data can be written. */
-		if (sk->sk_state == TCP_ESTABLISHED) {
+		if (transport && sk->sk_state == TCP_ESTABLISHED) {
 			if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
 				bool space_avail_now = false;
 				int ret = transport->notify_poll_out(


