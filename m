Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3421AA1B4
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370176AbgDOMpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408980AbgDOLnP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86DD72168B;
        Wed, 15 Apr 2020 11:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950995;
        bh=BLk2zqFpRCw7XR3epSmCEKoMUV+x/8k9ijREmEOOEx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPV6LcRc/xsxtqTgJgqQg7THKiFcp+bkI0H5NhktlA2e1bF3bQ5M8O8WpnUZZvHEQ
         WthBOqEaXE3jRhOHxAj7mPIUI/1fu7v2Hn2KQ0Y1ZcpES2kpNDA1XrZUS8ML48WAZi
         qnd963pNC4hEAgF0I+XTnTStq9DaHYWgphz5ii48=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willy Wolff <willy.mh.wolff.ml@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 041/106] thermal/drivers/cpufreq_cooling: Fix return of cpufreq_set_cur_state
Date:   Wed, 15 Apr 2020 07:41:21 -0400
Message-Id: <20200415114226.13103-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Wolff <willy.mh.wolff.ml@gmail.com>

[ Upstream commit ff44f672d74178b3be19d41a169b98b3e391d4ce ]

When setting the cooling device current state from userspace via sysfs,
the operation fails by returning an -EINVAL.

It appears the recent changes with the per-policy frequency QoS
introduced a regression as reported by:

 https://lkml.org/lkml/2020/3/20/599

The function freq_qos_update_request returns 0 or 1 describing update
effectiveness, and a negative error code on failure. However,
cpufreq_set_cur_state returns 0 on success or an error code otherwise.

Consider the QoS update as successful if the function does not return
an error.

Fixes: 3000ce3c52f8b ("cpufreq: Use per-policy frequency QoS")
Signed-off-by: Willy Wolff <willy.mh.wolff.ml@gmail.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200321092740.7vvwfxsebcrznydh@macmini.local
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/cpu_cooling.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 52569b27b426f..d679e9a515c8e 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -430,6 +430,7 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long state)
 {
 	struct cpufreq_cooling_device *cpufreq_cdev = cdev->devdata;
+	int ret;
 
 	/* Request state should be less than max_level */
 	if (WARN_ON(state > cpufreq_cdev->max_level))
@@ -441,8 +442,9 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 
 	cpufreq_cdev->cpufreq_state = state;
 
-	return freq_qos_update_request(&cpufreq_cdev->qos_req,
-				get_state_freq(cpufreq_cdev, state));
+	ret = freq_qos_update_request(&cpufreq_cdev->qos_req,
+				      get_state_freq(cpufreq_cdev, state));
+	return ret < 0 ? ret : 0;
 }
 
 /* Bind cpufreq callbacks to thermal cooling device ops */
-- 
2.20.1

