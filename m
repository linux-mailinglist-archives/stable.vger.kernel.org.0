Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1982A3462A9
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 16:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhCWPR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 11:17:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232739AbhCWPR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 11:17:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616512648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1jq2tvJtDPz72d+/3bbC8VgDfAbuUx+LKrL/pY9II6o=;
        b=DPgN6SQ1Q5LvUba5YAh1r7Yff+ZkXJfe4rSrwM24sFW7/GOEnLQ06fNQNDyoClnph2QyjF
        QLCzNL7z4M+oA13KwX+bspZSjaxVFacAf1zu+4Iy41q+3gk8gbLWzSVY4aIHVOuLODfHRi
        JxTMhQ+Ay5b0GJbaDVewipqUJz9IfCU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-xnmbI6VjN4uvnFuDKYhAVQ-1; Tue, 23 Mar 2021 11:17:22 -0400
X-MC-Unique: xnmbI6VjN4uvnFuDKYhAVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E106181625;
        Tue, 23 Mar 2021 15:17:20 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E655F5C1C5;
        Tue, 23 Mar 2021 15:17:18 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] s390/kvm: VSIE: fix MVPG handling for prefixing
 and MSO
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     frankja@linux.ibm.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
References: <20210322140559.500716-1-imbrenda@linux.ibm.com>
 <20210322140559.500716-3-imbrenda@linux.ibm.com>
 <433933f5-1b6e-ea58-618d-3c844edc73a6@de.ibm.com>
 <830ca8c6-4d21-b1ed-ccaf-e0c12237849e@redhat.com>
 <9293b208-0f1d-fb58-290c-66a8ae30d60c@de.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <e8d198f0-3e90-a86e-2a19-796da889f0f4@redhat.com>
Date:   Tue, 23 Mar 2021 16:17:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <9293b208-0f1d-fb58-290c-66a8ae30d60c@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.03.21 16:16, Christian Borntraeger wrote:
> 
> 
> On 23.03.21 16:11, David Hildenbrand wrote:
>> On 23.03.21 16:07, Christian Borntraeger wrote:
>>>
>>>
>>> On 22.03.21 15:05, Claudio Imbrenda wrote:
>>>> Prefixing needs to be applied to the guest real address to translate it
>>>> into a guest absolute address.
>>>>
>>>> The value of MSO needs to be added to a guest-absolute address in order to
>>>> obtain the host-virtual.
>>>>
>>>> Fixes: 223ea46de9e79 ("s390/kvm: VSIE: correctly handle MVPG when in VSIE")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
>>>> Reported-by: Janosch Frank <frankja@linux.ibm.com>
>>>> ---
>>>>     arch/s390/kvm/vsie.c | 6 +++++-
>>>>     1 file changed, 5 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
>>>> index 48aab6290a77..ac86f11e46dc 100644
>>>> --- a/arch/s390/kvm/vsie.c
>>>> +++ b/arch/s390/kvm/vsie.c
>>>> @@ -1002,7 +1002,7 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
>>>>     static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>>>     {
>>>>         struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
>>>> -    unsigned long pei_dest, pei_src, src, dest, mask;
>>>> +    unsigned long pei_dest, pei_src, dest, src, mask, mso, prefix;
>>>>         u64 *pei_block = &vsie_page->scb_o->mcic;
>>>>         int edat, rc_dest, rc_src;
>>>>         union ctlreg0 cr0;
>>>> @@ -1010,9 +1010,13 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>>>>         cr0.val = vcpu->arch.sie_block->gcr[0];
>>>>         edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
>>>>         mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
>>>> +    mso = scb_s->mso & ~(1UL << 20);
>>>              shouldnt that be ~((1UL << 20 ) -1)
>>>
>>
>> Looking at shadow_scb(), we can simply take scb_s->mso unmodified.
> 
> Right, I think I can fix this up (and get rid of the local mso variable)
> when queueing. Or shall Claudio send a new version of the patch?
> 

IMHO, you can just fix it up.

-- 
Thanks,

David / dhildenb

