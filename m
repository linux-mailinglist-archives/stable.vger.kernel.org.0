Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAB02A9238
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 10:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgKFJO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 04:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgKFJO5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 04:14:57 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B70C0613CF
        for <stable@vger.kernel.org>; Fri,  6 Nov 2020 01:14:56 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z3so733238pfb.10
        for <stable@vger.kernel.org>; Fri, 06 Nov 2020 01:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wGiP6IH7xnMvvVBl7RTJgDZKC+3VSCl/PjWU2e+fkKY=;
        b=bCTvmd6E6vqRFhauaP371i/RhTK2eWDitJBl/bqanQVzRAsr9dCBKjCwesc2zcftIF
         +OukNd175U/Dvx3Ed1kuF+cFF/w2RZP/iZ3iEKF+cfYhbH9vKOir89/VDdRNvuyvhp+a
         GVartjuLGcciI+bE4M4Av8IQjvP51LRqVF8hEoLYn4HSxM4w6gCrx01pd9LNXgZ69LAH
         px5rLmm5JqXMM2tKe7VcOxhcOtOJDKgUuGFMLA5bndSVkkzXo71QiYkE44j9eDg5eogG
         s8uwsvdVVhBITZervi6ZQoUUBoj/tXYvrUuger7AG42uwKse3x29FYGseM0BxXMegU5V
         YJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wGiP6IH7xnMvvVBl7RTJgDZKC+3VSCl/PjWU2e+fkKY=;
        b=Ry0RRxBlNO5IhEZf0S6TPloQYt9LS8lAwBp5Qwyd6QeuzYT6HmZNgMwF8BvTpRb+6K
         1bR8KwwLJd1JUwotorpFkcCpjPSPrpI9SsFAWtRcsKJpdB4QbuAcYypIPBlMs8x5Kn74
         o0ij282yaTfhRL5AkVhDdC+Hm70rsZRiWoGTBJPU6SAPBFtNiCsc1aXyy5qktXGVVY/m
         NUA/QYk95ccHNhxHkb9EuqYgoqC5ANrRBzTPldWSvI61ZGrnCxfDIPz1kTRNaqPIqRRV
         E3Kl7ar3bExTC1X1+S+Mlm7mrhTGCmRPWmKS6UbNpOIrrApx4nINiDJyQYtXp6zcGN11
         i/Vg==
X-Gm-Message-State: AOAM530GGyvYRMUtVaPz1gE0Huu/moWQx4CMPu0F2bbLAhLhqy1Zm+Tm
        /yJTzXRa8p0w27SiredfIH6LpAl0cfdO5w==
X-Google-Smtp-Source: ABdhPJyGuDYKEwicOPoOutC7EzGs6G4xw6gRgPGZ+OgxfvH+URBPEvLJu/905uX0SOn4Yx4MZMaIgw==
X-Received: by 2002:aa7:8b0b:0:b029:152:900d:2288 with SMTP id f11-20020aa78b0b0000b0290152900d2288mr1147276pfd.53.1604654096150;
        Fri, 06 Nov 2020 01:14:56 -0800 (PST)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.180])
        by smtp.gmail.com with ESMTPSA id w131sm1319067pfd.14.2020.11.06.01.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 01:14:55 -0800 (PST)
From:   zhuguangqing83@gmail.com
To:     zhuguanqing@xiaomi.com
Cc:     Zhuguangqing <zhuguangqing@xiaomi.com>,
        "v5 . 4+" <stable@vger.kernel.org>
Subject: [PATCH v2] thermal/drivers/cpufreq_cooling: Update cpufreq_state only if state has changed
Date:   Fri,  6 Nov 2020 17:14:30 +0800
Message-Id: <20201106091430.15505-1-zhuguangqing83@gmail.com>
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

