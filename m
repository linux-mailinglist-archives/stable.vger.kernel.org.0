Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58642A57BB
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732133AbgKCUwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732148AbgKCUwq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F0F02071E;
        Tue,  3 Nov 2020 20:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436765;
        bh=aHbdgysvukX0w/wcU3rTWMj51AjJJV3UkgaeNFflHTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKN6Nr5aac1a0oy3P851vKdWevURkFXClGclHTILZj+FdEy67oA0j+Lw7dNbNZ3aC
         c1rX04P5fF30/I3wqodIX4GVujBS1k7+mzml0YAXnN5p2emliEKR4bGlmM57dDrHCb
         IKT2SEIffQXXdZcmp0q3gYQ2DFZcr53yWBr5HydM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.9 386/391] cpufreq: schedutil: Always call driver if CPUFREQ_NEED_UPDATE_LIMITS is set
Date:   Tue,  3 Nov 2020 21:37:17 +0100
Message-Id: <20201103203413.208088631@linuxfoundation.org>
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

commit d1e7c2996e988866e7ceceb4641a0886885b7889 upstream.

Because sugov_update_next_freq() may skip a frequency update even if
the need_freq_update flag has been set for the policy at hand, policy
limits updates may not take effect as expected.

For example, if the intel_pstate driver operates in the passive mode
with HWP enabled, it needs to update the HWP min and max limits when
the policy min and max limits change, respectively, but that may not
happen if the target frequency does not change along with the limit
at hand.  In particular, if the policy min is changed first, causing
the target frequency to be adjusted to it, and the policy max limit
is changed later to the same value, the HWP max limit will not be
updated to follow it as expected, because the target frequency is
still equal to the policy min limit and it will not change until
that limit is updated.

To address this issue, modify get_next_freq() to let the driver
callback run if the CPUFREQ_NEED_UPDATE_LIMITS cpufreq driver flag
is set regardless of whether or not the new frequency to set is
equal to the previous one.

Fixes: f6ebbcf08f37 ("cpufreq: intel_pstate: Implement passive mode with HWP enabled")
Reported-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+: 1c534352f47f cpufreq: Introduce CPUFREQ_NEED_UPDATE_LIMITS ...
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+: a62f68f5ca53 cpufreq: Introduce cpufreq_driver_test_flags()
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/cpufreq_schedutil.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -102,7 +102,8 @@ static bool sugov_should_update_freq(str
 static bool sugov_update_next_freq(struct sugov_policy *sg_policy, u64 time,
 				   unsigned int next_freq)
 {
-	if (sg_policy->next_freq == next_freq)
+	if (sg_policy->next_freq == next_freq &&
+	    !cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS))
 		return false;
 
 	sg_policy->next_freq = next_freq;
@@ -175,7 +176,8 @@ static unsigned int get_next_freq(struct
 
 	freq = map_util_freq(util, freq, max);
 
-	if (freq == sg_policy->cached_raw_freq && !sg_policy->need_freq_update)
+	if (freq == sg_policy->cached_raw_freq && !sg_policy->need_freq_update &&
+	    !cpufreq_driver_test_flags(CPUFREQ_NEED_UPDATE_LIMITS))
 		return sg_policy->next_freq;
 
 	sg_policy->need_freq_update = false;


