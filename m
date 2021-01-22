Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B28430055B
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbhAVO0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728709AbhAVOZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:25:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7DCA23BCF;
        Fri, 22 Jan 2021 14:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325198;
        bh=p9akUb3zrmqwiTwgOqN0+IfWqHlfDh9dl07JoX7DtI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5kwVRoMEpcKOLpybsE/ASTRKxgzP+NgMeTRXuE+T5u/9zDD9DK4Nwm83RnpR3PIy
         Epb4wB/zNvWjplUHcxs4nA+kYyfiqJz6G3szGKpDhYUhgvHQD7pzZDYY48rFz1/YwE
         tKKTALzYQ+ZeWg1UWbAeZ/wBE0SJ7hwo2tuTxLJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 17/43] mlxsw: core: Add validation of transceiver temperature thresholds
Date:   Fri, 22 Jan 2021 15:12:33 +0100
Message-Id: <20210122135736.348381785@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
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
@@ -176,6 +176,12 @@ mlxsw_thermal_module_trips_update(struct
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
@@ -190,11 +196,8 @@ mlxsw_thermal_module_trips_update(struct
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


