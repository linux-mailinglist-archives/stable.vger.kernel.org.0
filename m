Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD6FE412320
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377846AbhITSVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:41848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351462AbhITSSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:18:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CEA4632A2;
        Mon, 20 Sep 2021 17:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158553;
        bh=GYqZbqkLQ4C4Ds8JdpEkexRz/rAqdZNfCAd97Sy5WmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6kbSsLS2+dmXkLtT/lmXzC/GKJxwbXn39iyr6Jysthm+4zX5HCOy98eUqXpPJRn/
         /lj6Vq9W4PuuhQ19Vc/wJ4syrk+Y1J4dVYcM6wnh/JR1UOrYzJnqihDWuecbwVBxkL
         jSP6RnDfaaIHlh2vrNcKwd9rzexBOOpxj9JRi0GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 209/260] tipc: fix an use-after-free issue in tipc_recvmsg
Date:   Mon, 20 Sep 2021 18:43:47 +0200
Message-Id: <20210920163938.211574882@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit cc19862ffe454a5b632ca202e5a51bfec9f89fd2 upstream.

syzbot reported an use-after-free crash:

  BUG: KASAN: use-after-free in tipc_recvmsg+0xf77/0xf90 net/tipc/socket.c:1979
  Call Trace:
   tipc_recvmsg+0xf77/0xf90 net/tipc/socket.c:1979
   sock_recvmsg_nosec net/socket.c:943 [inline]
   sock_recvmsg net/socket.c:961 [inline]
   sock_recvmsg+0xca/0x110 net/socket.c:957
   tipc_conn_rcv_from_sock+0x162/0x2f0 net/tipc/topsrv.c:398
   tipc_conn_recv_work+0xeb/0x190 net/tipc/topsrv.c:421
   process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
   worker_thread+0x658/0x11f0 kernel/workqueue.c:2422

As Hoang pointed out, it was caused by skb_cb->bytes_read still accessed
after calling tsk_advance_rx_queue() to free the skb in tipc_recvmsg().

This patch is to fix it by accessing skb_cb->bytes_read earlier than
calling tsk_advance_rx_queue().

Fixes: f4919ff59c28 ("tipc: keep the skb in rcv queue until the whole data is read")
Reported-by: syzbot+e6741b97d5552f97c24d@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1849,10 +1849,12 @@ static int tipc_recvmsg(struct socket *s
 		tipc_node_distr_xmit(sock_net(sk), &xmitq);
 	}
 
-	if (!skb_cb->bytes_read)
-		tsk_advance_rx_queue(sk);
+	if (skb_cb->bytes_read)
+		goto exit;
+
+	tsk_advance_rx_queue(sk);
 
-	if (likely(!connected) || skb_cb->bytes_read)
+	if (likely(!connected))
 		goto exit;
 
 	/* Send connection flow control advertisement when applicable */


