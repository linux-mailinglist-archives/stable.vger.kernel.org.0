Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C4366CFE
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfGLMZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728254AbfGLMZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:25:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5402921721;
        Fri, 12 Jul 2019 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934316;
        bh=pN1VIaFp/A6iSBg6XUkeVTqyYKGNIO4fMOdnyanPy3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LaBwmwUEvnLi8LfxosUMUof9OHQ+NeXgzgtKhZtxCDRYrf9jFDxP//4rDNO68XMfu
         TrEpvl7+GVFT6/G0+k3Ze6ZmeEt2rIMtUgGhcOPknSRDviOtygL/Hxgi+xFBIPhDPu
         Kj0qyRm+DKelU7zJPLJG4dj2/81gX5ch77XOHbV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 016/138] bpf: sockmap, fix use after free from sleep in psock backlog workqueue
Date:   Fri, 12 Jul 2019 14:18:00 +0200
Message-Id: <20190712121629.344998292@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bd95e678e0f6e18351ecdc147ca819145db9ed7b ]

Backlog work for psock (sk_psock_backlog) might sleep while waiting
for memory to free up when sending packets. However, while sleeping
the socket may be closed and removed from the map by the user space
side.

This breaks an assumption in sk_stream_wait_memory, which expects the
wait queue to be still there when it wakes up resulting in a
use-after-free shown below. To fix his mark sendmsg as MSG_DONTWAIT
to avoid the sleep altogether. We already set the flag for the
sendpage case but we missed the case were sendmsg is used.
Sockmap is currently the only user of skb_send_sock_locked() so only
the sockmap paths should be impacted.

==================================================================
BUG: KASAN: use-after-free in remove_wait_queue+0x31/0x70
Write of size 8 at addr ffff888069a0c4e8 by task kworker/0:2/110

CPU: 0 PID: 110 Comm: kworker/0:2 Not tainted 5.0.0-rc2-00335-g28f9d1a3d4fe-dirty #14
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-2.fc27 04/01/2014
Workqueue: events sk_psock_backlog
Call Trace:
 print_address_description+0x6e/0x2b0
 ? remove_wait_queue+0x31/0x70
 kasan_report+0xfd/0x177
 ? remove_wait_queue+0x31/0x70
 ? remove_wait_queue+0x31/0x70
 remove_wait_queue+0x31/0x70
 sk_stream_wait_memory+0x4dd/0x5f0
 ? sk_stream_wait_close+0x1b0/0x1b0
 ? wait_woken+0xc0/0xc0
 ? tcp_current_mss+0xc5/0x110
 tcp_sendmsg_locked+0x634/0x15d0
 ? tcp_set_state+0x2e0/0x2e0
 ? __kasan_slab_free+0x1d1/0x230
 ? kmem_cache_free+0x70/0x140
 ? sk_psock_backlog+0x40c/0x4b0
 ? process_one_work+0x40b/0x660
 ? worker_thread+0x82/0x680
 ? kthread+0x1b9/0x1e0
 ? ret_from_fork+0x1f/0x30
 ? check_preempt_curr+0xaf/0x130
 ? iov_iter_kvec+0x5f/0x70
 ? kernel_sendmsg_locked+0xa0/0xe0
 skb_send_sock_locked+0x273/0x3c0
 ? skb_splice_bits+0x180/0x180
 ? start_thread+0xe0/0xe0
 ? update_min_vruntime.constprop.27+0x88/0xc0
 sk_psock_backlog+0xb3/0x4b0
 ? strscpy+0xbf/0x1e0
 process_one_work+0x40b/0x660
 worker_thread+0x82/0x680
 ? process_one_work+0x660/0x660
 kthread+0x1b9/0x1e0
 ? __kthread_create_on_node+0x250/0x250
 ret_from_fork+0x1f/0x30

Fixes: 20bf50de3028c ("skbuff: Function to send an skbuf on a socket")
Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e5bfd42fd083..4ea96fbf3b49 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2309,6 +2309,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		kv.iov_base = skb->data + offset;
 		kv.iov_len = slen;
 		memset(&msg, 0, sizeof(msg));
+		msg.msg_flags = MSG_DONTWAIT;
 
 		ret = kernel_sendmsg_locked(sk, &msg, &kv, 1, slen);
 		if (ret <= 0)
-- 
2.20.1



