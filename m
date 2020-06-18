Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63FB1FE7CA
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgFRCni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728113AbgFRBLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F89320CC7;
        Thu, 18 Jun 2020 01:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442691;
        bh=EvwO6JCvwjH0ii7c8P2k9TCjFrLWsFBoTY+wiB+vL34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmldXKW4DMAMOBkNiM0yLRctZ5uVCSwjTjeF1dz76nsmTlLav5rYuSy9IOb0z41Mg
         TZ/H+ithTZPvUqiSL6CbFVXC0rkZYoSQDXMtxYezhC2/tzFYB+3DujYICLED2RcCJ6
         9h52OqmrVzG7/sC4sZFrn12s116s1KDIF7L4HFuY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 156/388] thermal/drivers/ti-soc-thermal: Avoid dereferencing ERR_PTR
Date:   Wed, 17 Jun 2020 21:04:13 -0400
Message-Id: <20200618010805.600873-156-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

[ Upstream commit 7440f518dad9d861d76c64956641eeddd3586f75 ]

On error the function ti_bandgap_get_sensor_data() returns the error
code in ERR_PTR() but we only checked if the return value is NULL or
not. And, so we can dereference an error code inside ERR_PTR.
While at it, convert a check to IS_ERR_OR_NULL.

Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200424161944.6044-1-sudipm.mukherjee@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index d3e959d01606..85776db4bf34 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -169,7 +169,7 @@ int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
 
-	if (!data || IS_ERR(data))
+	if (!IS_ERR_OR_NULL(data))
 		data = ti_thermal_build_data(bgp, id);
 
 	if (!data)
@@ -196,7 +196,7 @@ int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
 
-	if (data && data->ti_thermal) {
+	if (!IS_ERR_OR_NULL(data) && data->ti_thermal) {
 		if (data->our_zone)
 			thermal_zone_device_unregister(data->ti_thermal);
 	}
@@ -262,7 +262,7 @@ int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id)
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
 
-	if (data) {
+	if (!IS_ERR_OR_NULL(data)) {
 		cpufreq_cooling_unregister(data->cool_dev);
 		if (data->policy)
 			cpufreq_cpu_put(data->policy);
-- 
2.25.1

