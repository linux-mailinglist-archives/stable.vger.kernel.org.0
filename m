Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 588154A215
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 15:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFRN1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jun 2019 09:27:41 -0400
Received: from relay.sw.ru ([185.231.240.75]:49592 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbfFRN1l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jun 2019 09:27:41 -0400
Received: from [172.16.25.12]
        by relay.sw.ru with esmtp (Exim 4.92)
        (envelope-from <aryabinin@virtuozzo.com>)
        id 1hdE98-0001lw-VL; Tue, 18 Jun 2019 16:27:35 +0300
Subject: Re: [PATCH] ubsan: mark ubsan_type_mismatch_common inline
To:     Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
References: <20190617123109.667090-1-arnd@arndb.de>
 <20190617140210.GB3436@hirez.programming.kicks-ass.net>
 <CAK8P3a3iwWOkMBL-H3h5aSaHKjKWFce22rvydvVE=3uMfeOhVg@mail.gmail.com>
From:   Andrey Ryabinin <aryabinin@virtuozzo.com>
Message-ID: <fc10bc69-0628-59eb-c243-9cd1dd3b47a4@virtuozzo.com>
Date:   Tue, 18 Jun 2019 16:27:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a3iwWOkMBL-H3h5aSaHKjKWFce22rvydvVE=3uMfeOhVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/18/19 3:56 PM, Arnd Bergmann wrote:
> On Mon, Jun 17, 2019 at 4:02 PM Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> On Mon, Jun 17, 2019 at 02:31:09PM +0200, Arnd Bergmann wrote:
>>> objtool points out a condition that it does not like:
>>>
>>> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch()+0x4a: call to stackleak_track_stack() with UACCESS enabled
>>> lib/ubsan.o: warning: objtool: __ubsan_handle_type_mismatch_v1()+0x4a: call to stackleak_track_stack() with UACCESS enabled
>>>
>>> I guess this is related to the call ubsan_type_mismatch_common()
>>> not being inline before it calls user_access_restore(), though
>>> I don't fully understand why that is a problem.
>>
>> The rules are that when AC is set, one is not allowed to CALL schedule,
>> because scheduling does not save/restore AC.  Preemption, through the
>> exceptions is fine, because the exceptions do save/restore AC.
>>
>> And while most functions do not appear to call into schedule, function
>> trace ensures that every single call does in fact call into schedule.
>> Therefore any CALL (with AC set) is invalid.
> 
> I see that stackleak_track_stack is already marked 'notrace',
> since we must ensure we don't recurse when calling into it from
> any of the function trace logic.
> 
> Does that mean we could just mark it as another safe call?
> 
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -486,6 +486,7 @@ static const char *uaccess_safe_builtin[] = {
>         "__ubsan_handle_type_mismatch",
>         "__ubsan_handle_type_mismatch_v1",
>         /* misc */
> +       "stackleak_track_stack",
>         "csum_partial_copy_generic",
>         "__memcpy_mcsafe",
>         "ftrace_likely_update", /* CONFIG_TRACE_BRANCH_PROFILING */
> 
> 
>> Maybe we should disable stackleak when building ubsan instead? We
>> already disable stack-protector when building ubsan.
> 
> I couldn't find out how that is done.
> 

I guess this:
ccflags-y += $(DISABLE_STACKLEAK_PLUGIN)
