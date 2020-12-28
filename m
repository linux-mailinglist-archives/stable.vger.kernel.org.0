Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FD72E3F10
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504897AbgL1OdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504892AbgL1OdH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:33:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E85EA20791;
        Mon, 28 Dec 2020 14:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165972;
        bh=NLBOJ7ONeQ7FS3seacVnL5lTNHis3Wlm3OSNc+Z3HUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kL+2l2lFOeMEm+M3hIxwjb/LJqlj0g1DDyFtabzEvi/Xn1IO5oUgBRe3bQyN85jk3
         34T78RJk3YWpyd89W7T7ufY2d74Zqo/Yrc6aCxXrfZYiMdrcWlFg3GVPTQLr29P8K3
         ObppNX8tKKoOOXVxuMYwbMMFXhfVTcN4mKHhfFWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhuguangqing <zhuguangqing@xiaomi.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.10 713/717] thermal/drivers/cpufreq_cooling: Update cpufreq_state only if state has changed
Date:   Mon, 28 Dec 2020 13:51:51 +0100
Message-Id: <20201228125055.162854872@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
 drivers/thermal/cpufreq_cooling.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -438,13 +438,11 @@ static int cpufreq_set_cur_state(struct
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


