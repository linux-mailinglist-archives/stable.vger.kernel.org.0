Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8B2EC8B61
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 16:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfJBOhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 10:37:11 -0400
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:33430 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726951AbfJBOhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 10:37:10 -0400
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x92EQN8M016140;
        Wed, 2 Oct 2019 14:36:14 GMT
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com [15.241.140.73])
        by mx0b-002e3701.pphosted.com with ESMTP id 2vck9maha3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Oct 2019 14:36:14 +0000
Received: from g4t3433.houston.hpecorp.net (g4t3433.houston.hpecorp.net [16.208.49.245])
        by g4t3427.houston.hpe.com (Postfix) with ESMTP id AC04A57;
        Wed,  2 Oct 2019 14:35:53 +0000 (UTC)
Received: from [16.116.130.10] (unknown [16.116.130.10])
        by g4t3433.houston.hpecorp.net (Postfix) with ESMTP id E92F445;
        Wed,  2 Oct 2019 14:35:49 +0000 (UTC)
Subject: Re: [PATCH AUTOSEL 5.3 169/203] x86/platform/uv: Fix kmalloc() NULL
 check routine
To:     David Laight <David.Laight@ACULAB.COM>,
        'Sasha Levin' <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Austin Kim <austindh.kim@gmail.com>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russ Anderson <russ.anderson@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andy@infradead.org" <andy@infradead.org>,
        "armijn@tjaldur.nl" <armijn@tjaldur.nl>,
        "bp@alien8.de" <bp@alien8.de>,
        "dvhart@infradead.org" <dvhart@infradead.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "kjlu@umn.edu" <kjlu@umn.edu>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
 <20190922184350.30563-169-sashal@kernel.org>
 <20190922202544.GA2719513@kroah.com> <20191001160601.GX8171@sasha-vm>
 <ea163ee8ba4446978732c2c6607bd6da@AcuMS.aculab.com>
From:   Mike Travis <mike.travis@hpe.com>
Message-ID: <c3ecfbb0-b1d2-9af9-97e9-408a45b696d4@hpe.com>
Date:   Wed, 2 Oct 2019 07:35:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ea163ee8ba4446978732c2c6607bd6da@AcuMS.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-02_06:2019-10-01,2019-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1031 priorityscore=1501 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910020137
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 10/2/2019 1:34 AM, David Laight wrote:
> From: Sasha Levin
>> Sent: 01 October 2019 17:06
>> Subject: Re: [PATCH AUTOSEL 5.3 169/203] x86/platform/uv: Fix kmalloc() NULL check routine
>>
>> On Sun, Sep 22, 2019 at 10:25:44PM +0200, Greg KH wrote:
>>> On Sun, Sep 22, 2019 at 02:43:15PM -0400, Sasha Levin wrote:
>>>> From: Austin Kim <austindh.kim@gmail.com>
>>>>
>>>> [ Upstream commit 864b23f0169d5bff677e8443a7a90dfd6b090afc ]
>>>>
>>>> The result of kmalloc() should have been checked ahead of below statement:
>>>>
>>>> 	pqp = (struct bau_pq_entry *)vp;
>>>>
>>>> Move BUG_ON(!vp) before above statement.
>>>>
>>>> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> ...
>>>> ---
>>>>   arch/x86/platform/uv/tlb_uv.c | 4 ++--
>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
>>>> index 20c389a91b803..5f0a96bf27a1f 100644
>>>> --- a/arch/x86/platform/uv/tlb_uv.c
>>>> +++ b/arch/x86/platform/uv/tlb_uv.c
>>>> @@ -1804,9 +1804,9 @@ static void pq_init(int node, int pnode)
>>>>
>>>>   	plsize = (DEST_Q_SIZE + 1) * sizeof(struct bau_pq_entry);
>>>>   	vp = kmalloc_node(plsize, GFP_KERNEL, node);
>>>> -	pqp = (struct bau_pq_entry *)vp;
>>>> -	BUG_ON(!pqp);
>>>> +	BUG_ON(!vp);
>>>>
>>>> +	pqp = (struct bau_pq_entry *)vp;
>>>>   	cp = (char *)pqp + 31;
>>>>   	pqp = (struct bau_pq_entry *)(((unsigned long)cp >> 5) << 5);
>>>>
>>>
>>> How did this even get merged in the first place?  I thought a number of
>>> us complained about it.
>>>
>>> This isn't any change in code, and the original is just fine, the author
>>> didn't realize how C works :(
> 
> Mind you, the code itself if pretty horrid.
> Looks like it is aligning to 32 bytes, easier done by:
> 	pqp = (void *)((unsigned long)vp + 31 & ~31);
> (and there's a roundup macro to obfuscate it somewhere.)
> But I'd also expect to see a matching '+ 31' in the size passed to kmalloc().
> Not to mention a comment!
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

Thanks, I will put all of these comments in my notes.  This whole 
function is slated to move to a specialized UV APIC driver since it uses 
a unique scaling feature available in the UV hardware.  (The original 
author has long retired.)

-Mike
