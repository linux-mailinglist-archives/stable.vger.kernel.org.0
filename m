Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39227133281
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbgAGVLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:11:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730094AbgAGVLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:11:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E79D42072A;
        Tue,  7 Jan 2020 21:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431483;
        bh=HmTJcV/LNXiGU623gIedHC6UxR/iLTGeYne+j8wPRhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hqe7ivqYE7lzvYDSJzRynCvhTVs1dSXLoKMeCK/YlxYiLh1f8Rxb/pd6p62rYcBIQ
         tIyl18fdrDKFJ1zsVQ8rXspayMFsXIftI2c2KxCqZrgDjuXfRv+HBy11H4NDvRTixH
         4ll8sJpSuMyfL4Mk084TEbur29RQgkJnUH5zfFYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+611164843bd48cc2190c@syzkaller.appspotmail.com,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 67/74] rxrpc: Fix possible NULL pointer access in ICMP handling
Date:   Tue,  7 Jan 2020 21:55:32 +0100
Message-Id: <20200107205232.200362165@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit f0308fb0708078d6c1d8a4d533941a7a191af634 ]

If an ICMP packet comes in on the UDP socket backing an AF_RXRPC socket as
the UDP socket is being shut down, rxrpc_error_report() may get called to
deal with it after sk_user_data on the UDP socket has been cleared, leading
to a NULL pointer access when this local endpoint record gets accessed.

Fix this by just returning immediately if sk_user_data was NULL.

The oops looks like the following:

#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
...
RIP: 0010:rxrpc_error_report+0x1bd/0x6a9
...
Call Trace:
 ? sock_queue_err_skb+0xbd/0xde
 ? __udp4_lib_err+0x313/0x34d
 __udp4_lib_err+0x313/0x34d
 icmp_unreach+0x1ee/0x207
 icmp_rcv+0x25b/0x28f
 ip_protocol_deliver_rcu+0x95/0x10e
 ip_local_deliver+0xe9/0x148
 __netif_receive_skb_one_core+0x52/0x6e
 process_backlog+0xdc/0x177
 net_rx_action+0xf9/0x270
 __do_softirq+0x1b6/0x39a
 ? smpboot_register_percpu_thread+0xce/0xce
 run_ksoftirqd+0x1d/0x42
 smpboot_thread_fn+0x19e/0x1b3
 kthread+0xf1/0xf6
 ? kthread_delayed_work_timer_fn+0x83/0x83
 ret_from_fork+0x24/0x30

Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
Reported-by: syzbot+611164843bd48cc2190c@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/peer_event.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index 7f749505e699..7d73e8ce6660 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -150,6 +150,9 @@ void rxrpc_error_report(struct sock *sk)
 	struct rxrpc_peer *peer;
 	struct sk_buff *skb;
 
+	if (unlikely(!local))
+		return;
+
 	_enter("%p{%d}", sk, local->debug_id);
 
 	skb = sock_dequeue_err_skb(sk);
-- 
2.20.1



