Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45ADE3289E4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbhCASHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:52490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238288AbhCASBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:01:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4526B65291;
        Mon,  1 Mar 2021 17:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619946;
        bh=mWvpmEL7DxDByYBaP5gm30CGnZOnrdofibzdWQCDiNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xd6nmHHdRxcRCj/6Qxke7s3/BrvW27BotJWa8QU8dg9tuFZETb7C9jeCvk4IgVWDk
         cC6DUxZfaVyt4Co4McmOE2nmlTcLUNzQ2AW6nq/nV03pzMoeAwLGKkKFonhpm6EGTz
         ptptrLulcf3Ke9xjJebMx2eprYP0k7RzMyVmQEoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thara Gopinath <thara.gopinath@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Lukasz Luba <lukasz.luba@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 621/663] thermal: cpufreq_cooling: freq_qos_update_request() returns < 0 on error
Date:   Mon,  1 Mar 2021 17:14:29 +0100
Message-Id: <20210301161212.571384170@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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


