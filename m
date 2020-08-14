Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17762244E57
	for <lists+stable@lfdr.de>; Fri, 14 Aug 2020 20:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgHNSIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Aug 2020 14:08:04 -0400
Received: from mga17.intel.com ([192.55.52.151]:7013 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgHNSIE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Aug 2020 14:08:04 -0400
IronPort-SDR: AjcgjUXBse3d82xEDhL6gi0O+ujcNY8zzj3LULeME/1qePyNFApgZkuFt1wtfcF8p4AobX1YZ8
 Qy8BomIHNLPQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9713"; a="134534743"
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="134534743"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 11:08:03 -0700
IronPort-SDR: JlT2JRQubwjJ4IXBx6KH5pYudD6O6g17WQwUl75+l7b+Pa/MVl9H42sFttADNsjn88bCSWEDJ4
 4hGtjt9t3IfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,313,1592895600"; 
   d="scan'208";a="335657917"
Received: from orsmsx602-2.jf.intel.com (HELO ORSMSX602.amr.corp.intel.com) ([10.22.229.82])
  by orsmga007.jf.intel.com with ESMTP; 14 Aug 2020 11:08:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 14 Aug 2020 11:08:02 -0700
Received: from [10.209.97.116] (10.22.254.132) by ORSMSX610.amr.corp.intel.com
 (10.22.229.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Fri, 14 Aug
 2020 11:08:02 -0700
Subject: Re: [PATCH 2/3] drm/i915/gt: Wait for CSB entries on Tigerlake
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        <intel-gfx@lists.freedesktop.org>
CC:     Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        <stable@vger.kernel.org>
References: <20200814155735.29138-1-chris@chris-wilson.co.uk>
 <20200814155735.29138-2-chris@chris-wilson.co.uk>
From:   "Chang, Bruce" <yu.bruce.chang@intel.com>
Message-ID: <4e8f3929-06d9-9183-f5ed-9cf18abf40dc@intel.com>
Date:   Fri, 14 Aug 2020 11:07:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200814155735.29138-2-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.22.254.132]
X-ClientProxiedBy: orsmsx605.amr.corp.intel.com (10.22.229.18) To
 ORSMSX610.amr.corp.intel.com (10.22.229.23)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/14/2020 8:57 AM, Chris Wilson wrote:
> On Tigerlake, we are seeing a repeat of commit d8f505311717 ("drm/i915/icl:
> Forcibly evict stale csb entries") where, presumably, due to a missing
> Global Observation Point synchronisation, the write pointer of the CSB
> ringbuffer is updated _prior_ to the contents of the ringbuffer. That is
> we see the GPU report more context-switch entries for us to parse, but
> those entries have not been written, leading us to process stale events,
> and eventually report a hung GPU.
>
> However, this effect appears to be much more severe than we previously
> saw on Icelake (though it might be best if we try the same approach
> there as well and measure), and Bruce suggested the good idea of resetting
> the CSB entry after use so that we can detect when it has been updated by
> the GPU. By instrumenting how long that may be, we can set a reliable
> upper bound for how long we should wait for:
>
>      513 late, avg of 61 retries (590 ns), max of 1061 retries (10099 ns)
>
> Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/2045
> References: d8f505311717 ("drm/i915/icl: Forcibly evict stale csb entries")
> Suggested-by: Bruce Chang <yu.bruce.chang@intel.com>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Bruce Chang <yu.bruce.chang@intel.com>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: stable@vger.kernel.org # v5.4
> ---
>   drivers/gpu/drm/i915/gt/intel_lrc.c | 21 ++++++++++++++++++---
>   1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gt/intel_lrc.c b/drivers/gpu/drm/i915/gt/intel_lrc.c
> index db982fc0f0bc..3b8161c6b601 100644
> --- a/drivers/gpu/drm/i915/gt/intel_lrc.c
> +++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
> @@ -2498,9 +2498,22 @@ invalidate_csb_entries(const u64 *first, const u64 *last)
>    */
>   static inline bool gen12_csb_parse(const u64 *csb)
>   {
> -	u64 entry = READ_ONCE(*csb);
> -	bool ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
> -	bool new_queue =
> +	bool ctx_away_valid;
> +	bool new_queue;
> +	u64 entry;
> +
> +	/* XXX HSD */
> +	entry = READ_ONCE(*csb);
> +	if (unlikely(entry == -1)) {
> +		preempt_disable();
> +		if (wait_for_atomic_us((entry = READ_ONCE(*csb)) != -1, 50))
> +			GEM_WARN_ON("50us CSB timeout");

Out tests showed that 10us is not long enough, but 20us worked well. So 
50us should be good enough.

> +		preempt_enable();
> +	}
> +	WRITE_ONCE(*(u64 *)csb, -1);

A wmb() is probably needed here. it should be ok if CSB is in SMEM, but 
in the case CSB is allocated in LMEM, the memory type will be WC, so the 
memory write (WRITE_ONCE) is potentially still in the write combine 
buffer and not in any cache system, i.e., not visible to HW.

> +
> +	ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
> +	new_queue =
>   		lower_32_bits(entry) & GEN12_CTX_STATUS_SWITCHED_TO_NEW_QUEUE;
>   
>   	/*
> @@ -3995,6 +4008,8 @@ static void reset_csb_pointers(struct intel_engine_cs *engine)
>   	WRITE_ONCE(*execlists->csb_write, reset_value);
>   	wmb(); /* Make sure this is visible to HW (paranoia?) */
>   
> +	/* Check that the GPU does indeed update the CSB entries! */
> +	memset(execlists->csb_status, -1, (reset_value + 1) * sizeof(u64));
>   	invalidate_csb_entries(&execlists->csb_status[0],
>   			       &execlists->csb_status[reset_value]);
>   
