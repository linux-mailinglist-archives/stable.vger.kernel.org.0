Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D732681030
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbjA3OBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236957AbjA3OBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:01:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598273B3D1
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37B296102D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C9AC433D2;
        Mon, 30 Jan 2023 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087229;
        bh=2hID+bHTjE4+rJid8k5GEqbMycCoKGWv34BaYDUjRvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fm0nZngsY7/XUuPvcjyQOtoTqHcnIQyVX6TsAS8GA4CYIkBTLXtEtJbmfqsc+Tjnl
         Dwm9OTA2BBgElKZc8y5p+BFmZmN0X2p+Ef3fMEWI7HOps0WadcOmFoNTCgHGSg0vRZ
         AldQXATT/KwmwOOO25R6UJB7dSLWOcIAVk+jbEZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chris Mi <cmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/313] net/mlx5: E-switch, Fix switchdev mode after devlink reload
Date:   Mon, 30 Jan 2023 14:49:05 +0100
Message-Id: <20230130134341.780292752@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 7c83d1f4c5adae9583e7fca1e3e830d6b061522d ]

The cited commit removes eswitch mode none. So after devlink reload
in switchdev mode, eswitch mode is not changed. But actually eswitch
is disabled during devlink reload.

Fix it by setting eswitch mode to legacy when disabling eswitch
which is called by reload_down.

Fixes: f019679ea5f2 ("net/mlx5: E-switch, Remove dependency between sriov and eswitch mode")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 788a6ab5c463..43ba00d5e36e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1421,6 +1421,7 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw)
 	mlx5_lag_disable_change(esw->dev);
 	down_write(&esw->mode_lock);
 	mlx5_eswitch_disable_locked(esw);
+	esw->mode = MLX5_ESWITCH_LEGACY;
 	up_write(&esw->mode_lock);
 	mlx5_lag_enable_change(esw->dev);
 }
-- 
2.39.0



