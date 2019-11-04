Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BE9EED54
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389850AbfKDWFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:05:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389318AbfKDWFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:05:35 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D1E321929;
        Mon,  4 Nov 2019 22:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905134;
        bh=rADQ7uRo/1bD2l2NSIcwTk6GrNhK79IgegKRNKf2DhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJ/biROuY0xDH8RD6tlGMgj1nynrPibCXLFiEly5MuDISIXNWGIdIoiZ2u5nFt6Sn
         AidvWk9hAAmwPDqZdDv11SB05yZk1imTGZT7Vvu6CS2Ks7zDczK8KsOJoQYdYMX2rl
         ehqB2LqLte2gp+Lw2Y1bQcpF4nmi1EhbKMQY5ZT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 039/163] RDMA/nldev: Reshuffle the code to avoid need to rebind QP in error path
Date:   Mon,  4 Nov 2019 22:43:49 +0100
Message-Id: <20191104212143.134265389@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

[ Upstream commit 594e6c5d41ed2471ab0b90f3f0b66cdf618b7ac9 ]

Properly unwind QP counter rebinding in case of failure.

Trying to rebind the counter after unbiding it is not going to work
reliably, move the unbind to the end so it doesn't have to be unwound.

Fixes: b389327df905 ("RDMA/nldev: Allow counter manual mode configration through RDMA netlink")
Link: https://lore.kernel.org/r/20191002115627.16740-1-leon@kernel.org
Reviewed-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 91e2cc9ddb9f8..f42e856f30729 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1787,10 +1787,6 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
 	qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
-	ret = rdma_counter_unbind_qpn(device, port, qpn, cntn);
-	if (ret)
-		goto err_unbind;
-
 	if (fill_nldev_handle(msg, device) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, port) ||
 	    nla_put_u32(msg, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn) ||
@@ -1799,13 +1795,15 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto err_fill;
 	}
 
+	ret = rdma_counter_unbind_qpn(device, port, qpn, cntn);
+	if (ret)
+		goto err_fill;
+
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
 	return rdma_nl_unicast(msg, NETLINK_CB(skb).portid);
 
 err_fill:
-	rdma_counter_bind_qpn(device, port, qpn, cntn);
-err_unbind:
 	nlmsg_free(msg);
 err:
 	ib_device_put(device);
-- 
2.20.1



