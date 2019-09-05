Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23562AA940
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 18:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbfIEQnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 12:43:49 -0400
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:51694 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728601AbfIEQnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 12:43:49 -0400
Received: from pps.filterd (m0150242.ppops.net [127.0.0.1])
        by mx0a-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x85GfYb0031577;
        Thu, 5 Sep 2019 16:43:30 GMT
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com [15.241.140.75])
        by mx0a-002e3701.pphosted.com with ESMTP id 2uttq6nmyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Sep 2019 16:43:29 +0000
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g4t3426.houston.hpe.com (Postfix) with ESMTP id E0E4B59;
        Thu,  5 Sep 2019 16:43:28 +0000 (UTC)
Received: from [16.116.163.9] (unknown [16.116.163.9])
        by g9t2301.houston.hpecorp.net (Postfix) with ESMTP id 9727A4C;
        Thu,  5 Sep 2019 16:43:27 +0000 (UTC)
Subject: Re: [PATCH 6/8] x86/platform/uv: Decode UVsystab Info
From:   Mike Travis <mike.travis@hpe.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Christoph Hellwig <hch@infradead.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190905130252.590161292@stormcage.eag.rdlabs.hpecorp.net>
 <20190905130253.325911213@stormcage.eag.rdlabs.hpecorp.net>
 <20190905141634.GA25790@kroah.com>
 <ae007007-02cc-0081-22c0-34b2d67f2cd3@hpe.com>
Message-ID: <d0675e8f-80a2-bba4-888c-90feda085a14@hpe.com>
Date:   Thu, 5 Sep 2019 09:43:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ae007007-02cc-0081-22c0-34b2d67f2cd3@hpe.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-05_05:2019-09-04,2019-09-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=912 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1906280000
 definitions=main-1909050159
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/5/2019 7:47 AM, Mike Travis wrote:
> Also, nit:
> 
>> --- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c
>> +++ linux/arch/x86/kernel/apic/x2apic_uv_x.c
>> @@ -1303,7 +1303,8 @@ static int __init decode_uv_systab(void)
>>       struct uv_systab *st;
>>       int i;
>> -    if (uv_hub_info->hub_revision < UV4_HUB_REVISION_BASE)
>> +    /* Select only UV4 (hubbed or hubless) and higher */
>> +    if (is_uv_hubbed(-2) < uv(4) && is_uv_hubless(-2) < uv(4))
>>           return 0;    /* No extended UVsystab required */
>>       st = uv_systab;
>> @@ -1554,8 +1555,19 @@ static __init int uv_system_init_hubless
>>       /* Init kernel/BIOS interface */
>>       rc = uv_bios_init();
>> +    if (rc < 0) {
>> +        pr_err("UV: BIOS init error:%d\n", rc);
> 
> Why isn't that function printing an error?
> 
> 
>> +        return rc;
>> +    }
>> +
>> +    /* Process UVsystab */
>> +    rc = decode_uv_systab();
>> +    if (rc < 0) {
>> +        pr_err("UV: UVsystab decode error:%d\n", rc);
> 
> Same here, have the function itself print the error, makes this type of
> stuff much cleaner.

Turns out both functions already print an error message for each 
instance of an error.  The only redundancy is the caller also printing 
an error with just the numeric error code.  Shall I remove that?
