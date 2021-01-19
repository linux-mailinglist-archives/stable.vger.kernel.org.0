Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEEA2FBAAE
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 16:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbhASPCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 10:02:36 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33306 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391650AbhASOY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 09:24:27 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JE4u3W074421;
        Tue, 19 Jan 2021 09:23:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=acKRW+tf9H/mRn52iGKx2xvbEITiHOcevd/OtuDxIVA=;
 b=TpcF0C4DT0xvS7joh9qt/LCNupPXcdlz7pE5hPAYKvC//+nT2odaVL6jh9MW527LZmoY
 6cTa4UsoH45o/JsnVUvROyJiajOKVTYm07C28tYZ7EbA1G97+55lxc58gDX2AI3Er5FI
 vOApszdPLRl9OzKbs9othfl/XsBQo4iz7dDejvZxNYy5XQhxF3dSff01SvyZhX8KtIKK
 5y0cMTjs+zkgxkHcYYakO1n15iWGytnE87zC4VrQyJIieLNQH6BavzPqVBzkxupkiJfx
 1mLGPmKLO+SYrb0Sk6AT4W4WiBntwbi75h2kjXNwS8raoT8g5PLSUwXC2TELqo03nKVB IQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3660j3hdnb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 09:23:41 -0500
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JE5Nps076949;
        Tue, 19 Jan 2021 09:23:41 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3660j3hdmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 09:23:41 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JENddC002935;
        Tue, 19 Jan 2021 14:23:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 363qdh9mtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:23:39 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JENaQb18612722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 14:23:36 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39C1B52051;
        Tue, 19 Jan 2021 14:23:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.160.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B24565204F;
        Tue, 19 Jan 2021 14:23:35 +0000 (GMT)
Subject: Re: [PATCH v1 1/4] s390/kvm: VSIE: stop leaking host addresses
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
 <20201218141811.310267-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <4265bc48-40f9-54be-8a87-bcd50c7c628a@linux.ibm.com>
Date:   Tue, 19 Jan 2021 15:23:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201218141811.310267-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_04:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 clxscore=1011 mlxscore=0 spamscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190081
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/18/20 3:18 PM, Claudio Imbrenda wrote:
> The addresses in the SIE control block of the host should not be
> forwarded to the guest. They are only meaningful to the host, and
> moreover it would be a clear security issue.
> 
> Subsequent patches will actually put the right values in the guest SIE
> control block.
> 
> Fixes: a3508fbe9dc6d ("KVM: s390: vsie: initial support for nested virtualization")
> Cc: stable@vger.kernel.org
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Looks reasonable.
Give me some time to have a deeper look it's a lot of architecture to read.

> ---
>  arch/s390/kvm/vsie.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index 4f3cbf6003a9..ada49583e530 100644
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
> 

