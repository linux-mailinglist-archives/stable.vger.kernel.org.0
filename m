Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1977328F50
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbhCATsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241739AbhCATix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1292652DA;
        Mon,  1 Mar 2021 17:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620328;
        bh=WUxmzZfydwHe0wWBA3mir5wQeuuzTKyJWNifVrjz+q0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1tnJAnmZpv9UiKFQBhJ92zrrA3F9Wv/rqkvJuuAclOvpuv29aci5WvQQF1UaNjEt
         +lFXLJWPzxQR0XQ13XnrIjVtpKeEvbYSqbgsZRN6JgB75NwjNoLNjfS+M1exj1+iB2
         4Eanep2ICH54g92gtu1b4PLUAHdzWuGFt6bF+6+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 114/775] net/mlx5: Disable devlink reload for lag devices
Date:   Mon,  1 Mar 2021 17:04:42 +0100
Message-Id: <20210301161207.307532885@linuxfoundation.org>
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

[ Upstream commit edac23c2b3d3ac64cfcd351087295893671adbf5 ]

Devlink reload can't be allowed on lag devices since reloading one lag
device will cause traffic on the bond to get stucked.
Users who wish to reload a lag device, need to remove the device from
the bond, and only then reload it.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index c7073193db140..41474e42a819a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -128,6 +128,11 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
+	if (mlx5_lag_is_active(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "reload is unsupported in Lag mode\n");
+		return -EOPNOTSUPP;
+	}
+
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
 		mlx5_unload_one(dev, false);
-- 
2.27.0



