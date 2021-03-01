Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F063291F6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241932AbhCAUhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:37:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:50820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243483AbhCAUal (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:30:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CD6C65092;
        Mon,  1 Mar 2021 18:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622093;
        bh=mWvpmEL7DxDByYBaP5gm30CGnZOnrdofibzdWQCDiNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNKSuVio/k60KRN6e7JoiPJ9rOy5aq4ohW/49pCaH28nbhgmMvFX0AHlNN8KRmLIC
         UIJOpJAxQ64ExCUAD7FgqwXnB7F225+Gqs5EPKlY54/4LbNBL7hP8ABueYROMc7mEj
         MH5oj2d+mEF9Wc9AD4Q/vM5xJoZtOlXU6ltYphoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thara Gopinath <thara.gopinath@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lukasz Luba <lukasz.luba@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.11 727/775] thermal: cpufreq_cooling: freq_qos_update_request() returns < 0 on error
Date:   Mon,  1 Mar 2021 17:14:55 +0100
Message-Id: <20210301161237.257182737@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

commit a51afb13311cd85b2f638c691b2734622277d8f5 upstream.

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
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Tested-by: Lukasz Luba <lukasz.luba@arm.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Thara Gopinath<thara.gopinath@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/b2b7e84944937390256669df5a48ce5abba0c1ef.1613540713.git.viresh.kumar@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/cpufreq_cooling.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -441,7 +441,7 @@ static int cpufreq_set_cur_state(struct
 	frequency = get_state_freq(cpufreq_cdev, state);
 
 	ret = freq_qos_update_request(&cpufreq_cdev->qos_req, frequency);
-	if (ret > 0) {
+	if (ret >= 0) {
 		cpufreq_cdev->cpufreq_state = state;
 		cpus = cpufreq_cdev->policy->cpus;
 		max_capacity = arch_scale_cpu_capacity(cpumask_first(cpus));


