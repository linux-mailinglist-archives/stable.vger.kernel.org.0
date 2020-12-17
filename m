Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F372DCF9D
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 11:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgLQKkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 05:40:36 -0500
Received: from foss.arm.com ([217.140.110.172]:56082 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbgLQKkf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Dec 2020 05:40:35 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 408FF31B;
        Thu, 17 Dec 2020 02:39:50 -0800 (PST)
Received: from e113632-lin (e113632-lin.cambridge.arm.com [10.1.194.46])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 453883F66E;
        Thu, 17 Dec 2020 02:39:48 -0800 (PST)
References: <cover.1607036601.git.reinette.chatre@intel.com> <c8eebc438e057e4bc2ce00256664b7bb0561b323.1607036601.git.reinette.chatre@intel.com> <jhjlfe4t6jq.mognet@arm.com> <e250875b-1c86-660c-b9f0-4060842939bf@intel.com> <jhj1rfptzqt.mognet@arm.com> <b75d780d-d067-12bf-b0e6-706dda200511@intel.com>
User-agent: mu4e 0.9.17; emacs 26.3
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, bp@alien8.de,
        tony.luck@intel.com, kuo-lang.tseng@intel.com, shakeelb@google.com,
        mingo@redhat.com, babu.moger@amd.com, james.morse@arm.com,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/resctrl: Update PQR_ASSOC MSR synchronously when moving task to resource group
In-reply-to: <b75d780d-d067-12bf-b0e6-706dda200511@intel.com>
Date:   Thu, 17 Dec 2020 10:39:43 +0000
Message-ID: <jhjwnxgsols.mognet@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 16/12/20 18:26, Reinette Chatre wrote:
> Hi Valentin,
>> So that's part paranoia and part nonsense from my end - the contents of
>> smp_call() shouldn't matter here.
>>
>> If we distill the code to:
>>
>>    tsk->closid = x;
>>
>>    if (task_curr(tsk))
>>        smp_call(...);
>>
>> It is somewhat far fetched, but AFAICT this can be compiled as:
>>
>>    if (task_curr(tsk))
>>        tsk->closid = x;
>>        smp_call(...);
>>    else
>>        tsk->closid = x;
>>
>> IOW, there could be a sequence where the closid write is ordered *after*
>> the task_curr() read.
>
> Could you please elaborate why it would be an issue is the closid write
> is ordered after the task_curr() read? task_curr() does not depend on
> the closid.
>

IMO the 'task_curr()' check only makes sense if it happens *after* the
write, the logic being: 'closid/rmid has been written to, does the task now
need interrupting?'

In the above 'else' clause, task_curr() would need to be re-evaluated after
the write: the task wasn't current *before* the write, but nothing
guarantees this still holds *after* the write.

>> With
>>
>>    tsk->closid = x;
>>
>>    barrier();
>>
>>    if (task_curr(tsk))
>>        smp_call(...);
>>
>> that explicitely cannot happen.
>>
>
>
> Reinette
