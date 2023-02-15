Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F22697FA3
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 16:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjBOPjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 10:39:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjBOPjx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 10:39:53 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE25524E;
        Wed, 15 Feb 2023 07:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=i7LKngPzc/hrmVl4gzBZXU9fkDYg01lrfToW/TF07cs=; b=PYgxf7xd2iJA2O9fL3Ig5ZUpPY
        fanBc6tEOZsGwe4k5hiiZnOqQG0z7GIX6jVRBbYCc3GnFncqzPVsYMWO/dAoqXVDFWTmsCtoLjwww
        69PRVjORixfmCakpyMiRlZUdgYg9BYrmDMYcEiTQGUWaK8C+IUfHVuGtk+Y+nRaXPmvZDjhMz0/vX
        IXF7XeVgQyJGVANG++EQmailfaE5FPUa36BymSLRhzPDguJlcZxmWMYl4FqYqpyEDHQQKuchvOmDz
        6YJyNy0g9bCnH3WyCCV8b9L+0b9LVSEI5FhE/54LwGlkVMN0dBvIAjBbrHKXf2svDQ/7PGTynbBQT
        nHJjhKqA==;
Received: from [187.10.60.16] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1pSJsZ-00372S-HW; Wed, 15 Feb 2023 16:39:31 +0100
Message-ID: <b04fc583-c3d1-8c3d-3831-9c765a74a705@igalia.com>
Date:   Wed, 15 Feb 2023 12:39:22 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4] panic: Fixes the panic_print NMI backtrace setting
Content-Language: en-US
To:     Petr Mladek <pmladek@suse.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        dyoung@redhat.com, d.hatayama@jp.fujitsu.com, feng.tang@intel.com,
        hidehiro.kawai.ez@hitachi.com, keescook@chromium.org,
        mikelley@microsoft.com, vgoyal@redhat.com, kernel-dev@igalia.com,
        kernel@gpiccoli.net, stable@vger.kernel.org
References: <20230210203510.1734835-1-gpiccoli@igalia.com>
 <Y+ue4OsyrGSx5ujB@alley>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <Y+ue4OsyrGSx5ujB@alley>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 14/02/2023 11:46, Petr Mladek wrote:
> [...]
>> My understanding is that it's a mechanism to prevent some concurrency,
>> in case some other CPU modify this variable while panic() is running.
>> I find it very unlikely, hence I removed it - but if people consider
>> this copy needed, I can respin this patch and keep it, even providing a
>> comment about that, in order to be explict about its need.
> 
> Yes, I think that it makes the behavior consistent even when the
> global variable manipulated in parallel.
> 
> I would personally prefer to keep the local copy. Better safe
> than sorry.
> 

Hi Petr, thanks for your review!
OK, we could keep this local copy, makes sense...even adding a comment,
to make its purpose really clear.


>> [...]
>> @@ -211,9 +211,6 @@ static void panic_print_sys_info(bool console_flush)
>>  		return;
>>  	}
>>  
>> -	if (panic_print & PANIC_PRINT_ALL_CPU_BT)
>> -		trigger_all_cpu_backtrace();
>> -
> 
> Sigh, this is yet another PANIC_PRINT_ action that need special
> timing. We should handle both the same way.
> 
> What about the following? The parameter @mask says what
> actions are allowed at the given time.
> < ..code..> 

I think your approach is interesting, it's very "organized".

But I think it's a bit conflicting with that purpose we had on notifiers
refactor, to deprecate "bogus" usages of panic_print, as in
https://lore.kernel.org/lkml/20220427224924.592546-26-gpiccoli@igalia.com/ .

So, the idea of my approach is to allow:

(a) Easy removal of panic_print_sys_info() of panic(), once we move it
to a panic notifier;

(b) Better separate and identify the "bogus" cases. The CPU backtrace
one is less a bogus case in my opinion, more a "complicated" one, since
it's related with the CPUs stop routines. But the console flush, as we
discussed, it's clearly something that calls for a new parameter (and
such param was added in the refactor patch).


In the end, I think your approach is interesting but it's kinda like
we're adding the fix to later, on refactor, entirely remove/rework it.
With my approach we wouldn't be calling panic_print_sys_info() again
(3rd time!) on panic(), and also would be more natural to move it later
to a new panic notifier.

What you / others think? If your approach is in the end preferred, it's
fine by me - I'd just ask you to submit as a full patch so we can get it
merged as a fix in 6.3, if possible (and backport it to the 6.1/6.2
stable). Now, if my approach is fine, I can resubmit as a V5 keeping the
local variable - lemme know.

Cheers,


Guilherme
