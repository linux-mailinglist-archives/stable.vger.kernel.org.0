Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB7B3DD9EC
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbhHBOFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:49650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234770AbhHBOED (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:04:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 805526112E;
        Mon,  2 Aug 2021 13:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912649;
        bh=2GTZP091eKfU7pZPiLcAbWAP8+o0WKkT2uVkwuBOflY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfiugUhIRiw0XcYyZk13cabljuu9RqoLzev7rlrtzNf5SfoQTdQ0bZy3OgwRT8kCl
         HrMQLDe6jUxYhKN7olf4TgjxiGLyIV8jHynDJPFr9ZcjMb5etNFA5gEwvIljCS3cAY
         Mht2ihEyGpXzg/H8P3ww0tyAHbRZP+I4xxMRiZI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
Subject: [PATCH 5.13 054/104] net: qrtr: fix memory leaks
Date:   Mon,  2 Aug 2021 15:44:51 +0200
Message-Id: <20210802134345.791913780@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 52f3456a96c06760b9bfae460e39596fec7af22e ]

Syzbot reported memory leak in qrtr. The problem was in unputted
struct sock. qrtr_local_enqueue() function calls qrtr_port_lookup()
which takes sock reference if port was found. Then there is the following
check:

if (!ipc || &ipc->sk == skb->sk) {
	...
	return -ENODEV;
}

Since we should drop the reference before returning from this function and
ipc can be non-NULL inside this if, we should add qrtr_port_put() inside
this if.

The similar corner case is in qrtr_endpoint_post() as Manivannan
reported. In case of sock_queue_rcv_skb() failure we need to put
port reference to avoid leaking struct sock pointer.

Fixes: e04df98adf7d ("net: qrtr: Remove receive worker")
Fixes: bdabad3e363d ("net: Add Qualcomm IPC router")
Reported-and-tested-by: syzbot+35a511c72ea7356cdcf3@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/qrtr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index f2efaa4225f9..67993bcfecde 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -518,8 +518,10 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		if (!ipc)
 			goto err;
 
-		if (sock_queue_rcv_skb(&ipc->sk, skb))
+		if (sock_queue_rcv_skb(&ipc->sk, skb)) {
+			qrtr_port_put(ipc);
 			goto err;
+		}
 
 		qrtr_port_put(ipc);
 	}
@@ -839,6 +841,8 @@ static int qrtr_local_enqueue(struct qrtr_node *node, struct sk_buff *skb,
 
 	ipc = qrtr_port_lookup(to->sq_port);
 	if (!ipc || &ipc->sk == skb->sk) { /* do not send to self */
+		if (ipc)
+			qrtr_port_put(ipc);
 		kfree_skb(skb);
 		return -ENODEV;
 	}
-- 
2.30.2



