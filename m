Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE107DD4A4
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfJRWEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:04:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbfJRWEN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F2AB222C3;
        Fri, 18 Oct 2019 22:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436253;
        bh=rADQ7uRo/1bD2l2NSIcwTk6GrNhK79IgegKRNKf2DhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0Ieb+RS4g3q4fhIN1sLMCQz3vyQ0TtQD7VjNo7dtA9fSLGGqeyuLf7D7p69cHcBa
         8PeponsW//nR2r5H8TXOWMnhzs8v3dc5V415xQNjByu9bQU62CPkKDYe39MpfoquYo
         TrkhVm6hb999r8EGWZGEy5/qeOhB3RdndHiE2UWw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 36/89] RDMA/nldev: Reshuffle the code to avoid need to rebind QP in error path
Date:   Fri, 18 Oct 2019 18:02:31 -0400
Message-Id: <20191018220324.8165-36-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

