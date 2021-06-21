Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0D03AEF4C
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232724AbhFUQhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:37:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233243AbhFUQfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:35:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0DE16141E;
        Mon, 21 Jun 2021 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292875;
        bh=58p587Ztdh+iyD4r1ZSxRkyriJmylklzXXsDINK6tCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O98Qq1XUyCdLqVF2metqT6UDy0mVABlhGVDNIcs4Z4sxiLuU1cfmuktQegu4elrag
         tEpL/9EakvoG3hFjwl5LBP6dWYwag0D2PcsxRfd2Yi1voF9hVG2s010nd0rSc3xw9Z
         DQzwdEgC9H4eYXGrc554NLB6HZmP2MLrdrH50RTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Mykola Kostenok <c_mykolak@nvidia.com>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 017/178] mlxsw: core: Set thermal zone polling delay argument to real value at init
Date:   Mon, 21 Jun 2021 18:13:51 +0200
Message-Id: <20210621154922.250348868@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mykola Kostenok <c_mykolak@nvidia.com>

[ Upstream commit 2fd8d84ce3095e8a7b5fe96532c91b1b9e07339c ]

Thermal polling delay argument for modules and gearboxes thermal zones
used to be initialized with zero value, while actual delay was used to
be set by mlxsw_thermal_set_mode() by thermal operation callback
set_mode(). After operations set_mode()/get_mode() have been removed by
cited commits, modules and gearboxes thermal zones always have polling
time set to zero and do not perform temperature monitoring.

Set non-zero "polling_delay" in thermal_zone_device_register() routine,
thus, the relevant thermal zones will perform thermal monitoring.

Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Fixes: 5d7bd8aa7c35 ("thermal: Simplify or eliminate unnecessary set_mode() methods")
Fixes: 1ee14820fd8e ("thermal: remove get_mode() operation of drivers")
Signed-off-by: Mykola Kostenok <c_mykolak@nvidia.com>
Acked-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index bf85ce9835d7..42e4437ac3c1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -708,7 +708,8 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
 							MLXSW_THERMAL_TRIP_MASK,
 							module_tz,
 							&mlxsw_thermal_module_ops,
-							NULL, 0, 0);
+							NULL, 0,
+							module_tz->parent->polling_delay);
 	if (IS_ERR(module_tz->tzdev)) {
 		err = PTR_ERR(module_tz->tzdev);
 		return err;
@@ -830,7 +831,8 @@ mlxsw_thermal_gearbox_tz_init(struct mlxsw_thermal_module *gearbox_tz)
 						MLXSW_THERMAL_TRIP_MASK,
 						gearbox_tz,
 						&mlxsw_thermal_gearbox_ops,
-						NULL, 0, 0);
+						NULL, 0,
+						gearbox_tz->parent->polling_delay);
 	if (IS_ERR(gearbox_tz->tzdev))
 		return PTR_ERR(gearbox_tz->tzdev);
 
-- 
2.30.2



