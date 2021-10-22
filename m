Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E153437AD6
	for <lists+stable@lfdr.de>; Fri, 22 Oct 2021 18:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhJVQYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Oct 2021 12:24:16 -0400
Received: from mail-bn8nam11on2069.outbound.protection.outlook.com ([40.107.236.69]:25312
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231651AbhJVQYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Oct 2021 12:24:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3UTGEK/M0M1QFJiu760PH+c10LP96eogNnKYgmm19Bl1hnl98rRME+XR3pLeamDN/d1ZMDSpwcevagJoWJLdwuO+9wFZ/03IMnnHVpItUJJfI2sED0WdjEJxsjJQ0VZ8S/4j5RTecZlQJyz1jOitDDXh5yI/uwh8mLkJESOwWwgtm6G4uSMeAnNGCxmbc1Mel8sY6MXM/f9usgNArASIuHb6EvWtb5LPkbz8JOo1nWAsYKt65MB5fq18MQn3I26ln4QMSRcZxdMvszhjLvmVi+lMZ2K+FPDdVfQXW2Pa+wRpTCnKsK/mePgFSVKhrVPTJ9ZOJdCmu76vkdGjC3AOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gosr6vJKOAZGAk2vmKeAZEjcmKnPSK+0CKdsBdbwX1o=;
 b=dQy7C6PGTAxyJZQLcGnXX+tNNvl99vCuKBgp5Otm0YHvTT7ixfVmYJMgGlnLxNJI4OPOlViFw/r8MWmJwbgwQOH6mkh06XuUtac78VIbiU6IcI9FAVkCsxXhYAjyD97ACDp6fI4oOlKrHc7QXQJiEWIwfFxF7SOEpW/6BPb3e6osOz91Rajv3AK1bWR/xaSRdvjhckuuek5OIp1aTfGjF1AdvdvMWXb2OC4srjM16ajBQnCXFBMBQ3WSDgQij7Q0rVd4qx/is+fmPEC6DF2YW5+k3AXRlYSKxDTyu4kO4hyQ0gi7xjlmwT4gxXdHLLDfundrghmOzJeoK4+AQ7klFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gosr6vJKOAZGAk2vmKeAZEjcmKnPSK+0CKdsBdbwX1o=;
 b=OZYh6U+5ZswbUYjya18jekZmxc10I1vCuI/se6whzNb0XZCIu+Pyuq9RlLmQSnwLw1GcxlekZhe9MLkKtzIQrnZsbqDur2C0ZTlcpHpoeUJJxSO1Lz18g/jbMY6qeUdP89tjc4q1rHQbK9+vE5CgkmAOTU+ZWD76CRBJePtjOGA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (13.101.60.140) by
 DM4PR12MB5199.namprd12.prod.outlook.com (13.101.60.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Fri, 22 Oct 2021 16:21:55 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4628.016; Fri, 22 Oct 2021
 16:21:55 +0000
Subject: Re: [PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        "# 3.4.x" <stable@vger.kernel.org>
References: <ebf1eb2940405438a09d51d121ec0d02c8755558.1634752931.git.thomas.lendacky@amd.com>
 <9d9ca009-93c5-acc3-7445-d514c7878478@amd.com>
 <CAMj1kXEDPwORj=oeQJ66FVD6WMjpxWiXX1Y317izHzRH1c1ncw@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <0e45ccc7-2ddb-2297-c872-ee5046cecd5b@amd.com>
Date:   Fri, 22 Oct 2021 11:21:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CAMj1kXEDPwORj=oeQJ66FVD6WMjpxWiXX1Y317izHzRH1c1ncw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0186.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::11) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SA0PR11CA0186.namprd11.prod.outlook.com (2603:10b6:806:1bc::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 16:21:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f07f2875-8b30-4de1-9dc6-08d995781049
X-MS-TrafficTypeDiagnostic: DM4PR12MB5199:
X-Microsoft-Antispam-PRVS: <DM4PR12MB519922D4DDA715ACCA70F4A5EC809@DM4PR12MB5199.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WsTyDtmOVWY5GJTMJ0KixZBOoXenJH6LsnJ3Uz2LWJ9wq1n5r+wy2zXAZsGu8B6M9pt8OY4i9bLkr+YxTJ7XgdrrqKPf8AazJppstraxH/vKqiNwAKkBoesYB6eohXKWOuQVid/nUM5tYMX1RA1wk3QZS4y6GZO9hdL3F4gvQrEzuLRrdzdk1edN6M8pYGtJ3JRsyFxEmtPd8UfMIpNITW0SLuf9+kyydfZqXTdtmiQ312uaT+oNIIpSMH/1KQLzqdHjwe1yx72qXsEkFHADaQm1NEeg5UIfimS0QqBMNjX/pufRaFJ9uPjMBMGuOMqgncUxMxcDI7xMRVINLjFMhbFOLtTigCCXjygcI8m2T/3N5mG0pQt9fl7fgkDRpbTb2PVBQALofIs4f7+gfvOtcQn5+lT1IgOjyGv4cIULdwhu5QdRFYNU5aNRYv2tScWQdUyghJK8XlA9pvWxRJAaLgbnG9lStWTmQYD0iI+Mg5zyO5irTnnJWMfBl2z/o9ERPe1g8JsCw0YJqr4q96ILi9oR775ClTH6zC56HwJmfw9JtLiMLt2COIAFtGbEPSG0Q82tIFOvFdSYeq57FTQJoqOzLq0ghkbFbk2Z6kOhYTm8ja26AFZDs11P10835MVzEW/+oe4HOV/3WWihvn1P6ik7X8zuYAnUBqtP/mbj7LV5z/ZRLEJuuOnwXisWu0pHpefnxGqe3VPXEAJ10/RzHoBAJiOJftjG3S3avqErW7pZwWtCuzdl5jMGNTR4A53/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(53546011)(508600001)(66946007)(66476007)(66556008)(38100700002)(8936002)(4326008)(6512007)(2616005)(956004)(54906003)(6486002)(186003)(26005)(86362001)(5660300002)(2906002)(316002)(7416002)(31686004)(83380400001)(36756003)(8676002)(6916009)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFJkYjVJK1RWd1FTVy9YZ2R5LzVITkdNdFRIM3BmSitxQXhlWHh6S1V5RGRK?=
 =?utf-8?B?TjIxUHA3N25JaTVsckpYOWMxeFduM1NqQTQ2TUNDOTN6WnhZTWpkOXFxdHhi?=
 =?utf-8?B?Wmpnazl3dlZuMXRsM0doRzE2WEJJM0xGR1JCdWpPYkVxRmZSWFZ4cG1EUkNq?=
 =?utf-8?B?Zk5Eb0lLakhsRzZVemdwWlp5eTZVdFJrOW5zUzFBek5rcWk3RGdRQjBBMC9Z?=
 =?utf-8?B?Sk1MSko4U0ZtcFlOeWxwQ3BiTHJTMGkwc2Z2VmlXM3lLNDF6MjRrb0kxMVE2?=
 =?utf-8?B?NDRMdTBVeUpjY1REM2pQN3REa2VJM2lLRVFSWlVTZ1YyYS85ZTcrYXJXTVA0?=
 =?utf-8?B?dnlNVi9sMGJ5U1c0cGx1dnlZcysvYWZPNUYvWlRGVlNtR1B2RnNSUk9FZGdx?=
 =?utf-8?B?QW1nZ0RPZDNxR2hpZVdrTHRjVEpnMk9YT0FTeG94STNqeEYyUWtXRlhuWnRF?=
 =?utf-8?B?cGlzN1NEbUFVNklmZWFQV3drOVFtYi9jeXFrdFFqTE1iZXhnNWQzRjNJaDVz?=
 =?utf-8?B?cVA3TFgzOHpYV3MyVFFZTExobEs2K2lKUEhSQTU1TmV5T20rMzZqVHlwOC8v?=
 =?utf-8?B?M1MzM0M1WXdMb2hDWXc3bkxEM1ZYTmM0M00yckZINm1GbUxqeGNPNFptYUVT?=
 =?utf-8?B?VlV0bTBneEFycVBUUXBHTVJoZ004L25MR1FxSmJZLzFWcVl4UEdjdk9Qa3Jk?=
 =?utf-8?B?elhRTGtJa056VmdjaStCQWp2bUNWWitneVBZdjVTY0t2MU1mMkRFWFR3WFYy?=
 =?utf-8?B?R0hYV1lwKzN2WWd2cjZsQ0lxcmRWTXRUTUtUcENUZjNYVlhtVjRrdHJwengv?=
 =?utf-8?B?OFZOTWY3RGFQQXQ5a0o0UUNCVklrMDRKbEpCS2dGZU5DaUs5Sno1bTRhazl6?=
 =?utf-8?B?N0VVYUNPdlZpOVpvY0xLODhkVEdRR1ZSaGNIUitBOXlDRnVIRkorbVZxalBs?=
 =?utf-8?B?d3Q5MWEraUhaU3o0SmVxc3V2M0w0N3J0OVF5enhsWkRjNkpUZlA5SjlJZmxB?=
 =?utf-8?B?NFZsSnA2M2puU0tuaVVIV3UxQTJ6aVZFSnlBUVQ3MGw4U2pEdm9ScENWY3h2?=
 =?utf-8?B?R1VOM1o3VEZsTlRRMEtHMHBnOGE5TGhWdFZ0aWs3WEJmWVhXd2tNSXZCam1T?=
 =?utf-8?B?TStTNkdvcFkrUCtCbXdtdVIxT25ONkFRSE9Ic0xOYTI3Y0NNbHR1WXpvaTZ2?=
 =?utf-8?B?dWp5MkhkQytMRHFXNnNzL0FxWk5tZkYveVBhQjh1b2wwTnkvY2NRM3NCbDFq?=
 =?utf-8?B?T2VWb1M5S2NUd0ZaTkc0RnUweTRwQTlzMldLdUNieU1Ub2g0UVplNFcrZ2FQ?=
 =?utf-8?B?YmJsU3NjL3Z5T20yTzVSaDl1UHdoUklpck1OUWd3Z3R5cDhFV2hCZnk3cDZY?=
 =?utf-8?B?QnhkQkwvOFV0Mm1XK1dGd1c5Z090L1R1K3o4Zm1wRDFxRWtWQnZicmh2T1Z3?=
 =?utf-8?B?VDNWUC9NLzFpYVpWclJYTjY0VlVscGROVEQ4dmpkdER1bTV1OWZvYXc4TC9q?=
 =?utf-8?B?bW5PdWptYmNBMVRuamVlcEk5ajZLR243WDltMWpLNFVlZ0x1UjRNUXcrVkN2?=
 =?utf-8?B?NDlzK0pxbkN4WTNHejk3TEVKNkJqQTFCNUlEbUErTUtPYmY5aStaSVpFSHZa?=
 =?utf-8?B?eFRBYVMvSEFsU0NXcmh2MlFFaGp6WHpLWkZqQUdyNThwVVFqTnNDOStaUy95?=
 =?utf-8?B?dy9kMThNL0hlTk5ibEhrYkUwY0RFNFNkdDF4cWZUeWhkMWFMRUZLUlNjQzVq?=
 =?utf-8?B?aW1wajdtalJ3RWUyMjU3bEFzMG04aDM5V3k2QW1nTUNUdk95ZDJsL0hlZWJ5?=
 =?utf-8?B?VTBFQmlYK3pOaFByWm94QktxcGlWOHh6bXYyUzNsNUZZOE8yZ3c3bDJ5WlIv?=
 =?utf-8?B?K0hreHppRUxNS0pUWG5LdDdtNU9BUStZck1HQmtpcFRBNHhjczV0TW85OFND?=
 =?utf-8?Q?rRVPzN+tF4o=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f07f2875-8b30-4de1-9dc6-08d995781049
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 16:21:55.3331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5199
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/22/21 9:48 AM, Ard Biesheuvel wrote:
> On Thu, 21 Oct 2021 at 15:21, Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 10/20/21 1:02 PM, Tom Lendacky wrote:
>>> Reserving memory using efi_mem_reserve() calls into the x86
>>> efi_arch_mem_reserve() function. This function will insert a new EFI
>>> memory descriptor into the EFI memory map representing the area of
>>> memory to be reserved and marking it as EFI runtime memory. As part
>>> of adding this new entry, a new EFI memory map is allocated and mapped.
>>> The mapping is where a problem can occur. This new memory map is mapped
>>> using early_memremap() and generally mapped encrypted, unless the new
>>> memory for the mapping happens to come from an area of memory that is
>>> marked as EFI_BOOT_SERVICES_DATA memory.
> 
> This bit already sounds dodgy to me. At runtime, anything provided by
> the firmware that needs to be mapped unencrypted should be
> identifiable as such, regardless of the memory type. So why is there a
> special case for BS data?

Much of the EFI data is identifiable, but some is not. By default, an 
early_memremap() will map memory encrypted when SME is active. The 
early_memremap_pgprot_adjust() function in the early_memremap() path is 
used to alter this mapping. This function does a lot of checks to 
determine if the memory being mapped is setup data or EFI data. There is 
some EFI related data being mapped where the physical address didn't match 
the original EFI memory map address or EFI system table address or other 
EFI tables addresses. So checking whether the memory is part of 
EFI_BOOT_SERVICES_DATA or EFI_RUNTIME_SERVICES_DATA provided the missing 
piece so that it was mapped properly.

IIRC, one of the areas where this occurred was when mapping the BGRT image 
pointed to from the BGRT table.

> 
>>> In this case, the new memory will
>>> be mapped unencrypted. However, during replacement of the old memory map,
>>> efi_mem_type() is disabled, so the new memory map will now be long-term
>>> mapped encrypted (in efi.memmap), resulting in the map containing invalid
>>> data and causing the kernel boot to crash.
>>>
>>> Since it is known that the area will be mapped encrypted going forward,
>>> explicitly map the new memory map as encrypted using early_memremap_prot().
>>>
>>> Cc: <stable@vger.kernel.org> # 4.14.x
>>> Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> ---
>>>    arch/x86/platform/efi/quirks.c | 3 ++-
>>>    1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
>>> index b15ebfe40a73..b0b848d6933a 100644
>>> --- a/arch/x86/platform/efi/quirks.c
>>> +++ b/arch/x86/platform/efi/quirks.c
>>> @@ -277,7 +277,8 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>>>                return;
>>>        }
>>>
>>> -     new = early_memremap(data.phys_map, data.size);
>>> +     new = early_memremap_prot(data.phys_map, data.size,
>>> +                               pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
>>
>> I should really have a comment above this as to why this version of the
>> early_memremap is being used.
>>
>> Let me add that (and maybe work on the commit message a bit) and submit a
>> v2. But I'll hold off for a bit in case any discussion comes about.
>>
> 
> For the [backported] change itself (with the comment added)
> 
> Acked-by: Ard Biesheuvel <ardb@kernel.org>

Thanks, Ard. I'll send out the v2 shortly.

> 
> but I'd still like to understand if we can improve the situation with BS data.

I'll try to take a deeper look and see if anything can be done as a future 
enhancement.

Thanks,
Tom

> 
