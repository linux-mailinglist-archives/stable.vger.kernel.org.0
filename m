Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8312D343D4D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 10:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhCVJ4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 05:56:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48960 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230027AbhCVJzz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 05:55:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616406954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUufmyh3A4V077KACg1M3I/o1FkYLmY5QIZxvkVvBnY=;
        b=BdbH8h4vAglaOkiKBqyKHovwJOAuWJ3X+2ozs2XtLWTqd8syVyPa70rnGC2lHbL254nU1L
        FibnunYdgPIcrUf/vLOgPgN8VQamDcvUk9mftG6FJAmd5hxQqgvTHAgnkB6hoBcbAQzdmK
        sbf7lSzHMnOtPPgG577BZa+rjqOcDE4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-ErAyjmyPMFCqQrecXqZX2g-1; Mon, 22 Mar 2021 05:55:50 -0400
X-MC-Unique: ErAyjmyPMFCqQrecXqZX2g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9AA48B5DC2;
        Mon, 22 Mar 2021 09:55:48 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3650521ECB;
        Mon, 22 Mar 2021 09:55:47 +0000 (UTC)
Subject: Re: [PATCH v1 2/2] s390/kvm: VSIE: fix MVPG handling for prefixing
 and MSO
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210319193354.399587-1-imbrenda@linux.ibm.com>
 <20210319193354.399587-3-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <f7c8dd7d-34ab-95b9-dac4-bf2b9e37ae37@redhat.com>
Date:   Mon, 22 Mar 2021 10:55:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210319193354.399587-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 19.03.21 20:33, Claudio Imbrenda wrote:
> Prefixing needs to be applied to the guest real address to translate it
> into a guest absolute address.
> 
> The value of MSO needs to be added to a guest-absolute address in order to
> obtain the host-virtual.
> 
> Fixes: 223ea46de9e79 ("s390/kvm: VSIE: correctly handle MVPG when in VSIE")
> Cc: stable@vger.kernel.org
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   arch/s390/kvm/vsie.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 48aab6290a77..92864f9b3d84 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1002,7 +1002,7 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
>   static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   {
>   	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> -	unsigned long pei_dest, pei_src, src, dest, mask;
> +	unsigned long pei_dest, pei_src, r1, r2, src, dest, mask, mso, prefix;
>   	u64 *pei_block = &vsie_page->scb_o->mcic;
>   	int edat, rc_dest, rc_src;
>   	union ctlreg0 cr0;
> @@ -1010,9 +1010,13 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   	cr0.val = vcpu->arch.sie_block->gcr[0];
>   	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
>   	mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
> +	mso = READ_ONCE(vsie_page->scb_o->mso) & ~(1UL << 20);

I think we should use the one stored in the shadow page - this is what 
the SIE saw and will see when retrying.

> +	prefix = scb_s->prefix << GUEST_PREFIX_SHIFT;
>   
> -	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
> -	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
> +	r1 = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16);
> +	r2 = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20);

Just reuse dest and src here?

> +	dest = _kvm_s390_real_to_abs(prefix, r1 & mask) + mso;
> +	src = _kvm_s390_real_to_abs(prefix, r2 & mask) + mso;
>   
>   	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
>   	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
> 

Apart from that, looks good to me.

-- 
Thanks,

David / dhildenb

