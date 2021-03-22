Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214703440B9
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhCVMTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:19:43 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229905AbhCVMTK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 08:19:10 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12MC4s8h114258;
        Mon, 22 Mar 2021 08:19:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AqHNz9M0siufI5CPHNCyB+wHvM2fdYlg0rR9v3o22x0=;
 b=GF8mvBZ/gUIyj7xX+O79zvJYmwWAO4WjHldn/dACeTw3XN59si7oH+NkWcq/2m6+DYMQ
 kEaiQq1kx1HbIJPWIRTSDLyfXcZrd210a8b3PjVDfU0amDrd+VtiadJIZdUfq8Vc8aBW
 9gcdQfrT3+uWxIj5fln+M7Jyt+Vqi//phk/oQ2Wwt+a0p355SykKfKwfRxyk0oWOVg7t
 XvTF/WDZ+YcE1B+AWGpY7G6JSC+lJwBQv1SjsK5/VUAnGk5fHzUsdwS6YTiduBup833m
 eyXg5uU/KzGLnZxXA00+t6D6/kclXoWcMEpSULXMvxEBPkYO40O/H8ZvbQUBo2GZ+H33 1A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37effkfjnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 08:19:07 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12MC5ZWS116853;
        Mon, 22 Mar 2021 08:19:06 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37effkfjmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 08:19:06 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12MC6hIV018959;
        Mon, 22 Mar 2021 12:19:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 37d9bmjaea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Mar 2021 12:19:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12MCIiPt34603492
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 12:18:44 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA0C2AE055;
        Mon, 22 Mar 2021 12:19:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5EB4BAE051;
        Mon, 22 Mar 2021 12:19:01 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.7.234])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Mar 2021 12:19:01 +0000 (GMT)
Subject: Re: [PATCH v1 1/2] s390/kvm: split kvm_s390_real_to_abs
To:     Heiko Carstens <hca@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-kernel@vger.kernel.org, frankja@linux.ibm.com,
        cohuck@redhat.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
References: <20210319193354.399587-1-imbrenda@linux.ibm.com>
 <20210319193354.399587-2-imbrenda@linux.ibm.com>
 <fa583ab0-36ac-47a7-7fa3-4ce88c518488@redhat.com>
 <f76f770c-908e-4f4f-f060-15f4d30652d8@redhat.com> <YFh7nGfVZRD15Cbp@osiris>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <43e5cf87-d811-3c0c-b605-f64baa9ae006@de.ibm.com>
Date:   Mon, 22 Mar 2021 13:19:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YFh7nGfVZRD15Cbp@osiris>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_07:2021-03-22,2021-03-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 adultscore=0 clxscore=1011
 suspectscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103220089
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 22.03.21 12:12, Heiko Carstens wrote:
> On Mon, Mar 22, 2021 at 10:53:46AM +0100, David Hildenbrand wrote:
>>>> diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
>>>> index daba10f76936..7c72a5e3449f 100644
>>>> --- a/arch/s390/kvm/gaccess.h
>>>> +++ b/arch/s390/kvm/gaccess.h
>>>> @@ -18,17 +18,14 @@
>>>>     /**
>>>>      * kvm_s390_real_to_abs - convert guest real address to guest absolute address
>>>> - * @vcpu - guest virtual cpu
>>>> + * @prefix - guest prefix
>>>>      * @gra - guest real address
>>>>      *
>>>>      * Returns the guest absolute address that corresponds to the passed guest real
>>>> - * address @gra of a virtual guest cpu by applying its prefix.
>>>> + * address @gra of by applying the given prefix.
>>>>      */
>>>> -static inline unsigned long kvm_s390_real_to_abs(struct kvm_vcpu *vcpu,
>>>> -						 unsigned long gra)
>>>> +static inline unsigned long _kvm_s390_real_to_abs(u32 prefix, unsigned long gra)
>>>
>>> <bikeshedding>
>>> Just a matter of taste, but maybe this could be named differently?
>>> kvm_s390_real2abs_prefix() ? kvm_s390_prefix_real_to_abs()?
>>> </bikeshedding>
>>
>> +1, I also dislike these "_.*" style functions here.
> 
> Yes, let's bikeshed then :)
> 
> Could you then please try to rename page_to* and everything that looks
> similar to page2* please? I'm wondering what the response will be..

Given that this is stable material (due to patch 2), can we try to minimize
the bikeshedding to everything that his touched by this patch?


Claudio, can you respin the series addressing the comments?
I will then either add this to next or fold that into the existing next patches.
Not sure yet.
