Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919D63311F0
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 16:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCHPSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 10:18:25 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43372 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230502AbhCHPSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 10:18:17 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128F8SG3142646;
        Mon, 8 Mar 2021 10:18:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LcHazBRiO/XctMn3JYCn7BFHLxcjnonC6vqCVmw3mfc=;
 b=H0MY6Qy0DiYDdD44xVH//3/yBGfk4HpMLh7BqqXKvAm/rE5wfA62/E0v/skaE6LLNyet
 9u9mV+XsxvnrtP7TrEG6ougpvCaaRfE1ZmsXLBS7iUZaYLX91RLe0NtUslk2dwvpcAIU
 0Y8o8glS11qlcD1Vv7FN1FnffaMYXwfWJSPaqbMEFIymLNHoT4weyi3VCVDckL5GIy5n
 6zOlpIhHyMA3ZwZVuEpAkNeUSHBnShpIXFNJ2NWxtUi8HO6jck8aXtp6QBKYYBf8EbuT
 UljgWWZ+q8CzL3cg3K4eBloCfozR2K0DLuxk+05IVLhAH6XX8E3b/HV4+affWXwT89gy Ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375p19gstk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 10:18:17 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128F9hYS151002;
        Mon, 8 Mar 2021 10:18:16 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375p19gssr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 10:18:16 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128FBx9Z013715;
        Mon, 8 Mar 2021 15:18:14 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3741c8hxfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 15:18:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128FIBuB42598778
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 15:18:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 489F44C059;
        Mon,  8 Mar 2021 15:18:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D74A24C04A;
        Mon,  8 Mar 2021 15:18:10 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.67.70])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 15:18:10 +0000 (GMT)
Subject: Re: [PATCH v5 3/3] s390/kvm: VSIE: correctly handle MVPG when in VSIE
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210302174443.514363-1-imbrenda@linux.ibm.com>
 <20210302174443.514363-4-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <d5784664-0fb9-eeec-c1c8-5b6c11a32ea3@de.ibm.com>
Date:   Mon, 8 Mar 2021 16:18:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210302174443.514363-4-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_11:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 adultscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080083
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 02.03.21 18:44, Claudio Imbrenda wrote:
> Correctly handle the MVPG instruction when issued by a VSIE guest.
> 
> Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>

looks sane.

Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/s390/kvm/vsie.c | 98 +++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 93 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 78b604326016..48aab6290a77 100644
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
> @@ -983,6 +978,95 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   	return 0;
>   }
> 
> +/*
> + * Get a register for a nested guest.
> + * @vcpu the vcpu of the guest
> + * @vsie_page the vsie_page for the nested guest
> + * @reg the register number, the upper 4 bits are ignored.
> + * returns: the value of the register.
> + */
> +static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, u8 reg)
> +{
> +	/* no need to validate the parameter and/or perform error handling */
> +	reg &= 0xf;
> +	switch (reg) {
> +	case 15:
> +		return vsie_page->scb_s.gg15;
> +	case 14:
> +		return vsie_page->scb_s.gg14;
> +	default:
> +		return vcpu->run->s.regs.gprs[reg];
> +	}
> +}
> +
> +static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
> +{
> +	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> +	unsigned long pei_dest, pei_src, src, dest, mask;
> +	u64 *pei_block = &vsie_page->scb_o->mcic;
> +	int edat, rc_dest, rc_src;
> +	union ctlreg0 cr0;
> +
> +	cr0.val = vcpu->arch.sie_block->gcr[0];
> +	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
> +	mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
> +
> +	dest = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
> +	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 20) & mask;
> +
> +	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
> +	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
> +	/*
> +	 * Either everything went well, or something non-critical went wrong
> +	 * e.g. because of a race. In either case, simply retry.
> +	 */
> +	if (rc_dest == -EAGAIN || rc_src == -EAGAIN || (!rc_dest && !rc_src)) {
> +		retry_vsie_icpt(vsie_page);
> +		return -EAGAIN;
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
> +}
> +
>   /*
>    * Run the vsie on a shadow scb and a shadow gmap, without any further
>    * sanity checks, handling SIE faults.
> @@ -1071,6 +1155,10 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   		if ((scb_s->ipa & 0xf000) != 0xf000)
>   			scb_s->ipa += 0x1000;
>   		break;
> +	case ICPT_PARTEXEC:
> +		if (scb_s->ipa == 0xb254)
> +			rc = vsie_handle_mvpg(vcpu, vsie_page);
> +		break;
>   	}
>   	return rc;
>   }
> 
