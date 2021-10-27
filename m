Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834EC43CD2C
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 17:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238172AbhJ0POM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 11:14:12 -0400
Received: from mail-dm6nam12on2070.outbound.protection.outlook.com ([40.107.243.70]:11105
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236709AbhJ0POL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 11:14:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R2oc+s7NipBF2uewd9O5hclrqnk2H9dfLYGOAFmnmKH19MTzCigL4ZpGHyO3aZ2squ+wjr5ANKqPJZvTspFOJ11eeLCLx/1w2Xw8cLF5JBL2rnPmcOHMeqm0cnvaIKfwEvWcud/zGSILzMxTLhrAL8m4B7RkodRw5p6bZjKMMJcM3dQ8v94Pc2XislBhIlGezAb47CvPXwtE5fvSjyp5SZYQdG1IlgLpV6PIB6pFc+T46Y6ushgt9nrhx5rRP/pDaTP5MgKaTUN22HENfG+8ybo3OzhJEFbfnyogpy7i12Wo/9mv53bPre6lBD/SYBE1ellwepEbvf33gWGIsc3cMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZa4ULctBWnUHsTT1790sHV4VshTYOrL/uvBmJNXdcY=;
 b=ddKXFfdh6CfNgiGarvvzQh4JVIHU2oKYL76fZzrX60m66mSuCqqWLg7GXDicRlO+Fkb5yb03/RQp2jbcWn313N5dLJLMUDt+iaXayq67tvxWJjKjjM7TBvly+hL7ESSELg1W8QX177Ke8ZspW1rGh2aTfexW7W7WSnajxuO1cTG7uoS2OJBszPrZHNkY4vUqyyI+2pjQrE0WKaB3vPxGqulmEG2mp6lOWWcc9if0Qjrcb6KAjTP2vvzsBuJjJ4k1tOeiIVanAA0NIDhrPwcN56nDqDVr/6tyqYCuoLKGH0u0eC0sz9GIx9eGAJxIgIQdwse8fJgo63B0IOEKDivS6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZa4ULctBWnUHsTT1790sHV4VshTYOrL/uvBmJNXdcY=;
 b=e94FmgcmgHbuV4YArzKmXJ2l9qMFA0qp2UsN0eDDuaxTXx2Kwfy9AVWOLqs0E9mceTf+XB6G1X0T1DmLLTL6cEHh0U/3OgOXcfU5ln7h27qNrok4JwflIpOXlIvNI69LSaQ8oIH6XdNRPc1im13B8it27wUlOY+5lVic2aoXICQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5246.namprd12.prod.outlook.com (2603:10b6:5:399::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 15:11:44 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::a87d:568d:994f:c5f9%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 15:11:44 +0000
Subject: Re: [PATCH v2] x86/sme: Explicitly map new EFI memmap table as
 encrypted
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
References: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
Message-ID: <c997e8a2-b364-2a8e-d247-438e9d937a1e@amd.com>
Date:   Wed, 27 Oct 2021 10:11:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <8afff0c64feb6b96db36112cb865243f4ae280ca.1634922135.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0101.namprd05.prod.outlook.com
 (2603:10b6:803:42::18) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from office-ryzen.texastahm.com (67.79.209.213) by SN4PR0501CA0101.namprd05.prod.outlook.com (2603:10b6:803:42::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11 via Frontend Transport; Wed, 27 Oct 2021 15:11:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd7239fe-6875-4b0b-657e-08d9995c1609
X-MS-TrafficTypeDiagnostic: DM4PR12MB5246:
X-Microsoft-Antispam-PRVS: <DM4PR12MB524633F8746F63FC3E640D83EC859@DM4PR12MB5246.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MFcruFJecNpKiBKcillEdFDVpBrjGfIGFD8Eomt84mJDJukzFxoG2Ho8zKdpUWBaVWXQ2Oe7See7gvF6JVYh8/HYbgCSVNvMX8foFG798Qz1Hw4vv0kUr0Zo1sszRlOZXvclMwE4pVeWSQpDDEhs8M7shWFrziF9CdIVobYoas5KA+y/UQTaI67jJf18V8Uy5lXE+3wJ1NH1xGWSVP7sm8Dk8GoRMtla2pmUGtAQF/M5RN+z9WIKecvdhXPJPvGzj1Jmi1GcrPhq3i4eMstp/Xpnz/a/zZCR8tfAwttyPFoJ6HYQkRwtLPnfrLuQAnVHKvUuTuaGhO0BM0u4f/darL8iVI2Pr2+15wFItopF86EmR/ch2aAqDLxn5LAlHvfJuw3IEuCfS5me+8sxwMpEf9BvjB7bYIA6eN2hXRsfOl6AsdT4119cuXSYQFkg7C8/mC/0gByMbmdt1S4l2tjtHUSmDT5ORjoz7X1Z8MWQHam3Gbx4lhRId4QQ6Wc38m1TTA1HZh28iIojU5zTfNYj3D3ACOI1RSNzvyo/DvKTEkXTNKrsrznZKfAxQEMHa9JRv46wRAbOM0jBo1xswMA+cStlpqGMUnDPhCzVFlhIPuBBoZZXPe9jjdtRoTpAyx9nTeI1z9mn+N13/FvyDIl3y+rovVXnNtAeOu08Bk4MoZz74NRHwYt/pw1rZbFDTmnEKOA9MSxg+mUTH9YvVZA2lUrqctyLsfPyz+FUAOZ6woI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(26005)(4326008)(8936002)(7416002)(66556008)(66946007)(6486002)(53546011)(83380400001)(5660300002)(6506007)(2906002)(31696002)(54906003)(316002)(38100700002)(31686004)(186003)(2616005)(956004)(8676002)(36756003)(66476007)(6512007)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTU0SnlrV0tBM21jeDVVanF4WkZCRDhRWDROclo2NDl6RW0rSEtXcUZrL2lq?=
 =?utf-8?B?Zi9helE4aVNTSWJXS1pyc0lNUnRXWW5obVdsWnRZbjczd3E0TEt4VzYzV0Rx?=
 =?utf-8?B?aUE3anJKOVVaWEFZRTFObkVQaUVTQ1BJYWdSZHIweEZnNCtIUmVIU01pLzZP?=
 =?utf-8?B?cUxmc2t4c2loaGorWUVMRGE2RkxuSDZkcy9vTGM3R2ZNTnpZempCTmZ2ZE0v?=
 =?utf-8?B?Q2tsdmRRZUo2UXBwckRJQXJNaXBxdVk2L05LQlEyNDEzeVVabmpZUHZ4dWNX?=
 =?utf-8?B?STVYS1dIQmR1QkdRWlUyb2dJVXFIWmFZWk9DYThrOU9CVWNTZU9TNDczZ2JJ?=
 =?utf-8?B?NG45M25kRWpYL2NscWVXdDZGYSt3aEN4MFJzQmN4SkdydFNscWQ2NUV4Tzl0?=
 =?utf-8?B?VlhKVEFGZlRtZjhsOHgyRmYyR2NsZzlaYlJFc3AzdDlpcmxZTVdmU01FcVZv?=
 =?utf-8?B?YmlPQ3RiMWFOeksxVnpVR1psSE1leHhXd3NQODRiV0krZzlNa2wzTmhKcUh5?=
 =?utf-8?B?NldoQ3pHYmpnN2lUMWoyT3d6L1pTcnFVT21xdWRqanU2MXJqUW5SUFdzd2d2?=
 =?utf-8?B?eVBIYmMwM0FNcUZtVkZoV2dlRGJRWS9DMnEzc0hUZnNGZmhDc2w5c2VxRGNq?=
 =?utf-8?B?TDhDTUhOeE9FRUtRNmdPWFl4Vjlyc0laVzZIUk84UldyZVhrcjNLa1V4VXZz?=
 =?utf-8?B?cjFxRWM1M0IwTVJQMUNLWngydXBROXNJMVBkM1FYT0p4VUlUNVNwUnRHQlVI?=
 =?utf-8?B?UTJEaTRSUXc1RlZ0RUVGYmpjYmpiSGVlcmR6ZnlKYnVZV0RKTTFQTm5JTVBM?=
 =?utf-8?B?UTU3OGQrSktpYW9wQVZGazhRY1pOVmsyYytlcTRqVHdHcU1NT3EwTnNKZFVk?=
 =?utf-8?B?WDd1MlFqWTNobVNzRkthY0xFekdyZFExcndBaXdLNGhCZVNEdDVCZkhOQTJW?=
 =?utf-8?B?ZUVublJCT04xMDlyL2l4Wkh2aitKYSs3WDRRVDBleUVvVUdpdEJCWW1GZ1Vn?=
 =?utf-8?B?UlNHWk04UU9nVGh5Y21YUmJUMzdVNHNMY2plN1V1ekdOQ0tjSkwwTUpQZXNH?=
 =?utf-8?B?ZFcrN0pvR254YjVTQ0pYSFJacHlmeFdQOTV1ZUVvQXI3WWNkQlQxWEZtSmxK?=
 =?utf-8?B?QUEzSVNhZlFnTG9QVHBNcDJuMFZLUGI5a0I0Nm9KaHRzcEFZRW5ma092NGRn?=
 =?utf-8?B?WHF3QStaalpYeTZuK3Fja0w2Mkw1cEV5WWRiem8rVnY4NnFBL1RqVFRlREpY?=
 =?utf-8?B?MTJNVjJlRWFVc29LbExuSzB2UjJ6cjlRK0xQbHQ2b2tOZHhUZDBwbFV5YjBU?=
 =?utf-8?B?cmFqblN0VjJWa0loZHl1eUVxaU5BMWZUZ0VDWjdoenhGc053aWZPSnc2TTNa?=
 =?utf-8?B?T3BHTEI3cU1GclBFaVVsKzlYeTZUaklXa0tXZzJ4cSs0cm4wbUdEMjBBZUVT?=
 =?utf-8?B?NldUVXUxMVNiM25DT01rVmFCYlhXYUY1WUZhZmEwUytXbUFQK1pLNzYzbm5T?=
 =?utf-8?B?c3Z3cnpSYWQrMlZkaWdTWTNuaUlROGZlNmZMa0FqblpkdVc2T2tVNzdqVzh6?=
 =?utf-8?B?V0Rpd1VpTG9xekNaMlo2ZTYvTmNMWXhhT1R3MWM5b0grZTBtOW05Y0tXYkhz?=
 =?utf-8?B?b1EyV0FtVU9WTDN0am84Mml4cGxGcFZ3RjVOeE5MNGh4bGJrYnZZaGdiVWpW?=
 =?utf-8?B?RUFIaklhWHh1OXBTUUlocHpSRDhNNXNjNDNDanVxZFozT3BTUXMzS2Jobndj?=
 =?utf-8?B?WjUwMmtPUEZTSjVFT1BML2NKaWFZY3dSMkpWa3hSeUFNWms4L3RTYVhscHpa?=
 =?utf-8?B?TFJsZWZnekZlc1NVTUtCdjlXWnRPWllKUlBmK2xpYlMxL3JPYUVkTUkzM1BC?=
 =?utf-8?B?Z2JZRko4enVSWXZFV3NDUisvd0ExYVJZckM5TW9qOU00MmxGa2xwaE5WM3lX?=
 =?utf-8?B?R21tcldSdVdDZWxycXRCQlJzam5TbW1PTHRDNmY4VlhvbjQwTWpJVGNYcnlk?=
 =?utf-8?B?M1NWaGZhVEh3MWMwRDBlVXZCWE9WSHE4TWtSK3RWbTdxbENLcHhiSFRsRThj?=
 =?utf-8?B?TXdrZ3dDL1kzcWI5TXZFOXczYVhNclJlOUZPVktNWnBoUS9jeTEzdkY1TFhu?=
 =?utf-8?B?Yks3OEcveElhd0U1WXprQTVBNnlhSWZyc3dwMTJXVUUwZmxyTlcyZFhrcnVw?=
 =?utf-8?Q?StzEP+xtKwhyz4MpPJIAEig=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd7239fe-6875-4b0b-657e-08d9995c1609
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 15:11:44.1066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xLESfygwYYy5i+b1oqLVWlbCubWi4t3U+oLsfDy26OIec6jn0d/7gCwPqf76kKLpi2i/pqbe5ikowXMdW0IYhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5246
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/22/21 12:02 PM, Tom Lendacky wrote:
> Reserving memory using efi_mem_reserve() calls into the x86
> efi_arch_mem_reserve() function. This function will insert a new EFI
> memory descriptor into the EFI memory map representing the area of
> memory to be reserved and marking it as EFI runtime memory.
> 
> As part of adding this new entry, a new EFI memory map is allocated and
> mapped. The mapping is where a problem can occur. This new EFI memory map
> is mapped using early_memremap(). If the allocated memory comes from an
> area that is marked as EFI_BOOT_SERVICES_DATA memory in the current EFI
> memory map, then it will be mapped unencrypted (see memremap_is_efi_data()
> and the call to efi_mem_type()).
> 
> However, during replacement of the old EFI memory map with the new EFI
> memory map, efi_mem_type() is disabled, resulting in the new EFI memory
> map always being mapped encrypted in efi.memmap. This will cause a kernel
> crash later in the boot.
> 
> Since it is known that the new EFI memory map will always be mapped
> encrypted when efi_memmap_install() is called, explicitly map the new EFI
> memory map as encrypted (using early_memremap_prot()) when inserting the
> new memory map entry.
> 
> Cc: <stable@vger.kernel.org> # 4.14.x
> Fixes: 8f716c9b5feb ("x86/mm: Add support to access boot related data in the clear")
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Ard, are you going to take this through the EFI tree or does it need to go 
through another tree?

Thanks,
Tom

> 
> ---
> Changes for v2:
> - Update/expand commit message to (hopefully) make it easier to read and
>    understand
> - Add a comment around the use of the early_memremap_prot() call
> ---
>   arch/x86/platform/efi/quirks.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index b15ebfe40a73..14f8f20d727a 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -277,7 +277,19 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>   		return;
>   	}
>   
> -	new = early_memremap(data.phys_map, data.size);
> +	/*
> +	 * When SME is active, early_memremap() can map the memory unencrypted
> +	 * if the allocation came from EFI_BOOT_SERVICES_DATA (see
> +	 * memremap_is_efi_data() and the call to efi_mem_type()). However,
> +	 * when efi_memmap_install() is called to replace the memory map,
> +	 * efi_mem_type() is "disabled" and so the memory will always be mapped
> +	 * encrypted. To avoid this possible mismatch between the mappings,
> +	 * always map the newly allocated memmap memory as encrypted.
> +	 *
> +	 * When SME is not active, this behaves just like early_memremap().
> +	 */
> +	new = early_memremap_prot(data.phys_map, data.size,
> +				  pgprot_val(pgprot_encrypted(FIXMAP_PAGE_NORMAL)));
>   	if (!new) {
>   		pr_err("Failed to map new boot services memmap\n");
>   		return;
> 
