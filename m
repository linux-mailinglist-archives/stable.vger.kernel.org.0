Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3FE1D8483
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730621AbgERSE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:04:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732779AbgERSEZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:04:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12179207F5;
        Mon, 18 May 2020 18:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825065;
        bh=XqyQOH1CNWAtJ5rtGAxtJVoKyUbzhOxZj6h4kugtHog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KrlvN+xNBQtotClxnfJF0CUKBJ/MhMKeIdgmEnTJdo+osMdmDKSfm1+H0tKp2pelO
         8mTUkAwdsveS+c5Bse40h9sQKMBctvx95tNnCZCtNFm8AujOz+/IkNw7dWHdPImP4r
         N/1BnHmsu+dDTmFNl8DlaaALcUFmbqU6KIAX6UEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 114/194] RDMA/core: Fix double put of resource
Date:   Mon, 18 May 2020 19:36:44 +0200
Message-Id: <20200518173541.219710745@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

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
 drivers/infiniband/core/nldev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 9eec26d10d7b1..e16105be2eb23 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1292,11 +1292,10 @@ static int res_get_common_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	has_cap_net_admin = netlink_capable(skb, CAP_NET_ADMIN);
 
 	ret = fill_func(msg, has_cap_net_admin, res, port);
-
-	rdma_restrack_put(res);
 	if (ret)
 		goto err_free;
 
+	rdma_restrack_put(res);
 	nlmsg_end(msg, nlh);
 	ib_device_put(device);
 	return rdma_nl_unicast(sock_net(skb->sk), msg, NETLINK_CB(skb).portid);
-- 
2.20.1



