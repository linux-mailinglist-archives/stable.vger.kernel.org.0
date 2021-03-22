Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886E3345157
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 22:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhCVVCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 17:02:37 -0400
Received: from mail-eopbgr690083.outbound.protection.outlook.com ([40.107.69.83]:26606
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229871AbhCVVCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 17:02:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqWDptfh1V/TVDp7SjgccftERrjr3uWK5nVjiflDyC9Q/JfJCHqLKUtUgiLT9YPZsCUUFOq4pJUmsHUZ3N4HTEhW9qVV3xpfCFpiJk/3pxsGQWiTVfDqy9dwoeHUoZZJKlzu99xgeR3ww3ovK5cAUc49JB21J0pKK225P9clXZ67f2u7LW6GTA0wOfcyOlvcR4z1dAMksCNbzdbTLnwDFAWTCG4ZEjj0mT65jX8B+DX1BVk6I+U9CnrJd7Fh0RIYouGOnNoA8dqTR4iEi710o2smQnM8WnAjDv/l/zvb3qyoFmGPTDTZcryljUi9Jfn1gLiQHkqxSzjf4/AMmyW5qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZulT2Hz7YXcm2cNsw+7fTx87sm/ZGnkP/Hobb0Wz7D8=;
 b=Z7g+fQM9CiOGPKxjkZoZNTABuidpgIhzbI3g+MTbz3AciQjFBxqLjyWaReHqfY74td0MciizKD5FdUEZM0PSBqTCUniLn4MiUg9UmEV+0HsQw0FoqQrLypiIo5TOtYmIKok8ard7FlF8u3RJVaCIRiL/MOCLiYEuQkiNab2JB3zrpi6AN+LZ4+TiYFBfXceekC5c3bithJqswFtJFFyfNhujbhve7QkcSMdqSjArSLRdAT7CMOZo2Ll4fzCqWpadmVltmx+VUL1s/fRQwcDuXJQOhjxUhcF5YzPKPhO0khkPI3PEA4bTGM9wEcN6KNRYpKiMyU7ltjyyiUTR8Cxshw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZulT2Hz7YXcm2cNsw+7fTx87sm/ZGnkP/Hobb0Wz7D8=;
 b=iLqu1cshxxLx2GeBoeGtiFdhj39QGA4J9EXLKT/2FCrr/WBH4mO2giD/3YDLbGdfq80KOhHtkRxJco2sGS9UON3yL3Jfa0Co9hWseVQ7BgmKiGaADBd8L9jnnasPIUmwBBx5BeUbxnUQWItVPOLKL2yNvX5lgPSWVcghDaDvkUU=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2891.namprd12.prod.outlook.com (2603:10b6:5:188::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Mon, 22 Mar 2021 21:02:15 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 21:02:14 +0000
Subject: Re: [PATCH] X86: __set_clr_pte_enc() miscalculates physical address
To:     Isaku Yamahata <isaku.yamahata@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Cc:     brijesh.singh@amd.com, tglx@linutronix.de, bp@alien8.de,
        isaku.yamahata@gmail.com,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
References: <81abbae1657053eccc535c16151f63cd049dcb97.1616098294.git.isaku.yamahata@intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <0d99865a-30d5-9857-1a53-cc26ada6608c@amd.com>
Date:   Mon, 22 Mar 2021 16:02:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <81abbae1657053eccc535c16151f63cd049dcb97.1616098294.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SN4PR0501CA0136.namprd05.prod.outlook.com
 (2603:10b6:803:2c::14) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0501CA0136.namprd05.prod.outlook.com (2603:10b6:803:2c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Mon, 22 Mar 2021 21:02:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e3a6da93-8857-4188-ded5-08d8ed75c4fc
X-MS-TrafficTypeDiagnostic: DM6PR12MB2891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB289171F0FB78A4C6A417A4BEEC659@DM6PR12MB2891.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wubYVGq8PcJxayXWe/gwVDgGKf7yt0VbRRMyo9F8WkswhpGyEccix4s3UWwVLVMgCVnCU6FhqekLBnH2o1JneDqtbRykPf9PtGmCDXoysM9sWRAOvtFGSabC/Tscmi0odxQfYYp1FzRxUMUV4zcj91XMDpsPriOAig+mmifaBrI7petOTriowoymUIwGInozMXEzBy5kXH1zhIHRsgc0e1pqmx87h3sP63nKKfpQqxKc1GgUxF4kS3sa+PSlLDVr8sUgd1mQ+IGSmoVNcj7k/fL3RQI6kTcMvqYsezcFVkP/cyI3qRgc4WkIjXKc1UtKRv9Fs63iiaq2bFLMnhen+d2F58KevTg+HhjfZTj3Pr9ohQs0QLxs5kGTa9Uv/IxZ0ug49cRrdzQVCNyMemlF6dHVQBrJfv3s1s4ywJBZHwnkREO2U+gmbLhHh5UxYp8CCEbDqjSJIP6uzUbrxcDtGNfxzRTHWczesGBTYZnJz6RN2ohWJuRMqNkxpaXoQaUsZWYsH506MPanHASe76tnve9H62paf8o+4D3qdwOAPv4v1IFilKDKUiVv9ZfOqPYOUuFJQrAgwq8vCJKZW9dLK4Pxbdj46aAAcx0IQly5WF6PUfLgmOerJUyTkqCzKUt+QTn1AQTmp4Kud6WfG3F60AOGfmb5ewyw3JA0XFnVPT9d7Qtm+E9YQ/lf2F6FngObvg32ZFeYdV1CSO6Jm76GDDYkuDdN/QSBZoLZzWw2kEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(498600001)(86362001)(8676002)(31696002)(956004)(53546011)(6506007)(2906002)(2616005)(36756003)(66946007)(4326008)(186003)(83380400001)(16526019)(6512007)(31686004)(38100700001)(66556008)(6486002)(66476007)(5660300002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TGdOK2tpTFZyM2Q0UzZZU3RwQUZRRVJhOFlsTFZBekVNYlhIa2FsSmdwVlRQ?=
 =?utf-8?B?eDFVMXpKV2tNZmI3Ri82Y0RyVWtVTnpPUkJ2cFgvdkFiMkRPemFUM2NnWDd2?=
 =?utf-8?B?czQwcjZKRy9FTnQ3bGFKMWQxdXFvV2ZJb25LdnRPZitWRVljU2lDZklmS0hP?=
 =?utf-8?B?ZlA2cjNoTVlmZm1mMnhsSmVXckdrK3c5elFiSnBwQnZaVmNWZ21TU3BpaU16?=
 =?utf-8?B?SmFXUXVGZUQzcDdFQVp0NXZpckJFSGVtMzFYUWVBNTZnRUM0UHgraTBqcjc0?=
 =?utf-8?B?V1BEMzlBV1Vrb2ZLc2YxeDhZVTRXSEw4SGl1YXppTnk2RlJTNkE0THhIK084?=
 =?utf-8?B?NERLbUxPNHB5bVNPM3M3UW02aE5ZbG5RUyt2aEJnQWpCd0FJejIvRkk3NVZD?=
 =?utf-8?B?RnVoZ0p4aFpZYi94bDFPdGpDZGd4ZkczTEpZdFNZYnI3R0VaN1dTMk9TZTQz?=
 =?utf-8?B?RVpoZU5pZTAzYUxIcUZlajJOM1ZpS3FscmYxbFB5Y3Q2L2ZYcU1Pb1RlK1VY?=
 =?utf-8?B?QzJ1aE9DMHR4Q25iRUFNSVhkRjVhSDVxNTdPQUtuUG5GSEtJODlabTUrTWVw?=
 =?utf-8?B?MnVjVlNpblI2eTlyb0JwZlNvRVZDSUdTWWhPeGx3a0E4ZE53Wm4zMDZZT0xG?=
 =?utf-8?B?WGlib3F6L0FhZnRaMVdJOCtCb2JKbFc3ZzhNeUVCaTRPOHExaGZCYXVGNFFs?=
 =?utf-8?B?STVKL3dEOGJMNk11STBoTUs3S2FWRkdTSUtQaGZlTERWL3EyUlFBZVlueHBv?=
 =?utf-8?B?ZmMyRzFid0kxbDRqUkx6SHl1WUJIOFA0L2dUN0NJY2k4eUc3NHBnT3VTcHFw?=
 =?utf-8?B?YnRqZy9WMzB5VEV2aVVHM3Y5VUFYYjhTQ3NndU9aU1NyVUVsT3IzRmFESWdl?=
 =?utf-8?B?TEsxdW5sOHVnUGMvdkhyc2t2KzdxNHM5RUdrd1hqNTFrZjA1bWIxUm10a1hT?=
 =?utf-8?B?YlM4VjZ2OWZRWjZkQ29YQW5LNzVlZDN6Q1dFa2NSckdxeEovZU56QlQzbEZZ?=
 =?utf-8?B?Y0tMcTI0S25YbUlmNG1LbDk0aHpuNlFJQkZMTGJCYi9MYmhHSm9zaGJkeTdJ?=
 =?utf-8?B?bFhIRHFPcUwvcEhPK0hOVy9BQWZKZTIvUkc2SkxjT2ltWnR1YWYzRTI4RFdM?=
 =?utf-8?B?OUt6ZnFwcFA0bXJ2a0pmVWlHcW9BM1BCcm1tdUVNTm5sUHkwclA2ME9XN2RX?=
 =?utf-8?B?eTJwN3lyZWpFTy9OZWU2RWxrQmZtZUxmSlRNem9sNWRzRWtuL2NSdUZ5WDNN?=
 =?utf-8?B?WEdRbzBBTmc3aWFJaCtVQ21kdFN0KzR3N0Yybk1WYkZvSk5zUDBMcW92RVBt?=
 =?utf-8?B?djhxWDd0NmRINzBEV0Z5WGs2ay8wR2crRXJhNlhqelgxOXh2YWpIMVFQWC9O?=
 =?utf-8?B?dUd2ZnRCYVdvSWNzc0laRElvVXQ0SkFzbnpOMGpVM01rUmhMZ3RaZXp0SHJo?=
 =?utf-8?B?cEFmc21rNUFZNXVqdG9kMXJ1NHJGQkVKSnRuQzdXVG1kQi9JekhtN3hrR0pp?=
 =?utf-8?B?dHo1MjQwR2JacDl4REovWVRFZTNOK25JVFdBMEZxa3ZzZUhxaVhTTnp3N3kv?=
 =?utf-8?B?d2hkSlo0cEJhWko2T0FSb3NLc1RKMXYrMTJwTFQxMlNHOERNMzJaZzg5bzlj?=
 =?utf-8?B?NTdoRlJjVk9YU0xhUlBKZURaWjZBR3J4N21qdVVpaWhmS0MyeVZXNDVXNkM0?=
 =?utf-8?B?NjVZL01sS09SZnVQczFvTEVaUTFHQWxjSVM5WU5WcHFwQzlJVVBzdFN6Qkdw?=
 =?utf-8?Q?kqO4E7iC1kjjFYGr2/dkMpDelZ3VqwS7cHnKKMI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3a6da93-8857-4188-ded5-08d8ed75c4fc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 21:02:14.7457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uICSoguKlfO/0/vr/X/fcW7tC9jP650pB1ox2G7Fu6GhlPQYmvs8zBAa1uQH2fYAgg66IGM+WQ0q9oxWACEeHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2891
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/18/21 3:26 PM, Isaku Yamahata wrote:
> __set_clr_pte_enc() miscalculates physical address to operate.
> pfn is in unit of PG_LEVEL_4K, not PGL_LEVEL_{2M, 1G}.
> Shift size to get physical address should be PAGE_SHIFT,
> not page_level_shift().
> 
> Fixes: dfaaec9033b8 ("x86: Add support for changing memory encryption attribute in early boot")
> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/mm/mem_encrypt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 4b01f7dbaf30..ae78cef79980 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -262,7 +262,7 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>  	if (pgprot_val(old_prot) == pgprot_val(new_prot))
>  		return;
>  
> -	pa = pfn << page_level_shift(level);
> +	pa = pfn << PAGE_SHIFT;
>  	size = page_level_size(level);
>  
>  	/*
> 
