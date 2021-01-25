Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98693033AA
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:03:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbhAZFCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:02:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:38990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731171AbhAYSvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E8B52075B;
        Mon, 25 Jan 2021 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600665;
        bh=2Cjgi29JUGLSAOFH70Rues25dQhNiGdruvG3IE7tMGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhYii92aQNm1bmRpGFuuMorde/rdlSxdBxpy0k0ScCJjVGxlOhsP7G2wmA+XwZEu+
         mIhgB/8msY+Ftv+9SNDaFrMO2fbTEqhzR4pJqR7BXHOsxFX5kO9RiErtLPfC02s5b0
         YBFAtnnFqkDJhZ9j7iy2d7Rz4j5YKdwAsqsKgEW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/199] xsk: Clear pool even for inactive queues
Date:   Mon, 25 Jan 2021 19:38:46 +0100
Message-Id: <20210125183220.658165590@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit b425e24a934e21a502d25089c6c7443d799c5594 ]

The number of queues can change by other means, rather than ethtool. For
example, attaching an mqprio qdisc with num_tc > 1 leads to creating
multiple sets of TX queues, which may be then destroyed when mqprio is
deleted. If an AF_XDP socket is created while mqprio is active,
dev->_tx[queue_id].pool will be filled, but then real_num_tx_queues may
decrease with deletion of mqprio, which will mean that the pool won't be
NULLed, and a further increase of the number of TX queues may expose a
dangling pointer.

To avoid any potential misbehavior, this commit clears pool for RX and
TX queues, regardless of real_num_*_queues, still taking into
consideration num_*_queues to avoid overflows.

Fixes: 1c1efc2af158 ("xsk: Create and free buffer pool independently from umem")
Fixes: a41b4f3c58dd ("xsk: simplify xdp_clear_umem_at_qid implementation")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/20210118160333.333439-1-maximmi@mellanox.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index d5f42c62fd79e..52fd1f96b241e 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -107,9 +107,9 @@ EXPORT_SYMBOL(xsk_get_pool_from_qid);
 
 void xsk_clear_pool_at_qid(struct net_device *dev, u16 queue_id)
 {
-	if (queue_id < dev->real_num_rx_queues)
+	if (queue_id < dev->num_rx_queues)
 		dev->_rx[queue_id].pool = NULL;
-	if (queue_id < dev->real_num_tx_queues)
+	if (queue_id < dev->num_tx_queues)
 		dev->_tx[queue_id].pool = NULL;
 }
 
-- 
2.27.0



