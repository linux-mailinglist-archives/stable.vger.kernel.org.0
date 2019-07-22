Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D196F6C8
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 02:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfGVAkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Jul 2019 20:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfGVAkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Jul 2019 20:40:39 -0400
Received: from localhost (unknown [216.243.17.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7364208E4;
        Mon, 22 Jul 2019 00:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563756037;
        bh=pksMj5/FXJk8/iIRDPlhkgyCu9m3bhlGZMNsFsAw9FA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IYj8AWak2RI5lQS1G+4yLZKbvRyhSFWzg6+QtgHIn+tqXRLQYHHkWiwXEljEoLLJO
         ZBFqIrEzM0UBTq1jCf/YwwlShppXmwtGaIqmiOM5aZO8Q+oXQi6rqJVYsQvbPQ64rx
         Lw8B/KhoRTGH3ZxlZu1i6ecuB7G8dfipXD6G2+V0=
Date:   Sun, 21 Jul 2019 20:40:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 123/158] cpufreq: Don't skip frequency
 validation for has_target() drivers
Message-ID: <20190722004037.GE1607@sasha-vm>
References: <20190715141809.8445-1-sashal@kernel.org>
 <20190715141809.8445-123-sashal@kernel.org>
 <92ae669e-654c-40b2-0470-e9280d9c2dd0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <92ae669e-654c-40b2-0470-e9280d9c2dd0@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 11:21:34AM +0200, Rafael J. Wysocki wrote:
>On 7/15/2019 4:17 PM, Sasha Levin wrote:
>>From: Viresh Kumar <viresh.kumar@linaro.org>
>>
>>[ Upstream commit 9801522840cc1073f8064b4c979b7b6995c74bca ]
>>
>>CPUFREQ_CONST_LOOPS was introduced in a very old commit from pre-2.6
>>kernel release by commit 6a4a93f9c0d5 ("[CPUFREQ] Fix 'out of sync'
>>issue").
>>
>>Basically, that commit does two things:
>>
>>  - It adds the frequency verification code (which is quite similar to
>>    what we have today as well).
>>
>>  - And it sets the CPUFREQ_CONST_LOOPS flag only for setpolicy drivers,
>>    rightly so based on the code we had then. The idea was to avoid
>>    frequency validation for setpolicy drivers as the cpufreq core doesn't
>>    know what frequency the hardware is running at and so no point in
>>    doing frequency verification.
>>
>>The problem happened when we started to use the same CPUFREQ_CONST_LOOPS
>>flag for constant loops-per-jiffy thing as well and many has_target()
>>drivers started using the same flag and unknowingly skipped the
>>verification of frequency. There is no logical reason behind skipping
>>frequency validation because of the presence of CPUFREQ_CONST_LOOPS
>>flag otherwise.
>>
>>Fix this issue by skipping frequency validation only for setpolicy
>>drivers and always doing it for has_target() drivers irrespective of
>>the presence or absence of CPUFREQ_CONST_LOOPS flag.
>>
>>cpufreq_notify_transition() is only called for has_target() type driver
>>and not for set_policy type, and the check is simply redundant. Remove
>>it as well.
>>
>>Also remove () around freq comparison statement as they aren't required
>>and checkpatch also warns for them.
>>
>>Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
>>Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  drivers/cpufreq/cpufreq.c | 13 +++++--------
>>  1 file changed, 5 insertions(+), 8 deletions(-)
>>
>>diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
>>index d3213594d1a7..80942ec34efd 100644
>>--- a/drivers/cpufreq/cpufreq.c
>>+++ b/drivers/cpufreq/cpufreq.c
>>@@ -321,12 +321,10 @@ static void cpufreq_notify_transition(struct cpufreq_policy *policy,
>>  		 * which is not equal to what the cpufreq core thinks is
>>  		 * "old frequency".
>>  		 */
>>-		if (!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
>>-			if (policy->cur && (policy->cur != freqs->old)) {
>>-				pr_debug("Warning: CPU frequency is %u, cpufreq assumed %u kHz\n",
>>-					 freqs->old, policy->cur);
>>-				freqs->old = policy->cur;
>>-			}
>>+		if (policy->cur && policy->cur != freqs->old) {
>>+			pr_debug("Warning: CPU frequency is %u, cpufreq assumed %u kHz\n",
>>+				 freqs->old, policy->cur);
>>+			freqs->old = policy->cur;
>>  		}
>>  		for_each_cpu(freqs->cpu, policy->cpus) {
>>@@ -1543,8 +1541,7 @@ static unsigned int __cpufreq_get(struct cpufreq_policy *policy)
>>  	if (policy->fast_switch_enabled)
>>  		return ret_freq;
>>-	if (ret_freq && policy->cur &&
>>-		!(cpufreq_driver->flags & CPUFREQ_CONST_LOOPS)) {
>>+	if (has_target() && ret_freq && policy->cur) {
>>  		/* verify no discrepancy between actual and
>>  					saved value exists */
>>  		if (unlikely(ret_freq != policy->cur)) {
>
>This is not -stable material, please drop it.

I've dropped it, thanks!

--
Thanks,
Sasha
