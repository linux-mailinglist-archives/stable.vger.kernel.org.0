Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44684712A7
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 09:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388274AbfGWHSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 03:18:16 -0400
Received: from cmta19.telus.net ([209.171.16.92]:52036 "EHLO cmta19.telus.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388273AbfGWHSQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jul 2019 03:18:16 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jul 2019 03:18:14 EDT
Received: from dougxps ([173.180.45.4])
        by cmsmtp with SMTP
        id povzhPPxQeRl4pow0hmKDw; Tue, 23 Jul 2019 01:10:06 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=telus.net; s=neo;
        t=1563865806; bh=XH+cz0n2jFZrvdwK8js+vpCkuU9iaoulaMkw/K2zsms=;
        h=From:To:Cc:References:In-Reply-To:Subject:Date;
        b=G++Hwup0R1EK/XPjtggH/7xZv8yDgRDpKUb95GLBiwrkBrDvAEZeD1njy7Mmd5wG7
         EpKPCzpaaQfcvyLKLX188WLHDfgAFRke/aU0Y6NKC7DvCyaozReFoNnodA8/7Qks9q
         UxPwk2m+pVWDoO+RQjs1b5NvpZiy809PURrvIYwbba2iBziAt1hwZOeKXNlolVT4bV
         kwxx30AteLw5o/C7L5lUGkWlezabsV4UZoA2NwLMQHvnEw4iFzaPRUbE3p5PxEgrMN
         HK1l+Z2yLvLRUISRNmHra0y5pX6A4nn0VgFqDCjC73QYs1cV/l2tciqo4yIU/5qmfg
         BmxRR8sZBoaJw==
X-Telus-Authed: none
X-Authority-Analysis: v=2.3 cv=KqozJleN c=1 sm=1 tr=0
 a=zJWegnE7BH9C0Gl4FFgQyA==:117 a=zJWegnE7BH9C0Gl4FFgQyA==:17
 a=Pyq9K9CWowscuQLKlpiwfMBGOR0=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=KKAkSRfTAAAA:8
 a=X7X60EFgtTFmTPkmaoQA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=cvBusfyB2V15izCimMoJ:22
From:   "Doug Smythies" <dsmythies@telus.net>
To:     "'Viresh Kumar'" <viresh.kumar@linaro.org>,
        "'Rafael Wysocki'" <rjw@rjwysocki.net>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Peter Zijlstra'" <peterz@infradead.org>
Cc:     <linux-pm@vger.kernel.org>,
        "'Vincent Guittot'" <vincent.guittot@linaro.org>,
        <joel@joelfernandes.org>, "'v4 . 18+'" <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1563431200-3042-1-git-send-email-dsmythies@telus.net> <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org>
In-Reply-To: <8091ef83f264feb2feaa827fbeefe08348bcd05d.1563778071.git.viresh.kumar@linaro.org>
Subject: RE: [PATCH] cpufreq: schedutil: Don't skip freq update when limits change
Date:   Tue, 23 Jul 2019 00:10:01 -0700
Message-ID: <001201d54125$a6a82350$f3f869f0$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-Language: en-ca
Thread-Index: AdVAWfe+bwrPM5WESwOhTvNG8+jZwgAylY+w
X-CMAE-Envelope: MS4wfIlZvk504tenK5OfDjLaKFLSYbpLAFtMePH9EnvmmFwRbTgJQDEN1WZ6akOpYspZyktenwTEGsQg2/SR9897cVSYAddD9ki03lKRcPwC7C1NLVSjsovm
 mK3e/gC5KpzcmPsBNzjG6X34+TI051No1xRzPSUAskKB6v97KObyvM1XiXxX+u3RENtiItk2M6RCVjLAJlyUIS1o9wwKPMCKzNjxG4sFaDkw+e0WIgjaU90X
 MR4p8AKCXJRAMlnryoJVSO1bnPEl13Zlk2wun46bb6zRtdInsj/d8FiCYGiWj2X9Gb4RIbe3Ci75bIaI6s0dljUHS/EAFNNsHpqfap5QBjauHxBPjP0XVQrU
 hrkjhl+f5ecMEVe17c2Q9jn9fuVJTyU/NF7bc5AlEOvzIuT+LszyyCOW/3m8VWqULVflx1tdOtu5Rd1fdbaGzG3QczCybw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019.07.21 23:52 Viresh Kumar wrote:

> To avoid reducing the frequency of a CPU prematurely, we skip reducing
> the frequency if the CPU had been busy recently.
> 
> This should not be done when the limits of the policy are changed, for
> example due to thermal throttling. We should always get the frequency
> within limits as soon as possible.
>
> Fixes: ecd288429126 ("cpufreq: schedutil: Don't set next_freq to UINT_MAX")
> Cc: v4.18+ <stable@vger.kernel.org> # v4.18+
> Reported-by: Doug Smythies <doug.smythies@gmail.com>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> @Doug: Please try this patch, it must fix the issue you reported.

It fixes the driver = acpi-cpufreq ; governor = schedutil test case
It does not fix the driver = intel_cpufreq ; governor = schedutil test case

I have checked my results twice, but will check again in the day or two.

... Doug

>
> kernel/sched/cpufreq_schedutil.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
> index 636ca6f88c8e..b53c4f02b0f1 100644
> --- a/kernel/sched/cpufreq_schedutil.c
> +++ b/kernel/sched/cpufreq_schedutil.c
> @@ -447,7 +447,7 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
>  	struct sugov_policy *sg_policy = sg_cpu->sg_policy;
> 	unsigned long util, max;
>  	unsigned int next_f;
> -	bool busy;
> +	bool busy = false;
> 
> 	sugov_iowait_boost(sg_cpu, time, flags);
> 	sg_cpu->last_update = time;
> @@ -457,7 +457,9 @@ static void sugov_update_single(struct update_util_data *hook, u64 time,
> 	if (!sugov_should_update_freq(sg_policy, time))
>		return;
> 
> -	busy = sugov_cpu_is_busy(sg_cpu);
> +	/* Limits may have changed, don't skip frequency update */
> +	if (!sg_policy->need_freq_update)
> +		busy = sugov_cpu_is_busy(sg_cpu);
> 
> 	util = sugov_get_util(sg_cpu);
>  	max = sg_cpu->max;
> -- 
> 2.21.0.rc0.269.g1a574e7a288b


