Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A262A9269
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 10:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgKFJXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 04:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgKFJXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 04:23:55 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B64CC0613CF;
        Fri,  6 Nov 2020 01:23:55 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id t14so501467pgg.1;
        Fri, 06 Nov 2020 01:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wGiP6IH7xnMvvVBl7RTJgDZKC+3VSCl/PjWU2e+fkKY=;
        b=DgzhnVVBGDcLhY2BLREDhgCzeP8GErAySn03nrC4XC09J8M8B7OknTsy1cndg8fht5
         2p4VACsFNYK37OBmq8luha8ysVYiN2hacEMW/3Yir3yGF5xEthLyq9dTeOueWjg5Ko+a
         C1wA6t8SEVh/btdtfzf4pDbbT7hWCzffi0qBTadY4cxtYSl+mRVb/i+O/RHlowqcV3tj
         ckyhM2fQQ66RZoHVHhwPP3pmcQOKU48Jx2ZhwyTqji3dyU1Su2J+LgXR2Tu0rLoHZwZq
         h6Z7i4kfuI84POtbW2TR+SoMWbp0LOCEu38EiOM/KYqaYTB7s3O9LlpXgNvNonB4FkwB
         1leg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wGiP6IH7xnMvvVBl7RTJgDZKC+3VSCl/PjWU2e+fkKY=;
        b=Hp07dBbYdrHVeo7GjiLUa79kVhM4TJP7cqETOkaTd96Mzid7Qk+RjqMTj/Ym2tSD0E
         z/1x+E/xyO6ssjkwCOZkYMj8vmStwsQuR+qoLJUngz99WMNZ2aJ+mqQQeLKkPaax4GsS
         KIWtFvx7jOw3y9d+Jhcpy1+dVeetQAvIz9+OLoHmdyO/I/uM2jziC2tIDx4RGav7Ckiy
         BOVbrsvWBxW8D9cekN7gIUz0dv6vkwG3Zs3VAn/bovMUiVt1hC1mhg6wNsKJN2fSf5h4
         uY8NvrjU2SKlUiDXDXD5Bb6uCB8jXOjOWco2SEb+BBg4ZWyJsjtb5mlyHGfgtn+oQcq8
         ps4g==
X-Gm-Message-State: AOAM531sHgrm5eISzHM60FYhTp5Fc1nk9WRdimgxXv1a8l/6FmL9oNpr
        Xc/O16hT7O3wlZFf9LXbV5k=
X-Google-Smtp-Source: ABdhPJyrNv7YPC3YHkS/Zay8U+BBa7uUFLjhVd4xi1VwqRTBIJkZNXH6X/lzIsJ+RJ6pbifqY6JuCw==
X-Received: by 2002:a63:5826:: with SMTP id m38mr998447pgb.240.1604654634931;
        Fri, 06 Nov 2020 01:23:54 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([209.9.72.215])
        by smtp.gmail.com with ESMTPSA id b67sm1333601pfa.151.2020.11.06.01.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 01:23:54 -0800 (PST)
From:   zhuguangqing83@gmail.com
To:     viresh.kumar@linaro.org, amit.kachhap@gmail.com,
        daniel.lezcano@linaro.org, javi.merino@kernel.org,
        rui.zhang@intel.com, amitk@kernel.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhuguangqing <zhuguangqing@xiaomi.com>,
        "v5 . 4+" <stable@vger.kernel.org>
Subject: [PATCH v2] thermal/drivers/cpufreq_cooling: Update cpufreq_state only if state has changed
Date:   Fri,  6 Nov 2020 17:22:43 +0800
Message-Id: <20201106092243.15574-1-zhuguangqing83@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhuguangqing <zhuguangqing@xiaomi.com>

If state has not changed successfully and we updated cpufreq_state,
next time when the new state is equal to cpufreq_state (not changed
successfully last time), we will return directly and miss a
freq_qos_update_request() that should have been.

Fixes: 5130802ddbb1 ("thermal: cpu_cooling: Switch to QoS requests for freq limits")
Cc: v5.4+ <stable@vger.kernel.org> # v5.4+
Signed-off-by: Zhuguangqing <zhuguangqing@xiaomi.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
v2:
  - Add Fixes: 5130802ddbb1 in log.
  - Add Cc: v5.4+ <stable@vger.kernel.org> # v5.4+ in log.
  - Add Acked-by: Viresh Kumar <viresh.kumar@linaro.org> in log.
  - Delete an extra blank line.
---
 drivers/thermal/cpufreq_cooling.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index cc2959f22f01..612f063c1cfc 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -438,13 +438,11 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 	if (cpufreq_cdev->cpufreq_state == state)
 		return 0;
 
-	cpufreq_cdev->cpufreq_state = state;
-
 	frequency = get_state_freq(cpufreq_cdev, state);
 
 	ret = freq_qos_update_request(&cpufreq_cdev->qos_req, frequency);
-
 	if (ret > 0) {
+		cpufreq_cdev->cpufreq_state = state;
 		cpus = cpufreq_cdev->policy->cpus;
 		max_capacity = arch_scale_cpu_capacity(cpumask_first(cpus));
 		capacity = frequency * max_capacity;
-- 
2.17.1

