Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E298C1B3F14
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbgDVKeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730413AbgDVKYY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:24:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8B022077D;
        Wed, 22 Apr 2020 10:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551064;
        bh=Y1oOwpvRztHomKDGyowfxLsgFTMmRI5+HPm22BtDbKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiglV4KIvmGGfeotokNXrT5xSg0uptFS0x8v48TPfgRy6WY3qmltwlklUly3utPuS
         stP5aH7LJcHHOn3XEEYTnvIcEKHNzCe8RN0wjuM78GFhVnOkt8HtO2wi1OmoqUf/3a
         g2CcPSHh1EZ+V0OWI8UFhGmBXscdUtIBQIDGYdNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willy Wolff <willy.mh.wolff.ml@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 086/166] thermal/drivers/cpufreq_cooling: Fix return of cpufreq_set_cur_state
Date:   Wed, 22 Apr 2020 11:56:53 +0200
Message-Id: <20200422095057.925468831@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/thermal/cpufreq_cooling.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index fe83d7a210d47..af55ac08e1bd5 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -431,6 +431,7 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long state)
 {
 	struct cpufreq_cooling_device *cpufreq_cdev = cdev->devdata;
+	int ret;
 
 	/* Request state should be less than max_level */
 	if (WARN_ON(state > cpufreq_cdev->max_level))
@@ -442,8 +443,9 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 
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



