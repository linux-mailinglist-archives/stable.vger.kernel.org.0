Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59AE300B18
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbhAVSVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:21:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbhAVOXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2224F23B7E;
        Fri, 22 Jan 2021 14:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325059;
        bh=BreF1d2jKNiFg+Fwk9ONHe4R+VqIPJQd+QFwBQeAnSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxWxTsUJa9UxePD6GwJc3JtnJJu4K8ktPxZa6mGzb1BMmJ9q34nD4YvPOBgPNK4Au
         MY+3LOxEEnLIJSZZXkvVIiB+SK5u9ZIii8PoaNesXcVY44y4g3wWwiR3aqcsvwJ0CX
         2evxCx7EHUCs0VBmxInQ9pp+YVCxSh87/PrRnONo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 17/33] mlxsw: core: Add validation of transceiver temperature thresholds
Date:   Fri, 22 Jan 2021 15:12:33 +0100
Message-Id: <20210122135734.282982816@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit 57726ebe2733891c9f59105eff028735f73d05fb ]

Validate thresholds to avoid a single failure due to some transceiver
unreliability. Ignore the last readouts in case warning temperature is
above alarm temperature, since it can cause unexpected thermal
shutdown. Stay with the previous values and refresh threshold within
the next iteration.

This is a rare scenario, but it was observed at a customer site.

Fixes: 6a79507cfe94 ("mlxsw: core: Extend thermal module with per QSFP module thermal zones")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -177,6 +177,12 @@ mlxsw_thermal_module_trips_update(struct
 	if (err)
 		return err;
 
+	if (crit_temp > emerg_temp) {
+		dev_warn(dev, "%s : Critical threshold %d is above emergency threshold %d\n",
+			 tz->tzdev->type, crit_temp, emerg_temp);
+		return 0;
+	}
+
 	/* According to the system thermal requirements, the thermal zones are
 	 * defined with four trip points. The critical and emergency
 	 * temperature thresholds, provided by QSFP module are set as "active"
@@ -191,11 +197,8 @@ mlxsw_thermal_module_trips_update(struct
 		tz->trips[MLXSW_THERMAL_TEMP_TRIP_NORM].temp = crit_temp;
 	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HIGH].temp = crit_temp;
 	tz->trips[MLXSW_THERMAL_TEMP_TRIP_HOT].temp = emerg_temp;
-	if (emerg_temp > crit_temp)
-		tz->trips[MLXSW_THERMAL_TEMP_TRIP_CRIT].temp = emerg_temp +
+	tz->trips[MLXSW_THERMAL_TEMP_TRIP_CRIT].temp = emerg_temp +
 					MLXSW_THERMAL_MODULE_TEMP_SHIFT;
-	else
-		tz->trips[MLXSW_THERMAL_TEMP_TRIP_CRIT].temp = emerg_temp;
 
 	return 0;
 }


