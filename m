Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718891FB9CD
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732546AbgFPQGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732354AbgFPPrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:47:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A24920776;
        Tue, 16 Jun 2020 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322458;
        bh=dyqp+Fnlnyi5NeHTmMqL6I3YbaA5yLh7dj/yLkB9YR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7xws0yn4ghR/pp8YZLdYivxZCgWKO7MnvZYorhH+KaJ7b5okWn4RF1i7ov3briv5
         bXUJQvBAh042DnsPaIMbqpFP9nyaSHe3SmaY2gzJeLJYQ6sxMO6LbfA8UHoV8aefK+
         F79UzgySrx948+CA4WvitBmApfNyf1aoC/XoxpnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.7 122/163] cpufreq: Fix up cpufreq_boost_set_sw()
Date:   Tue, 16 Jun 2020 17:34:56 +0200
Message-Id: <20200616153112.655066932@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 552abb884e97d26589964e5a8c7e736f852f95f0 upstream.

After commit 18c49926c4bf ("cpufreq: Add QoS requests for userspace
constraints") the return value of freq_qos_update_request(), that can
be 1, passed by cpufreq_boost_set_sw() to its caller sometimes
confuses the latter, which only expects to see 0 or negative error
codes, so notice that cpufreq_boost_set_sw() can return an error code
(which should not be -EINVAL for that matter) as soon as the first
policy without a frequency table is found (because either all policies
have a frequency table or none of them have it) and rework it to meet
its caller's expectations.

Fixes: 18c49926c4bf ("cpufreq: Add QoS requests for userspace constraints")
Reported-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Reported-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2535,26 +2535,27 @@ EXPORT_SYMBOL_GPL(cpufreq_update_limits)
 static int cpufreq_boost_set_sw(int state)
 {
 	struct cpufreq_policy *policy;
-	int ret = -EINVAL;
 
 	for_each_active_policy(policy) {
+		int ret;
+
 		if (!policy->freq_table)
-			continue;
+			return -ENXIO;
 
 		ret = cpufreq_frequency_table_cpuinfo(policy,
 						      policy->freq_table);
 		if (ret) {
 			pr_err("%s: Policy frequency update failed\n",
 			       __func__);
-			break;
+			return ret;
 		}
 
 		ret = freq_qos_update_request(policy->max_freq_req, policy->max);
 		if (ret < 0)
-			break;
+			return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 int cpufreq_boost_trigger_state(int state)


