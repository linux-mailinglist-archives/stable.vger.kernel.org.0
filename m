Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA0712EF85
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbgABWaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:30:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730012AbgABWaU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:30:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 349A62253D;
        Thu,  2 Jan 2020 22:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004219;
        bh=Q0XfiEEF4+nFab0KeB9h3/YN2rBxXvvfp51xB1lxAsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDMdFxpeWlTSlScb6cJymbkSwv1YjJ1fPglyFhA7FiBZeAQX41MqX71IB5/DjZwAN
         sjwywIKaz4HMFKcbJ5ZumKZuk0z7ATkLJR475fSP6MivM5X3tc45o2ySM2FRedE86A
         8M4aMVFknmGO+s2h5jmK8x4VIorFBV9l0gGsY+3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 070/171] cpufreq: Register drivers only after CPU devices have been registered
Date:   Thu,  2 Jan 2020 23:06:41 +0100
Message-Id: <20200102220556.622524885@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 46770be0cf94149ca48be87719bda1d951066644 ]

The cpufreq core heavily depends on the availability of the struct
device for CPUs and if they aren't available at the time cpufreq driver
is registered, we will never succeed in making cpufreq work.

This happens due to following sequence of events:

- cpufreq_register_driver()
  - subsys_interface_register()
  - return 0; //successful registration of driver

... at a later point of time

- register_cpu();
  - device_register();
    - bus_probe_device();
      - sif->add_dev();
	- cpufreq_add_dev();
	  - get_cpu_device(); //FAILS
  - per_cpu(cpu_sys_devices, num) = &cpu->dev; //used by get_cpu_device()
  - return 0; //CPU registered successfully

Because the per-cpu variable cpu_sys_devices is set only after the CPU
device is regsitered, cpufreq will never be able to get it when
cpufreq_add_dev() is called.

This patch avoids this failure by making sure device structure of at
least CPU0 is available when the cpufreq driver is registered, else
return -EPROBE_DEFER.

Reported-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Co-developed-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Amit Kucheria <amit.kucheria@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 063ce77df619..86d48f8c6a2e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2449,6 +2449,13 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	if (cpufreq_disabled())
 		return -ENODEV;
 
+	/*
+	 * The cpufreq core depends heavily on the availability of device
+	 * structure, make sure they are available before proceeding further.
+	 */
+	if (!get_cpu_device(0))
+		return -EPROBE_DEFER;
+
 	if (!driver_data || !driver_data->verify || !driver_data->init ||
 	    !(driver_data->setpolicy || driver_data->target_index ||
 		    driver_data->target) ||
-- 
2.20.1



