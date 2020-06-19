Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F33D2004C8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 11:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgFSJQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 05:16:05 -0400
Received: from lucky1.263xmail.com ([211.157.147.131]:43726 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgFSJQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 05:16:04 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2020 05:16:03 EDT
Received: from localhost (unknown [192.168.167.32])
        by lucky1.263xmail.com (Postfix) with ESMTP id 6D418AFDC6;
        Fri, 19 Jun 2020 17:09:11 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-ABS-CHECKED: 0
Received: from localhost.localdomain (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P3326T139697392834304S1592557749877054_;
        Fri, 19 Jun 2020 17:09:10 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <434d5cdc956ae93f131f66b7a903d7ad>
X-RL-SENDER: finley.xiao@rock-chips.com
X-SENDER: xf@rock-chips.com
X-LOGIN-NAME: finley.xiao@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
X-System-Flag: 0
From:   Finley Xiao <finley.xiao@rock-chips.com>
To:     heiko@sntech.de, amit.kachhap@gmail.com, daniel.lezcano@linaro.org,
        viresh.kumar@linaro.org, javi.merino@kernel.org,
        rui.zhang@intel.com, amit.kucheria@verdurent.com
Cc:     linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, stable@vger.kernel.org,
        huangtao@rock-chips.com, tony.xie@rock-chips.com,
        cl@rock-chips.com, Finley Xiao <finley.xiao@rock-chips.com>
Subject: [PATCH] thermal/drivers/cpufreq_cooling: Fix wrong frequency converted from power
Date:   Fri, 19 Jun 2020 17:08:25 +0800
Message-Id: <20200619090825.32747-1-finley.xiao@rock-chips.com>
X-Mailer: git-send-email 2.11.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function cpu_power_to_freq is used to find a frequency and set the
cooling device to consume at most the power to be converted. For example,
if the power to be converted is 80mW, and the em table is as follow.
struct em_cap_state table[] = {
	/* KHz     mW */
	{ 1008000, 36, 0 },
	{ 1200000, 49, 0 },
	{ 1296000, 59, 0 },
	{ 1416000, 72, 0 },
	{ 1512000, 86, 0 },
};
The target frequency should be 1416000KHz, not 1512000KHz.

Fixes: 349d39dc5739 ("thermal: cpu_cooling: merge frequency and power tables")
Cc: <stable@vger.kernel.org> # v4.13+
Signed-off-by: Finley Xiao <finley.xiao@rock-chips.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/thermal/cpufreq_cooling.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index 9e124020519f..6c0e1b053126 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -123,12 +123,12 @@ static u32 cpu_power_to_freq(struct cpufreq_cooling_device *cpufreq_cdev,
 {
 	int i;
 
-	for (i = cpufreq_cdev->max_level - 1; i >= 0; i--) {
-		if (power > cpufreq_cdev->em->table[i].power)
+	for (i = cpufreq_cdev->max_level; i >= 0; i--) {
+		if (power >= cpufreq_cdev->em->table[i].power)
 			break;
 	}
 
-	return cpufreq_cdev->em->table[i + 1].frequency;
+	return cpufreq_cdev->em->table[i].frequency;
 }
 
 /**
-- 
2.11.0



