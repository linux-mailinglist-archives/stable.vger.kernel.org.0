Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E3A346257
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 16:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhCWPHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 11:07:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22210 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232372AbhCWPHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 11:07:41 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12NF2pwG045780;
        Tue, 23 Mar 2021 11:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1V+2bc1WkRfKPoSgjb5f7jfbIZu9JqpxVj/qHI1agnE=;
 b=b+CSjrEfQAf6k3BBv7kUifG+jlBvEJDDdxVxpMByVAgIupkO8DK83+WnF6iGQBN5kCMN
 GtQK0sjZQCnbfD3kB54d0sGpmUzzFqR0IAX0TMRHpNa1yfcCI8f/8Ew93JAxGfe+Y1EE
 rTYS6t+AINJnm5PnDZh6Jb2aNfcdYgO3SASQ2RVc624rc5pHrsh9GgOcowuA83y+SJEY
 jHlsj8SRpcJBQ9g3WwZvqF6WMXMdDmFlXf6nzGpqampMjNkb5VqxDM7YNHmcV2/X8cB1
 J2E53xrfs2e38tAWen3VFDzrXvjjdQoxZKfL/uagkinoskQus5RwZRywyoJoReWaIgXS tg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37fjewgm25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 11:07:41 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12NF31Z4046650;
        Tue, 23 Mar 2021 11:07:40 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37fjewgm08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 11:07:40 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12NF7cho014315;
        Tue, 23 Mar 2021 15:07:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 37d9a61tmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Mar 2021 15:07:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12NF7Y0e39518554
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 15:07:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B73DFA4060;
        Tue, 23 Mar 2021 15:07:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33DCBA405B;
        Tue, 23 Mar 2021 15:07:34 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.5.141])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Mar 2021 15:07:34 +0000 (GMT)
Subject: Re: [PATCH v2 2/2] s390/kvm: VSIE: fix MVPG handling for prefixing
 and MSO
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     frankja@linux.ibm.com, david@redhat.com, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210322140559.500716-1-imbrenda@linux.ibm.com>
 <20210322140559.500716-3-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <433933f5-1b6e-ea58-618d-3c844edc73a6@de.ibm.com>
Date:   Tue, 23 Mar 2021 16:07:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322140559.500716-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-23_06:2021-03-22,2021-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 phishscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103230112
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 22.03.21 15:05, Claudio Imbrenda wrote:
> Prefixing needs to be applied to the guest real address to translate it
> into a guest absolute address.
> 
> The value of MSO needs to be added to a guest-absolute address in order to
> obtain the host-virtual.
> 
> Fixes: 223ea46de9e79 ("s390/kvm: VSIE: correctly handle MVPG when in VSIE")
> Cc: stable@vger.kernel.org
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reported-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   arch/s390/kvm/vsie.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 48aab6290a77..ac86f11e46dc 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1002,7 +1002,7 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
>   static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   {
>   	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
> -	unsigned long pei_dest, pei_src, src, dest, mask;
> +	unsigned long pei_dest, pei_src, dest, src, mask, mso, prefix;
>   	u64 *pei_block = &vsie_page->scb_o->mcic;
>   	int edat, rc_dest, rc_src;
>   	union ctlreg0 cr0;
> @@ -1010,9 +1010,13 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>   	cr0.val = vcpu->arch.sie_block->gcr[0];
>   	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
>   	mask = _kvm_s390_logical_to_effective(&scb_s->gpsw, PAGE_MASK);
> +	mso = scb_s->mso & ~(1UL << 20);
			shouldnt that be ~((1UL << 20 ) -1)
