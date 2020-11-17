Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 078D82B63C7
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733097AbgKQNl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:41:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733092AbgKQNl1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:41:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74A2A206A5;
        Tue, 17 Nov 2020 13:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620487;
        bh=9IrT82M9DQYhzeoNHKJMJKpQDzlamVxhafriOdQlUgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwrklAdARzlZNhytYwiNc14e+0eCQNrBM7clJk70pY43sLax5ImS4txaUdUviLk2K
         37NSRwZApzHDQCeGIQ0srhbNct19E1qTpJih2gDISniwt96lLtJw4AZX/Vq8Kg6YIk
         3/0tLlXSol1aU0ayzUNIbvt+QXSo3LvDTQLtPR0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.9 236/255] cpufreq: Introduce CPUFREQ_GOV_STRICT_TARGET
Date:   Tue, 17 Nov 2020 14:06:16 +0100
Message-Id: <20201117122150.424011551@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 218f66870181bec7aaa6e3c72f346039c590c3c2 upstream.

Introduce a new governor flag, CPUFREQ_GOV_STRICT_TARGET, for the
governors that want the target frequency to be set exactly to the
given value without leaving any room for adjustments on the hardware
side and set this flag for the powersave and performance governors.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq_performance.c |    1 +
 drivers/cpufreq/cpufreq_powersave.c   |    1 +
 include/linux/cpufreq.h               |    3 +++
 3 files changed, 5 insertions(+)

--- a/drivers/cpufreq/cpufreq_performance.c
+++ b/drivers/cpufreq/cpufreq_performance.c
@@ -20,6 +20,7 @@ static void cpufreq_gov_performance_limi
 static struct cpufreq_governor cpufreq_gov_performance = {
 	.name		= "performance",
 	.owner		= THIS_MODULE,
+	.flags		= CPUFREQ_GOV_STRICT_TARGET,
 	.limits		= cpufreq_gov_performance_limits,
 };
 
--- a/drivers/cpufreq/cpufreq_powersave.c
+++ b/drivers/cpufreq/cpufreq_powersave.c
@@ -21,6 +21,7 @@ static struct cpufreq_governor cpufreq_g
 	.name		= "powersave",
 	.limits		= cpufreq_gov_powersave_limits,
 	.owner		= THIS_MODULE,
+	.flags		= CPUFREQ_GOV_STRICT_TARGET,
 };
 
 MODULE_AUTHOR("Dominik Brodowski <linux@brodo.de>");
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -575,6 +575,9 @@ struct cpufreq_governor {
 /* For governors which change frequency dynamically by themselves */
 #define CPUFREQ_GOV_DYNAMIC_SWITCHING	BIT(0)
 
+/* For governors wanting the target frequency to be set exactly */
+#define CPUFREQ_GOV_STRICT_TARGET	BIT(1)
+
 
 /* Pass a target to the cpufreq driver */
 unsigned int cpufreq_driver_fast_switch(struct cpufreq_policy *policy,


