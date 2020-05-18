Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6DD1D750C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 12:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgERKWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 06:22:37 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:52840 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgERKWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 06:22:36 -0400
Received: from 89-64-86-21.dynamic.chello.pl (89.64.86.21) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.415)
 id d62f9a6050febd90; Mon, 18 May 2020 12:22:34 +0200
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, linux-mips@vger.kernel.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org,
        Frederic Weisbecker <frederic@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Yue Hu <huyue2@yulong.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 20/20] cpufreq: Return zero on success in boost sw setting
Date:   Mon, 18 May 2020 12:22:31 +0200
Message-ID: <10461949.HoJUxHt8jL@kreacher>
In-Reply-To: <20200518101109.4uggngudy4gfmlvo@vireshk-i7>
References: <20200306124807.3596F80307C2@mail.baikalelectronics.ru> <a8dfa493-f858-e35d-7e57-78478be555c4@intel.com> <20200518101109.4uggngudy4gfmlvo@vireshk-i7>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Monday, May 18, 2020 12:11:09 PM CEST Viresh Kumar wrote:
> On 18-05-20, 11:53, Rafael J. Wysocki wrote:
> > That said if you really only want it to return 0 on success, you may as well
> > add a ret = 0; statement (with a comment explaining why it is needed) after
> > the last break in the loop.
> 
> That can be done as well, but will be a bit less efficient as the loop
> will execute once for each policy, and so the statement will run
> multiple times. Though it isn't going to add any significant latency
> in the code.

Right.

However, the logic in this entire function looks somewhat less than
straightforward to me, because it looks like it should return an
error on the first policy without a frequency table (having a frequency
table depends on the driver and that is the same for all policies, so it
is pointless to iterate any further in that case).

Also, the error should not be -EINVAL, because that means "invalid
argument" which would be the state value.

So I would do something like this:

---
 drivers/cpufreq/cpufreq.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/cpufreq.c
+++ linux-pm/drivers/cpufreq/cpufreq.c
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



