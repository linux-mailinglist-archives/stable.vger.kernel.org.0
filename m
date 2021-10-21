Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F37A4362C0
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 15:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhJUNXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 09:23:40 -0400
Received: from mail-co1nam11on2086.outbound.protection.outlook.com ([40.107.220.86]:16960
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230379AbhJUNXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Oct 2021 09:23:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5NrDhimFxe2SRq1uxylyiCQOsetQBWaubu9eo6BNotvUvGvmMgcofrku+3qcYc9t0xPjqT3iSpJSrkvXoeAKyuCrXqfkafH6NsS3FBaXe9is4UWYEIlYIfpo4gP77ulVa4cH1b91XSi3OGQ907v3iyqD0MUqujytBtpGWfFZ321Dulqm9Arn5GCG/elboIDzgaQIx94E+1BSydOFoE7Pnzuo4uJZb3XkYXsmib5TEnygBRv5/kjZSardeMRx9CsfDh3HeUC3sQEtJJrFSYje9JDNfvPXo5zETMxqP2n5VQVFFJc3s751hEnzDA37qFH2k9dac9lNOqjQBzoqoqIvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6V57evmdGS8eiGYU3AIFpYLGt/qYelnmDajY2inyeew=;
 b=BN+1prkPEGICPtMS0eJH7ZXNRGMSZ9j0k2KuiYoLLdgrLrPggHeLXSX2LJeLJbE3oYT+VTBSIjXj3iy6GgPxEibtfMKVWTrGeJtoT8thiuAtJ7C3CUD6KuHyzdYHpcInRTMszie3yYHF3qR2ZYOT7smx9py5UkQEPMRMPme9M7bQGDUORxl6ViE1Azd0oXAAax3bRpo7WxKkLZyCzMgmdL75jry5M+kfyraFqCodVsBrSCxZQ5GGNc85vIOGmHNhSBbWgdp+aD2yPDKkIl/PdA5E/70KJvHmFX6pm55KlRI54NA+CAf6GXxKF6zcvptP+9lzcgujLSu8/J2Q+ItV+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6V57evmdGS8eiGYU3AIFpYLGt/qYelnmDajY2inyeew=;
 b=N5w0q76V2oF8TbwbEbx4jA+2bIYPhStalDJJEnfQVfHncpZvXH0RINZTTBWkPXIirxtJMK4RUDgdtBYzZXI3V9wK7Rsn32Kmhk0KMAS/eSb706kBbXE6p8D7/aM5P6iP22FJra6AxASE0ISEmPW09WxooceVlOagQfllTNGdIXc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5072.namprd12.prod.outlook.com (2603:10b6:5:38b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 21 Oct
 2021 13:21:19 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4628.016; Thu, 21 Oct 2021
 13:21:19 +0000
Subject: Re: [PATCH] x86/sme: Explicitly map new EFI memmap table as encrypted
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>, stable@vger.kernel.org
References: <ebf1eb2940405438a09d51d121ec0d02c8755558.1634752931.git.thomas.lendacky@amd.com>
Message-ID: <9d9ca009-93c5-acc3-7445-d514c7878478@amd.com>
Date:   Thu, 21 Oct 2021 08:21:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <ebf1eb2940405438a09d51d121ec0d02c8755558.1634752931.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:208:15e::35) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by MN2PR17CA0022.namprd17.prod.outlook.com (2603:10b6:208:15e::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Thu, 21 Oct 2021 13:21:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 840bea1c-df49-44a7-18dd-08d99495aaf1
X-MS-TrafficTypeDiagnostic: DM4PR12MB5072:
X-Microsoft-Antispam-PRVS: <DM4PR12MB50729B06C2B0434C36B39485ECBF9@DM4PR12MB5072.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YxfFw+uQE89Cuiew7BjDPayYoMCa3ctT0yIwankD8YABCn9tM4+A3Dhj6cBdPH8CrtPGLhBVoim9yCwnCJ/Ajs3kf/ADSVEt8CwEj2+y65QR12kokVrvUaoN5nqIGW9wjf6wfyrCHycPwPPAOBAYHaemZEd+EuYldNafY1NWO+ag2515UIue9IhppLNMCwfAvnIjbsjJ3R6O1pib+qVGQM1lqVqZYMgZ63PBWehlTtWDM58PGtpFC74aqulOJHECiqFmjZT4hWF8mVWFQIv3lHKQdMN5drkxw2fLJWEbBlOLYxqFRzbj+8uIxWVaUdoijOGPJCSQd8oqV3uukMhmVUalnOTnbBbCr1lddmYJF8uRQut3aIy6xeEXMURrShSKuP+npAXn09TNBX8tx6e43Vn8jmSqEjZkL9mThXmmVEejMeHxPdltZCyIalyARlC8cdm3hZigoeJPX0PuQXCVsvuK/Lffe3kXbWGlzvMt6gtceDIjFBH6ev/AVdveBPWmJVFIqvMxSl6mx7I7SGaT72i8obND+Sz8sfMsJMoUeDvho1L8HfWMR23ebIowNxHbH9RLniaPArqv5x5cPYEFICD69+Pvyawvi88Wg8lrUBEuzYnvkFZx7mtNlyY3mzGL26dw5qwXFTO2O2troIktuKUz8mIzmZ81tQOypaZ+U1FONhrSNRzUMbcEpcLnGyrUGsvHxpODn/ILPRLTw3hxwzBJAGWt/7Lj06wDOA+4Y3+aOWgJCe6NODSnAv8ZkED4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(53546011)(66476007)(66556008)(66946007)(186003)(5660300002)(38100700002)(54906003)(4326008)(6486002)(956004)(508600001)(2616005)(86362001)(7416002)(83380400001)(2906002)(316002)(36756003)(16576012)(8676002)(31696002)(31686004)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bndXOU52OUhlMGtOTGdvV01MeGlzTGt6bWUwM1pXbkxIRGptOVU4aFNqTFE4?=
 =?utf-8?B?TnVBTFd5SG5ZWDdDQ001enU4VEdmU3RsZTJzeGErb2huMnlMcGYvRmRTbVZY?=
 =?utf-8?B?OXFYTHpiQkxEeVBnN0JGeUNDVzlVN2lyM1YxNUxUUmwvc2Z1Zmp1TURlSVZj?=
 =?utf-8?B?SWUzYmw4RGRkY2dMeHMycWtmZDdtN3lMYjhzc09XMGN1NnRSUVoyYmF4NXE4?=
 =?utf-8?B?NXB6SERaOFJkTzRQNy94VmIrYThiTGJOZmg5SzhvV3NNbWNWK0w3Vk9WRXAr?=
 =?utf-8?B?cCtMMkxhamsxcnJBVlZwOFFGUW0yMlRxR1RXeUVEUDB5eHY5WjJlMHREQzgv?=
 =?utf-8?B?UzZzNjNHajZxOHhxeEFoSkZ0dFVBdHdncDdjNmVISHVTOWtQWi9KMDZlc3k4?=
 =?utf-8?B?OU5haGRxNGp0VTA2Kzg4bnRGUi9scjM3dXFJTnNrbm1nV0tlMzVvSExPRTdZ?=
 =?utf-8?B?eG1uRVpkd3FBdk10NHN4ZWpmOHhBZEhzQ21HZExFeXhrY1Q3VEwwaXEwYXNT?=
 =?utf-8?B?MjRoYkVYZFNtdzZWY2xkSC91YU9EMGJjakcrWEIxWjVnOC9WNmZ1OHZaSjhl?=
 =?utf-8?B?TC9BV1ErKzZEZHlLQitWakNrQjZ3YzBrakltUlV3T0hVaVpvVjBGQjlQS3FD?=
 =?utf-8?B?LzUxcWYyaEpFQ09aZ1YzSjlsNWRWT1YvWWYrSXFldkZGZ3kvdFNFWmZKRWYy?=
 =?utf-8?B?Q0FBb29KaVJmQU5yS0J3bDRTd3JKUlhZMjhYYlZ3QTA4ZEhqRU41cVhZL0E3?=
 =?utf-8?B?Y3BuNU1NaW9LTUoxOWpPMDQwd3p6bEQyYVN0cDQ0b0crNWRTdkhpMVZmVXQy?=
 =?utf-8?B?K25XMWI3amJqOEQ5RnJ1bVdPRndrcWV1ZUcvbVk1MDVXeXZQRnpOcXY4QjRp?=
 =?utf-8?B?NW85Z2xKbFJSTm5iZFJISThtTk5XYVJLZitsYS84N2hVcHdlNnRQdWtzcGM5?=
 =?utf-8?B?dWpHMzFNNHJGSVZJSFRQRW9UZE1aWHJEcnV6SW9GK0UvclpQczBqZE4va3ha?=
 =?utf-8?B?ZGxQazFFWHllall2WlhFaE9ZRUdnZTl0U09yTHp5QS9QQlQzc0grVmlXeFBs?=
 =?utf-8?B?a0ppc1NsaWJ6dklaT2xQbGlNakM1cmszcHY3L1BnTmFTTENiOWRHR3JpdWg3?=
 =?utf-8?B?dGJ4NmQxOUt6MXE1QkIrUHJOdXpDS25XeHZCUjAyY1YwejgxODgzRFF3Z3B6?=
 =?utf-8?B?RTdHaVNMellQUXEwRlVTTVY1cjBLODBPWlVhRGRtaU1VWXBYS3VodzdpQVVV?=
 =?utf-8?B?WTJST2NkZGZ4S1M1SlRvMU0xa2FJYnBXSEZxcEpySGRWMU5EcE1jSHh2ZFJH?=
 =?utf-8?B?aEpFWGtoTi8rdHl3QkJkTFUwZ2h2dk5hdzMwa01sVlZVUnZJbXlwZjMzTHBi?=
 =?utf-8?B?NkZVelFWZnhZbHJGN0REbUZvVEVuY0lYdUU4WUM4cjlyVGVZT0l6R2Iyb0dR?=
 =?utf-8?B?VmRJWVNKUVVOdFE3a2FjWmpkc3J1cU5Bb2dRVFpUV2dIWHViOUJSb3lxeDhm?=
 =?utf-8?B?T2VCTmZVYVdnd1B6ZkRmRGNMNG5uMUtBZFJxVTVjNFlZNHE4eGhiSzV4eEF4?=
 =?utf-8?B?ODc2ajA2OHR6UzdBTnF5U1p3b3ZCa2d5WlgvY0k1M3liMm56RGJISzZkaDVQ?=
 =?utf-8?B?RUhpZ3dZQjY1RUFLdGFqQVFtOVFkOXFzRVZXTkhITGJFdFdyejdGT1EzNTR1?=
 =?utf-8?B?OXFlSjUxaHZvOW40VWQwVWdJbzVGRFA0anRkY3Zaa0tTVWlXaWVTcWVuVmkz?=
 =?utf-8?B?YmVmV0NSdE12OVY2VnFzdzlnblJOVEcyMVpHNHY5blMrYjF2TmJQSUtXR2p3?=
 =?utf-8?B?cU50dE1aQmZCMG82UXZUT1V0THVnZ0hVN1FSRjN0N2s3bHptNUROeWJ4bnZ4?=
 =?utf-8?B?VFJ2N3EyV2pEUGFFMTJrTm4wTzlBL2xobWo3YjBqZ21NS0JyRXhzREFXc2l1?=
 =?utf-8?Q?guOBkgzITMU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 840bea1c-df49-44a7-18dd-08d99495aaf1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 13:21:19.3360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tlendack@amd.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5072
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/20/21 1:02 PM, Tom Lendacky wrote:
> Reserving memory using efi_mem_reserve() calls into the x86
> efi_arch_mem_reserve() function. This function will insert a new EFI
> memory descriptor into the EFI memory map representing the area of
> memory to be reserved and marking it as EFI runtime memory. As part
> of adding this new entry, a new EFI memory map is allocated and mapped.
> The mapping is where a problem can occur. This new memory map is mapped
> using early_memremap() and generally mapped encrypted, unless the new
> memory for the mapping happens to come from an area of memory that is
> marked as EFI_BOOT_SERVICES_DATA memory. In this case, the new memory will
> be mapped unencrypted. However, during replacement of the old memory map,
> efi_mem_type() is disabled, so the new memory map will now be long-term
> mapped encrypted (in efi.memmap), resulting in the map containing invalid
> data and causing the kernel boot to crash.
> 
> Since it is known that the area will be mapped encrypted going forward,
> explicitly map the new memory map as encrypted using early_memremap_prot().
> 
> Cc: <stable@vger.kernel.org> # 4.14.x
> Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
>   arch/x86/platform/efi/quirks.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index b15ebfe40a73..b0b848d6933a 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -277,7 +277,8 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>   		return;
>   	}
>   
> -	new = early_memremap(data.phys_map, data.size);
> +	new = early_memremap_prot(data.phys_map, data.size,
> +				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));

I should really have a comment above this as to why this version of the 
early_memremap is being used.

Let me add that (and maybe work on the commit message a bit) and submit a 
v2. But I'll hold off for a bit in case any discussion comes about.

Thanks,
Tom

>   	if (!new) {
>   		pr_err("Failed to map new boot services memmap\n");
>   		return;
> 
