Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E314E49A2D7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365991AbiAXXwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843476AbiAXXED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF6DC06C5AE;
        Mon, 24 Jan 2022 13:15:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C82861484;
        Mon, 24 Jan 2022 21:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF4EC340E5;
        Mon, 24 Jan 2022 21:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058917;
        bh=StLZvHkPPjNWX2Zkf87Xunam5bpuvhcD5gKxOAP1LCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rehNUeHjYOlq1lAUKykXTH8FHqjZ0OCIUNPHm0gv/zAgQ/KM1ZqCU2kBxv0LrgLnn
         /8oPjocxA2z4xyszo4zeKh8wPbihbPzRoyZMkylovZsrewFwz+Tn/Awwer3LFRkg8I
         s8bNsWxp3PdGoQ2DiIssM/80iO+3cuZ0jXXFmCus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0412/1039] net/mlx5: Fix access to sf_dev_table on allocation failure
Date:   Mon, 24 Jan 2022 19:36:41 +0100
Message-Id: <20220124184139.165179659@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit a1c7c49c2091926962f8c1c866d386febffec5d8 ]

Even when SF devices are supported, the SF device table allocation
can still fail.
In such case mlx5_sf_dev_supported still reports true, but SF device
table is invalid. This can result in NULL table access.

Hence, fix it by adding NULL table check.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index f37db7cc32a65..7da012ff0d419 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -30,10 +30,7 @@ bool mlx5_sf_dev_allocated(const struct mlx5_core_dev *dev)
 {
 	struct mlx5_sf_dev_table *table = dev->priv.sf_dev_table;
 
-	if (!mlx5_sf_dev_supported(dev))
-		return false;
-
-	return !xa_empty(&table->devices);
+	return table && !xa_empty(&table->devices);
 }
 
 static ssize_t sfnum_show(struct device *dev, struct device_attribute *attr, char *buf)
-- 
2.34.1



