Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F542A5823
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731739AbgKCVtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731819AbgKCUuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:50:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54F1722404;
        Tue,  3 Nov 2020 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436639;
        bh=P/28zFVrF1olkuFhfzeyQX2oR6hrSTizoEGKCQ8FTTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=krFQLH6hovQ31sDybDUma7kfgow8IZbJeI6XeembbK4tH9OsvpvRytfG2VP2Twi+i
         u0xjsTRk0qHNX9SPTMgvKvJI+AXSOLhOpTZLGdAIV6TmsHe/AikbTi5NsXrHgZPLDd
         Q/VMSf5Dq6tavWNSuue/NfoeZ0yVmFpHiNfNdKMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.9 337/391] cpufreq: Introduce CPUFREQ_NEED_UPDATE_LIMITS driver flag
Date:   Tue,  3 Nov 2020 21:36:28 +0100
Message-Id: <20201103203409.871460397@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 1c534352f47fd83eb08075ac2474f707e74bf7f7 upstream.

Generally, a cpufreq driver may need to update some internal upper
and lower frequency boundaries on policy max and min changes,
respectively, but currently this does not work if the target
frequency does not change along with the policy limit.

Namely, if the target frequency does not change along with the
policy min or max, the "target_freq == policy->cur" check in
__cpufreq_driver_target() prevents driver callbacks from being
invoked and they do not even have a chance to update the
corresponding internal boundary.

This particularly affects the "powersave" and "performance"
governors that always set the target frequency to one of the
policy limits and it never changes when the other limit is updated.

To allow cpufreq the drivers needing to update internal frequency
boundaries on policy limits changes to avoid this issue, introduce
a new driver flag, CPUFREQ_NEED_UPDATE_LIMITS, that (when set) will
neutralize the check mentioned above.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |    3 ++-
 include/linux/cpufreq.h   |   10 +++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2166,7 +2166,8 @@ int __cpufreq_driver_target(struct cpufr
 	 * exactly same freq is called again and so we can save on few function
 	 * calls.
 	 */
-	if (target_freq == policy->cur)
+	if (target_freq == policy->cur &&
+	    !(cpufreq_driver->flags & CPUFREQ_NEED_UPDATE_LIMITS))
 		return 0;
 
 	/* Save last value to restore later on errors */
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -293,7 +293,7 @@ __ATTR(_name, 0644, show_##_name, store_
 
 struct cpufreq_driver {
 	char		name[CPUFREQ_NAME_LEN];
-	u8		flags;
+	u16		flags;
 	void		*driver_data;
 
 	/* needed by all drivers */
@@ -417,6 +417,14 @@ struct cpufreq_driver {
  */
 #define CPUFREQ_IS_COOLING_DEV			BIT(7)
 
+/*
+ * Set by drivers that need to update internale upper and lower boundaries along
+ * with the target frequency and so the core and governors should also invoke
+ * the diver if the target frequency does not change, but the policy min or max
+ * may have changed.
+ */
+#define CPUFREQ_NEED_UPDATE_LIMITS		BIT(8)
+
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 


