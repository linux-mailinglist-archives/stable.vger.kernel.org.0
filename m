Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79EC2EA8D3
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 11:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbhAEKco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 05:32:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24350 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728239AbhAEKck (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 05:32:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609842673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TCdWrkSxLou0I6q81I1C/gts0l+m7St/LyKjpTgDhNY=;
        b=RABnb0R7pWETieRI1N3KnNwpOo+VWMMBKtb10jv8huirM0zeDKovNuF8AebdkV16MibW78
        +nGgyFD87w58tH+zZ92GiHrFkg8Vreq3+r2UFE+lywDhbS1n/1LrC27LWMKCBcr66Fs/NJ
        tIel5M5UXu0oaKKdcM07V1ioeeubxlU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-BTmzTlDvM8-rSTiBU-5qZA-1; Tue, 05 Jan 2021 05:31:11 -0500
X-MC-Unique: BTmzTlDvM8-rSTiBU-5qZA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7159A803630;
        Tue,  5 Jan 2021 10:31:10 +0000 (UTC)
Received: from [10.36.114.117] (ovpn-114-117.ams2.redhat.com [10.36.114.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A78471CA2;
        Tue,  5 Jan 2021 10:31:08 +0000 (UTC)
Subject: Re: [PATCH v1 3/4] s390/kvm: add kvm_s390_vsie_mvpg_check needed for
 VSIE MVPG
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
 <20201218141811.310267-4-imbrenda@linux.ibm.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <ae6f3ec4-773f-2527-6cb5-7aaf803f73bf@redhat.com>
Date:   Tue, 5 Jan 2021 11:31:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201218141811.310267-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 18.12.20 15:18, Claudio Imbrenda wrote:
> Add kvm_s390_vsie_mvpg_check to perform the necessary checks in case an
> MVPG instruction intercepts in a VSIE guest.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kvm/gaccess.c | 55 +++++++++++++++++++++++++++++++++++++++++
>  arch/s390/kvm/gaccess.h |  3 +++
>  2 files changed, 58 insertions(+)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 8e256a233583..90e9baff6eac 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -1228,3 +1228,58 @@ int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
>  	mmap_read_unlock(sg->mm);
>  	return rc;
>  }
> +
> +static int kvm_s390_mvpg_check_one(struct kvm_vcpu *vcpu, unsigned long *addr,
> +			     const int edat, const union asce asce,
> +			     const enum gacc_mode mode, unsigned long *pteptr)
> +{
> +	enum prot_type prot;
> +	int rc;
> +
> +	rc = guest_translate(vcpu, *addr, addr, asce, mode, &prot, pteptr);
> +	if (rc <= 0)
> +		return rc;
> +
> +	switch (rc) {
> +	case PGM_REGION_FIRST_TRANS:
> +	case PGM_REGION_SECOND_TRANS:
> +	case PGM_REGION_THIRD_TRANS:
> +	case PGM_SEGMENT_TRANSLATION:
> +		if (!edat)
> +			return trans_exc(vcpu, rc, *addr, 0, mode, prot);
> +		*pteptr |= 4;

Hmmm, I wonder why that is necessary. Can't we set that in all relevant
cases in guest_translate() just as you do via

*entryptr |= dat_protection ? 6 : 4;


Can you enlighten me? :)

> +		fallthrough;
> +	case PGM_PAGE_TRANSLATION:
> +		return -ENOENT;
> +	default:
> +		return rc;
> +	}
> +}
> +
> +int kvm_s390_vsie_mvpg_check(struct kvm_vcpu *vcpu, unsigned long r1,
> +			     unsigned long r2, void *gpei)
> +{
> +	unsigned long pei[2] = {0};
> +	union ctlreg0 cr0;
> +	union asce cr1;
> +	int edat, rc1, rc2;
> +
> +	cr0.val = vcpu->arch.sie_block->gcr[0];
> +	cr1.val = vcpu->arch.sie_block->gcr[1];
> +	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
> +
> +	rc1 = kvm_s390_mvpg_check_one(vcpu, &r1, edat, cr1, GACC_FETCH, pei);
> +	rc2 = kvm_s390_mvpg_check_one(vcpu, &r2, edat, cr1, GACC_STORE, pei + 1);
> +
> +	if (rc1 == -ENOENT || rc2 == -ENOENT) {
> +		memcpy(gpei, pei, sizeof(pei));

I'd really prefer just passing two unsigned long pointers to
kvm_s390_vsie_mvpg_check() and eventually directly forwarding them to
kvm_s390_mvpg_check_one().

> +		return -ENOENT;
> +	}
> +
> +	if (rc2 < 0)
> +		return rc2;
> +	if (rc1 < 0)
> +		return rc1;
> +
> +	return 0;
> +}
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index f4c51756c462..2c53cee3b29f 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -166,6 +166,9 @@ int check_gva_range(struct kvm_vcpu *vcpu, unsigned long gva, u8 ar,
>  int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  		 unsigned long len, enum gacc_mode mode);
>  
> +int kvm_s390_vsie_mvpg_check(struct kvm_vcpu *vcpu, unsigned long r1,
> +			     unsigned long r2, void *gpei);
> +
>  int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>  		      void *data, unsigned long len, enum gacc_mode mode);
>  
> 


-- 
Thanks,

David / dhildenb

