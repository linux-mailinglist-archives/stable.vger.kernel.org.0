Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89097397A1C
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 20:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbhFAScd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 14:32:33 -0400
Received: from mail-bn7nam10on2044.outbound.protection.outlook.com ([40.107.92.44]:37473
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233970AbhFAScc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 14:32:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GynH5mnC91UaQ2lw6hggbYygUsoTSs3WPsK/8mVCl8vv7VDAhhetehw2XKrPrHI3+0O5Y72d7yFdDKw/a6cPxh2bpQW4oVbs/Iwi1v6PPKT/TChHNCA4tGNjB+26gbwHLUCdUWUq2/P7Q7XvcD0huNGhcDyRNUCm3VZoJTjjRc1JnmZS2KAp2gIxL5G0ZbkVEbXPnhUffOa7pt0f+c2SgvM8W3rFGFuzGFvWvTJ+3c1H0G6vGpJw2cDII6QhEqp6gn2qS6Ltnkb/3LDbC4WuxZ8lkaUvooCBwXBGwyUoZ2yK1daNWtL1ivEsGCzjB3VJ9BSd3MnOy09TGEW92TxaXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpLyygWiCd9X60rbaw+kAdWgXDed2KxbAjMPgAFvP34=;
 b=iTzNl5O7fGH+zC04ad4sqXMx8Jj7yAbIj/Cb/SpkUZodnkp2uLwcs2JRB/BYIaFs0b5WgHbX00VCMOR+cPMI4ADIRmQ8aUo/h787DJOZ4Oyf1m5zeROKVuuQ3FbUBJk/Jcwb+Z0yFF4mJ1K1Dle1MrlPUY9jha7IO6+7KLed/XZiN1ukebs38uUAnIo4rCeTgZm+npIXHoMJ173tBSmitFXKEVLYZsCwMKb/TaED3fV+AA6WPWDLULghoncPtsoKJbneIXA34AvhzprnqeDe46BkVuXavgTxI/Fqk+eQqGLfz16YN/kIeDApP7IR0fhSBOvpsPWQZTWUdYL9wxddfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tpLyygWiCd9X60rbaw+kAdWgXDed2KxbAjMPgAFvP34=;
 b=tJlta826CWL4cH0bZc94f3kv967qZxkha5l5orPX8HHzAb3rMT1ywB1jmCjJT57zNVdvcyo7IDYg83wtKjLPnFlcsihnLE3p9Sxca15bN49W7Zkftk776wg0NCLCRr2pGtuEJ2vtOeNfiGyY0U/Tpl2MDU+BZb0VDVPa0AYbHRc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4777.namprd12.prod.outlook.com (2603:10b6:5:16f::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.27; Tue, 1 Jun 2021 18:30:48 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 18:30:48 +0000
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
To:     Pu Wen <puwen@hygon.cn>, x86@kernel.org
Cc:     joro@8bytes.org, dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, bp@suse.de, hpa@zytor.com,
        jroedel@suse.de, sashal@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
References: <20210526072424.22453-1-puwen@hygon.cn>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <dc69a9bb-a4a0-d82b-2e9c-cf6336ab8252@amd.com>
Date:   Tue, 1 Jun 2021 13:30:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210526072424.22453-1-puwen@hygon.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0083.namprd13.prod.outlook.com
 (2603:10b6:806:23::28) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0083.namprd13.prod.outlook.com (2603:10b6:806:23::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Tue, 1 Jun 2021 18:30:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d60f5ad-3ccb-483f-5b3f-08d9252b6031
X-MS-TrafficTypeDiagnostic: DM6PR12MB4777:
X-Microsoft-Antispam-PRVS: <DM6PR12MB47772F9661CD16A2CC3063C5EC3E9@DM6PR12MB4777.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:541;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yejscmoM6cDnLm1zeP+4QwhrKOPEgSphqy24FMT1pqnOX9z99KY/prMmPWZa5NAA6nYHKv1lSYVRIzHup1eqAPYkkUbijYfr/zcQAiO/Rckm00dkbPPbSi+XVzYaj6kmgnO7zTbItccAlP4evtFX40coUUgFruOVqRvANesVYbX2AaCpE7pTIyTuiRIRFJ8aH2b0Ez7gAzohRGotyK9M6a8Ih8upzk46ZD2ImBUoz4WlcVsGCtW1jUy0f6whmpBE+USMajA7tjNNlfyCVEy0H9WtakWC4SEf8VZA/Xkc3yY+/PIs1YFrjxNcyDk5iOvTH5MBDZN0PhkAwwmOeVbgPahHewHHpqN0M2hw2j7H3Ozoh2LpUS0whI2t0swokOZ3tJbATDqL6ynB1vOXBTHzpi4q0GICVMMfEyCDsFY4DGiYwjxiNXBLeDqi4WgnBP3qJWZjmGJB8JsGGUPP6Z9lpZVgl2nP17UAKHMv+H5pQGMWpoqTOfkJwlNqoPIDVEy5Jp8SmZeJtxZTHqtOz05w98CCKRAA+x1KvgpzZQGvpge9Mgmw1MnQ6nYmIRDHhSR4NOSaG3Ea0DQwUhxpC+KsF63KsW/hRwhgz0pT3HubBZA7D5AWDbXNVbTO5WgispTnHP4e0w+FjZkCCRbx3de9uBcesbVvY8TWLY1dsp9mlf8Naike7djGZVg5d36Ifj6E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(346002)(39850400004)(396003)(66556008)(66476007)(186003)(16526019)(2906002)(26005)(66946007)(86362001)(4326008)(31696002)(83380400001)(38100700002)(6506007)(7416002)(6512007)(2616005)(8936002)(6486002)(36756003)(956004)(53546011)(478600001)(8676002)(5660300002)(316002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?M1VhMDA2RFdLNjE5VXlaN3pnMHovZ3J2Q2pkRy92d2JSZXNETnQxaEZCUnYr?=
 =?utf-8?B?VUZ1aEUyVHlCc0V2Q0Y0UVc1VTBZWnJWbHlrVTAxdFVXT3drelY2ZC8xbVVN?=
 =?utf-8?B?RUtINkh5VVoyUnZvKzlPMW1ZTWdPU2oyN1J0SHg3SWJFMjZmV0VRdXJIZUU4?=
 =?utf-8?B?RVVmRWo3NmVkdmUyQlJNbk54UGtVeHZJN2RidEg1V1V6aVdGYnUrNGNTQVBC?=
 =?utf-8?B?OEtzZDM2Y1l6ci9BT0t4YmVrUXRqaXN0aGlqWlhrb1U5eHpFVUN3bWpFU1pZ?=
 =?utf-8?B?MVJPWmJRTlFROCtpdUY4NVYwT2lqOU5mdG1UbXVsYXlML1VSNmNVeFBXU25T?=
 =?utf-8?B?a2g2UWJWaHJxU1Erd2d6RGdSQWdJelMxc0ZOT1kwd3YrRXZPUlp5TVlZVUx2?=
 =?utf-8?B?R2dHb1FFL09UYldpRnEyQVNKWWpMdEpWTFZidW92NUVYTzRBSWNCNWo0YWda?=
 =?utf-8?B?bWxEWGQzOTVtRjBVOEVyKzROWVVtZjh0bThTb09hSEk5dWsvbEtXbWdnOTBI?=
 =?utf-8?B?UjFZSXgwS3lmOC9PZVZrUmgzT1ovcFY2S25vMVBTVUhMNHlMcENrWVhaTm5Z?=
 =?utf-8?B?cmpWMW8veHVVMDlPdVVITTZHYmJUMmZLMlArMVowMVEycW1EQXFybEo1MmRk?=
 =?utf-8?B?b1V5SC8zMlQvNkZsTnRmaHNveFYwNVhwdmxmaDVzVGFjVE1VMkh0bGJzS2w3?=
 =?utf-8?B?dUEvbWlZclVZN2NxYlRNcUl6TlVSUmJSMktDSFlsY3hpK3NodEFNN280WGtG?=
 =?utf-8?B?Vm5rQUYvMlBJR255Q2Z4ZzdYS0NrSGZlUFNpNnE5RTVMYjVEeHhOY2JVSWNE?=
 =?utf-8?B?ZFlxNUx1UnV4alFUbklaUTVCRHRQSTYrdHFZVzgrOUlQS0l4M1BFcUR2ZTFw?=
 =?utf-8?B?OVdmWnFMZFlnQ1RtRGtyU2xUQndmNkpNQnZBcmFnMmc0eXVjMFZrOUUxTTkx?=
 =?utf-8?B?QldlRHJSL0ZZSHJUOE5tZkxaQU9INWtiUVdaOFh5M1Y3ejBOY0d6bldyTnZq?=
 =?utf-8?B?SVFLMitSSlhCSVhpTjBCYUl4VFZDbUhyK0ZnS3VIMkJYU3JNWis5Q3NTcHgz?=
 =?utf-8?B?d3VHeHhKODA3NzVlbTIrT09jTThjeG5SS0pFRWtISE91L0hLT1BVV3pDTjM0?=
 =?utf-8?B?RGx4aWxYcTFjVXRLL3FCNGY0OEM1ZXZOVGJVSmZTWDZxaEdoWUlxbUU1cUVX?=
 =?utf-8?B?UmdjYU43dEE1RFo3aGFLYzlSUlFGSkZ6UlhxSFlsTlBCemtDeDZYZmM4RXBo?=
 =?utf-8?B?U1cvSk9UYjhtM2dBRUpacUtDM3JoZUZyV2pxc0lGLzVMc3JtdUFiRTZmZjhi?=
 =?utf-8?B?VVdBVTZrTGwyUXBNRks5Ym5HcEYrWkF3Q3BBQUVHUG04Uk81ekxURFFwaWNv?=
 =?utf-8?B?eDFkcHEyZWxReWlhN2wwdE1DeWxkaDEwTFZ2bjgwNVIrd1BEelVkTWFSR05M?=
 =?utf-8?B?RXNDQzZPTzFLZk9yQnZuMnhzSDFPTldlUTVKVXFIMjFUL05WVERZS2wydW81?=
 =?utf-8?B?YjRIaVhYNnRvbGxUbEFmdldqOVRUZ3MyUkkvOUIxaVpCR1NjaG03S0dvRm56?=
 =?utf-8?B?S2NMOEN2K0xieTJldU44V2JKWEZ2UjNCbEVsQmI5NkxHTVgySCs2SkoxdWxi?=
 =?utf-8?B?VVMzQVRIOHBYQU9hRUZtQisxV2xOMlZ2ekRlSFlmSTBVRHgySkgxcnhQcWVt?=
 =?utf-8?B?LzR2dWhVWG1uOUw5b1JaRHhaVTBHenNoTWVoc1hya2xqV003Szl0Y1pNeWlr?=
 =?utf-8?Q?C5T8OxLTN/gFfgDsC0Wv8B7sliSxk9qLquFFRRj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d60f5ad-3ccb-483f-5b3f-08d9252b6031
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 18:30:47.9903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxHcOiM6ttD0yoYZKgZvIvdZMfho+UrHz9FnQe2vnlji8/CXfaJ3nLkz1L2+ICaBV5O1vtV9At+Qmrxy5qg9nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4777
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/26/21 2:24 AM, Pu Wen wrote:
> The first two bits of the CPUID leaf 0x8000001F EAX indicate whether
> SEV or SME is supported respectively. It's better to check whether
> SEV or SME is supported before checking the SEV MSR(0xc0010131) to
> see whether SEV or SME is enabled.
> 
> This also avoid the MSR reading failure on the first generation Hygon
> Dhyana CPU which does not support SEV or SME.
> 
> Fixes: eab696d8e8b9 ("x86/sev: Do not require Hypervisor CPUID bit for SEV guests")
> Cc: <stable@vger.kernel.org> # v5.10+
> Signed-off-by: Pu Wen <puwen@hygon.cn>

I think the commit message needs to be expanded to clarify the situations
and provide more detail.

This is both a bare-metal issue and a guest/VM issue. Since Hygon doesn't
support the MSR_AMD64_SEV MSR, reading that MSR results in a #GP - either
directly from hardware in the bare-metal case or via the hypervisor
(because the RDMSR is actually intercepted) in the guest/VM case,
resulting in a failed boot. And since this is very early in the boot
phase, rdmsrl_safe()/native_read_msr_safe() can't be used.

So by checking the CPUID information before attempting the RDMSR, this
goes back to the behavior before the patch identified in the Fixes: tag.

With an improved commit message:

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/mm/mem_encrypt_identity.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
> index a9639f663d25..470b20208430 100644
> --- a/arch/x86/mm/mem_encrypt_identity.c
> +++ b/arch/x86/mm/mem_encrypt_identity.c
> @@ -504,10 +504,6 @@ void __init sme_enable(struct boot_params *bp)
>  #define AMD_SME_BIT	BIT(0)
>  #define AMD_SEV_BIT	BIT(1)
>  
> -	/* Check the SEV MSR whether SEV or SME is enabled */
> -	sev_status   = __rdmsr(MSR_AMD64_SEV);
> -	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
> -
>  	/*
>  	 * Check for the SME/SEV feature:
>  	 *   CPUID Fn8000_001F[EAX]
> @@ -519,11 +515,16 @@ void __init sme_enable(struct boot_params *bp)
>  	eax = 0x8000001f;
>  	ecx = 0;
>  	native_cpuid(&eax, &ebx, &ecx, &edx);
> -	if (!(eax & feature_mask))
> +	/* Check whether SEV or SME is supported */
> +	if (!(eax & (AMD_SEV_BIT | AMD_SME_BIT)))
>  		return;
>  
>  	me_mask = 1UL << (ebx & 0x3f);
>  
> +	/* Check the SEV MSR whether SEV or SME is enabled */
> +	sev_status   = __rdmsr(MSR_AMD64_SEV);
> +	feature_mask = (sev_status & MSR_AMD64_SEV_ENABLED) ? AMD_SEV_BIT : AMD_SME_BIT;
> +
>  	/* Check if memory encryption is enabled */
>  	if (feature_mask == AMD_SME_BIT) {
>  		/*
> 
