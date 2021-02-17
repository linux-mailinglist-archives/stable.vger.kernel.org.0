Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187E231D529
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 06:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhBQFtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 00:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhBQFtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 00:49:46 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADBAC061574
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 21:49:06 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d13so6858789plg.0
        for <stable@vger.kernel.org>; Tue, 16 Feb 2021 21:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=emQXPuqsgdPSuXYNHs0efrSNIkqWhGSVKDhTTdUubPU=;
        b=UM0W1EROsKnnez2p5z5LslvgyTFdH1bXFYB4C/W/MIWfs5sSfuIwm/WsNV3THSjkC8
         q08/e7CU00IjvLsa0Um4TNuhC2WI35K1v8PDQZoHRiWwA+SQV0hDiY61WRMG5swjNemb
         vOeuf8GHA0oSeQxmkCgWUXrH7Ow2l3icXf85rNkRJ2gvSk4YQT8IopwzMZBWEbiZnPas
         V5uampE4auaSsVj3MrM8bO5JzeQhsmJMCgNQuqcG+9gsMSxjap/t3SUBA3+VwonfJXzq
         93E9Uq+D0fCW/2rauj5/kmF4o8Ois6HGwreVALPqYGj/fpvET1YZyP8nejLOsnEGBTDb
         2MXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=emQXPuqsgdPSuXYNHs0efrSNIkqWhGSVKDhTTdUubPU=;
        b=P5QD9ZzYhSGzyVCri/DxohUn3xB44ZQrXEXVrXKe81nrMIlRmjNqWtM3Ch1XXVIBhK
         ZYr4LKr7uQchwtNANKjDiWUNuTm3ybQINIdcdq19mHZVkwUiF3sXzHEKTzWesl2FqKsm
         IWUxwk5sb1fKsHL7DvKwLlHBMpDDtUkDE/RwQtzC51qxuTaJAJ7UPgdqOY2+RpNdohyG
         vmGND0vWaDbzy4IyxhiGSGUgrf26qX+IjT0s3Wgl0OUvJfIpr/mS9FBIJO0FPOWL/ebq
         XdBGkpstrHnH8XlQdOL+osCVeIvz19zevWk7zWmIE5xjHdGwcTc8WUPYbTR6sbArLS/2
         8rxA==
X-Gm-Message-State: AOAM531g1Fzr+7IdskOk8BnulpSJ+ogNUFaV60JZxUS6I5dig5OeuV28
        eMEp+WhOlDwXeBhG04nMuCUAWA==
X-Google-Smtp-Source: ABdhPJzjKJf4FU20uEGFouwXC02tQlCg6j476G+w0mokmMJ5uCcC+odaB6FT6A4CpwEVlrVqbts2jw==
X-Received: by 2002:a17:90a:ac09:: with SMTP id o9mr7946027pjq.191.1613540946178;
        Tue, 16 Feb 2021 21:49:06 -0800 (PST)
Received: from localhost ([122.172.59.240])
        by smtp.gmail.com with ESMTPSA id j22sm803460pff.57.2021.02.16.21.49.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Feb 2021 21:49:05 -0800 (PST)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Amit Daniel Kachhap <amit.kachhap@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Javi Merino <javi.merino@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Kucheria <amitk@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Cc:     Vincent Guittot <vincent.guittot@linaro.org>,
        "v5 . 7+" <stable@vger.kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] thermal: cpufreq_cooling: freq_qos_update_request() returns < 0 on error
Date:   Wed, 17 Feb 2021 11:18:58 +0530
Message-Id: <b2b7e84944937390256669df5a48ce5abba0c1ef.1613540713.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.25.0.rc1.19.g042ed3e048af
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

freq_qos_update_request() returns 1 if the effective constraint value
has changed, 0 if the effective constraint value has not changed, or a
negative error code on failures.

The frequency constraints for CPUs can be set by different parts of the
kernel. If the maximum frequency constraint set by other parts of the
kernel are set at a lower value than the one corresponding to cooling
state 0, then we will never be able to cool down the system as
freq_qos_update_request() will keep on returning 0 and we will skip
updating cpufreq_state and thermal pressure.

Fix that by doing the updates even in the case where
freq_qos_update_request() returns 0, as we have effectively set the
constraint to a new value even if the consolidated value of the
actual constraint is unchanged because of external factors.

Cc: v5.7+ <stable@vger.kernel.org> # v5.7+
Reported-by: Thara Gopinath <thara.gopinath@linaro.org>
Fixes: f12e4f66ab6a ("thermal/cpu-cooling: Update thermal pressure in case of a maximum frequency capping")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Guys,

This needs to go in 5.12-rc.

Thara, please give this a try and give your tested-by :).

 drivers/thermal/cpufreq_cooling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index f5af2571f9b7..10af3341e5ea 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -485,7 +485,7 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 	frequency = get_state_freq(cpufreq_cdev, state);
 
 	ret = freq_qos_update_request(&cpufreq_cdev->qos_req, frequency);
-	if (ret > 0) {
+	if (ret >= 0) {
 		cpufreq_cdev->cpufreq_state = state;
 		cpus = cpufreq_cdev->policy->cpus;
 		max_capacity = arch_scale_cpu_capacity(cpumask_first(cpus));
-- 
2.25.0.rc1.19.g042ed3e048af

