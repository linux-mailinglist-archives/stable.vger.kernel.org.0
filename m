Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583862E9975
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbhADQAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:00:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728164AbhADQAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7309322507;
        Mon,  4 Jan 2021 15:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775974;
        bh=wnUQKLxohvRGyTmXR07pj6xB9AmiF50wiB7wPUNxG6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JsXpqkeck7BGTAX1dXbGS0vcthLAs227xdVf/Lh3XGM0X434vpmlKyL4+V8hho0vr
         EE2ILUJ0FIsiWgFnV3bEQ3JcD+dAaKBmLhBrykMB+wHCqDUd3zVsN2EUnsgUhZ4ZWn
         J/k/6QOl+2AYuvLF2yhUK1BMxsu+jAB78RTrOTJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhuguangqing <zhuguangqing@xiaomi.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.4 03/47] thermal/drivers/cpufreq_cooling: Update cpufreq_state only if state has changed
Date:   Mon,  4 Jan 2021 16:57:02 +0100
Message-Id: <20210104155705.912483575@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhuguangqing <zhuguangqing@xiaomi.com>

commit 236761f19a4f373354f1dcf399b57753f1f4b871 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/cpu_cooling.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -320,6 +320,7 @@ static int cpufreq_set_cur_state(struct
 				 unsigned long state)
 {
 	struct cpufreq_cooling_device *cpufreq_cdev = cdev->devdata;
+	int ret;
 
 	/* Request state should be less than max_level */
 	if (WARN_ON(state > cpufreq_cdev->max_level))
@@ -329,10 +330,12 @@ static int cpufreq_set_cur_state(struct
 	if (cpufreq_cdev->cpufreq_state == state)
 		return 0;
 
-	cpufreq_cdev->cpufreq_state = state;
+	ret = freq_qos_update_request(&cpufreq_cdev->qos_req,
+			cpufreq_cdev->freq_table[state].frequency);
+	if (ret > 0)
+		cpufreq_cdev->cpufreq_state = state;
 
-	return freq_qos_update_request(&cpufreq_cdev->qos_req,
-				cpufreq_cdev->freq_table[state].frequency);
+	return ret;
 }
 
 /**


