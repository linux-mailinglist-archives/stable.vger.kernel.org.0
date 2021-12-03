Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43271467B3A
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 17:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245589AbhLCQZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Dec 2021 11:25:36 -0500
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:24161
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245586AbhLCQZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Dec 2021 11:25:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhcIQqVAokr69DYbVxvN+nbMYuJseT6RCV8qPundJx7fdXGsT0gjVv2y5VMGImk+JVijRYJqJJzhe/IWS5gYWVFFC20lqCknp0hPkWH5gBXvzzn/h+T6pr/w5C1OqPhIqQX0Lbe1UWt4tmr76YarBAck9RJuYGc6kpl9+GsixBhuaBWoKzTBqrPxY4AQzg+rIQ2G9Q+H+1ZoXAbAtVbit9Juf1VRNPqT9C4UsKBolNq21524BcsYhCLxt2grwDqyVmEQZI1Xwn8jbDo/9lI2kUQIjzWNrpBEqcnDxlYmkVEiCPSfNOFC16IJy3o50FxwFvep0//mWhGmTl9fDJ85Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mm9mUurDvch6b6m2+CflosQu0E/RWnvGqO2fgPX58Ho=;
 b=BTp3TEZ6gbqolDLSn3fp+ut8z6TqU/ckh+nULPQYNNGyS4l+xDMXAat9Yob+vbqIDQTL8dlKsZvEMHIYqPcARgSA/kDYPkWNlE93fSj8OaQnJuHHfqtZkdXE1IskIL8SYLksWLxGPuD3EkVezx8Y6X2+SYoDCWFiqvhgLSLxcS3t1is3nYk5JMVCn+iFUi/Bobt4qzamgtSzh3WwUEpzmwrpZ11jmpDKxZRw/10A9Zm4quhqf4GgXO+41FmrMsRx8DTUjAS/nyPHaJ2vNT1n/lmUgE4r3ziEoMdRANZbiW52jW9immNaUcTX/+tEDXAY6L6jPafXMzu6gu15US1cpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mm9mUurDvch6b6m2+CflosQu0E/RWnvGqO2fgPX58Ho=;
 b=A921Jziii4fayFjBvbZHBOg/vu/7fDTtr+f/IZD4H9rgqZ63kFpffXtTVZfZMm7coLUY+1tVwbqPdr1GgkxTWbYz/UXltlcQLb3LxvaIcms/H+4dd/f8iKQW6Hwqk6wVo1EPvvILpKnhaeKAFGN/zJJwVBZgZji50cm3jGxdQOA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5230.namprd12.prod.outlook.com (2603:10b6:5:399::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 16:22:09 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.028; Fri, 3 Dec 2021
 16:22:08 +0000
Subject: Re: [PATCH v2] x86/sme: Explicitly map new EFI memmap table as
 encrypted
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>,
        linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
References: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
 <c997e8a2-b364-2a8e-d247-438e9d937a1e@amd.com>
 <CAMj1kXGH7aGR==o1L2dnA9U9L==gM0__10UGznnyZwkHrT84sw@mail.gmail.com>
 <YXmEo8iMNIn1esYC@zn.tnic>
 <CAMj1kXEZkw99MPssHWFRL_k0okeGF47VYL+o8p72hBWkqW927g@mail.gmail.com>
 <f939e968-149f-1caf-c1fb-5939eafae31c@amd.com>
 <15ceb556-0b56-2833-206e-0cf9b9d2cb45@amd.com>
 <CAMj1kXHKxObuebZJMWQQwg014rYzvoBgWPZxfCYakuf+GSoqhg@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6d6b4982-ce69-4fd4-1bb8-5c35b360a95f@amd.com>
Date:   Fri, 3 Dec 2021 10:22:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAMj1kXHKxObuebZJMWQQwg014rYzvoBgWPZxfCYakuf+GSoqhg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0047.namprd13.prod.outlook.com
 (2603:10b6:806:22::22) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA9PR13CA0047.namprd13.prod.outlook.com (2603:10b6:806:22::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.12 via Frontend Transport; Fri, 3 Dec 2021 16:22:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a9e29f6-dded-4ea7-3373-08d9b6790db7
X-MS-TrafficTypeDiagnostic: DM4PR12MB5230:
X-Microsoft-Antispam-PRVS: <DM4PR12MB523015C3788EB33460D5C500EC6A9@DM4PR12MB5230.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bwBeZG+459hNaMFaJ7ziO1njlv5AMEYQJVdB1teS/mt5vybeG6jVy0N+W8BB9ehRZtCBP7ucxqgDODN52FaAQJ/uQL7Nabx6yR3uzDfRUgQiD6KR1GW/Kttum7jKQexk4h2jooDGWwHMltcXmcHfiWQXypEmcSYkiTc+bq0ykbIfUo29aNa3JVZMaHdFS3KOTH8OrWbOMyV2lILIZCbH4tnjx6Mn53K/AR5DYYQf0iGtSt0qbxP0gMLsm1jgfubH2P40oXcvbx8LY53m6hd3FZvOD2aUDTWNnK9Mv+BZUBqiicWjwsjEpQhBShPsiDpgx0XnMbWxDnVgrRKigMY7ezP9cTejM9FGy/WifzJ2hTqZ/gtUEeC3DxYRbaFbrEyYsqKwJJ68pWOZ06EZTUyGwSDhDfEyIlqAZvLo1ZWKJgHoySWG7WVIM/DyjLzvRHB/WQ9UPmg2t3jhyg8qnKEe26kfY/7nJdCakz9U7aBvzVV+X+wrR32i5dxrjoAEUBdNzjYmxnjgHD8UC8b+mcJYVs1Td4z37mAF63ia1T9SKZVqGNPxNLbsd+EPBaaAw0uKEw3pgr7a4ec3eTNLpEtIehcxjN+OVQUe/+RxmgOuFLzrI2blopnnz2XomWBr14vGr0WIAApFqMrPzh/F8KRneotAAPDCGl6B/5w+aznF1hm6dUhZTGfbSg4bi8ICmWOntqBmsxM79d2sKS4xGWEO03uPkGvcqpYQ+ILjEk8yhU0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(83380400001)(38100700002)(186003)(53546011)(6512007)(8676002)(26005)(86362001)(316002)(31696002)(54906003)(6486002)(5660300002)(6916009)(66476007)(2616005)(8936002)(66946007)(2906002)(36756003)(6506007)(508600001)(31686004)(956004)(4326008)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGVoaUdmdmVUVUNNWFg3Sk5qdWZRRGNiWkZ3RWx0SlpVRmJkZUk0TnIwbjU5?=
 =?utf-8?B?MlJPMmYxaVh0c0dka3dMU1BnNGc5T0F0WXZRNG1hQnJHUTRSRDU3NXEvVnFO?=
 =?utf-8?B?YmRqMWtDWmhVK2lzajNad1FKNVk3ZStTb3NNWC90VUFqMVNuNU8zWlhhOUdm?=
 =?utf-8?B?QzROdjh1OU8xV0tUSVYrQ1E4UTVYQ1BtazRXcXYzaXliM2F2cGhVU3AvcVF1?=
 =?utf-8?B?MDNoSld6YWtvaW5hVUlVS2tOeEJYUWxTdk44UjIyZnduU3FOY2hJV21JZ3Ir?=
 =?utf-8?B?MWIyOTNCMFlIT1VxaFVCSUV2Y3N5LzRyRzNQRFBwamZFWllrbmd2ZFlHbXhV?=
 =?utf-8?B?L2JpbGdEMEo4UmVMNGswQ1dsQ3FVS1lTVXVKVTRNb2tpd0tUMDVrbHRDNkVU?=
 =?utf-8?B?TFBVeGM1QTN3ZGpwNCtkMzZFcGdqMGlnOXRwa05RbDJDcERKeENvWi9YK0Fl?=
 =?utf-8?B?a0d4TFFPVW4yK215NUFhSVlpRFp3dWRTREtLcFcyeHlVZTk0UWl0Z2JBTWx5?=
 =?utf-8?B?OHIxRHU0Y1Fpckc0MHY1SkxWMkR0RHloemFwZlh6MlNTOXd5RVlqNG14M1FV?=
 =?utf-8?B?NmVrWTk1RWo4WnRUQUwvajZoV2d4ck8rVzMyVy9kekJpNVJ3Z0JrM0NiT1Ez?=
 =?utf-8?B?SEc5TUVZdkkxRWhaT1FoNEJueTZpVzFQWTdrYmdzcFoxNFkrZkY1WkpZY3VW?=
 =?utf-8?B?enVKczd2QU42eEM5ZW1mcnVCZFBJR1lmSzczZkI4Vk5USzRIVGdnd2RCdVl5?=
 =?utf-8?B?NlZERnhkUTZQQWtnTHJ6NXJEcjZwbVpERjUzZ0JLWFB6VkRwKzgrUUFHTTlJ?=
 =?utf-8?B?Q2pnTVJMcjNYcG1OVEkxelFDcGtKdEhkUXIydzdNY0gyKzd5OUl3OE9VVHha?=
 =?utf-8?B?QndMWm5qQ2c2eXBScmhvQnplRy9HMURrejZmbGY4bUxZVGkvRHNNUUVINlNa?=
 =?utf-8?B?WTE0SnY2eVI2V2RXSmFVYWdiRVdCOHBUVzZ1cDIyUE1PMzJLcW0vemgwQ291?=
 =?utf-8?B?eElnRDlydHkzQm4yOU9RRERYMkdlMDAzUXBTMDBydzgyL3h1ekpHd1B2OTJa?=
 =?utf-8?B?WGlwcm1ya3JSU3hrSkR0ZDFYa2VqbVBpNmlZTEdYK0h0MUlsRlJlbnpMZ0pz?=
 =?utf-8?B?b0FSZGhGTnF1QjE4SW15eW4xNWFwL3JGWDZobTh0NTJaeERxUDQ4ZGdXR2lr?=
 =?utf-8?B?L25FVGNkdkpzWWI0eDRWeU9jcTVaejRWL2hqeWtNREROdFF2alFuYkJzZHJO?=
 =?utf-8?B?ZEg2MGU1dmhLY2lkTzlGUktIQm03bUFrT001c05wekwxYVRVQTdPemNOL0kr?=
 =?utf-8?B?bnNkMVFsN0RCb25qSElwRURoeUh0TjRTVjVnanUrMTMyNmJ1SXJWblo4YzRm?=
 =?utf-8?B?Q2Z6YVk3ditjVk1qSkhXTU1hRGRETS9HempCYlYwSzZmUmZzcyszL0FHRkRa?=
 =?utf-8?B?WENpOVN6SGRxM293QzdSbFZrREZHVEk4cVFLVTV2YzNqaDJodXdyY1RBYTl5?=
 =?utf-8?B?RXJMUnZKdEtFcWdYbHZ4RDllNjBNcm1iL3A0OW9VaFRERDROL3duQ2xEY1hh?=
 =?utf-8?B?eGR0aGl3bE4xZFpZMzZySzlRUlZ4K2hlRElSUWdiMkxOeVFsUVB0NkJ2QUls?=
 =?utf-8?B?K2tvOU9YN1RVMld6T1QwMU5yRzZncEcyZDRyRUJ4bXdQaUdjYW1mbmxnalZp?=
 =?utf-8?B?WnZYTU5Na1NrVmNEZVAyOHZnNkxNR0FhbEFVMHQzQVc3TzVkdGd1UDFCV0Yy?=
 =?utf-8?B?TkVHa3NpaUw5NFB3QmIrdjh5R0lXL1JWYS9JektEaXVSbllNZUk3MjVLWFFq?=
 =?utf-8?B?NHdlZmFVc0hQanAxTmE4LzFnWVdveHJUbytFMjRaSHZ6enFGc2FyZXc0S2tI?=
 =?utf-8?B?cUJQS2JNSkV4bDVaY0FERWRhUnJ6SVhrNzZVcEJwR1YvOWdkZjJveStBVVNS?=
 =?utf-8?B?YnFqSHNjTWN5MnF2QzVkU05uSjFZS011V3NPZnpDTzhqVm1YRFZ5RStleENx?=
 =?utf-8?B?cHFsT2xlZEpJZEx6UCs4eEljQTNZVldnT0JzU2JwYVFCSTBqVzFwMkpCNnJB?=
 =?utf-8?B?L1AyUTNVdlI1THlGTDdPL1dybm9rMjFRSFRrbDVlekFaY2EvSldhekU5VWdX?=
 =?utf-8?B?eUNSYXR1MTFYVU9zWEp3MTljd0ZUaUI2NDZFS0NzRTZRYjdraUdDQTdWbSth?=
 =?utf-8?Q?MUMlNJxzmvOMjRl3Ja5E5ms=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9e29f6-dded-4ea7-3373-08d9b6790db7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2021 16:22:08.8756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P+4j1NPs86mwzLoxeO1dl1lWGjow2M5aXEz9MTmWOsv+YhdisXqmnBGTlQ6eLYUGUxVRraJRIjpIVC+8Xxt8sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5230
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/3/21 4:30 AM, Ard Biesheuvel wrote:
> On Wed, 1 Dec 2021 at 15:06, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 10/27/21 12:04 PM, Tom Lendacky wrote:
>>>
>>>
>>> On 10/27/21 11:59 AM, Ard Biesheuvel wrote:
>>>> On Wed, 27 Oct 2021 at 18:56, Borislav Petkov <bp@alien8.de> wrote:
>>>>>
>>>>> On Wed, Oct 27, 2021 at 05:14:35PM +0200, Ard Biesheuvel wrote:
>>>>>> I could take it, but since it will ultimately go through -tip anyway,
>>>>>> perhaps better if they just take it directly? (This will change after
>>>>>> the next -rc1 though)
>>>>>>
>>>>>> Boris?
>>>>>
>>>>> Yeah, I'm being told this is not urgent enough to rush in now so you
>>>>> could queue it into your fixes branch for 5.16 once -rc1 is out and send
>>>>> it to Linus then. The stable tag is just so it gets backported to the
>>>>> respective trees.
>>>>>
>>>>> But if you prefer I should take it, then I can queue it after -rc1.
>>>>> It'll boil down to the same thing though.
>>>>>
>>>>
>>>> No, in that case, I can take it myself.
>>>>
>>>> Tom, does that work for you?
>>>
>>> Yup, that works for me. Thanks guys!
>>
>> I don't see this in any tree yet, so just a gentle reminder in case it
>> dropped off the radar.
>>
> 
> Apologies for the delay, I've pushed this out to -next now.
> 
> Before I send it to Linus, can you please confirm (for my peace of
> mind) how this only affects systems that have memory encryption
> available and enabled in the first place?

Certainly.

An early_memremap() call uses the FIXMAP_PAGE_NORMAL protection value for 
performing the mapping. Prior to performing the actual mapping though, a 
call to early_memremap_pgprot_adjust() is made to possibly alter the 
protection value, but only if memory encryption is active.

Changing the call to early_memremap_prot() and providing 
pgprot_encrypted(FIXMAP_PAGE_NORMAL) as the protection value results in an 
equivalent call to early_memremap() when memory encryption is not active. 
This is because the pgprot_encrypted() is, in effect, a NOP when memory 
encryption is not active.

So when memory encryption is not available or active, the result of an 
early_memremap_prot() call with a protection value of 
pgprot_encrypted(FIXMAP_PAGE_NORMAL) is equivalent to an early_memremap() 
call.

Let me know if that answers your question.

Thanks,
Tom

> 
