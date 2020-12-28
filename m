Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02512E3980
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388683AbgL1NYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:24:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:52742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388637AbgL1NYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:24:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9DD1206ED;
        Mon, 28 Dec 2020 13:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161813;
        bh=2XqWZFPId9bk6wT1G3ZQCRlY4/L2OQwvozFut9jjwqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OD0LIUeiOlXm8N/0Gu6Ji+WUmfNNK6tEXkhsLmEeFVycoPJx/BbpbO3vCbenfFLWO
         AVFCmOH7NwbSZK+DUMRGtjFIbTDEAUNQrHCPKkHBmj+C1AiBuy9WPeZU9CGcxL27nK
         kRh5EKrW8MrQP6++XBf7hVdhVQmoGPZE3mP7ibKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/346] xsk: Fix xsk_poll()s return type
Date:   Mon, 28 Dec 2020 13:46:19 +0100
Message-Id: <20201228124922.697398216@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>

[ Upstream commit 5d946c5abbaf68083fa6a41824dd79e1f06286d8 ]

xsk_poll() is defined as returning 'unsigned int' but the
.poll method is declared as returning '__poll_t', a bitwise type.

Fix this by using the proper return type and using the EPOLL
constants instead of the POLL ones, as required for __poll_t.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/20191120001042.30830-1-luc.vanoostenryck@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 9ff2ab63e6392..6bb0649c028c4 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -289,17 +289,17 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	return (xs->zc) ? xsk_zc_xmit(sk) : xsk_generic_xmit(sk, m, total_len);
 }
 
-static unsigned int xsk_poll(struct file *file, struct socket *sock,
+static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
-	unsigned int mask = datagram_poll(file, sock, wait);
+	__poll_t mask = datagram_poll(file, sock, wait);
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 
 	if (xs->rx && !xskq_empty_desc(xs->rx))
-		mask |= POLLIN | POLLRDNORM;
+		mask |= EPOLLIN | EPOLLRDNORM;
 	if (xs->tx && !xskq_full_desc(xs->tx))
-		mask |= POLLOUT | POLLWRNORM;
+		mask |= EPOLLOUT | EPOLLWRNORM;
 
 	return mask;
 }
-- 
2.27.0



