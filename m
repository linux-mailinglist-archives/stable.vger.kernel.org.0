Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97BF22A1639
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgJaLnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:43206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbgJaLnS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:43:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4991820739;
        Sat, 31 Oct 2020 11:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144597;
        bh=6NOvDwna89Xg6/5ANPsNM8eoED4byYDHXq7aX+vYSLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOpOcoJ3ZytaBZsssHGBu7bivXTPRvoGQwB+dfPtjp6cDJtS6p33PRPbM3gcz6p9+
         mcrG3PNNsLRFhQpTZizGIgsPz8mZxSA4JXMQ+Yg8RyeNKEIr5ptlKvvgjR3XlWPNu3
         PtbRsNJ7o0yYbHaTjMKxV4sqVSv6dPgyWSNPaApU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Gupta <sumitg@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 5.9 01/74] cpufreq: Improve code around unlisted freq check
Date:   Sat, 31 Oct 2020 12:35:43 +0100
Message-Id: <20201031113500.107354186@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

commit 97148d0ae5303bcc18fcd1c9b968a9485292f32a upstream.

The cpufreq core checks if the frequency programmed by the bootloaders
is not listed in the freq table and programs one from the table in such
a case. This is done only if the driver has set the
CPUFREQ_NEED_INITIAL_FREQ_CHECK flag.

Currently we print two separate messages, with almost the same content,
and do this with a pr_warn() which may be a bit too much as the driver
only asked us to check this as it expected this to be the case. Lower
down the severity of the print message by switching to pr_info() instead
and print a single message only.

Reported-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Tested-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1450,14 +1450,13 @@ static int cpufreq_online(unsigned int c
 	 */
 	if ((cpufreq_driver->flags & CPUFREQ_NEED_INITIAL_FREQ_CHECK)
 	    && has_target()) {
+		unsigned int old_freq = policy->cur;
+
 		/* Are we running at unknown frequency ? */
-		ret = cpufreq_frequency_table_get_index(policy, policy->cur);
+		ret = cpufreq_frequency_table_get_index(policy, old_freq);
 		if (ret == -EINVAL) {
-			/* Warn user and fix it */
-			pr_warn("%s: CPU%d: Running at unlisted freq: %u KHz\n",
-				__func__, policy->cpu, policy->cur);
-			ret = __cpufreq_driver_target(policy, policy->cur - 1,
-				CPUFREQ_RELATION_L);
+			ret = __cpufreq_driver_target(policy, old_freq - 1,
+						      CPUFREQ_RELATION_L);
 
 			/*
 			 * Reaching here after boot in a few seconds may not
@@ -1465,8 +1464,8 @@ static int cpufreq_online(unsigned int c
 			 * frequency for longer duration. Hence, a BUG_ON().
 			 */
 			BUG_ON(ret);
-			pr_warn("%s: CPU%d: Unlisted initial frequency changed to: %u KHz\n",
-				__func__, policy->cpu, policy->cur);
+			pr_info("%s: CPU%d: Running at unlisted initial frequency: %u KHz, changing to: %u KHz\n",
+				__func__, policy->cpu, old_freq, policy->cur);
 		}
 	}
 


