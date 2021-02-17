Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEE631D6E5
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 10:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhBQJTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 04:19:15 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21284 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhBQJTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 04:19:11 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11H90dMt026168;
        Wed, 17 Feb 2021 04:18:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ia97Hv6vISsG9Ib9rQmb1DZFC45uId5MKmhx6AfP8W8=;
 b=YxKvHF0avTHXHFMcyQSst74SbNLMamyS0ABtA65fa/D0yFOUgmdvZeZfNrxUikxrM5n/
 xN1vLljgqPjSTP4Thf7Wh2WFh3kyRYlQhn+Y/Q9Kjsba7LFh4BINixli1pKHzev0ELTy
 G4R2rMBVZlP8Co7LYN7Vi9hkfhQ7i6ArSVKc/9kxzt6qoKz+mKY0hl/XYZPDkaTBHkSm
 iz1kfviRZeDMCrfnao5TvYX6fdEruZyGil6fXM+j5ickk11JF+E5ArfpVdsStrDbid0n
 XSXtHmV3AhftCPiaTxVVupJtiD8mDPjtYUJD83rT5RwsNM7wY4wRjPtRJjqkJ1ug5RPS UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s03brqb3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 04:18:21 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11H9HjAQ103877;
        Wed, 17 Feb 2021 04:18:21 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s03brqaf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 04:18:21 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11H9DhxN010720;
        Wed, 17 Feb 2021 09:18:18 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 36p6d8bhq5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:18:18 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11H9IGvZ36897094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 09:18:16 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CD59A405E;
        Wed, 17 Feb 2021 09:18:16 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8429A4053;
        Wed, 17 Feb 2021 09:18:12 +0000 (GMT)
Received: from [9.160.89.213] (unknown [9.160.89.213])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Feb 2021 09:18:12 +0000 (GMT)
Subject: Re: [PATCH for 5.4] Fix unsynchronized access to sev members through
 svm_register_enc_region
To:     Peter Gonda <pgonda@google.com>, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210208164855.772287-1-pgonda@google.com>
From:   Dov Murik <dovmurik@linux.vnet.ibm.com>
Message-ID: <2ddf06e9-a541-3d9c-3a0c-db557a04afcc@linux.vnet.ibm.com>
Date:   Wed, 17 Feb 2021 11:18:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210208164855.772287-1-pgonda@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_06:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 malwarescore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 adultscore=0 impostorscore=0
 spamscore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170064
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Peter,

On 08/02/2021 18:48, Peter Gonda wrote:
> commit 19a23da53932bc8011220bd8c410cb76012de004 upstream.
> 
> Grab kvm->lock before pinning memory when registering an encrypted
> region; sev_pin_memory() relies on kvm->lock being held to ensure
> correctness when checking and updating the number of pinned pages.
> 
> Add a lockdep assertion to help prevent future regressions.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: 1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")
> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> V2
>  - Fix up patch description
>  - Correct file paths svm.c -> sev.c
>  - Add unlock of kvm->lock on sev_pin_memory error
> 
> V1
>  - https://lore.kernel.org/kvm/20210126185431.1824530-1-pgonda@google.com/
> 
> Message-Id: <20210127161524.2832400-1-pgonda@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 2b506904be02..93c89f1ffc5d 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1830,6 +1830,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  	struct page **pages;
>  	unsigned long first, last;
> 
> +	lockdep_assert_held(&kvm->lock);
> +
>  	if (ulen == 0 || uaddr + ulen < uaddr)
>  		return NULL;
> 
> @@ -7086,12 +7088,21 @@ static int svm_register_enc_region(struct kvm *kvm,
>  	if (!region)
>  		return -ENOMEM;
> 
> +	mutex_lock(&kvm->lock);
>  	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>  	if (!region->pages) {
>  		ret = -ENOMEM;
> +		mutex_unlock(&kvm->lock);
>  		goto e_free;
>  	}
> 
> +	region->uaddr = range->addr;
> +	region->size = range->size;
> +
> +	mutex_lock(&kvm->lock);

This extra mutex_lock call doesn't appear in the upstream patch (committed 
as 19a23da5393), but does appear in the 5.4 and 4.19 backports.  Is it
needed here?

-Dov


> +	list_add_tail(&region->list, &sev->regions_list);
> +	mutex_unlock(&kvm->lock);
> +
>  	/*
>  	 * The guest may change the memory encryption attribute from C=0 -> C=1
>  	 * or vice versa for this memory range. Lets make sure caches are
> @@ -7100,13 +7111,6 @@ static int svm_register_enc_region(struct kvm *kvm,
>  	 */
>  	sev_clflush_pages(region->pages, region->npages);
> 
> -	region->uaddr = range->addr;
> -	region->size = range->size;
> -
> -	mutex_lock(&kvm->lock);
> -	list_add_tail(&region->list, &sev->regions_list);
> -	mutex_unlock(&kvm->lock);
> -
>  	return ret;
> 
>  e_free:
> 
