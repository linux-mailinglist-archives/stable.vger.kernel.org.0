Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194F46DA673
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 02:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjDGANq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 20:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjDGANq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 20:13:46 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29499740;
        Thu,  6 Apr 2023 17:13:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKTluBlEH/Lw3un8PA2C7kFFRvSZXwlUiuRogY601QuzLQ7EELXSIx89JiRA+qprJasIXwaZTD6UatmK+syksEDTg9Vumqj4Pm0IufzTIp/CoX8yD+dI4sIr7GC4IMKO3q6tiohCi6guQMVZaX0Xj0msjQmijBgJs6shjfvlihWe4sYWJEpRX4iEzVH532IukKVpKJ4RJRBSIXM8JjE9f7+y8MQNemaKixEpq/DD9vApG6UAfAdcHxRywyfWySPwtufexPpPEESF8PgUfZbsIsi8C9141PZ9/M27j7mAlQOgLQvvG5wPCk2dC0ctYwdsHdC5trxpGwGulLofNKKkwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BQqb/8f0zgx5AgaK5cqRdro4J9O8JK+NJSbgdaUE56s=;
 b=nTXqEqgMIahyGwIaTtb9hj139GhA/KqSLMVPHZmeTs84ushfTSsq0fM6PB3+mw6WDPdIcFvNRu0IV2+flSB8cCtS9cZhXWB8Kj99dUOlFPtq6+AxMJw10Sw3+IaFIilFNrrOgerPxm9L/NoQvBxCKNEPdxpuJQzs2mtpCBsoB4yuy1sXKUMdmB9UZc2qEwDzNDfar4Bm46lhq9dLvcfVBVDIuRkKfK0moo4f9zuZXYW0VIa4ab7fQSehM0ioHnZqaUkZ7KlSrRoSd9NthlLHMElHxy2FGAWj4xBvL0AIvP5ryA3PPeZflJxoEiF8MUxWW7Xtnyw36xAnSX8SvzsPTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQqb/8f0zgx5AgaK5cqRdro4J9O8JK+NJSbgdaUE56s=;
 b=eJgRLRTwp6K5rcpKuLfngyt5mOAqbIi6eSSr3YnenyasmzeukfNu737J9ZWU2woM7+seVfp9RTusQsHnf3ftMBQeZXnJLhezflxO/5NvboyRVXbqjVhuy8PhhHtyxUfoHtqTB8atqcJ4npcSZW4bF26ghV9FeCFAqfXqsMc1cvLJ/ZclGfbEqMZiwh7yA2RfCUD/BwOOXlmBc8Dapm046/vKMl3cpMTaAeIJlcW/r/0AZ2tQVBZT3dgAwd5vtdJQKWPvY3C7PP14ZLfrlvflE3G7vZoHGM6sA52hcqWtPLiLHgwd//fhPyD7BnSv8sU+bTnc/AqcUNRlcl5wL5cAIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Fri, 7 Apr
 2023 00:13:42 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::14c1:21d:5f45:5b49]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::14c1:21d:5f45:5b49%4]) with mapi id 15.20.6277.031; Fri, 7 Apr 2023
 00:13:42 +0000
Message-ID: <a421b96a-ed4b-ae7d-2fe9-ed5f5f8deacf@nvidia.com>
Date:   Thu, 6 Apr 2023 17:13:40 -0700
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
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <CAMj1kXHxyntweiq76CdW=ov2_CkEQUbdPekGNDtFp7rBCJJE2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0206.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::31) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: 84e98ff9-eb21-4adf-88fb-08db36fcf1f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: piiQ1L/Pgw3B5yXJZfTZ9RpyP7InI1MsqtvRlc78w/U6IlmQqigRsWyJ0KEjvv8V2nTEqSbYkTiBO4qgpmlA6QlUyO5YTzsQCjIMu0kYcAY9+WDRQDk8HL9jUmB71z/1EfeCsyQlxfys1aeLJifSVhUvaCoKNUMWN7Am5ABAFAeUc6CQc26KGwN6c+TrxzrShiTijqAxoN/Q7qkV/C+FdxGQn5FlFeO6f2WmNQm+2f52H1T490f6UDqY6klri/085/EEmTOu0DgvSHvI7rWHnfTz5LctNuHqrT5E6D08KdAUq1g8Tsq7jxbZZAu+SnlenlVruSWCnx/QGJV3DgoMr+z6BnXrZnEs81IIH8TdFHrTRsOFcGK0aqgiqs5mV/gVtL1qKgLGms/UM19V9DKFSXPx+HSKsksyUVgSfv37G4D/BkD0A7t6zznvXOgPDeNjMOwq/laspk9yhvsoeBoYXFIJUYxHo2Kt4I/Jmaq3/EnwrSULtHjRO/YoBIICZMMLkAdoUQxMzWbdbHzIhq5pzdY2EEfYiJ+OmX2PvgALBJCbJOBxVc8BFhI7SRRRcQDBTWEHzkWtfQM+QEw81Zt6ISmcoSEcsvtI2f24hSqmPFKwjkSPDCzYbPj/pLoNOBFM67gACOYxHez0m99FF0hvYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(346002)(39860400002)(396003)(136003)(451199021)(8676002)(83380400001)(6916009)(86362001)(66476007)(2906002)(41300700001)(66556008)(316002)(66946007)(31696002)(54906003)(478600001)(31686004)(36756003)(8936002)(38100700002)(6486002)(2616005)(4326008)(5660300002)(6512007)(53546011)(7416002)(186003)(26005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3JiSGdaTG1kcDNSckp6dytZdUFRK2ZsT3YwT2kydjFDRDZmamVsR29lV1lj?=
 =?utf-8?B?WWtTWEYwN2JkMmdaZ2FvcXl1TDgwQmJMRmwxYTAwekRYZ3RRTnNwYjFXMVA0?=
 =?utf-8?B?YVhmd28zdTJKenc2bkY4bmI1bTZuUUdJL1N5NVhTMXdEdnM5d2phbk5PODF4?=
 =?utf-8?B?bUdjQ3BqYmVTZ0RIcWI4WmNMWi9jRTlIY1lpUUUwckRmd2dld210UDUwbXJV?=
 =?utf-8?B?clhjZFYyM3p3Y3VpdG52WTJSWUFhNGdibGxoQmxRUk01cG1pYjJEYVZyK1Yv?=
 =?utf-8?B?QVlNRk4ySTZ0akhCT1IxMEdQZUd3bGJZVWxTL2xOcXJlQlVIbDFwVGpIRGp6?=
 =?utf-8?B?RThOK3V2UVJOSUxNQW5NRmJNekM2M3RDamV0ZjRZbjJGeC9pa1lVODIrd29Z?=
 =?utf-8?B?L2dmU21tM1FqYzd0SU5mWi9abnJMRTllOFVYeGFQR01CRzhEQ1UwblRvTTJn?=
 =?utf-8?B?K3k0ZE1CcU44eTFsbkVodkREYnJVeGttall6ZWRHZVlOM2k5eFhsWmlnNWtP?=
 =?utf-8?B?eGIyeG1Ga1JSejBTaTEramxNcE9kUmZEb1U1VlpyRWp6WVVVSzBaNnNmUTNI?=
 =?utf-8?B?dFUwV2tHbG84R1dFc3lXQmlTbWtxNDZYZXd4SzR4WWo2NlRjRzJ0K3ByeEY4?=
 =?utf-8?B?RnNNdW41YkhNTWZBcEk4SytCSTI2VnBtSmU2RCtzaXB2eWtYdytPRERrSXhG?=
 =?utf-8?B?MndndERSN3VMMnFtWmYzT2pHSFRCM3htQUNqNjlvQVFXMDhIVFZCVUlFbUdM?=
 =?utf-8?B?My9mdUZYQldhTjZsd090cU9YRmVwaXl6dmlGNmZMa28zY0xPNmpFWHBVMTZk?=
 =?utf-8?B?MzNMQkhPTFhsN21DbnRiUHlxWWZueUVVKzF2Z0UxNk9ZbXpSaCsyb2JIYTFn?=
 =?utf-8?B?VkRxa0FhNG1CVmJ0WWdMaEdPbldlTlNSWStMZDJLczFwNkN0dnhxQkZyUTA1?=
 =?utf-8?B?RVk4ZWcrNW5xemNUenlCdWhMaWovamVOQ1dvYUhTV1FLSTFua2lJYW52M3pL?=
 =?utf-8?B?dDJhQUlpTXZRVHNuVHprOVpTMEc1WmU5NmJzQUZaeUpudElXZ3dqM0gvemtR?=
 =?utf-8?B?cXdKMFhZMlNaYlJYekx5cXQ4ZGxMdnl2S242eThnOGt2NVdMSUdUSU4xOHR4?=
 =?utf-8?B?eUZ2U1ZsMkJhQ3p6NkJCVVl5S05nazBycEJkM2ZMbDU3UnJLc1NLQStiRlU3?=
 =?utf-8?B?VmthY2dQWklHNjBvYS9acTNXOFV4WkhLeVJXMmpqYWlnUkgyd0s3V1Z6a05p?=
 =?utf-8?B?YUx1Q2ZsNFZHM1dSRmU3RUZhQ0VKRTZlckdEakd3VmdXV2Iwb0tYUTZnWWx5?=
 =?utf-8?B?VFlDM3NrL0Q3SWNoYzNtQmV0RUFlbVdQTEhaZVluMDFBbjRkRmtvYkkxR21X?=
 =?utf-8?B?UTk0ejQ4K2RpNFJVT3dNOVdMUnU0a1NaNkxtdFhieGY3QkkzZ1c4N0NXKzYv?=
 =?utf-8?B?L09STXMxOHRDWXVGUyt6ZEpNN1RmRjMyb282bUsxWERpcmh2T2ZSblg2UHhq?=
 =?utf-8?B?Uk5kRFU2YUJKd3FoZ2UwV3VibmZ6dktaQzM5cTFUQUpxSnEwK1hNYnp0cFNi?=
 =?utf-8?B?b2FZOVo4UzB0WHc1TDBGcGtBaTlXcys4c0ZZaWlTVVlUWFBya1d6TWg5cmtI?=
 =?utf-8?B?RmgvTDQzeWVIUXVyczNEYnI3ZmtGZ2l5YzVRZmJESTNHQ0Y0MlhQdGxkSkJC?=
 =?utf-8?B?TnF6WFZZYnBUTmxQZ01iVVBRWjRxV0dNWU81RGx1NlVyMXBwVnpVSjMrNUZw?=
 =?utf-8?B?YXg5alVPRlRWZWVMRlFnSEdJRnhmYjdnVUR4aFBFaHNnVHVOM2tZalB4S3hJ?=
 =?utf-8?B?M1ZoRitqN2RtS1dWdDF5Mnh2TnJtSWxZMDlpVnNRN2tWVW1SZm91bjZYWUQy?=
 =?utf-8?B?YldPVWhOWDBoQ1EzeUZRNFk5bWlmZjc3bjAvbG9JWVhFQmpySUd1Z3pSeURL?=
 =?utf-8?B?My9xT1l5SU10OXBwcEFKdmJXeXBseFpRUGoxa1cvcGxKcnB0cDdjVk40R2Ix?=
 =?utf-8?B?Y2FyOHVPSi84ejVIYmsvTWJaYlpKa2lrb1NIenh5M2hsNzhCRkVjaEFHSUxC?=
 =?utf-8?B?UmpwYStPWFNzYU42K2k3TU9hL1Q4SDZTOHVlVmgxQk1UanZxbm0yenJldUt1?=
 =?utf-8?B?QWl2c3AzaVJtbVFiWXhrUWJ3L3B0Z09QbHh4Z3BDM0pBTkM2R3U3NTVWYk9n?=
 =?utf-8?B?M1E9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e98ff9-eb21-4adf-88fb-08db36fcf1f6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2023 00:13:42.3508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N9nA8PMH5l6dtmNVD0pN9hMNKVwYgWxNg33jUnT5726jeeudJXKo9SmwCI1i05QaCG6qkQ6rn3+9iGfLnCE3hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768
X-Spam-Status: No, score=-1.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/6/23 00:31, Ard Biesheuvel wrote:
> Hello John,
> 
> On Thu, 6 Apr 2023 at 06:05, John Hubbard <jhubbard@nvidia.com> wrote:
>>
>> Although CONFIG_DEVICE_PRIVATE and hmm_range_fault() and related
>> functionality was first developed on x86, it also works on arm64.
>> However, when trying this out on an arm64 system, it turns out that
>> there is a massive slowdown during the setup and teardown phases.
>>
>> This slowdown is due to lots of calls to WARN_ON()'s that are checking
>> for pages that are out of the physical range for the CPU. However,
>> that's a design feature of device private pages: they are specfically
>> chosen in order to be outside of the range of the CPU's true physical
>> pages.
>>

Hi Ard,

Thank you for looking at this so soon, I've been working on filling
in some details and studying what you said.

By the way, to address an implicit question from Andrew on the other
thread, the reason that this slows things down is due to a loop in 
__add_pages() that repeatedly calls through to vmemmap_populate(),
like this:

device driver setup: allocate struct pages for the device (GPU)
    memremap_pages(pagemap.type = MEMORY_DEVICE_PRIVATE)
        pagemap_range()
        __add_pages() /* device private case does this */
            for (; pfn < end_pfn; pfn += cur_nr_pages) {
		/* this loops 125 times on an x86 test machine: */
                sparse_add_section()
                    section_activate()
                        populate_section_memmap()
                            __populate_section_memmap()
                                vmemmap_populate()

> 
> Currently, the vmemmap region is dimensioned to only cover the PFN
> range that backs the linear map. So the WARN() seems appropriate here:
> you are mapping struct page[] ranges outside of the allocated window,
> and afaict, you might actually wrap around and corrupt the linear map
> at the start of the kernel VA space like this.
> 

Well...it's only doing a partial hotplug of these pages, just enough to get
ZONE_DEVICE to work. As I understand it so far, only the struct pages
themselves are ever accessed, not any mappings.

More below:

...
>>                 /* arch/x86/mm/init_64.c */
>>                 vmemmap_free()
>>                 {
>>                   VM_BUG_ON(!PAGE_ALIGNED(start));
>>                   VM_BUG_ON(!PAGE_ALIGNED(end));
>>                   ...
>>                 }
>>
>> So, the warning is a false positive for this case. Therefore, skip the
>> warning if CONFIG_DEVICE_PRIVATE is set.
>>
> 
> I don't think this is a false positive. We'll need to adjust
> VMEMMAP_SIZE to account for this.
> 

Looking at the (new to me) arm64 code for this, VMEMMAP_SIZE is only
ever used to calculate VMEMMAP_END, which in turn is used for the
WARN_ON()'s in question, plus as the "ceiling" arg to free_empty_tables().

It seems Mostly Harmless. How would you feel about changing it to a
WARN_ON_ONCE() as Andrew suggested? That would completely fix the
user-visible symptoms:

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6f9d8898a025..82d4205af9f2 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1157,7 +1157,7 @@ int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
 int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap)
 {
-	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
+	WARN_ON_ONCE((start < VMEMMAP_START) || (end > VMEMMAP_END));
 
 	if (!IS_ENABLED(CONFIG_ARM64_4K_PAGES))
 		return vmemmap_populate_basepages(start, end, node, altmap);
@@ -1169,7 +1169,7 @@ int __meminit vmemmap_populate(unsigned long start, unsigned long end, int node,
 void vmemmap_free(unsigned long start, unsigned long end,
 		struct vmem_altmap *altmap)
 {
-	WARN_ON((start < VMEMMAP_START) || (end > VMEMMAP_END));
+	WARN_ON_ONCE((start < VMEMMAP_START) || (end > VMEMMAP_END));
 
 	unmap_hotplug_range(start, end, true, altmap);
 	free_empty_tables(start, end, VMEMMAP_START, VMEMMAP_END);



thanks,
-- 
John Hubbard
NVIDIA

