Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED3A328B07
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbhCAS10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239757AbhCASUg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:20:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 288A1652DC;
        Mon,  1 Mar 2021 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620325;
        bh=CRiuIbclouiUbaLTy6sw927wBmIUJmWe4DITZW1TZjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaFZ+lEULb14hirHPrGOAnzaze2YakYsCONPCZ2/qaXNtkZYhKKfuQKAqqsg9WlKq
         K4Izh+/OO4BfqXZya2Yze1ZLjz2ggZj8UN3PuS+jIcyFUdVexCyy174aApH3u4X54f
         ZHiFJFhpiOt0eOQyAV7hAmp+iNppnDWn0mKppx0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 113/775] net/mlx5: Disallow RoCE on lag device
Date:   Mon,  1 Mar 2021 17:04:41 +0100
Message-Id: <20210301161207.255767168@linuxfoundation.org>
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

[ Upstream commit 7ab91f2b03367f9d25dd807ebdfb0d67295e0e41 ]

In lag mode, setting roce enabled/disable of lag device have no effect.
e.g.: bond device (roce/vf_lag) roce status remain unchanged.
Therefore disable it and add an error message.

Fixes: cc9defcbb8fa ("net/mlx5: Handle "enable_roce" devlink param")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 317ce6b80b23b..c7073193db140 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -273,8 +273,8 @@ static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support RoCE");
 		return -EOPNOTSUPP;
 	}
-	if (mlx5_core_is_mp_slave(dev)) {
-		NL_SET_ERR_MSG_MOD(extack, "Multi port slave device can't configure RoCE");
+	if (mlx5_core_is_mp_slave(dev) || mlx5_lag_is_active(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Multi port slave/Lag device can't configure RoCE");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.27.0



