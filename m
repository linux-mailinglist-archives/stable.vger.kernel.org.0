Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF7755AD8B
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 23:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfF2Vtn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jun 2019 17:49:43 -0400
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:59681 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726925AbfF2Vtn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jun 2019 17:49:43 -0400
Received: from c-73-193-85-113.hsd1.wa.comcast.net ([73.193.85.113] helo=srivatsab-a01.vmware.com)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1hhLE3-000NeQ-Dv; Sat, 29 Jun 2019 17:49:39 -0400
Subject: Re: [4.19.y PATCH 1/3] efi/x86/Add missing error handling to
 old_memmap 1:1 mapping code
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        Gen Zhang <blackgod016574@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Bradford <robert.bradford@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com
References: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
 <156174732219.34985.6679541271840078416.stgit@srivatsa-ubuntu>
 <20190629065721.GA365@kroah.com>
 <CAKv+Gu-_senkX5Asy1ZL+0cbAJBGib7Ys1WnMgdS36YO2LOU4Q@mail.gmail.com>
 <20190629091059.GA4198@kroah.com>
 <CAKv+Gu9AJ0Xt=Aec4VLnn5F-fHAYKGAYgxeJFAZE+G+3tGFG5Q@mail.gmail.com>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Message-ID: <488f90f2-4c8c-61bc-0e0f-8a1dd5e54bca@csail.mit.edu>
Date:   Sat, 29 Jun 2019 14:49:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9AJ0Xt=Aec4VLnn5F-fHAYKGAYgxeJFAZE+G+3tGFG5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/29/19 2:11 PM, Ard Biesheuvel wrote:
> On Sat, 29 Jun 2019 at 11:11, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Sat, Jun 29, 2019 at 10:47:00AM +0200, Ard Biesheuvel wrote:
>>> On Sat, 29 Jun 2019 at 08:57, Greg KH <gregkh@linuxfoundation.org> wrote:
>>>>
>>>> On Fri, Jun 28, 2019 at 11:42:13AM -0700, Srivatsa S. Bhat wrote:
>>>>> From: Gen Zhang <blackgod016574@gmail.com>
>>>>>
>>>>> commit 4e78921ba4dd0aca1cc89168f45039add4183f8e upstream.
>>>>>
>>>>> The old_memmap flow in efi_call_phys_prolog() performs numerous memory
>>>>> allocations, and either does not check for failure at all, or it does
>>>>> but fails to propagate it back to the caller, which may end up calling
>>>>> into the firmware with an incomplete 1:1 mapping.
>>>>>
>>>>> So let's fix this by returning NULL from efi_call_phys_prolog() on
>>>>> memory allocation failures only, and by handling this condition in the
>>>>> caller. Also, clean up any half baked sets of page tables that we may
>>>>> have created before returning with a NULL return value.
>>>>>
>>>>> Note that any failure at this level will trigger a panic() two levels
>>>>> up, so none of this makes a huge difference, but it is a nice cleanup
>>>>> nonetheless.
>>>>
>>>> With a description like this, why is this needed in a stable kernel if
>>>> it does not really fix anything useful?
>>>>
>>>
>>> Because it fixes a 'CVE', remember? :-)
>>
>> No, I don't remember that at all.
>>
>> Remember, I get 1000+ emails a day to do something with, and hence, have
>> the short-term memory of prior emails of a squirrel.
>>
>> Also, CVEs mean nothing, anyone can get one and they are impossible to
>> revoke, so don't treat them like they are "authoritative" at all.
>>
> 
> To refresh your memory: I already nacked this backport once before, on
> the grounds that the CVE is completely bogus.
> 

Oh! I didn't know that this patch was discussed here before (this is
the first time I'm posting these backports). Anyway, based on the
discussion above, Greg, please ignore this patchset.

Regards,
Srivatsa
