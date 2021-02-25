Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49184325681
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 20:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbhBYTQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 14:16:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233007AbhBYTOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 14:14:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614280359;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=06Wk8j084czweIl2sAHUw6QfIrOuQIVq2H1D3mFdUrw=;
        b=innT8SjbUgQlVZVDBXqwti84HaJ6AEwk2xlI4e/+rmiBysi+IC4LTHFgUvbiU6J5Wv+TAO
        YZ1tVwGf0Wg/lbq9qmSPULjcHVgZwgjvpKYt0cZwUNudk3n+fr7yxvwM0BzMa+1Ob0FuzX
        omJZXu/nSrpO2pvJYO6JpiscvQ5X8lE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-FRsNhabSOcWl8_2jz3Lyag-1; Thu, 25 Feb 2021 14:12:36 -0500
X-MC-Unique: FRsNhabSOcWl8_2jz3Lyag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD79A107ACF3;
        Thu, 25 Feb 2021 19:12:34 +0000 (UTC)
Received: from [10.36.114.58] (ovpn-114-58.ams2.redhat.com [10.36.114.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B7585D9D2;
        Thu, 25 Feb 2021 19:12:32 +0000 (UTC)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210223191353.267981-1-imbrenda@linux.ibm.com>
 <20210223191353.267981-3-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH v4 2/2] s390/kvm: VSIE: correctly handle MVPG when in VSIE
Message-ID: <2978d95c-62d9-556a-186f-9534e202f4c9@redhat.com>
Date:   Thu, 25 Feb 2021 20:12:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223191353.267981-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23.02.21 20:13, Claudio Imbrenda wrote:
> Correctly handle the MVPG instruction when issued by a VSIE guest.
> 
> Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/kvm/vsie.c | 93 +++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 88 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 78b604326016..dbf4241bc2dc 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -417,11 +417,6 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   		memcpy((void *)((u64)scb_o + 0xc0),
>   		       (void *)((u64)scb_s + 0xc0), 0xf0 - 0xc0);
>   		break;
> -	case ICPT_PARTEXEC:
> -		/* MVPG only */
> -		memcpy((void *)((u64)scb_o + 0xc0),
> -		       (void *)((u64)scb_s + 0xc0), 0xd0 - 0xc0);
> -		break;
>   	}
>   
>   	if (scb_s->ihcpu != 0xffffU)
> @@ -983,6 +978,90 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   	return 0;
>   }
>   
> +static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, u8 reg)
> +{
> +	reg &= 0xf;

Nit, I'd mask of that value in the caller where you extract it from the ipb.

...

> +static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
> +{
> +	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> +	unsigned long pei_dest, pei_src, src, dest, mask = PAGE_MASK;
> +	u64 *pei_block = &vsie_page->scb_o->mcic;
> +	int edat, rc_dest, rc_src;
> +	union ctlreg0 cr0;

...

const uint8_t r1 = (scb_s->ipb >> 16) & 0xf;
const uint8_t r3 = (scb_s->ipb >> 20) & 0xf;

(note: r1/r3 is just a guess ;) - and having the actual identifiers here 
will make the code easier to understand)

> +
> +	cr0.val = vcpu->arch.sie_block->gcr[0];
> +	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
> +	if (psw_bits(scb_s->gpsw).eaba == PSW_BITS_AMODE_24BIT)

What about factoring out that masking like

kvm_s390_logical_to_effective()

introduce

vsie_logical_to_effective()

to handle that.

> +		mask = 0xfff000;
> +	else if (psw_bits(scb_s->gpsw).eaba == PSW_BITS_AMODE_31BIT)
> +		mask = 0x7ffff000;
> +
> +	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
> +	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
> +
> +	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
> +	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
> +	/*
> +	 * Either everything went well, or something non-critical went wrong
> +	 * e.g. beause of a race. In either case, simply retry.

s/beause/because/

> +	 */
> +	if (rc_dest == -EAGAIN || rc_src == -EAGAIN || (!rc_dest && !rc_src)) {
> +		retry_vsie_icpt(vsie_page);
> +		return -EAGAIN;

I remember, because of the retry_vsie_icpt() you can simply return 0. 
Whatever you prefer.

> +	}
> +	/* Something more serious went wrong, propagate the error */
> +	if (rc_dest < 0)
> +		return rc_dest;
> +	if (rc_src < 0)
> +		return rc_src;
> +
> +	/* The only possible suppressing exception: just deliver it */
> +	if (rc_dest == PGM_TRANSLATION_SPEC || rc_src == PGM_TRANSLATION_SPEC) {
> +		clear_vsie_icpt(vsie_page);
> +		rc_dest = kvm_s390_inject_program_int(vcpu, PGM_TRANSLATION_SPEC);
> +		WARN_ON_ONCE(rc_dest);
> +		return 1;
> +	}
> +
> +	/*
> +	 * Forward the PEI intercept to the guest if it was a page fault, or
> +	 * also for segment and region table faults if EDAT applies.
> +	 */
> +	if (edat) {
> +		rc_dest = rc_dest == PGM_ASCE_TYPE ? rc_dest : 0;
> +		rc_src = rc_src == PGM_ASCE_TYPE ? rc_src : 0;
> +	} else {
> +		rc_dest = rc_dest != PGM_PAGE_TRANSLATION ? rc_dest : 0;
> +		rc_src = rc_src != PGM_PAGE_TRANSLATION ? rc_src : 0;
> +	}
> +	if (!rc_dest && !rc_src) {
> +		pei_block[0] = pei_dest;
> +		pei_block[1] = pei_src;
> +		return 1;
> +	}
> +
> +	retry_vsie_icpt(vsie_page);
> +
> +	/*
> +	 * The host has edat, and the guest does not, or it was an ASCE type
> +	 * exception. The host needs to inject the appropriate DAT interrupts
> +	 * into the guest.
> +	 */
> +	if (rc_dest)
> +		return inject_fault(vcpu, rc_dest, dest, 1);
> +	return inject_fault(vcpu, rc_src, src, 0);

The rc_dest and rc_src handling towards the end is a little confusing, 
but I have no real suggestion to make it easier to digest.


Only some suggestions to make the code a bit nicer to read. Apart from 
that LGTM.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

