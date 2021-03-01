Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245F7328F8D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242287AbhCATw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:52:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242208AbhCAToE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:44:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C252264EBA;
        Mon,  1 Mar 2021 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618495;
        bh=eAjSvhkBBZluCsTXUPyqDx6Pspy1webdMF923ZsT4VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SZWDTKk8BIxpelnS4hhUcxG7wSecDDMauTPD4T51Ch7jJevjLr5J9Bg219W48EWGN
         HfcIIHPjVa/shXBP3Xn+6NPZrz+xDKPSdwnepJjtnfCXVsNi7fW8xLxEAlOQqI4AMM
         O9wBRcFemgk9Hj2id3uB8xZHUAZarvYtbJSOgj5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/663] net/mlx5: Disable devlink reload for multi port slave device
Date:   Mon,  1 Mar 2021 17:05:56 +0100
Message-Id: <20210301161147.081144442@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit d89ddaae1766f8fe571ea6eb63ec098ff556f1dd ]

Devlink reload can't be allowed on a multi port slave device, because
reload of slave device doesn't take effect.

The right flow is to disable devlink reload for multi port slave
device. Hence, disabling it in mlx5_core probing.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index e455a2f31f070..8246b6285d5a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1380,7 +1380,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
 
 	pci_save_state(pdev);
-	devlink_reload_enable(devlink);
+	if (!mlx5_core_is_mp_slave(dev))
+		devlink_reload_enable(devlink);
 	return 0;
 
 err_load_one:
-- 
2.27.0



