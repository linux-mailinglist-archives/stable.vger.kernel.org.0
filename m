Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3AD1F0DC
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbfEOLsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:34616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731754AbfEOLYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:24:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 396AA20818;
        Wed, 15 May 2019 11:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919443;
        bh=x78V6glkD3FrZhsB1aPYUajBeskWtj2i4dms4jnPZ8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eozuOcJ8pBdh+Wom+j0TmTevZBGMxzqCqdOkNZrvxoWKxRWqNRE5IAQTO96KcaPnb
         dGDrPLRFGqtfCJ1A5+oQOlSruGjOL2YB174iCebQvxg0AhrTADz96jKGpFnEvUANRW
         gKWjeY0oX0pM1GIUmRsvSEMnDUUW8RtGK3lwffAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.19 076/113] mlxsw: core: Do not use WQ_MEM_RECLAIM for mlxsw workqueue
Date:   Wed, 15 May 2019 12:56:07 +0200
Message-Id: <20190515090659.330723241@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b442fed1b724af0de087912a5718ddde1b87acbb ]

The workqueue is used to periodically update the networking stack about
activity / statistics of various objects such as neighbours and TC
actions.

It should not be called as part of memory reclaim path, so remove the
WQ_MEM_RECLAIM flag.

Fixes: 3d5479e92087 ("mlxsw: core: Remove deprecated create_workqueue")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 7482db0767afb..2e6df5804b356 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1875,7 +1875,7 @@ static int __init mlxsw_core_module_init(void)
 {
 	int err;
 
-	mlxsw_wq = alloc_workqueue(mlxsw_core_driver_name, WQ_MEM_RECLAIM, 0);
+	mlxsw_wq = alloc_workqueue(mlxsw_core_driver_name, 0, 0);
 	if (!mlxsw_wq)
 		return -ENOMEM;
 	mlxsw_owq = alloc_ordered_workqueue("%s_ordered", 0,
-- 
2.20.1



