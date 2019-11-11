Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85FBCF7D3C
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbfKKSyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:54:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729538AbfKKSyj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:54:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 455E220818;
        Mon, 11 Nov 2019 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498479;
        bh=pur4SZ1TslIwdXzg0QtfP1E6LnyIzDKBcr/u+XQoe6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uk+bzJnQ4DWT5hZA+SyZX1/IcLCyMVaUpXi5Nrwa6IAi5WOwA8CqOb+EndjvQY9Rd
         Iog6mhInQnd1TsONKQTY4SBcULYItEstPJwzP+2woQGdMvC1x6euYwDsRFpzrb4PXG
         GK+XDIecDTX8kNEtCwv6YIRE/+PDYCEoXZVR3/nQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 131/193] RDMA/nldev: Skip counter if port doesnt match
Date:   Mon, 11 Nov 2019 19:28:33 +0100
Message-Id: <20191111181510.839768118@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

[ Upstream commit a15542bb72a48042f5df7475893d46f725f5f9fb ]

The counter resource should return -EAGAIN if it was requested for a
different port, this is similar to how QP works if the users provides a
port filter.

Otherwise port filtering in netlink will return broken counter nests.

Fixes: c4ffee7c9bdb ("RDMA/netlink: Implement counter dumpit calback")
Link: https://lore.kernel.org/r/20191020062800.8065-1-leon@kernel.org
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index f42e856f30729..4300e21865845 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -778,7 +778,7 @@ static int fill_res_counter_entry(struct sk_buff *msg, bool has_cap_net_admin,
 		container_of(res, struct rdma_counter, res);
 
 	if (port && port != counter->port)
-		return 0;
+		return -EAGAIN;
 
 	/* Dump it even query failed */
 	rdma_counter_query_stats(counter);
-- 
2.20.1



