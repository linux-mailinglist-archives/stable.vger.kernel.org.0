Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8391A2DC674
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 19:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgLPS1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 13:27:45 -0500
Received: from mga12.intel.com ([192.55.52.136]:49884 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730673AbgLPS1p (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 13:27:45 -0500
IronPort-SDR: PmeavCPnRTxK/vQbrv3DsaHVo/60MyXfjWkxT3A6oKxQsoGZAiYysGUE6pdPZqY/m6BmrdO0dE
 OMQuHHsHW6/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9837"; a="154345016"
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="154345016"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 10:26:52 -0800
IronPort-SDR: 0egVT9fGEg6D6S2xHs+u+Qgvx5PmLBSDI9FG/0d9ataW0YhQqtdGDtoyTHMLEoxDeZ9Z4NK9Hp
 gfpOyAfRN/7Q==
X-IronPort-AV: E=Sophos;i="5.78,425,1599548400"; 
   d="scan'208";a="352711684"
Received: from rchatre-mobl3.amr.corp.intel.com (HELO [10.209.155.249]) ([10.209.155.249])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2020 10:26:51 -0800
Subject: Re: [PATCH 2/3] x86/resctrl: Update PQR_ASSOC MSR synchronously when
 moving task to resource group
To:     Valentin Schneider <valentin.schneider@arm.com>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, bp@alien8.de,
        tony.luck@intel.com, kuo-lang.tseng@intel.com, shakeelb@google.com,
        mingo@redhat.com, babu.moger@amd.com, james.morse@arm.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <cover.1607036601.git.reinette.chatre@intel.com>
 <c8eebc438e057e4bc2ce00256664b7bb0561b323.1607036601.git.reinette.chatre@intel.com>
 <jhjlfe4t6jq.mognet@arm.com> <e250875b-1c86-660c-b9f0-4060842939bf@intel.com>
 <jhj1rfptzqt.mognet@arm.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <b75d780d-d067-12bf-b0e6-706dda200511@intel.com>
Date:   Wed, 16 Dec 2020 10:26:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <jhj1rfptzqt.mognet@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Valentin,

On 12/16/2020 9:41 AM, Valentin Schneider wrote:
> 
> On 14/12/20 18:41, Reinette Chatre wrote:
>>>> -	return ret;
>>>> +
>>>> +	/*
>>>> +	 * By now, the task's closid and rmid are set. If the task is current
>>>> +	 * on a CPU, the PQR_ASSOC MSR needs to be updated to make the resource
>>>> +	 * group go into effect. If the task is not current, the MSR will be
>>>> +	 * updated when the task is scheduled in.
>>>> +	 */
>>>> +	update_task_closid_rmid(tsk);
>>>
>>> We need the above writes to be compile-ordered before the IPI is sent.
>>> There *is* a preempt_disable() down in smp_call_function_single() that
>>> gives us the required barrier(), can we deem that sufficient or would we
>>> want one before update_task_closid_rmid() for the sake of clarity?
>>>
>>
>> Apologies, it is not clear to me why the preempt_disable() would be
>> insufficient. If it is not then there may be a few other areas (where
>> resctrl calls smp_call_function_xxx()) that needs to be re-evaluated.
> 
> So that's part paranoia and part nonsense from my end - the contents of
> smp_call() shouldn't matter here.
> 
> If we distill the code to:
> 
>    tsk->closid = x;
> 
>    if (task_curr(tsk))
>        smp_call(...);
> 
> It is somewhat far fetched, but AFAICT this can be compiled as:
> 
>    if (task_curr(tsk))
>        tsk->closid = x;
>        smp_call(...);
>    else
>        tsk->closid = x;
> 
> IOW, there could be a sequence where the closid write is ordered *after*
> the task_curr() read.

Could you please elaborate why it would be an issue is the closid write 
is ordered after the task_curr() read? task_curr() does not depend on 
the closid.

> With
> 
>    tsk->closid = x;
> 
>    barrier();
> 
>    if (task_curr(tsk))
>        smp_call(...);
> 
> that explicitely cannot happen.
> 


Reinette
