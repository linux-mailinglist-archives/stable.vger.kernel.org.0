Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11EC27C3E4
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgI2LJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729036AbgI2LJB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:09:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F8521D92;
        Tue, 29 Sep 2020 11:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377740;
        bh=IMqgfg1I+JZ+Db7k4qTX1k8eQKQ+wMBHtVjAinua6Mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dm9g5YyvLhFmzs3FfVCOiBhCp8GiJUtCKXGEpVpjeKmIhi9yL9w49Uql8PGBjyNKu
         cCvpR/OQHCng65enCV8GUe8djr19CVZXsefeHuNZhnnJgormA4bJGWieR5yD6EcM+X
         R1JaBQsWObLiFFeRy+AkMY1HUcf41y6F/0dZV8Eg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 025/121] RDMA/i40iw: Fix potential use after free
Date:   Tue, 29 Sep 2020 12:59:29 +0200
Message-Id: <20200929105931.436641200@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit da046d5f895fca18d63b15ac8faebd5bf784e23a ]

Release variable dst after logging dst->error to avoid possible use after
free.

Link: https://lore.kernel.org/r/1573022651-37171-1-git-send-email-bianpan2016@163.com
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 282a726351c81..ce1a4817ab923 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -2036,9 +2036,9 @@ static int i40iw_addr_resolve_neigh_ipv6(struct i40iw_device *iwdev,
 	dst = i40iw_get_dst_ipv6(&src_addr, &dst_addr);
 	if (!dst || dst->error) {
 		if (dst) {
-			dst_release(dst);
 			i40iw_pr_err("ip6_route_output returned dst->error = %d\n",
 				     dst->error);
+			dst_release(dst);
 		}
 		return rc;
 	}
-- 
2.25.1



