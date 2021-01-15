Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648F52F79CE
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbhAOMlA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:41:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387567AbhAOMkZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:40:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A840D223E0;
        Fri, 15 Jan 2021 12:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714384;
        bh=z9ZxyARVlPbNTvVUjxRbQNF/9k2rCYkG7QtiA/dUePA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEyXvH5+bIZlmQ0u86gVN+SjXRYzIwAgWCZA4Vx0QspOnmGzo6lK4EhsVnKimMibx
         rI5jjCC0JIFZOuiLUKIrGFHfAOeS9+Xkvy3kfBZisGnbA9j8v5IVEZ+avsSK/6nfSx
         ArT2JgbJt05n+POZQmrz+FBECuiWrhgZ2P6jwfCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCH 5.10 096/103] xsk: Rollback reservation at NETDEV_TX_BUSY
Date:   Fri, 15 Jan 2021 13:28:29 +0100
Message-Id: <20210115122010.650109709@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit b1b95cb5c0a9694d47d5f845ba97e226cfda957d upstream.

Rollback the reservation in the completion ring when we get a
NETDEV_TX_BUSY. When this error is received from the driver, we are
supposed to let the user application retry the transmit again. And in
order to do this, we need to roll back the failed send so it can be
retried. Unfortunately, we did not cancel the reservation we had made
in the completion ring. By not doing this, we actually make the
completion ring one entry smaller per NETDEV_TX_BUSY error we get, and
after enough of these errors the completion ring will be of size zero
and transmit will stop working.

Fix this by cancelling the reservation when we get a NETDEV_TX_BUSY
error.

Fixes: 642e450b6b59 ("xsk: Do not discard packet when NETDEV_TX_BUSY")
Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/20201218134525.13119-3-magnus.karlsson@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xdp/xsk.c       |    3 +++
 net/xdp/xsk_queue.h |    5 +++++
 2 files changed, 8 insertions(+)

--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -428,6 +428,9 @@ static int xsk_generic_xmit(struct sock
 		if  (err == NETDEV_TX_BUSY) {
 			/* Tell user-space to retry the send */
 			skb->destructor = sock_wfree;
+			spin_lock_irqsave(&xs->pool->cq_lock, flags);
+			xskq_prod_cancel(xs->pool->cq);
+			spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
 			/* Free skb without triggering the perf drop trace */
 			consume_skb(skb);
 			err = -EAGAIN;
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -286,6 +286,11 @@ static inline bool xskq_prod_is_full(str
 	return !free_entries;
 }
 
+static inline void xskq_prod_cancel(struct xsk_queue *q)
+{
+	q->cached_prod--;
+}
+
 static inline int xskq_prod_reserve(struct xsk_queue *q)
 {
 	if (xskq_prod_is_full(q))


