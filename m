Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACFA247238
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbgHQP6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:58:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730789AbgHQP5k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:57:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D64532173E;
        Mon, 17 Aug 2020 15:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679859;
        bh=/omsBwg8Yyncdrw92Temo+2BdmMOicqXhOUwneH6NX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ur3/lf9CmT+nl0GCru1ad3PFxd+7QPc1tlRTSiMBeGRAO3uXsZsIQqxzv5a0qwzxP
         RmO+k1WaQgHrPwGDbjuJ4VVI+xKSx5iBZyjYk+TPSJUFlGbSujREVAr5SNUl1rNHLa
         F4rkBdKIbLBXgLdoUgDUxjmy6sOHfHK8T4KD8SfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot+a61bac2fcc1a7c6623fe@syzkaller.appspotmail.com
Subject: [PATCH 5.7 328/393] vsock: fix potential null pointer dereference in vsock_poll()
Date:   Mon, 17 Aug 2020 17:16:18 +0200
Message-Id: <20200817143835.506412482@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
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


