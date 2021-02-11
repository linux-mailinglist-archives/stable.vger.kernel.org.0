Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5FB318675
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 09:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBKIsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 03:48:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229743AbhBKIr6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 03:47:58 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11B8WnpN068816;
        Thu, 11 Feb 2021 03:46:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xi7bGN9YnvKz/mCD8mUzVxtMkrNS7ZBPC5mQO05VJGk=;
 b=MZmk0LHp37Dr3tNP6kIPhGcNdJhBnPCE5gsIDxDg1Y4U9WsiGY2TDEb4vNB77VfMZOeo
 TGy56rmXevY+jlAGflp7is8YUQQ7+1/BzKNEfmj0OI8JYTG99vIsVN7Rw2m/Iv+tSWne
 JWU6MqdbqAI1ygJsSC4cAkwY+ZUpKLiSto/Rqxl5LVvFHu+cfbIackJq0k+3CdvSJZBL
 85T1Ln+cwds8V62djyA33Wz7yd1JuwfNyJ7WDhV3jvt4UVJ+KryIah1yYpDU5+/67MZ2
 2BR1eDuuh8Tz5M5BQ+XBzpWoLc4OvrAPKfBObDyjf+bMTCzkXw9kFj0Yysq+aPCdVQK6 nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36n0pq1e52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 03:46:52 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11B8XKr8070853;
        Thu, 11 Feb 2021 03:46:51 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36n0pq1e4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 03:46:51 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11B8gt0A004081;
        Thu, 11 Feb 2021 08:46:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 36hskb2sda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 08:46:49 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11B8kaBK37224884
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Feb 2021 08:46:36 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0706CAE053;
        Thu, 11 Feb 2021 08:46:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92734AE045;
        Thu, 11 Feb 2021 08:46:46 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.64.239])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Feb 2021 08:46:46 +0000 (GMT)
Subject: Re: [PATCH v3 2/2] s390/kvm: VSIE: correctly handle MVPG when in VSIE
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210209154302.1033165-1-imbrenda@linux.ibm.com>
 <20210209154302.1033165-3-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <7a529aec-3c3a-2860-375c-0bacd4d82413@linux.ibm.com>
Date:   Thu, 11 Feb 2021 09:46:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209154302.1033165-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_05:2021-02-10,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102110072
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/9/21 4:43 PM, Claudio Imbrenda wrote:
> Correctly handle the MVPG instruction when issued by a VSIE guest.
> 
> Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---

Thanks for fixing this.

Acked-by: Janosch Frank <frankja@linux.ibm.com>

>  arch/s390/kvm/vsie.c | 93 +++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 88 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 7db022141db3..7dbb0d93c25f 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -416,11 +416,6 @@ static void unshadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  		memcpy((void *)((u64)scb_o + 0xc0),
>  		       (void *)((u64)scb_s + 0xc0), 0xf0 - 0xc0);
>  		break;
> -	case ICPT_PARTEXEC:
> -		/* MVPG only */
> -		memcpy((void *)((u64)scb_o + 0xc0),
> -		       (void *)((u64)scb_s + 0xc0), 0xd0 - 0xc0);
> -		break;
>  	}
>  
>  	if (scb_s->ihcpu != 0xffffU)
> @@ -982,6 +977,90 @@ static int handle_stfle(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  	return 0;
>  }
>  
> +static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page, u8 reg)
> +{
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
> +	unsigned long pei_dest, pei_src, src, dest, mask = PAGE_MASK;
> +	u64 *pei_block = &vsie_page->scb_o->mcic;
> +	int edat, rc_dest, rc_src;
> +	union ctlreg0 cr0;
> +
> +	cr0.val = vcpu->arch.sie_block->gcr[0];
> +	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
> +	if (psw_bits(scb_s->gpsw).eaba == PSW_BITS_AMODE_24BIT)
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
>  /*
>   * Run the vsie on a shadow scb and a shadow gmap, without any further
>   * sanity checks, handling SIE faults.
> @@ -1068,6 +1147,10 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  		if ((scb_s->ipa & 0xf000) != 0xf000)
>  			scb_s->ipa += 0x1000;
>  		break;
> +	case ICPT_PARTEXEC:
> +		if (scb_s->ipa == 0xb254)
> +			rc = vsie_handle_mvpg(vcpu, vsie_page);
> +		break;
>  	}
>  	return rc;
>  }
> 

