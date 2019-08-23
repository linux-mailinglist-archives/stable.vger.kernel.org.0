Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4F29A9A7
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 10:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388841AbfHWIHG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 23 Aug 2019 04:07:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:15376 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731543AbfHWIHG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Aug 2019 04:07:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 01:07:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,420,1559545200"; 
   d="scan'208";a="170058264"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga007.jf.intel.com with ESMTP; 23 Aug 2019 01:07:05 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 23 Aug 2019 01:07:05 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 23 Aug 2019 01:07:04 -0700
Received: from shsmsx101.ccr.corp.intel.com (10.239.4.153) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 23 Aug 2019 01:07:03 -0700
Received: from shsmsx107.ccr.corp.intel.com ([169.254.9.65]) by
 SHSMSX101.ccr.corp.intel.com ([169.254.1.80]) with mapi id 14.03.0439.000;
 Fri, 23 Aug 2019 16:07:02 +0800
From:   "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: to make vgpu ppgtt
 notificaiton as atomic operation
Thread-Topic: [Intel-gfx] [PATCH v2] drm/i915: to make vgpu ppgtt
 notificaiton as atomic operation
Thread-Index: AQHVWYAStc1z8bkPQE+oDmYb7X55Dg==
Date:   Fri, 23 Aug 2019 08:07:01 +0000
Message-ID: <073732E20AE4C540AE91DBC3F07D4460876D3410@SHSMSX107.ccr.corp.intel.com>
References: <1566543451-13955-1-git-send-email-xiaolin.zhang@intel.com>
 <156654711627.27716.4474982727513548344@skylake-alporthouse-com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.4.101]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/23/2019 03:58 PM, Chris Wilson wrote:
> Quoting Xiaolin Zhang (2019-08-23 07:57:31)
>> vgpu ppgtt notification was split into 2 steps, the first step is to
>> update PVINFO's pdp register and then write PVINFO's g2v_notify register
>> with action code to tirgger ppgtt notification to GVT side.
>>
>> currently these steps were not atomic operations due to no any protection,
>> so it is easy to enter race condition state during the MTBF, stress and
>> IGT test to cause GPU hang.
>>
>> the solution is to add a lock to make vgpu ppgtt notication as atomic
>> operation.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
>> ---
>>  drivers/gpu/drm/i915/i915_drv.h     | 1 +
>>  drivers/gpu/drm/i915/i915_gem_gtt.c | 4 ++++
>>  drivers/gpu/drm/i915/i915_vgpu.c    | 1 +
>>  3 files changed, 6 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
>> index eb31c16..32e17c4 100644
>> --- a/drivers/gpu/drm/i915/i915_drv.h
>> +++ b/drivers/gpu/drm/i915/i915_drv.h
>> @@ -961,6 +961,7 @@ struct i915_frontbuffer_tracking {
>>  };
>>  
>>  struct i915_virtual_gpu {
>> +       struct mutex lock;
>>         bool active;
>>         u32 caps;
>>  };
>> diff --git a/drivers/gpu/drm/i915/i915_gem_gtt.c b/drivers/gpu/drm/i915/i915_gem_gtt.c
>> index 2cd2dab..ff0b178 100644
>> --- a/drivers/gpu/drm/i915/i915_gem_gtt.c
>> +++ b/drivers/gpu/drm/i915/i915_gem_gtt.c
>> @@ -833,6 +833,8 @@ static int gen8_ppgtt_notify_vgt(struct i915_ppgtt *ppgtt, bool create)
>>         enum vgt_g2v_type msg;
>>         int i;
>>  
>> +       mutex_lock(&dev_priv->vgpu.lock);
>> +
>>         if (create)
>>                 atomic_inc(px_used(ppgtt->pd)); /* never remove */
>>         else
>> @@ -860,6 +862,8 @@ static int gen8_ppgtt_notify_vgt(struct i915_ppgtt *ppgtt, bool create)
>>  
>>         I915_WRITE(vgtif_reg(g2v_notify), msg);
>>  
> How do you know the operation is complete and it is now safe to
> overwrite the data regs?
> -Chris
>
by design, the data reg value is copied out to use, so as long as the
action and data is operated together, how long the operation is not a
issue and  it is safe to overwrite the data regs with new action next time.

-BRs, Xiaolin

