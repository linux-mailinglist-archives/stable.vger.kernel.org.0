Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ADE3DDA1C
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhHBOGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:06:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235616AbhHBODI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:03:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB49E61245;
        Mon,  2 Aug 2021 13:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912627;
        bh=w8LG4SGjI07S3SqEp3/DqM01iAQIzXLzr0NppjkdDDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTIylboad9hIu2tFpXYxHSfW3jJYQeFIcF6YXU8INDwXibrOLDq0QiySogVk5qkOB
         Tb6sfMrqrqylQyibGFAdog94mZ1ZUtT0WM7undZUJvCQavntcMBIdHjToNkuPneoOe
         SHduiYWcwhLgJNzacmA2tLlSy6pyY9UjGa7SJNmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 078/104] net/mlx5: E-Switch, handle devcom events only for ports on the same device
Date:   Mon,  2 Aug 2021 15:45:15 +0200
Message-Id: <20210802134346.579410900@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit dd3fddb82780bfa24124834edd90bbc63bd689cc ]

This is the same check as LAG mode checks if to enable lag.
This will fix adding peer miss rules if lag is not supported
and even an incorrect rules in socket direct mode.

Also fix the incorrect comment on mlx5_get_next_phys_dev() as flow #1
doesn't exists.

Fixes: ac004b832128 ("net/mlx5e: E-Switch, Add peer miss rules")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c              | 5 +----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 3 +++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index ceebfc20f65e..def2156e50ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -500,10 +500,7 @@ static int next_phys_dev(struct device *dev, const void *data)
 	return 1;
 }
 
-/* This function is called with two flows:
- * 1. During initialization of mlx5_core_dev and we don't need to lock it.
- * 2. During LAG configure stage and caller holds &mlx5_intf_mutex.
- */
+/* Must be called with intf_mutex held */
 struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
 {
 	struct auxiliary_device *adev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 91571156a89d..b66e12753f37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2351,6 +2351,9 @@ static int mlx5_esw_offloads_devcom_event(int event,
 
 	switch (event) {
 	case ESW_OFFLOADS_DEVCOM_PAIR:
+		if (mlx5_get_next_phys_dev(esw->dev) != peer_esw->dev)
+			break;
+
 		if (mlx5_eswitch_vport_match_metadata_enabled(esw) !=
 		    mlx5_eswitch_vport_match_metadata_enabled(peer_esw))
 			break;
-- 
2.30.2



