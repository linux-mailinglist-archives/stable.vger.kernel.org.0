Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E072DC582
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 18:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgLPRmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 12:42:20 -0500
Received: from foss.arm.com ([217.140.110.172]:37776 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727482AbgLPRmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 12:42:20 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA60BD6E;
        Wed, 16 Dec 2020 09:41:34 -0800 (PST)
Received: from e113632-lin (e113632-lin.cambridge.arm.com [10.1.194.46])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C327B3F66E;
        Wed, 16 Dec 2020 09:41:32 -0800 (PST)
References: <cover.1607036601.git.reinette.chatre@intel.com> <c8eebc438e057e4bc2ce00256664b7bb0561b323.1607036601.git.reinette.chatre@intel.com> <jhjlfe4t6jq.mognet@arm.com> <e250875b-1c86-660c-b9f0-4060842939bf@intel.com>
User-agent: mu4e 0.9.17; emacs 26.3
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, bp@alien8.de,
        tony.luck@intel.com, kuo-lang.tseng@intel.com, shakeelb@google.com,
        mingo@redhat.com, babu.moger@amd.com, james.morse@arm.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/resctrl: Update PQR_ASSOC MSR synchronously when moving task to resource group
In-reply-to: <e250875b-1c86-660c-b9f0-4060842939bf@intel.com>
Date:   Wed, 16 Dec 2020 17:41:30 +0000
Message-ID: <jhj1rfptzqt.mognet@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 14/12/20 18:41, Reinette Chatre wrote:
>>> -	return ret;
>>> +
>>> +	/*
>>> +	 * By now, the task's closid and rmid are set. If the task is current
>>> +	 * on a CPU, the PQR_ASSOC MSR needs to be updated to make the resource
>>> +	 * group go into effect. If the task is not current, the MSR will be
>>> +	 * updated when the task is scheduled in.
>>> +	 */
>>> +	update_task_closid_rmid(tsk);
>>
>> We need the above writes to be compile-ordered before the IPI is sent.
>> There *is* a preempt_disable() down in smp_call_function_single() that
>> gives us the required barrier(), can we deem that sufficient or would we
>> want one before update_task_closid_rmid() for the sake of clarity?
>>
>
> Apologies, it is not clear to me why the preempt_disable() would be
> insufficient. If it is not then there may be a few other areas (where
> resctrl calls smp_call_function_xxx()) that needs to be re-evaluated.

So that's part paranoia and part nonsense from my end - the contents of
smp_call() shouldn't matter here.

If we distill the code to:

  tsk->closid = x;

  if (task_curr(tsk))
      smp_call(...);

It is somewhat far fetched, but AFAICT this can be compiled as:

  if (task_curr(tsk))
      tsk->closid = x;
      smp_call(...);
  else
      tsk->closid = x;

IOW, there could be a sequence where the closid write is ordered *after*
the task_curr() read. With

  tsk->closid = x;

  barrier();

  if (task_curr(tsk))
      smp_call(...);

that explicitely cannot happen.

>
> Thank you very much
>
> Reinette
