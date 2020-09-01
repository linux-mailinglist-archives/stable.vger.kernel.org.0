Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE32E259794
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 18:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbgIAQQB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 12:16:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729463AbgIAPef (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:34:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6633021582;
        Tue,  1 Sep 2020 15:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974467;
        bh=1707qQ10LAEAGo9o7LZgT2Bu+3XkbCXhvwIxoK85cx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3KM4QE1px2a4K4yjYy+yCrukBU8fwinoxmBYd7v+PV11r9BLmFZTZUQAGWlgxHzn
         /YrjTY2pqpjEV5D1qMAe2PAt4ws47rsofh3X/sr6Anerv5yxIVa1H4aELVUJzJa9aU
         whG8RoqER/o3XP9Gi5DbWdqw/7WmsgoAid0jnk5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 187/214] drm/amd/pm: correct Vega20 swctf limit setting
Date:   Tue,  1 Sep 2020 17:11:07 +0200
Message-Id: <20200901151001.907451487@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 9b51c4b2ba31396f3894ccc7df8bdf067243e9f5 upstream.

Correct the Vega20 thermal swctf limit.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/vega20_thermal.c
@@ -240,6 +240,8 @@ int vega20_thermal_get_temperature(struc
 static int vega20_thermal_set_temperature_range(struct pp_hwmgr *hwmgr,
 		struct PP_TemperatureRange *range)
 {
+	struct phm_ppt_v3_information *pptable_information =
+		(struct phm_ppt_v3_information *)hwmgr->pptable;
 	struct amdgpu_device *adev = hwmgr->adev;
 	int low = VEGA20_THERMAL_MINIMUM_ALERT_TEMP *
 			PP_TEMPERATURE_UNITS_PER_CENTIGRADES;
@@ -249,8 +251,8 @@ static int vega20_thermal_set_temperatur
 
 	if (low < range->min)
 		low = range->min;
-	if (high > range->max)
-		high = range->max;
+	if (high > pptable_information->us_software_shutdown_temp)
+		high = pptable_information->us_software_shutdown_temp;
 
 	if (low > high)
 		return -EINVAL;


