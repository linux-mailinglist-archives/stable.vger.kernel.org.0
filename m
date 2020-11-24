Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F112C2192
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 10:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbgKXJgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 04:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731377AbgKXJgj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Nov 2020 04:36:39 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE1CC0613D6;
        Tue, 24 Nov 2020 01:36:39 -0800 (PST)
Date:   Tue, 24 Nov 2020 09:36:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606210597;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Rr1olwPsduJoSlDBlgVnYq3Dyq3H3lG9aBuxY+YJgY=;
        b=bdLb+GjL9GC1CQW5OxHln8M3zRyDo80syFtdrM2YSmPBS/SA9MkdGU+IodNOqBrqMQSWw8
        8qxn9UCxYTfhOshHaEAqDU7DIfJhEGjnD7Tq0dQrPbheo4psqyN9FvFUFiN/d2boH1O8yy
        x2BkIu/osBWeV6WwTj+PbcA3pihArBASA01rYSR3/4gyUx7a+uUVVxg2Qkw0yxHXuYK0v1
        mduNXtnJeVcFge5GvII7NvVCwQ+Iquv8sy3dnCXV/pOuIUjX/p535ToBmGT0leVdwj1bBY
        R9KGdJ6DTRyWSHFYif3a0ZwBVOgWBMs0WvHfpWK/7NTFwDM9dUUjzddjkzcUcw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606210597;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Rr1olwPsduJoSlDBlgVnYq3Dyq3H3lG9aBuxY+YJgY=;
        b=/8DxIZHQdTfPgmOlNY4M+cj8zjsfowsqzqFAS8erptKFIrIMPjU8kzAfqVfyc+ZIZPThd9
        kSxtnOehaoXvGqDg==
From:   "thermal-bot for Zhuguangqing" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-pm@vger.kernel.org
To:     linux-pm@vger.kernel.org
Subject: [thermal: thermal/next] thermal/drivers/cpufreq_cooling: Update
 cpufreq_state only if state has changed
Cc:     "v5.4+" <stable@vger.kernel.org>,
        Zhuguangqing <zhuguangqing@xiaomi.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        rui.zhang@intel.com, amitk@kernel.org
In-Reply-To: <20201106092243.15574-1-zhuguangqing83@gmail.com>
References: <20201106092243.15574-1-zhuguangqing83@gmail.com>
MIME-Version: 1.0
Message-ID: <160621059697.11115.16868017639431284982.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the thermal/next branch of thermal:

Commit-ID:     236761f19a4f373354f1dcf399b57753f1f4b871
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/thermal/linux.git//236761f19a4f373354f1dcf399b57753f1f4b871
Author:        Zhuguangqing <zhuguangqing@xiaomi.com>
AuthorDate:    Fri, 06 Nov 2020 17:22:43 +08:00
Committer:     Daniel Lezcano <daniel.lezcano@linaro.org>
CommitterDate: Thu, 12 Nov 2020 12:23:35 +01:00

thermal/drivers/cpufreq_cooling: Update cpufreq_state only if state has changed

If state has not changed successfully and we updated cpufreq_state,
next time when the new state is equal to cpufreq_state (not changed
successfully last time), we will return directly and miss a
freq_qos_update_request() that should have been.

Fixes: 5130802ddbb1 ("thermal: cpu_cooling: Switch to QoS requests for freq limits")
Cc: v5.4+ <stable@vger.kernel.org> # v5.4+
Signed-off-by: Zhuguangqing <zhuguangqing@xiaomi.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201106092243.15574-1-zhuguangqing83@gmail.com
---
 drivers/thermal/cpufreq_cooling.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index cc2959f..612f063 100644
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
