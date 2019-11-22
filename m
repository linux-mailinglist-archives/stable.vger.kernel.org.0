Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA92106F74
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730083AbfKVKvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:51:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41653 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728236AbfKVKvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 05:51:41 -0500
Received: by mail-wr1-f66.google.com with SMTP id b18so8026415wrj.8
        for <stable@vger.kernel.org>; Fri, 22 Nov 2019 02:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ObvK4D1522uU+aqw4/rA24ESPbrBwV4/rk1T5o0KCo4=;
        b=VisIS0RksZUtaeTkk3UvDcdVc3/4kSCMfopBofj1/6RYKTV/xeb8UwMA2RaoP/wXRG
         aL87yxgB+jGx48F4PwfXteIyxKuU/v87DNSlurHO+H/XbZXyvUD9JVyQWKjIYoxpVdgX
         r7mxnnq/ZX5uV3VgjG4vdaut0K0/bwtMsYnXRqpbe0mDjZVBKTkBHuPZr+n+sR6pEeHC
         DIQeI8Hv7U4jdO2kh8024mFTaiyW+a1OfPRBAF6A08jrS8YY42NTkR5Zl1pDeUttDmLt
         3yJbR0yDHGcqD8qTPSUXvg+RX5dWVQMbkA8pmFaG/+Y9b0aWIcv0tJNjZeaHXP1bqYwo
         p3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ObvK4D1522uU+aqw4/rA24ESPbrBwV4/rk1T5o0KCo4=;
        b=iMLq1iI6+FXBG7v1XjMkYYAe3myc2eTsJzNEr+rhtwLJFs6Oz6geujhHMFXPD8kfeX
         CXJz0qZuxThX1QwnzK55X2xE9p4T4a8MUsvsZoe6yCbNOSrnK8g1NBOGM3hMwXKJeUQd
         2MHUieLzLC0bCcq2K6nchgAEWHDgYP4BQwsvxr1rcWxtvylkqXAdzbKhlGqfYNRvvNe5
         hGdeCMzNZtK75KSXEJZhd/JPvvL9SWRbR9FvQvmSEs1foics8N3qFRQL+iz6apYo1a1e
         2y4srOmQ7Ke1/OLmVAZ6tB52PnncJLtsefIq5OeBa61IIag1m/i68fmnMSXorFHSJTRy
         FrDg==
X-Gm-Message-State: APjAAAVQSYrpCiZd7YRgRvoa+8F3hQuWwZzei+pC2CVCJUIPF6dRLQxG
        8D233nt3IjLnCcMMCUc1TtlnuQ==
X-Google-Smtp-Source: APXvYqyDygoUYbu8JBzEqYqWLEDVIdXgZ0AKjMRd9Jy9xED4VeQ0akGnfm1vg8kSJomQz19wOBTU+g==
X-Received: by 2002:a05:6000:354:: with SMTP id e20mr1167456wre.17.1574419899560;
        Fri, 22 Nov 2019 02:51:39 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id w4sm2894338wmk.29.2019.11.22.02.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 02:51:39 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, gregkh@google.com, stable@vger.kernel.org
Subject: [PATCH 4.4 4/9] cpufreq: Skip cpufreq resume if it's not suspended
Date:   Fri, 22 Nov 2019 10:51:08 +0000
Message-Id: <20191122105113.11213-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122105113.11213-1-lee.jones@linaro.org>
References: <20191122105113.11213-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bo Yan <byan@nvidia.com>

[ Upstream commit 703cbaa601ff3fb554d1246c336ba727cc083ea0 ]

cpufreq_resume can be called even without preceding cpufreq_suspend.
This can happen in following scenario:

    suspend_devices_and_enter
       --> dpm_suspend_start
          --> dpm_prepare
              --> device_prepare : this function errors out
          --> dpm_suspend: this is skipped due to dpm_prepare failure
                           this means cpufreq_suspend is skipped over
       --> goto Recover_platform, due to previous error
       --> goto Resume_devices
       --> dpm_resume_end
           --> dpm_resume
               --> cpufreq_resume

In case schedutil is used as frequency governor, cpufreq_resume will
eventually call sugov_start, which does following:

    memset(sg_cpu, 0, sizeof(*sg_cpu));
    ....

This effectively erases function pointer for frequency update, causing
crash later on. The function pointer would have been set correctly if
subsequent cpufreq_add_update_util_hook runs successfully, but that
function returns earlier because cpufreq_suspend was not called:

    if (WARN_ON(per_cpu(cpufreq_update_util_data, cpu)))
		return;

The fix is to check cpufreq_suspended first, if it's false, that means
cpufreq_suspend was not called in the first place, so do not resume
cpufreq.

Signed-off-by: Bo Yan <byan@nvidia.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
[ rjw: Dropped printing a message ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0836d2939c7a..a68a2d5ac042 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1627,6 +1627,9 @@ void cpufreq_resume(void)
 	if (!cpufreq_driver)
 		return;
 
+	if (unlikely(!cpufreq_suspended))
+		return;
+
 	cpufreq_suspended = false;
 
 	if (!has_target())
-- 
2.24.0

