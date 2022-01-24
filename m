Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAB9499B18
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574494AbiAXVti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456715AbiAXVjy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828F6C0419CD;
        Mon, 24 Jan 2022 12:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27D8BB8122F;
        Mon, 24 Jan 2022 20:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40336C340E5;
        Mon, 24 Jan 2022 20:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056016;
        bh=1PybLUB2+DcUQg1vl2n3BluKdz3jaZoo+BtLc1Ze5oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqZhcvMMpJGxfMdpbaI6fcunk2PE+/D3GmDu+BJPtZ3fHZL06ceLGlRQrCHh4ILcj
         dTL2JKyUPmGWyP06Q02esZux7I0bCAs1Qyum8lpFfZpcQ9z4b627SbG/CYXYMZDZgk
         HcXTFa4pjHZK+F+vUGy08Sg/Jtb8VvfhflW747Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 343/846] net/mlx5: Fix access to sf_dev_table on allocation failure
Date:   Mon, 24 Jan 2022 19:37:40 +0100
Message-Id: <20220124184112.755779053@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index 871c2fbe18d39..64bbc18332d56 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -28,10 +28,7 @@ bool mlx5_sf_dev_allocated(const struct mlx5_core_dev *dev)
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



