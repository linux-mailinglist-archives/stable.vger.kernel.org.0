Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FEF1D8538
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbgERR5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731735AbgERR5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:57:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94E3920715;
        Mon, 18 May 2020 17:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824625;
        bh=xtTsyYfsgItSKEaBHLrJ0+2xE14hvp9SsYBsLBVY7Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLp94sijjGfTfaMx189pJyK/wNlA0DQdKFt3lYd21y6emPMY4N5RIUoAzwkn5CBjr
         4/gBa+cKTbXRtnb64++zc/BCV183S7/oeVkOYcZjbGue7BF+lngp2cVR2KY6ydELhn
         GpCpYRY8dTrwFa3soNqyA8nm9MjRJ3rEMnWzT28U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/147] RDMA/core: Fix double put of resource
Date:   Mon, 18 May 2020 19:36:50 +0200
Message-Id: <20200518173524.410646270@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 50bbe3d34fea74b7c0fabe553c40c2f4a48bb9c3 ]

Do not decrease the reference count of resource tracker object twice in
the error flow of res_get_common_doit.

Fixes: c5dfe0ea6ffa ("RDMA/nldev: Add resource tracker doit callback")
Link: https://lore.kernel.org/r/20200507062942.98305-1-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index ef4b0c7061e4c..244ebf285fc3f 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1248,10 +1248,10 @@ static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	has_cap_net_admin = netlink_capable(skb, CAP_NET_ADMIN);
 	ret = fe->fill_res_func(msg, has_cap_net_admin, res, port);
-	rdma_restrack_put(res);
 	if (ret)
 		goto err_free;
 
+	rdma_restrack_put(res);
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
-- 
2.20.1



