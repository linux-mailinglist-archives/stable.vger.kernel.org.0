Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273764E8CFC
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 06:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbiC1EOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 00:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiC1EOr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 00:14:47 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A63B233;
        Sun, 27 Mar 2022 21:13:07 -0700 (PDT)
Received: from [192.168.12.80] (unknown [182.2.37.32])
        by gnuweeb.org (Postfix) with ESMTPSA id 227087E70A;
        Mon, 28 Mar 2022 04:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648440786;
        bh=m8nJ0aUP+EcTvuSXye5QG/gDYxyUt/Fhy/dpUgbn7PE=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=Z8Ogbd1Bk+6QXwE5rWrlzy4uHfHeUYxjlVhGoxr3oGJNs5cjF0gkYj9VS2Fd50NU0
         hKVT8gZUh78ToGtYx3VfhrdeyCzjfZOi6k50uBbrjdB6tN/JQcPHaYq0KsnQ67qrmd
         zPhLTRawIV1BfEddcRKQamm7ta8r73mGCthagShH/q0rVdSW7OIVV/oRD4MeA0FM2v
         6YlaBJDn8PaSO7LRfwbberrPonmMm6XDNZzdEMNuazQMgR0fAnmG/qKJWT7EniOa6F
         wD4KLUg8e0K1pS1CHV7mla20JA6tbtduFndrCTMLrszNgEGObmm/jKsgRdw0vVdDoM
         GkUHFqjxgwVQA==
Message-ID: <82609267-8fc6-5b3d-c931-c0d93ab14788@gnuweeb.org>
Date:   Mon, 28 Mar 2022 11:12:53 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gwml@vger.gnuweeb.org, x86@kernel.org
References: <20220310015306.445359-1-ammarfaizi2@gnuweeb.org>
 <20220310015306.445359-3-ammarfaizi2@gnuweeb.org> <YkDqo2eEbABbtSGY@zn.tnic>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH v5 2/2] x86/MCE/AMD: Fix memory leak when
 `threshold_create_bank()` fails
In-Reply-To: <YkDqo2eEbABbtSGY@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/28/22 5:52 AM, Borislav Petkov wrote:
[...]
>> Fixes: 6458de97fc15 ("x86/mce/amd: Straighten CPU hotplug path")
> 
> How did you decide this is the commit that this is fixing?

I examined the history in those lines by git blame. Will recheck after the below
doubt is cleared.

>> Link: https://lore.kernel.org/lkml/9dfe087a-f941-1bc4-657d-7e7c198888ff@gnuweeb.org
> 
> That Link tag is not needed.
> 
>> Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
>> Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
>> Co-authored-by: Yazen Ghannam <yazen.ghannam@amd.com>
> 
> There's no "Co-authored-by".
> 
> The correct tag is described in
> 
> Documentation/process/submitting-patches.rst

Will fix them in the v6.

> ...
> 
>> @@ -1350,15 +1357,14 @@ int mce_threshold_create_device(unsigned int cpu)
>>   		if (!(this_cpu_read(bank_map) & (1 << bank)))
>>   			continue;
>>   		err = threshold_create_bank(bp, cpu, bank);
>> -		if (err)
>> -			goto out_err;
>> +		if (err) {
>> +			_mce_threshold_remove_device(bp, numbanks);
>> +			return err;
>> +		}
>>   	}
>>   	this_cpu_write(threshold_banks, bp);
> 
> Do I see it correctly that the publishing of the @bp pointer - i.e.,
> this line - should be moved right above the for loop?
> 
> Then mce_threshold_remove_device() would properly free it in the error
> case and your patch turns into a oneliner?

Previously, in v4 I did that too. But after discussion with Yazen, we got a
conclusion that placing `this_cpu_write(threshold_banks, bp);` before the for loop
is not the right thing to do.

> And then your Fixes: tag would be correct too...
The reason is based on the discussion with Yazen, the full discussion can be read in
the Link tag above.

==================
The point is:

On Wed, 2 Mar 2022 17:26:32 +0000, Yazen Ghannam <yazen.ghannam@amd.com> wrote:
> The threshold interrupt handler uses this pointer. I think the goal here is to
> set this pointer when the list is fully formed and clear this pointer before
> making any changes to the list. Otherwise, the interrupt handler will operate
> on incomplete data if an interrupt comes in the middle of these updates.
==================

Also, looking at the comment in mce_threshold_remove_device() function:

	/*
	 * Clear the pointer before cleaning up, so that the interrupt won't
	 * touch anything of this.
	 */
	this_cpu_write(threshold_banks, NULL);

I think it's reasonable to place `this_cpu_write(threshold_banks, bp);` after
the "for loop" on the creation process for the similar reason. In short, don't
let the interrupt sees incomplete data.

Although, I am not sure if that 100% guarantees mce_threshold_remove_device()
will not mess up with the interrupt (e.g. freeing the data while the interrupt
reading it), unless we're using RCU stuff.

What do you think?

-- 
Ammar Faizi
