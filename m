Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8EC2EE828
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 23:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbhAGWLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 17:11:54 -0500
Received: from mga17.intel.com ([192.55.52.151]:41743 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbhAGWLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 17:11:54 -0500
IronPort-SDR: wKtW8U9NL/sGeIuFUhCvs+DmG5iZ2LOiLTUcp7rlL4K4bERL1StlbhWOw3Wy06AnMBI1FlE0rV
 dv0e59q0q2Lw==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="157283921"
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="157283921"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 14:11:08 -0800
IronPort-SDR: f+bOgyqwx0PH6puNAhoPTH1mfbw24NGWYiF8A6eWluQYlYLX29Qi8IQKmnmp/neFXf+U9yhM7V
 t0lc0NWbdpJA==
X-IronPort-AV: E=Sophos;i="5.79,330,1602572400"; 
   d="scan'208";a="566275602"
Received: from rchatre-mobl3.amr.corp.intel.com (HELO [10.212.132.29]) ([10.212.132.29])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 14:11:07 -0800
Subject: Re: [PATCH V2 1/4] x86/resctrl: Use IPI instead of task_work_add() to
 update PQR_ASSOC MSR
To:     Borislav Petkov <bp@alien8.de>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, tony.luck@intel.com,
        kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        james.morse@arm.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <cover.1608243147.git.reinette.chatre@intel.com>
 <17aa2fb38fc12ce7bb710106b3e7c7b45acb9e94.1608243147.git.reinette.chatre@intel.com>
 <20210106111958.GD5729@zn.tnic>
From:   Reinette Chatre <reinette.chatre@intel.com>
Message-ID: <516cbcf4-ec80-a81a-c5f4-971fba4b2972@intel.com>
Date:   Thu, 7 Jan 2021 14:11:07 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20210106111958.GD5729@zn.tnic>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Borislav,

On 1/6/2021 3:19 AM, Borislav Petkov wrote:
> On Thu, Dec 17, 2020 at 02:31:18PM -0800, Reinette Chatre wrote:
>> +#ifdef CONFIG_SMP
>> +static void update_task_closid_rmid(struct task_struct *t)
>> +{
>> +	if (task_curr(t))
>> +		smp_call_function_single(task_cpu(t), _update_task_closid_rmid,
>> +					 t, 1);
>>   }
>> +#else
>> +static void update_task_closid_rmid(struct task_struct *t)
>> +{
>> +	_update_task_closid_rmid(t);
>> +}
>> +#endif
> 
> Why the ifdeffery? Why not simply:
> 
> static void update_task_closid_rmid(struct task_struct *t)
> {
>          if (IS_ENABLED(CONFIG_SMP) && task_curr(t))
>                  smp_call_function_single(task_cpu(t), _update_task_closid_rmid, t, 1);
>          else
>                  _update_task_closid_rmid(t);
> }
> 
> ?
> 
> If no particular reason, I'll change it before committing.

There is no particular reason. What you propose is much more readable.
Thank you very much.

Reinette
