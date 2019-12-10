Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD4C11871C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 12:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfLJLtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 06:49:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:4591 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727223AbfLJLtc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 06:49:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 03:49:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,299,1571727600"; 
   d="scan'208";a="295868192"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 10 Dec 2019 03:49:31 -0800
Received: from [10.125.252.242] (abudanko-mobl.ccr.corp.intel.com [10.125.252.242])
        by linux.intel.com (Postfix) with ESMTP id 01EEA580A3B;
        Tue, 10 Dec 2019 03:49:29 -0800 (PST)
Subject: Re: [PATCH] perf/x86/intel: Fix PT PMI handling
To:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>,
        Vitaly Slobodskoy <vitaly.slobodskoy@intel.com>,
        stable@vger.kernel.org
References: <20191210105101.77210-1-alexander.shishkin@linux.intel.com>
From:   Alexey Budankov <alexey.budankov@linux.intel.com>
Organization: Intel Corp.
Message-ID: <aff9e887-5048-ccc2-fe03-91a5de3fdedb@linux.intel.com>
Date:   Tue, 10 Dec 2019 14:49:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191210105101.77210-1-alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 10.12.2019 13:51, Alexander Shishkin wrote:
> Commit:
> 
>   ccbebba4c6bf ("perf/x86/intel/pt: Bypass PT vs. LBR exclusivity if the core supports it")
> 
> skips the PT/LBR exclusivity check on CPUs where PT and LBRs coexist, but
> also inadvertently skips the active_events bump for PT in that case, which
> is a bug. If there aren't any hardware events at the same time as PT, the
> PMI handler will ignore PT PMIs, as active_events reads zero in that case,
> resulting in the "Uhhuh" spurious NMI warning and PT data loss.
> 
> Fix this by always increasing active_events for PT events.
> 
> Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Fixes: ccbebba4c6bf ("perf/x86/intel/pt: Bypass PT vs. LBR exclusivity if the core supports it")
> Reported-by: Vitaly Slobodskoy <vitaly.slobodskoy@intel.com>
> Cc: stable@vger.kernel.org # v4.7
> ---
>  arch/x86/events/core.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

Acked-by: Alexey Budankov <alexey.budankov@linux.intel.com>

> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 6e3f0c18908e..5a736197dfa4 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -375,7 +375,7 @@ int x86_add_exclusive(unsigned int what)
>  	 * LBR and BTS are still mutually exclusive.
>  	 */
>  	if (x86_pmu.lbr_pt_coexist && what == x86_lbr_exclusive_pt)
> -		return 0;
> +		goto out;
>  
>  	if (!atomic_inc_not_zero(&x86_pmu.lbr_exclusive[what])) {
>  		mutex_lock(&pmc_reserve_mutex);
> @@ -387,6 +387,7 @@ int x86_add_exclusive(unsigned int what)
>  		mutex_unlock(&pmc_reserve_mutex);
>  	}
>  
> +out:
>  	atomic_inc(&active_events);
>  	return 0;
>  
> @@ -397,11 +398,15 @@ int x86_add_exclusive(unsigned int what)
>  
>  void x86_del_exclusive(unsigned int what)
>  {
> +	atomic_dec(&active_events);
> +
> +	/*
> +	 * See the comment in x86_add_exclusive().
> +	 */
>  	if (x86_pmu.lbr_pt_coexist && what == x86_lbr_exclusive_pt)
>  		return;
>  
>  	atomic_dec(&x86_pmu.lbr_exclusive[what]);
> -	atomic_dec(&active_events);
>  }
>  
>  int x86_setup_perfctr(struct perf_event *event)
> 
