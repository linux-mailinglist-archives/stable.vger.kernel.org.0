Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAB24094FC
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245092AbhIMOgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347522AbhIMOel (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:34:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E6AE615E6;
        Mon, 13 Sep 2021 13:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541184;
        bh=NaFQczeRRvShnUGcwVtzfHHtonWS6PsaNy3rEK6pA9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ah0xSJfqziwyUqljiJgmtLGIDLIbCdmlxEnK/hyJRdFpEG+shsI9Oq8jzvbPAmFMf
         Ej/Kd3XSlkstbVGJwKtGJw6SKzV65gywSUkH7zOnZY8zAjzQM9bEdjwvWkS897xs12
         28xpWKNhxhFBCLyPS1ZCHx4fj20aHurb2BV5AwPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 196/334] net/mlx5: Fix unpublish devlink parameters
Date:   Mon, 13 Sep 2021 15:14:10 +0200
Message-Id: <20210913131120.023685255@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit 6f35723864b42ec9e9bb95a503449633395c4975 ]

Cleanup routine missed to unpublish the parameters. Add it.

Fixes: e890acd5ff18 ("net/mlx5: Add devlink flow_steering_mode parameter")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d791d351b489..be6b75bd10f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -670,6 +670,7 @@ params_reg_err:
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
 	mlx5_devlink_traps_unregister(devlink);
+	devlink_params_unpublish(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
-- 
2.30.2



