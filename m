Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB877EC36
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 07:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732636AbfHBFoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 01:44:54 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34596 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732606AbfHBFoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 01:44:54 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so33222102plt.1
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 22:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yjkqVlh93tpY60WVDl/QuqFVLpfL0sHzZ896Xvml+z4=;
        b=CjPSiFwCyakBTrbLM1unJu3mh6t/OHjXEJsYhOgENLXIMkZfnmMK7kA4LLGRIkBU5N
         FewiqxHM7ESNfuWy2LjIA4max+VbOFSXBW1I11lkee7ya6yGtzI5G4pqadAGrlKLptjT
         YUsYi2X+fUKMaCyHazV9Prvo7PrNCv5sBRDoskVTPIGO+CZ+YffAR1wonAWLwe9b966v
         76f8CYpIul0BJVlnnsDy37Dd3kofpRsC6EUqlYjluPwa/qFkUuWzuquWKxaoNaNJFiOy
         UnyKRZ17Ukwbmbg5qUIql6Zmb69GtFTP+WFmxAodQ0KI8fm+5phv1vdMnCPHLC5/4bd4
         bpKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjkqVlh93tpY60WVDl/QuqFVLpfL0sHzZ896Xvml+z4=;
        b=WOjeQK1lP5tIdKdAXD0id31W7SdpprYJcX3cdlLmjcx1i9DBwgJHrwRkn5tf6qk5jL
         oJKOoXNI005fSLG6oi/lfOGjsiQw9YplSZ1lKD5w1B/hhotw+bozpEFy9H0GwSvp7HLw
         Mg7q75yi+fx7+ilenl04YDx0HWMvJ8g04PC/elpcILYat7S/tMOMnvZeabeNWqjHr7tV
         jbUMRZQVzFnnMLf9htgr7Qaau0HY+IKIFfmEyIXjaT41UtZvfYpi/I5Ct8ZQaEgfh+7C
         8567taohIpiH6uFqLq2RZkGqI+DmjS3+xkHlJj+Pch6hK60RveZiqdKUoAPXaIbamf9K
         XHtg==
X-Gm-Message-State: APjAAAVSqVQhAdnViH+m+mtmeiBjQ3nZDdO6YPw/F0ugl4nkFLARiYKg
        jPELfTCITueOnnN1rXqWF3FfAg==
X-Google-Smtp-Source: APXvYqyZ1krLVASDIdDV11DS2l8tbxmM4spkv0MIrZ/oPkthee5mDfwIoxrJ33RZlFf4CMYGV6/CvQ==
X-Received: by 2002:a17:902:846:: with SMTP id 64mr129733304plk.265.1564724693243;
        Thu, 01 Aug 2019 22:44:53 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id bg3sm7230593pjb.9.2019.08.01.22.44.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 22:44:52 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Rafael Wysocki <rjw@rjwysocki.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Len Brown <lenb@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc:     linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        "v4 . 18+" <stable@vger.kernel.org>,
        Doug Smythies <doug.smythies@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3 2/2] cpufreq: intel_pstate: Implement ->resolve_freq()
Date:   Fri,  2 Aug 2019 11:14:30 +0530
Message-Id: <23e3dee8688f5a9767635b686bb7a9c0e09a4438.1564724511.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org>
References: <7dedb6bd157b8183c693bb578e25e313cf4f451d.1564724511.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Intel pstate driver exposes min_perf_pct and max_perf_pct sysfs files,
which can be used to force a limit on the min/max P state of the driver.
Though these files eventually control the min/max frequencies that the
CPUs will run at, they don't make a change to policy->min/max values.

When the values of these files are changed (in passive mode of the
driver), it leads to calling ->limits() callback of the cpufreq
governors, like schedutil. On a call to it the governors shall
forcefully update the frequency to come within the limits. For getting
the value within limits, the schedutil governor calls
cpufreq_driver_resolve_freq(), which eventually tries to call
->resolve_freq() callback for this driver. Since the callback isn't
present, the schedutil governor fails to get the target freq within
limit and sometimes aborts the update believing that the frequency is
already set to the target value.

This patch implements the resolve_freq() callback, so the correct target
frequency can be returned by the driver and the schedutil governor gets
the frequency within limits immediately.

Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
Reported-by: Doug Smythies <doug.smythies@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V3:
- This was earlier posted as a diff to an email reply and is getting
  sent for the first time only as a proper patch.

 drivers/cpufreq/intel_pstate.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index cc27d4c59dca..2d84361fbebc 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2314,6 +2314,18 @@ static int intel_cpufreq_target(struct cpufreq_policy *policy,
 	return 0;
 }
 
+static unsigned int intel_cpufreq_resolve_freq(struct cpufreq_policy *policy,
+					       unsigned int target_freq)
+{
+	struct cpudata *cpu = all_cpu_data[policy->cpu];
+	int target_pstate;
+
+	target_pstate = DIV_ROUND_UP(target_freq, cpu->pstate.scaling);
+	target_pstate = intel_pstate_prepare_request(cpu, target_pstate);
+
+	return target_pstate * cpu->pstate.scaling;
+}
+
 static unsigned int intel_cpufreq_fast_switch(struct cpufreq_policy *policy,
 					      unsigned int target_freq)
 {
@@ -2350,6 +2362,7 @@ static struct cpufreq_driver intel_cpufreq = {
 	.verify		= intel_cpufreq_verify_policy,
 	.target		= intel_cpufreq_target,
 	.fast_switch	= intel_cpufreq_fast_switch,
+	.resolve_freq	= intel_cpufreq_resolve_freq,
 	.init		= intel_cpufreq_cpu_init,
 	.exit		= intel_pstate_cpu_exit,
 	.stop_cpu	= intel_cpufreq_stop_cpu,
-- 
2.21.0.rc0.269.g1a574e7a288b

