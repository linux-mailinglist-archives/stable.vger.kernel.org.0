Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31C9346238
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 16:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhCWPC0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 11:02:26 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36256 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232547AbhCWPCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 11:02:03 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12NF198c066224;
        Tue, 23 Mar 2021 11:02:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=k1WO91Nv459jd5UeN2hfVomwEBZAVg0mYE2a7vxyJsw=;
 b=gUxUE6ST303gKUKQ+vfeg3ox1CJW7RkCoTGe51pHufx1OfCvpVfQAoEGt2QmHpAPDj2X
 LZooWZWntfSQyawXdFMvgEVgzWbStFwqT8ujWNS5Bhdv5vjc5ks591+/cMytwnIQothR
 lFW3VCnY1SgkF0o6oflj+si6uuOAkTRuKuKX8P1fGiADAx7PiqQ+SHqwAedbgPaVc+Vn
 a5xqAbEkwZyB8yi7Eel8D1Di61bkOWxEJtua2JWI/mRq0i3ts8dIl96IED7WpA7DdORC
 Csw7RbeWEKkUxKxfoiv1CGE14lwzIIm76FXJyDG2bCUeweMAWMGblg4gjFhYp0ZNM53r YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37fjkjg1fg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 11:02:01 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12NF1PgI067384;
        Tue, 23 Mar 2021 11:02:01 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37fjkjg1dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 11:02:00 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12NEuwVJ023389;
        Tue, 23 Mar 2021 15:01:58 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 37d9bmkf71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 15:01:58 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12NF1tXj40632730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 15:01:55 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6AA93A405C;
        Tue, 23 Mar 2021 15:01:55 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A345A4065;
        Tue, 23 Mar 2021 15:01:55 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.5.141])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Mar 2021 15:01:54 +0000 (GMT)
Subject: Re: [PATCH v2 1/2] s390/kvm: split kvm_s390_real_to_abs
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org, Thomas Huth <thuth@redhat.com>
References: <20210322140559.500716-1-imbrenda@linux.ibm.com>
 <20210322140559.500716-2-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <7965aef3-9441-6d2e-909f-a3733992425f@de.ibm.com>
Date:   Tue, 23 Mar 2021 16:01:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322140559.500716-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_06:2021-03-22,2021-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 clxscore=1015 impostorscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2103230107
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 22.03.21 15:05, Claudio Imbrenda wrote:
> A new function _kvm_s390_real_to_abs will apply prefixing to a real address
> with a given prefix value.
> 
> The old kvm_s390_real_to_abs becomes now a wrapper around the new function.
> 
> This is needed to avoid code duplication in vSIE.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

> ---
>   arch/s390/kvm/gaccess.h | 23 +++++++++++++++++------
>   1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
> index daba10f76936..7c72a5e3449f 100644
> --- a/arch/s390/kvm/gaccess.h
> +++ b/arch/s390/kvm/gaccess.h
> @@ -18,17 +18,14 @@
>   
>   /**
>    * kvm_s390_real_to_abs - convert guest real address to guest absolute address
> - * @vcpu - guest virtual cpu
> + * @prefix - guest prefix
>    * @gra - guest real address
>    *
>    * Returns the guest absolute address that corresponds to the passed guest real
> - * address @gra of a virtual guest cpu by applying its prefix.
> + * address @gra of by applying the given prefix.
>    */
> -static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
> -						 unsigned long gra)
> +static inline unsigned long _kvm_s390_real_to_abs(u32 prefix, unsigned long gra)
>   {
> -	unsigned long prefix  = kvm_s390_get_prefix(vcpu);
> -
>   	if (gra < 2 * PAGE_SIZE)
>   		gra += prefix;
>   	else if (gra >= prefix && gra < prefix + 2 * PAGE_SIZE)
> @@ -36,6 +33,20 @@ static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
>   	return gra;
>   }
>   
> +/**
> + * kvm_s390_real_to_abs - convert guest real address to guest absolute address
> + * @vcpu - guest virtual cpu
> + * @gra - guest real address
> + *
> + * Returns the guest absolute address that corresponds to the passed guest real
> + * address @gra of a virtual guest cpu by applying its prefix.
> + */
> +static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
> +						 unsigned long gra)
> +{
> +	return _kvm_s390_real_to_abs(kvm_s390_get_prefix(vcpu), gra);
> +}
> +
>   /**
>    * _kvm_s390_logical_to_effective - convert guest logical to effective address
>    * @psw: psw of the guest
> 
