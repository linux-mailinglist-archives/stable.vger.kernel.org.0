Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2FE24520B
	for <lists+stable@lfdr.de>; Sat, 15 Aug 2020 23:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHOVid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Aug 2020 17:38:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:62772 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgHOVid (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Aug 2020 17:38:33 -0400
IronPort-SDR: 0ROQFYf4/BPHv/NtGaje6FYCDcT+flpulRMnvwn09fehS4xpEG0RsbifVmVMKoARvpH56eq4yP
 KyOPmQmOv/2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9713"; a="218836801"
X-IronPort-AV: E=Sophos;i="5.76,314,1592895600"; 
   d="scan'208";a="218836801"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2020 19:16:59 -0700
IronPort-SDR: b2aaqcIH1wZ3Chnl5PaiKjRLx+9QWc5M+MXUMCMq66HKUzIOVTuolrb9myYxhkpGoJiDI+bArh
 hNX6pGV04OEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,314,1592895600"; 
   d="scan'208";a="333564935"
Received: from orsmsx606-2.jf.intel.com (HELO ORSMSX606.amr.corp.intel.com) ([10.22.229.86])
  by FMSMGA003.fm.intel.com with ESMTP; 14 Aug 2020 19:16:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 14 Aug 2020 19:16:59 -0700
Received: from [10.209.97.116] (10.22.254.132) by ORSMSX610.amr.corp.intel.com
 (10.22.229.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Fri, 14 Aug
 2020 19:16:58 -0700
Subject: Re: [Intel-gfx] [PATCH 2/3] drm/i915/gt: Wait for CSB entries on
 Tigerlake
From:   "Chang, Bruce" <yu.bruce.chang@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        <intel-gfx@lists.freedesktop.org>
CC:     <stable@vger.kernel.org>
References: <20200814155735.29138-1-chris@chris-wilson.co.uk>
 <20200814155735.29138-2-chris@chris-wilson.co.uk>
 <4e8f3929-06d9-9183-f5ed-9cf18abf40dc@intel.com>
 <159743033592.31882.10893400044974332038@build.alporthouse.com>
 <66272f87-c6c1-2b45-87f4-cf54303ab44b@intel.com>
Message-ID: <1e1abf15-21ed-5c8a-56b2-da34fc67439d@intel.com>
Date:   Fri, 14 Aug 2020 19:16:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <66272f87-c6c1-2b45-87f4-cf54303ab44b@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.22.254.132]
X-ClientProxiedBy: orsmsx607.amr.corp.intel.com (10.22.229.20) To
 ORSMSX610.amr.corp.intel.com (10.22.229.23)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/14/2020 5:36 PM, Chang, Bruce wrote:
>
>>>> @@ -2498,9 +2498,22 @@ invalidate_csb_entries(const u64 *first, 
>>>> const u64 *last)
>>>>     */
>>>>    static inline bool gen12_csb_parse(const u64 *csb)
>>>>    {
>>>> -     u64 entry = READ_ONCE(*csb);
>>>> -     bool ctx_away_valid = GEN12_CSB_CTX_VALID(upper_32_bits(entry));
>>>> -     bool new_queue =
>>>> +     bool ctx_away_valid;
>>>> +     bool new_queue;
>>>> +     u64 entry;
>>>> +
>>>> +     /* XXX HSD */
>>>> +     entry = READ_ONCE(*csb);
>>>> +     if (unlikely(entry == -1)) {
>>>> +             preempt_disable();
>>>> +             if (wait_for_atomic_us((entry = READ_ONCE(*csb)) != 
>>>> -1, 50))
>>>> +                     GEM_WARN_ON("50us CSB timeout");
>>> Out tests showed that 10us is not long enough, but 20us worked well. So
>>> 50us should be good enough.
>
> Just realized this may not fully work, as one of the common issue we 
> run into is that higher 32bit is updated from the HW, but lower 32bit 
> update at a later time: meaning the csb will read like 
> 0xFFFFFFFF:xxxxxxxx (low:high) . So this check (!= -1) can still pass 
> but with a partial invalid csb status. So, we may need to check each 
> 32bit separately.
>
After tested, with the new 64bit read, the above issue never happened so 
far. So, it seems this only applicable to 32bit read (CSB updated 
between the two lower and high 32bit reads). Assuming the HW 64bit CSB 
update is also atomic, the above code should be fine.

>>>> +             preempt_enable();
>>>> +     }
>>>> +     WRITE_ONCE(*(u64 *)csb, -1);
>>> A wmb() is probably needed here. it should be ok if CSB is in SMEM, but
>>> in the case CSB is allocated in LMEM, the memory type will be WC, so 
>>> the
>>> memory write (WRITE_ONCE) is potentially still in the write combine
>>> buffer and not in any cache system, i.e., not visible to HW.
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/intel-gfx
