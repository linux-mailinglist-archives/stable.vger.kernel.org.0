Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A37D21FB64D
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgFPPgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:46664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728917AbgFPPgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:36:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AF9520C09;
        Tue, 16 Jun 2020 15:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321771;
        bh=mlbf5webgelWXh1c2w76bsMcqMr/gV9ShhQ99iTpZc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7UKEG3Na5OmN1Ob+g3pTEOoCUTAiFMhre9QJPa/gWFko2d/z7/YcrysWt5h+dsJu
         noWbiWTFEFK0IEmCLytBCdAHEVmBWRINNgWs4bRnYLLUebAVg8glEiedjxyHg7dMKI
         l2JxRJxf5ME5MykWKT78/w6dsR4US3YOdSL2y6XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 002/134] mlxsw: core: Use different get_trend() callbacks for different thermal zones
Date:   Tue, 16 Jun 2020 17:33:06 +0200
Message-Id: <20200616153100.765876058@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

[ Upstream commit 2dc2f760052da4925482ecdcdc5c94d4a599153c ]

The driver registers three different types of thermal zones: For the
ASIC itself, for port modules and for gearboxes.

Currently, all three types use the same get_trend() callback which does
not work correctly for the ASIC thermal zone. The callback assumes that
the device data is of type 'struct mlxsw_thermal_module', whereas for
the ASIC thermal zone 'struct mlxsw_thermal' is passed as device data.

Fix this by using one get_trend() callback for the ASIC thermal zone and
another for the other two types.

Fixes: 6f73862fabd9 ("mlxsw: core: Add the hottest thermal zone detection")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   23 +++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -390,8 +390,7 @@ static int mlxsw_thermal_set_trip_hyst(s
 static int mlxsw_thermal_trend_get(struct thermal_zone_device *tzdev,
 				   int trip, enum thermal_trend *trend)
 {
-	struct mlxsw_thermal_module *tz = tzdev->devdata;
-	struct mlxsw_thermal *thermal = tz->parent;
+	struct mlxsw_thermal *thermal = tzdev->devdata;
 
 	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
 		return -EINVAL;
@@ -592,6 +591,22 @@ mlxsw_thermal_module_trip_hyst_set(struc
 	return 0;
 }
 
+static int mlxsw_thermal_module_trend_get(struct thermal_zone_device *tzdev,
+					  int trip, enum thermal_trend *trend)
+{
+	struct mlxsw_thermal_module *tz = tzdev->devdata;
+	struct mlxsw_thermal *thermal = tz->parent;
+
+	if (trip < 0 || trip >= MLXSW_THERMAL_NUM_TRIPS)
+		return -EINVAL;
+
+	if (tzdev == thermal->tz_highest_dev)
+		return 1;
+
+	*trend = THERMAL_TREND_STABLE;
+	return 0;
+}
+
 static struct thermal_zone_device_ops mlxsw_thermal_module_ops = {
 	.bind		= mlxsw_thermal_module_bind,
 	.unbind		= mlxsw_thermal_module_unbind,
@@ -603,7 +618,7 @@ static struct thermal_zone_device_ops ml
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_trend_get,
+	.get_trend	= mlxsw_thermal_module_trend_get,
 };
 
 static int mlxsw_thermal_gearbox_temp_get(struct thermal_zone_device *tzdev,
@@ -642,7 +657,7 @@ static struct thermal_zone_device_ops ml
 	.set_trip_temp	= mlxsw_thermal_module_trip_temp_set,
 	.get_trip_hyst	= mlxsw_thermal_module_trip_hyst_get,
 	.set_trip_hyst	= mlxsw_thermal_module_trip_hyst_set,
-	.get_trend	= mlxsw_thermal_trend_get,
+	.get_trend	= mlxsw_thermal_module_trend_get,
 };
 
 static int mlxsw_thermal_get_max_state(struct thermal_cooling_device *cdev,


