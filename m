Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5726DC3F6
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 09:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjDJHj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 03:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjDJHjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 03:39:48 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2066.outbound.protection.outlook.com [40.107.212.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A5849CB;
        Mon, 10 Apr 2023 00:39:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MskY+qpQN9W1tM/wJFekqKGegW95TGQW6IJ8mTUu7cpdhUMrAzYWeIrkiOXwDJjNOrDR86JN79ZnP/Kn1f57Re4JnAFzvNg2VYMb+YKUBtm99NJPd5mDYIVg3Y1TU22oJn5977w3bgaoAASqIplPwQWKUS+pEaRz+qHXm3eXoRX1wW909psK5AJ6FsDpElhxU+0gg/dxRmc+CjwACKEWJiho1Vp5L8v5wziH7aX92f3ZNadtMbXqgs0xkyRXROAZumxMJAyz4Ttg+Yl0q4cJdRz+f0VolcdFMbyyWW1bJw1kqk53dajZdrJt3es3o2ID0Dp1GPcUhSmFgHeoM7Uo5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1RKLDAsILyNOePiaDmgk1567/CO810rMQ/ab0/oJg8E=;
 b=nDnnnagKcs9CfxrXXUaWq86CpaKE3Zr+IOAVX8VWae/kbFHgw2TIo2K1ciLhEZxuPWDcLlThwyvOeuN4ktGX6kLHYwrxTfFSxKau1rnTSmjOlUOmReh3BdspKhhd/KAGbIE3Pl6aypDfAayxikwI3eoVHngVyCMg0wZaLguHJTApUiVzgsvL0Ynt6doSODmFDTUM5NjXmOw/h1F4iNjGw8vi9WnBpal+bMrnMIPeUrzwBwIAx2n8hHr4xF3DDyiiI/egwiyfiG5li2BJFKJzb/JnIVA06E0QeV2YqxQ7c8IBHJjw8JyLHH/Rhe9MxjLSDM+dXJ6j7fUzykUeNxMbOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RKLDAsILyNOePiaDmgk1567/CO810rMQ/ab0/oJg8E=;
 b=o33JNU1alr9GEpxzUYWaMKmsAUS1ykRpx9xUMFmgFEDyO2NeMAOaHUrrcN48UKwQbDb+0RyfaOzW6weaMVgwD2oFn8F0wOM0PTgJ/kJW65anHy9Dy3YnE5OFpWsjk5j7lz72+Jlyio7zT26ZHULf/lc7IXqqT+qFH65rh0Bd/rWFPQJxKEmowP6DH3/EAHXvGvysUPmnmKljvo5COytWlX+x1c5LLHzyaQpsn4RFkC0DBpvKXlWJRNOqCZjiYlWKN1CmfV89CTToDipyaUG/6xv8p63bWsQMxbkDj4FG2A9lH4lwwTUWZC09LZTvEa2fhBUnjQj0K01QswFJHG1n/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by PH0PR12MB8100.namprd12.prod.outlook.com (2603:10b6:510:29b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 10 Apr
 2023 07:39:19 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::14c1:21d:5f45:5b49]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::14c1:21d:5f45:5b49%4]) with mapi id 15.20.6277.034; Mon, 10 Apr 2023
 07:39:19 +0000
Message-ID: <8dd0e252-8d8b-a62d-8836-f9f26bc12bc7@nvidia.com>
Date:   Mon, 10 Apr 2023 00:39:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH] arm64/mm: don't WARN when alloc/free-ing device private
 pages
Content-Language: en-US
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Feiyang Chen <chenfeiyang@loongson.cn>,
        Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        stable@vger.kernel.org
References: <20230406040515.383238-1-jhubbard@nvidia.com>
 <CAMj1kXHxyntweiq76CdW=ov2_CkEQUbdPekGNDtFp7rBCJJE2w@mail.gmail.com>
 <a421b96a-ed4b-ae7d-2fe9-ed5f5f8deacf@nvidia.com>
 <CAMj1kXGtFyugzi9MZW=4_oVTy==eAF6283fwvX9fdZhO98ZA3g@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <CAMj1kXGtFyugzi9MZW=4_oVTy==eAF6283fwvX9fdZhO98ZA3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0202.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::27) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|PH0PR12MB8100:EE_
X-MS-Office365-Filtering-Correlation-Id: 301244f8-05f7-4b09-8334-08db3996b1d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eUvMXi85w4GdKh5zSCC2qpwnweRXS/opuCShXezSFKal4NMXMAhbwmKdc+y+R6ehPmIqMzHMBT70jaIBOrfE1pJNySXjnzun48BwEm3jc/YgFsmy+eRoNiGMTs76moaGV0nRGgwjLCjV8PBP2c1URx6KHFurJbXjraJJ8YZ/wOXI3dwmrl9jW0JmEJHNcm5AS0668d/2eDdBmNbYSmgXieJsYnjUKwSCyAI+77tknEr9F9UIIjKyNnuaEnkNCP9FVjpa0fr7tA0sB77kBlS+yqzQO3vb7mlnCmNb/FV9zlquEXWRWoHZDdCIBAjLEwCXhCb8KNTsVbLub0+fO5XHWKnD9OJHmtgGkjoKMBvjuG9FxxfF7tYbmflnzj5HZlUOacM4OHoKVsnIzVxo2yuUr3D11SMPoPOo036zXqjt9WAM6NQxyZ0495A5gOZoGBKtCZczsx8bZK+5H1nRYIAgscA9ZWqQ7xVjFkdaNGtz4D47Z0xFFzWItFnGu0LXP/vjswTaKJmbQWQwO3mgEtJydKE3eWhIjC2Unj5g4vzOZo9sReiiarwEpt40RegvG7Tne26AZuEQa/kQ72WB6CLWc32Elp8BqCkneqjb/WpW6+1QbeWMuFv6t2QpATFJqLb2Lcg6m2D6OXFe9G0rJqJWUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199021)(36756003)(2906002)(6512007)(6486002)(54906003)(316002)(6506007)(53546011)(26005)(2616005)(478600001)(31686004)(66946007)(186003)(86362001)(8676002)(66476007)(66556008)(6916009)(83380400001)(31696002)(4326008)(7416002)(41300700001)(5660300002)(38100700002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGh5YzJROE9CTTJraHJ4dFBlTUVHMFU0bzFOL3pOZHpEeHJ0SHVQbkhVMWtl?=
 =?utf-8?B?MVJoQzNNd291N2xieXY0Y1B5OFhOR2JqMFpNS1hiVjVYbE1xUFNTNXBtc3A4?=
 =?utf-8?B?ejc5TUJYSDh1TnhOU2d0UlpzTFYybzZRcCtFRHRuS1RSK1RuOU5helovT1FR?=
 =?utf-8?B?b0lGdDRCVkVNSGEyejVXNWwyWE1ydldYaWljTU52a24zVWJ6dUEwbTZaUW1l?=
 =?utf-8?B?MURVbjNpc1cvcUxMMFJBRnRRaVdyT3BDaHg3MWd1ZXd0KzY0SmllWk1hTUVY?=
 =?utf-8?B?VWphQkRhQi9XTWp5aG84UW5nRUQxWkUvWkxTQnFqMSt5UGtxQkRML1FhQUZM?=
 =?utf-8?B?WXQ1S2tSZXd0Q0xablgrMVl6VUdMKzhyVm14ZFJRUHlVbWFGQzhJV1djd0lN?=
 =?utf-8?B?cXlxUUNoUEgzaWJvL0JBWWhVMXFTV1pEM0N2OGpZWkVTWk5tLzRGZGtrVi92?=
 =?utf-8?B?dlplOExwNGJFWmM3Vm9aNHZvZHJudnZta3RCU2N5L0JqUHExQW9zS2kvUUdh?=
 =?utf-8?B?aEhsZXhFbUVodFowem82aGFOZTdMRk9pQ2xjUDJ0Tk91S2pBaU1KYjVWa1VE?=
 =?utf-8?B?RTEwUDlSejJPV1pEUUpYTlMwb2FLMGJodS9QRkpQWEwxVzFDc2ZoTEZFNk1Y?=
 =?utf-8?B?MjNNQ0kvQ3cvWG5lSXd1TGZ2bHhTR0o1cVZDT2s1Tm9RbXpBblMrVUY1VlJr?=
 =?utf-8?B?eFA0enY4clUyalZXRnVHeXRPOHdieWlHTmFhRVc1T1ZURXFFaFhmS3VYYVlK?=
 =?utf-8?B?MllTTTFTTDBCSTF1Y0trK1dTU3BVTzVRdGdGdEYwSm1yS1BsYTU3RGlsbUg4?=
 =?utf-8?B?dVVndXowNHk3YUFWQ2ZmbzNvOXdQWldhcGNtV3FacjJFR2FNZkxaREFYSHVy?=
 =?utf-8?B?dG1sUzM2VWJnTnd5UnF3Wk9HdUZmZ0NLZVFES3JLcTU1MGt0TkhGVHBMWUpi?=
 =?utf-8?B?aXZqZExBaFFPbnNIc2xiKzdCcE41WnNwTHFDSE1OaCtlbldlUHFRZzNydUZz?=
 =?utf-8?B?dUxHQ2ZvYXFSd2JXK2NMeUJ2amlURksrd3psQ1lmQ3h6ZjhUU1VFREJORFVl?=
 =?utf-8?B?SlNlODJmcnhXbUprMjlkNlBlbG1UNXJVY1Q1K3dRYU9Cb3F6UzUyVnlFSzZM?=
 =?utf-8?B?S1A4cEE4ODFhUmU1OE9IZ0w1OUQzU1dFL0p6RkR6N2hkTndJbk01cXdvK3lv?=
 =?utf-8?B?T0ZUOGNDWHlxWiswcFpQNndNMnloVWUxcFlTVFZ5VFQ5Z0RVRWNrT3dQeUJF?=
 =?utf-8?B?eEFjelJJOGtUNHV6YnNaTGV6YWxWYis0SjhwVFUwZmZKWEdaaUJqOHpOZ291?=
 =?utf-8?B?UENVdFVVUHlINEFOR1NtSWpHbEx5Wm9HWVhweHhsbEk1d1B6YUJjSndMV3Zk?=
 =?utf-8?B?VXliTWJPRUxaQ3BuWmFMVWxxdmNiUGRTbHhYU0kyaWdUR2dsektIcHh2QU02?=
 =?utf-8?B?aFFxTVhpTWdHOUp3akdQKzI5M09zRE8weHVKVE4rQU5WRWJIUmlaaGZTNmt2?=
 =?utf-8?B?NUV1aEZGeUo1aEF4TTVtN0UyblhpNGcxV1VxM3ZsWC90cW5ic0hNWnZIYzE5?=
 =?utf-8?B?cEJob2JLYWhJZE9LdUREL1JKZUUwTHhMQWM0bXpDZ0JoNlRoNVhIeVVMdGVl?=
 =?utf-8?B?V3F0bW4zOGJSSUtKK2VyQnREUkxmU1pvSk1kdFJoWTlqZ3pXa3hXWk9rTWRT?=
 =?utf-8?B?NkR6NkNzcGkyNkdQUUI4VlpDaXFNdE5yTkU1a3NzMC9qMUtVVEVrRXRpeHRq?=
 =?utf-8?B?RTQ1OUNvM2V0amRXOWZmcnBMM3BJcWt4ak1zYlJrTTd5UUNVOWdNQm9jZHZi?=
 =?utf-8?B?MVJWWFZHcitYTGxZbUFXdDQzTUZ2L3AzSkVwOEgyOUNUb1BYS1c5L0cxTXhy?=
 =?utf-8?B?VVdjMlZ2dEpQQ0hBWHFlM3NHcVJLSE1DYkZjMTUzUURpaEZoVFRPeEhNNnB3?=
 =?utf-8?B?cEhtd0k5YmlvY0dBU3RiRUhCeFE1UFBycW1ldUwvUGFzVk5HYS9YTVBOK0xS?=
 =?utf-8?B?WGh2UDVCeTFWRkVWT3IrU2Fwb3R6M09NQyswY1hSYTRFcDg2ZVBTWTR4R3Ft?=
 =?utf-8?B?eE5XL25NYk5hbERBS0VndHVPSitzMDZKRXNTdGFEaEIxeFZleUFpOGxHcks4?=
 =?utf-8?Q?vEHNnE+sleTYGQmitIP8XTGrv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 301244f8-05f7-4b09-8334-08db3996b1d3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 07:39:19.6426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTrnl6n33BsJlz2Y2UGrHoifN0jW6Zh9cvi72NHO9VhuMU0rwZZ1Ng5ft3OVzCG9xYERYX7FE5hjGlCD57RB1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8100
X-Spam-Status: No, score=-3.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/7/23 03:45, Ard Biesheuvel wrote:
...
> That is what I am talking about - the struct pages are allocated in a
> region that is reserved for something else.
> 
> Maybe an example helps here:

It does! After also poking around quite a lot, and comparing to x86,
it is starting to become clearer now.

> 
> When running the 39-bit VA kernel build on a AMD Seatte board, we will
> have (assuming sizeof(struct page) == 64)
> 
> memstart_addr := 0x80_0000_0000
> 
> PAGE_OFFSET := 0xffff_ff80_0000_0000
> 
> VMEMMAP_SHIFT := 6
> VMEMMAP_START := 0xffff_fffe_0000_0000
> VMEMMAP_SIZE := 0x1_0000_0000
> 
> pfn_to_page() conversions are based on ordinary array indexing
> involving vemmap[], where vmemmap is defined as
> 
> #define vmemmap \
>     ((struct page *)VMEMMAP_START - (memstart_addr >> PAGE_SHIFT))
> 
> So the PFN associated with the first usable DRAM address is
> 0x800_0000, and pfn_to_page(0x800_0000) will return VMEMMAP_START.

OK, I see how that's set up, yes.

> 
> pfn_to_page(x) for any x < 0x800_0000 will produce a kernel VA that
> points into the vmalloc area, and may conflict with the kernel
> mapping, modules mappings, per-CPU mappings, IO mappings, etc etc.
> 
> pfn_to_page(x) for values 0xc00_0000 < x < 0x1000_0000 will produce a
> kernel VA that points outside the region set aside for the vmemmap.
> This region is currently unused, but that will likely change soon.
> 

I tentatively think I'm in this case right now. Because there is no wrap
around happening in my particular config, which is CONFIG_ARM64_VA_BITS
== 48, and PAGE_SIZE == 4KB and sizeof(struct page) == 64 (details
below).

It occurs to me that ZONE_DEVICE and (within that category) device
private page support need only support rather large setups. On x86, it
requires 64-bit. And on arm64, from what I'm learning after a day or so
of looking around and comparing, I think we must require at least 48 bit
VA support. Otherwise there's just no room for things.

And for smaller systems, everyone disables this fancy automatic handling
(hmm_range_fault()-based page migration) anyway, partly because of the
VA and PA small ranges, but also because of size and performance
constraints.

> pfn_to_page(x) for any x >= 0x1000_0000 will wrap around and produce a
> bogus address in the user range.
> 
> The bottom line is that the VMEMMAP region is dimensioned to cover
> system memory only, i.e., what can be covered by the kernel direct
> map. If you want to allocate struct pages for thing that are not
> system memory, you will need to enlarge the VMEMMAP region, and ensure
> that request_mem_region() produces a region that is covered by it.
> 
> This is going to be tricky with LPA2, because there, the 4k pages
> configuration already uses up half of the vmalloc region to cover the
> linear map, so we have to consider this carefully.

Things are interlocked a little differently on arm64, than on x86, and
the layout is also different. One other interesting thing jumps out at
me: On arm64, the (VMALLOC_END - VMALLOC_START) size is *huge*: 123 TB
on my config. And it seems to cover the kernel mapping. On x86, those
are separate. This still confuses me a bit and I wonder if I'm reading
it wrong?

Also, below are the values on my 48 bit VA setup. I'm listing these in
order to help jumpstart thinking about how exactly to extend
VMEMMAP_SIZE. GPUs have on the order of GB's of memory these days, so
that's the order of magnitude that's needed.

PAGE_OFFSET:                      0xffff000000000000
PAGE_END:                         0xffff800000000000
high_memory:                      0xffff087f80000000 (8 TB)

VMALLOC_START:                    0xffff800008000000
VMALLOC_END:                      0xfffffbfff0000000 (123 TB)

vmemmap:                          0xfffffbfffe000000
VMEMMAP_START:                    0xfffffc0000000000
VMEMMAP_END:                      0xfffffe0000000000

Typical device private struct page
that is causing warnings:         0xffffffffaee00000

VMEMMAP_SIZE:                     0x0000020000000000 (2 TB)
VMEMMAP_SHIFT:                    6

PHYS_OFFSET:                      0x0000000080000000
memstart_addr (signed 64-bit):    0x0000000080000000

MODULES_VADDR:                    0xffff800000000000
MODULES_END:                      0xffff800008000000 (128 MB)

PAGE_SHIFT:                       12
PAGE_SIZE:                        0x0000000000001000 (4 KB)
PAGE_MASK:                        0xfffffffffffff000

PMD_SIZE:                         0x0000000000200000 (2 MB)
PMD_MASK:                         0xffffffffffe00000

PUD_SIZE:                         0x0000000040000000 (1 GB)
PUD_MASK:                         0xffffffffc0000000

PGDIR_SIZE:                       0x0000008000000000 (512 GB)

PTE_ADDR_MASK:                    0x0000fffffffff000
sizeof(struct page):              64

thanks,
-- 
John Hubbard
NVIDIA

