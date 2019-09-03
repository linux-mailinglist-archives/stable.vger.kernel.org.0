Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C3AA6AE2
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 16:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbfICOMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 10:12:31 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:29666 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728679AbfICOMb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 10:12:31 -0400
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x83AwDuw025168;
        Tue, 3 Sep 2019 14:12:00 GMT
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com [15.241.140.78])
        by mx0b-002e3701.pphosted.com with ESMTP id 2us2qw1dk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Sep 2019 14:12:00 +0000
Received: from g4t3433.houston.hpecorp.net (g4t3433.houston.hpecorp.net [16.208.49.245])
        by g4t3425.houston.hpe.com (Postfix) with ESMTP id 664528D;
        Tue,  3 Sep 2019 14:12:00 +0000 (UTC)
Received: from [16.116.163.9] (unknown [16.116.163.9])
        by g4t3433.houston.hpecorp.net (Postfix) with ESMTP id 6552846;
        Tue,  3 Sep 2019 14:11:58 +0000 (UTC)
Subject: Re: [PATCH 2/8] x86/platform/uv: Return UV Hubless System Type
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903001815.893030884@stormcage.eag.rdlabs.hpecorp.net>
 <20190903064914.GA9914@infradead.org>
From:   Mike Travis <mike.travis@hpe.com>
Message-ID: <0eee6d96-e4fc-763b-a8b9-52c85ddd5531@hpe.com>
Date:   Tue, 3 Sep 2019 07:12:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903064914.GA9914@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-02_04:2019-08-29,2019-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 spamscore=0 impostorscore=0 mlxlogscore=680 adultscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909020138
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/2/2019 11:49 PM, Christoph Hellwig wrote:
>>   static inline bool is_early_uv_system(void)
>>   {
>>   	return !((efi.uv_systab == EFI_INVALID_TABLE_ADDR) || !efi.uv_systab);
> 
> No need for the inner braces here.
> 
> But woudn't this be nicer as:
> 
> 	return efi.uv_systab != EFI_INVALID_TABLE_ADDR && efi.uv_systab;
> 
> anyway?

Yes, good catch.  It somehow evolved to this but your suggestion is
much more clear.
> 
>> +#define is_uv_hubless _is_uv_hubless
> 
> Why the weird macro indirection?
> 
>> -static inline int is_uv_hubless(void)	{ return 0; }
>> +static inline int _is_uv_hubless(int uv) { return 0; }
>> +#define is_uv_hubless _is_uv_hubless
> 
> And here again.
> 

Sorry, I should have explained this better.  The problem arises because
we have a number of UV specific kernel modules that support multiple
distributions.  And with back porting to earlier distros we cannot
rely on the KERNEL_VERSION macro to define whether the source is being
built for an earlier kernel.  So this allows an ifdef on the function
name to discover if the kernel is before or after these changes.

The primary motivation is to avoid referencing the hub structures
when there aren't any, thus avoiding any NULL dereferences.  (Similar
to patch 8/8.)
