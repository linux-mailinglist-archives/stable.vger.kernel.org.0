Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B34D2EA869
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbhAEKSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:18:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56588 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728784AbhAEKSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 05:18:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609841829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zAP8iYZeFWK+rDPt5xfMhF9Y6yvbIrq3xHNDaJv01T0=;
        b=jFWV/iCH4daY8f7ghJdiWEhgM/dLqYTUZJ1JOt1sMgux1jL5y2G2YBOFHU5USClEATzpUV
        TvlSwG0UI8Es3V4eNMNBv/en9BrVmH+j8WKyN6KXfz6ciByTG83+NNlgDaeqx6Wxq0WSfa
        1oJWUtQiz6m9Krv2Nm1Iwl+RxrO/22E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-532-PovHZBsWMt68hH1xfWjC4Q-1; Tue, 05 Jan 2021 05:17:08 -0500
X-MC-Unique: PovHZBsWMt68hH1xfWjC4Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0981800D53;
        Tue,  5 Jan 2021 10:17:06 +0000 (UTC)
Received: from [10.36.114.117] (ovpn-114-117.ams2.redhat.com [10.36.114.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DAEF7771C;
        Tue,  5 Jan 2021 10:17:05 +0000 (UTC)
Subject: Re: [PATCH v1 4/4] s390/kvm: VSIE: correctly handle MVPG when in VSIE
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
 <20201218141811.310267-5-imbrenda@linux.ibm.com>
 <6836573a-a49d-9d9f-49e0-96b5aa479c52@redhat.com>
 <20210104162231.4e56ab47@ibm-vm>
 <3376268b-7fd7-9fbe-b483-fe7471038a18@redhat.com>
 <20210104173644.2e6c8df4@ibm-vm>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <b3dbadf7-80a9-36de-9d32-f80005ee6dcf@redhat.com>
Date:   Tue, 5 Jan 2021 11:17:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210104173644.2e6c8df4@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.01.21 17:36, Claudio Imbrenda wrote:
> On Mon, 4 Jan 2021 17:08:15 +0100
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 04.01.21 16:22, Claudio Imbrenda wrote:
>>> On Sun, 20 Dec 2020 11:13:57 +0100
>>> David Hildenbrand <david@redhat.com> wrote:
>>>   
>>>> On 18.12.20 15:18, Claudio Imbrenda wrote:  
>>>>> Correctly handle the MVPG instruction when issued by a VSIE guest.
>>>>>     
>>>>
>>>> I remember that MVPG SIE documentation was completely crazy and
>>>> full of corner cases. :)  
>>>
>>> you remember correctly
>>>   
>>>> Looking at arch/s390/kvm/intercept.c:handle_mvpg_pei(), I can spot
>>>> that
>>>>
>>>> 1. "This interception can only happen for guests with DAT disabled
>>>> ..." 2. KVM does not make use of any mvpg state inside the SCB.
>>>>
>>>> Can this be observed with Linux guests?  
>>>
>>> a Linux guest will typically not run with DAT disabled
>>>   
>>>> Can I get some information on what information is stored at [0xc0,
>>>> 0xd) inside the SCB? I assume it's:
>>>>
>>>> 0xc0: guest physical address of source PTE
>>>> 0xc8: guest physical address of target PTE  
>>>
>>> yes (plus 3 flags in the lower bits of each)  
>>
>> Thanks! Do the flags tell us what the deal with the PTE was? If yes,
>> what's the meaning of the separate flags?
>>
>> I assume something like "invalid, proteced, ??"
> 
> bit 61 indicates that the address is a region or segment table entry,
> when EDAT applies
> bit 62 is "protected" when the protected bit is set in the segment
> table entry (or region, if EDAT applies) 
> bit 63 is set when the operand was translated with a real-space ASCE

Thanks!

> but you can check if the PTE is valid just by dereferencing the
> pointers...

The pgtable might already have been unshadowed and repurposed I think.
So for vSIE, the PTE content, therefore, is a little unreliable.

We could, of course, try using them to make a guess.

"Likely valid"
"Likely invalid"

A rerun of the vSIE will fixup any wrong guess.

> 
>> I'm asking because I think we can handle this a little easier.
> 
> what is your idea?

I was wondering if we can

1. avoid essentially two translations per PTE, obtaining the information
we need while tying to shadow. kvm_s390_shadow_fault() on steroids that

a) gives us the last guest pte address (tricky for segment.region table
I think ... will have to think about this)
b) the final protection

2. avoid faulting/shadowing in case we know an entry is not problematic.
E.g., no need to shadow/fault the source in case the PTE is there and
not invalid. "likely valid" case above.


The idea would be to call the new kvm_s390_shadow_fault() two times (or
only once due to our guesses) and either rerun the vsie, inject an
interrupt, or create the partial intercept.

Essentially avoiding kvm_s390_vsie_mvpg_check(). Will have to think
about this.

[...]
>>
>> arch/s390/kvm/intercept.c:handle_partial_execution() we only seem to
>> handle
>>
>> 1. MVPG
>> 2. SIGP PEI
>>
>> The latter is only relevant for external calls. IIRC, this is only
>> active with sigp interpretation - which is never active under vsie
>> (ECA_SIGPI).
> 
> I think putting an explicit check is better than just a jump in the
> dark.

Agreed, but that should then be called out somewhere why the change as
done. (e.g., separate cleanup patch)

-- 
Thanks,

David / dhildenb

