Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87700273030
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 19:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgIUQhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:37600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728681AbgIUQhT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:37:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74250206B7;
        Mon, 21 Sep 2020 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706239;
        bh=a/DBhDU9dITUGcVCZ0xcp0swSwSVyTH4WRKPaXBO/UY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxoaUElT5dCg0M6MsW39kAoxY3QxPrPkQ4fMXYi0smP6rKuJrWVX9+gGQU6LucOQ7
         eWwjCPcpOSk6pKFKdRRuH5Hg2WwAbuWKAd5i5sYXU4CnHkz5NwIF0TqrSz/MygkrLf
         Dkmb3A9BA/uEh5wqF9wYQcxDBXVUCh1BTTsrJj2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalheib1@gmail.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/94] RDMA/rxe: Drop pointless checks in rxe_init_ports
Date:   Mon, 21 Sep 2020 18:26:50 +0200
Message-Id: <20200921162035.704780710@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162035.541285330@linuxfoundation.org>
References: <20200921162035.541285330@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 6112ef62826e91afbae5446d5d47b38e25f47e3f ]

Both pkey_tbl_len and gid_tbl_len are set in rxe_init_port_param() - so no
need to check if they aren't set.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20200705104313.283034-2-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 8c3d30b3092d4..25267a620e0b5 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -170,9 +170,6 @@ static int rxe_init_ports(struct rxe_dev *rxe)
 
 	rxe_init_port_param(port);
 
-	if (!port->attr.pkey_tbl_len || !port->attr.gid_tbl_len)
-		return -EINVAL;
-
 	port->pkey_tbl = kcalloc(port->attr.pkey_tbl_len,
 			sizeof(*port->pkey_tbl), GFP_KERNEL);
 
-- 
2.25.1



