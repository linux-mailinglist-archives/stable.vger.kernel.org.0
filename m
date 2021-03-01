Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444FD328DDE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhCATSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:18:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241185AbhCATPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:15:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B02C652DB;
        Mon,  1 Mar 2021 17:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620323;
        bh=7MbYujPS7xpkq/1GI8xly21i8kpWVAHvV0+WzJYU6xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHe/pw97kR1tUjsTg6ssbR8E7Vgej3P0OHKqshgAygdNfY/yfR39tsd7KsTSAxXOM
         hxRezMGyrsCv7HfCWqJTMnQx8agZ4Uyk5MHFUhrah94lH7kHHs9mXIw6O8Ma9iEO5O
         YP5v/95b7LglAaqhIxth2XqUrm1mpJGiKkMsqvX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 112/775] net/mlx5: Disallow RoCE on multi port slave device
Date:   Mon,  1 Mar 2021 17:04:40 +0100
Message-Id: <20210301161207.204839147@linuxfoundation.org>
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

[ Upstream commit c70f8597fcc1399ef6d5b5ce648a31d887d5dba2 ]

In dual port mode, setting roce enabled/disable for the slave device
have no effect. e.g.: the slave device roce status remain unchanged.
Therefore disable it and add an error message.
Enable or disable roce of the master device affect both master and slave
devices.

Fixes: cc9defcbb8fa ("net/mlx5: Handle "enable_roce" devlink param")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 3261d0dc11044..317ce6b80b23b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -273,6 +273,10 @@ static int mlx5_devlink_enable_roce_validate(struct devlink *devlink, u32 id,
 		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support RoCE");
 		return -EOPNOTSUPP;
 	}
+	if (mlx5_core_is_mp_slave(dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Multi port slave device can't configure RoCE");
+		return -EOPNOTSUPP;
+	}
 
 	return 0;
 }
-- 
2.27.0



