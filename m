Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C55318711
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 10:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhBKJ1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 04:27:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230295AbhBKJUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 04:20:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613035144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u4st3dUfUDrEYqTNg6+oyu4V3aGVRlCGOHLDzYx7178=;
        b=alzAKdTHWPLT2RueiidX2x/dsBz/gwPe1aJyrgpJJQRKY4jzLPDHv2OPh0f7w4CgIC5Z7z
        +OHLnptA0px22EOxNybuWNhRKOyrHpZNW1drom08sFJAklYGq3DwI+qJwyJ1mmH7JG9Cm2
        eFwPiTFS1xAOrIih83DwvwpnzC7T8Nc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-cwDao8JwMxi9SulrTdCGIQ-1; Thu, 11 Feb 2021 04:19:01 -0500
X-MC-Unique: cwDao8JwMxi9SulrTdCGIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E031BBEE4;
        Thu, 11 Feb 2021 09:18:59 +0000 (UTC)
Received: from [10.36.114.52] (ovpn-114-52.ams2.redhat.com [10.36.114.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2DF360C17;
        Thu, 11 Feb 2021 09:18:57 +0000 (UTC)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210209154302.1033165-1-imbrenda@linux.ibm.com>
 <20210209154302.1033165-2-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH v3 1/2] s390/kvm: extend kvm_s390_shadow_fault to return
 entry pointer
Message-ID: <2a65f089-1728-7bc7-a2a8-a2c089a01cec@redhat.com>
Date:   Thu, 11 Feb 2021 10:18:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210209154302.1033165-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 09.02.21 16:43, Claudio Imbrenda wrote:
> Extend kvm_s390_shadow_fault to return the pointer to the valid leaf
> DAT table entry, or to the invalid entry.
> 
> Also return some flags in the lower bits of the address:
> DAT_PROT: indicates that DAT protection applies because of the
>            protection bit in the segment (or, if EDAT, region) tables
> NOT_PTE: indicates that the address of the DAT table entry returned
>           does not refer to a PTE, but to a segment or region table.
> 

I've been thinking about one possible issue, but I think it's not 
actually an issue. Just sharing so others can verify:

In case our guest uses huge pages / gigantic pages / ASCE R, we create 
fake page tables (GMAP_SHADOW_FAKE_TABLE).

So, it could be that kvm_s390_shadow_fault()->gmap_shadow_pgt_lookup()
succeeds, however, we have a fake PTE in our hands. We lost the
actual guest STE/RTE address. (I think it could be recovered somehow via 
page->index, thought)

But I guess, if there is a fake PTE, then there is not acutally
something that could go wrong in gmap_shadow_page() anymore that could
lead us in responding something wrong to the guest. We can only really
fail with -EINVAL, -ENOMEM or -EFAULT.

So if the guest changed anything in the meantime (e.g., zap a segment), 
we would have unshadowed the whole fake page table hierarchy and would
simply retry.

> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Cc: stable@vger.kernel.org
> ---
>   arch/s390/kvm/gaccess.c | 30 +++++++++++++++++++++++++-----
>   arch/s390/kvm/gaccess.h |  5 ++++-
>   arch/s390/kvm/vsie.c    |  8 ++++----
>   3 files changed, 33 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 6d6b57059493..e0ab83f051d2 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -976,7 +976,9 @@ int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra)
>    * kvm_s390_shadow_tables - walk the guest page table and create shadow tables
>    * @sg: pointer to the shadow guest address space structure
>    * @saddr: faulting address in the shadow gmap
> - * @pgt: pointer to the page table address result
> + * @pgt: pointer to the beginning of the page table for the given address if
> + *       successful (return value 0), or to the first invalid DAT entry in
> + *       case of exceptions (return value > 0)
>    * @fake: pgt references contiguous guest memory block, not a pgtable
>    */
>   static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
> @@ -1034,6 +1036,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   			rfte.val = ptr;
>   			goto shadow_r2t;
>   		}
> +		*pgt = ptr + vaddr.rfx * 8;
>   		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8, &rfte.val);

Using

gmap_read_table(parent, *pgt, &rfte.val);

or similar with a local variable might then be even clearer. But no 
strong opinion.

>   		if (rc)
>   			return rc;
> @@ -1060,6 +1063,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   			rste.val = ptr;
>   			goto shadow_r3t;
>   		}
> +		*pgt = ptr + vaddr.rsx * 8;
>   		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8, &rste.val);
>   		if (rc)
>   			return rc;
> @@ -1087,6 +1091,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   			rtte.val = ptr;
>   			goto shadow_sgt;
>   		}
> +		*pgt = ptr + vaddr.rtx * 8;
>   		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8, &rtte.val);
>   		if (rc)
>   			return rc;
> @@ -1123,6 +1128,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>   			ste.val = ptr;
>   			goto shadow_pgt;
>   		}
> +		*pgt = ptr + vaddr.sx * 8;
>   		rc = gmap_read_table(parent, ptr + vaddr.sx * 8, &ste.val);
>   		if (rc)
>   			return rc;
> @@ -1157,6 +1163,8 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>    * @vcpu: virtual cpu
>    * @sg: pointer to the shadow guest address space structure
>    * @saddr: faulting address in the shadow gmap
> + * @datptr: will contain the address of the faulting DAT table entry, or of
> + *          the valid leaf, plus some flags
>    *
>    * Returns: - 0 if the shadow fault was successfully resolved
>    *	    - > 0 (pgm exception code) on exceptions while faulting
> @@ -1165,11 +1173,11 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
>    *	    - -ENOMEM if out of memory
>    */
>   int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
> -			  unsigned long saddr)
> +			  unsigned long saddr, unsigned long *datptr)
>   {
>   	union vaddress vaddr;
>   	union page_table_entry pte;
> -	unsigned long pgt;
> +	unsigned long pgt = 0;
>   	int dat_protection, fake;
>   	int rc;
>   
> @@ -1191,8 +1199,20 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
>   		pte.val = pgt + vaddr.px * PAGE_SIZE;
>   		goto shadow_page;
>   	}
> -	if (!rc)
> -		rc = gmap_read_table(sg->parent, pgt + vaddr.px * 8, &pte.val);
> +
> +	switch (rc) {
> +	case PGM_SEGMENT_TRANSLATION:
> +	case PGM_REGION_THIRD_TRANS:
> +	case PGM_REGION_SECOND_TRANS:
> +	case PGM_REGION_FIRST_TRANS:
> +		pgt |= NOT_PTE;
> +		break;
> +	case 0:
> +		pgt += vaddr.px * 8;
> +		rc = gmap_read_table(sg->parent, pgt, &pte.val);
> +	}
> +	if (*datptr)
> +		*datptr = pgt | dat_protection * DAT_PROT;
>   	if (!rc && pte.i)
>   		rc = PGM_PAGE_TRANSLATION;
>   	if (!rc && pte.z)
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index f4c51756c462..fec26bbb17ba 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -359,7 +359,10 @@ void ipte_unlock(struct kvm_vcpu *vcpu);
>   int ipte_lock_held(struct kvm_vcpu *vcpu);
>   int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
>   
> +#define DAT_PROT 2
> +#define NOT_PTE 4

What if our guest is using ASCE.R ?

-- 
Thanks,

David / dhildenb

