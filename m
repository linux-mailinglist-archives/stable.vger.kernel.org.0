Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 165D83289D8
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhCASGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:06:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239235AbhCAR7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:59:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDF33652D4;
        Mon,  1 Mar 2021 17:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620320;
        bh=8w1TZUV8hSH9PhnDkiPf0xwdfKjVcyUm54xyB2G8qoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgPgqSWw5LlShG/qMK4O0ERUj4lTgYPoYFp6b/01k0BnJWbmv72a9ELCeA+3wBSBo
         shIqc0EWjM0j7AC/f9w/hlF9n+Ybqkxw4UCPUytWq3GRdt59E9uWVkKH5Sqrrd8Jj0
         c+atEPVxRp815EFhfmPsIc0e04hweYFyfYMxBs7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 111/775] net/mlx5: Disable devlink reload for multi port slave device
Date:   Mon,  1 Mar 2021 17:04:39 +0100
Message-Id: <20210301161207.154146883@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index ca6f2fc39ea0a..ba1a4ae28097d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1396,7 +1396,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
 
 	pci_save_state(pdev);
-	devlink_reload_enable(devlink);
+	if (!mlx5_core_is_mp_slave(dev))
+		devlink_reload_enable(devlink);
 	return 0;
 
 err_load_one:
-- 
2.27.0



