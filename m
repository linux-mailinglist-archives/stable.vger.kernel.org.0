Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E18D200FD3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393016AbgFSPWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393011AbgFSPWc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD7AA21582;
        Fri, 19 Jun 2020 15:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580151;
        bh=oFIdwIPcbSh6WjyfTNz2t9h1mlmA98OxWyFA46v78Jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/spPdRv45gj7x2DuTVjIcMaoE2r5yq2cbH4CWNBk3xLzy4g1vSUojPJrZ0yR3KtV
         xt1Ym9f+PQNhMQUWsPA4ilbPCtSp6up3SGc0nsa49V1cxufs+Z1+46ZJlVrL/+p5R+
         ZoQw0ee5xaunD3eYGO0t9VP45Vws9JQKautZMZDY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 114/376] net/mlx4_core: Add missing iounmap() in error path
Date:   Fri, 19 Jun 2020 16:30:32 +0200
Message-Id: <20200619141715.742868593@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit c90af587a9eee697e2d89683113707cada70116a ]

This fixes the following coccicheck warning:

drivers/net/ethernet/mellanox/mlx4/crdump.c:200:2-8: ERROR: missing iounmap;
ioremap on line 190 and execution via conditional on line 198

Fixes: 7ef19d3b1d5e ("devlink: report error once U32_MAX snapshot ids have been used")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index 73eae80e1cb7..ac5468b77488 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -197,6 +197,7 @@ int mlx4_crdump_collect(struct mlx4_dev *dev)
 	err = devlink_region_snapshot_id_get(devlink, &id);
 	if (err) {
 		mlx4_err(dev, "crdump: devlink get snapshot id err %d\n", err);
+		iounmap(cr_space);
 		return err;
 	}
 
-- 
2.25.1



