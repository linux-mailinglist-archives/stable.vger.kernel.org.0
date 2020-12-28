Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99902E64E0
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390879AbgL1Pxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:53:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390677AbgL1NhO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:37:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA5A22063A;
        Mon, 28 Dec 2020 13:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162619;
        bh=Q9TkJ8ShH9JIDrwkgqFIpgCicJDV+11vn5+w5kSxC7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E51Dg8QNyNbD6yj5zpbmkhoV57msCwF2p5OFw/1RQO/s2bAFdC3o5kiuyJf7KmI8X
         m/RoQLNBew5mf6utmsMeIz7/G7MaVHZeT/z14g6ECMy5Fm7QLeHvEYXGX3NSb/0/ur
         ev7Jl8uWF73CXyJXisYSSSH/l0BsUFzp6s8Ginek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 015/453] xsk: Replace datagram_poll by sock_poll_wait
Date:   Mon, 28 Dec 2020 13:44:11 +0100
Message-Id: <20201228124937.984994582@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit f5da54187e33dce9bea63170667dbb0ca8d98194 ]

datagram_poll will judge the current socket status (EPOLLIN, EPOLLOUT)
based on the traditional socket information (eg: sk_wmem_alloc), but
this does not apply to xsk. So this patch uses sock_poll_wait instead of
datagram_poll, and the mask is calculated by xsk_poll.

Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/bpf/e82f4697438cd63edbf271ebe1918db8261b7c09.1606555939.git.xuanzhuo@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 04652797cd374..2bc0d6e3e124c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -429,11 +429,13 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
-	__poll_t mask = datagram_poll(file, sock, wait);
+	__poll_t mask = 0;
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
 	struct xdp_umem *umem;
 
+	sock_poll_wait(file, sock, wait);
+
 	if (unlikely(!xsk_is_bound(xs)))
 		return mask;
 
-- 
2.27.0



