Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842A413F0AB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395542AbgAPSXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:23:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392450AbgAPR1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:27:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CB90246D3;
        Thu, 16 Jan 2020 17:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195637;
        bh=8ulGqGGgG/KSl86q7oAlWShVtHvVkhPD+22UvMfrX/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKnR8yxAGl2TMXtgW5W9Y5YV18p+77jaHz8KsmXFhs/NIRr/3ggNGzczLZX2QQlM8
         R7/650OK2FRTlAv9uuUWvRDGJdGZOCH985kfPSvOMQo6ISYQpxmw2jVPo8PBZVePXS
         JUgj7itcrdn8E8aKalq4rzm21zNnWzHCou81m2BQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Javi Merino <javi.merino@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 203/371] thermal: cpu_cooling: Actually trace CPU load in thermal_power_cpu_get_power
Date:   Thu, 16 Jan 2020 12:21:15 -0500
Message-Id: <20200116172403.18149-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

[ Upstream commit bf45ac18b78038e43af3c1a273cae4ab5704d2ce ]

The CPU load values passed to the thermal_power_cpu_get_power
tracepoint are zero for all CPUs, unless, unless the
thermal_power_cpu_limit tracepoint is enabled too:

  irq/41-rockchip-98    [000] ....   290.972410: thermal_power_cpu_get_power:
  cpus=0000000f freq=1800000 load={{0x0,0x0,0x0,0x0}} dynamic_power=4815

vs

  irq/41-rockchip-96    [000] ....    95.773585: thermal_power_cpu_get_power:
  cpus=0000000f freq=1800000 load={{0x56,0x64,0x64,0x5e}} dynamic_power=4959
  irq/41-rockchip-96    [000] ....    95.773596: thermal_power_cpu_limit:
  cpus=0000000f freq=408000 cdev_state=10 power=416

There seems to be no good reason for omitting the CPU load information
depending on another tracepoint. My guess is that the intention was to
check whether thermal_power_cpu_get_power is (still) enabled, however
'load_cpu != NULL' already indicates that it was at least enabled when
cpufreq_get_requested_power() was entered, there seems little gain
from omitting the assignment if the tracepoint was just disabled, so
just remove the check.

Fixes: 6828a4711f99 ("thermal: add trace events to the power allocator governor")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Acked-by: Javi Merino <javi.merino@kernel.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/cpu_cooling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 908a8014cf76..aed995ec2c90 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -514,7 +514,7 @@ static int cpufreq_get_requested_power(struct thermal_cooling_device *cdev,
 			load = 0;
 
 		total_load += load;
-		if (trace_thermal_power_cpu_limit_enabled() && load_cpu)
+		if (load_cpu)
 			load_cpu[i] = load;
 
 		i++;
-- 
2.20.1

