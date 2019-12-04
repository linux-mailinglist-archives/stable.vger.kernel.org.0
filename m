Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767F3112F14
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 16:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfLDP5V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 10:57:21 -0500
Received: from mail-eopbgr790042.outbound.protection.outlook.com ([40.107.79.42]:23589
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727008AbfLDP5V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 10:57:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FK+9OuQo9dgLfVhWdzuMK/ZnuzzQuakph2Ck5vODusXKejxHN05cDQ4aNfcdnVN0c0mK3VW7SVkxn9JJi5tIWZIDSSVdm71gJFkNQny6s7zJ9KxseKitM/PVwP2x2Dma43W/mMVVvMUl9two5ZvYWfoqeBwZVc5ZDK5xD6c5ywXg95oip6CiobUfS0AEjgadJpg9TVJK/Lq/0GYxhbH2v0L0OFs+DdWjtNGOBKipqKn9s0Es6vanLzsUc4KMHVHFtcpB+RPxIbc3/p6BJQbHwEnfkhmtGDM4noilU43JxAn3/h2M6L9DybcM2DZWCUsI7Rj1Lp7of7PJR1hpL75W9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbfMhQG78o8HkyaGhiYpQ6euyVURvLChY/j7nT0OEpc=;
 b=ffdd9muenqWj1nFGqrUHchSc2hO5soXxrEDGj7yTD3o6Sw5bv3vfqUOJoejbYM0r2vk8w3W8OTMcZ+j733U/ZF3ip3Ia59pBcm32ME46PqGWvlIHgLT2o5Ivh1WapxBBbQshIAc8ptXeFUYtovi6q0hupYciQX7UzGmh7aiSmFzneHuSVyOklgrJYgdxSfBujzC6HBuV+lpzY2v1QMpv7D/81gVMjrigFlz4fCvF6P+PhdmwyGeiGJhMvksvUqB2xxZIlrRnKWodT5/ePnCGzXg3TPpREM5h7GdbPlHxjHT3zataDAJZo+PHR7jsfMskt4fMe7WBIQHJtdgeAXbPWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hbfMhQG78o8HkyaGhiYpQ6euyVURvLChY/j7nT0OEpc=;
 b=aLhgRbbKdYfiZctL3/6KsG9VdeMcfrv4n8k7FsHthSVoRcr20Lfy9VeTTf61fG5iJQ3nFT1l2N9DvnR0aIVqZ1ycIETjXnBT5YHDcbOgZgm61n3uenZyE7AIDpkl79y8jD2FYyiQCI/pZtgkYpGlgHR1IzulbKnHycbLZH8GKRE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (20.179.71.154) by
 DM6PR12MB3257.namprd12.prod.outlook.com (20.179.105.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.19; Wed, 4 Dec 2019 15:57:18 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::dd0c:8e53:4913:8ef4]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::dd0c:8e53:4913:8ef4%5]) with mapi id 15.20.2495.014; Wed, 4 Dec 2019
 15:57:18 +0000
Subject: Re: [PATCH v2] KVM: x86: use CPUID to locate host page table reserved
 bits
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, stable@vger.kernel.org
References: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <8f7e3e87-15dc-2269-f5ee-c3155f91983c@amd.com>
Date:   Wed, 4 Dec 2019 09:57:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
In-Reply-To: <1575474037-7903-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0014.namprd21.prod.outlook.com
 (2603:10b6:5:174::24) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a79e736-6e92-4ab0-82ea-08d778d2a38d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3257:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3257C3B919C13B03D90CDDCBEC5D0@DM6PR12MB3257.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0241D5F98C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(346002)(366004)(396003)(189003)(199004)(66476007)(66556008)(31696002)(6116002)(230700001)(8936002)(6512007)(3846002)(31686004)(25786009)(36756003)(4326008)(14454004)(5660300002)(6246003)(2906002)(478600001)(99286004)(81156014)(26005)(6506007)(2616005)(23676004)(53546011)(81166006)(186003)(229853002)(305945005)(50466002)(66946007)(65956001)(58126008)(8676002)(6436002)(7736002)(6486002)(52116002)(76176011)(86362001)(11346002)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3257;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FOs8OvRqZnhTn4XQ5rCJy8PUFFmWD7xMVFxFz9b3oiP1WdSTX53VTiqcMpjnL6CNHMLub5+cGp6TtEwuamGtoMZgJmnFDQYAck4KP8EENxjktsvR6jsAEdB7+mgpCiW2n/fo1loPMx4F3DPUabIGGGos44n1ILAEb3eRpxzrLlXJ+YQtjc1TG8LGeHkgHGiG4srvt81hZf+uaJPqKI9QvqLWxaRAsmH68v4balpmoaF3DN5SDNdGfo/OVrDWLo//9/YMlPxxpZX6UmgY2LCY8vL1vRmDdqciu/xwmC1wSZLLR3Wno6fDmjdIkrPRHscsOHeNdDIXkOl4BXfo0Hiktus6C4W/Axd4y8ZsyLJibm8FUyFWVlb/TZltaYacnAoJpsOlxu8x5qLrKuJMOS5lSGTrVN/LO4P2hi1rYfbkbiJ/3UZs29wtYSbKEoyz0xlm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a79e736-6e92-4ab0-82ea-08d778d2a38d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2019 15:57:18.0768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F95ax/b/2ti/O4VU/eyRFiqem7n/ovS48pz2+29kUTNaM0aELmOnXsri27YZs2JdbPO3XssMF6Tr7ERsGMErHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3257
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/4/19 9:40 AM, Paolo Bonzini wrote:
> The comment in kvm_get_shadow_phys_bits refers to MKTME, but the same is actually
> true of SME and SEV.  Just use CPUID[0x8000_0008].EAX[7:0] unconditionally if
> available, it is simplest and works even if memory is not encrypted.

This isn't correct for AMD. The reduction in physical addressing is
correct. You can't set, e.g. bit 45, in the nested page table, because
that will be considered a reserved bit and generate an NPF. When memory
encryption is enabled today, bit 47 is the encryption indicator bit and
bits 46:43 must be zero or else an NPF is generated. The hardware uses
these bits internally based on the whether running as the hypervisor or
based on the ASID of the guest.

Thanks,
Tom

> 
> Cc: stable@vger.kernel.org
> Reported-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6f92b40d798c..1e4ee4f8de5f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -538,16 +538,20 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64 accessed_mask,
>  static u8 kvm_get_shadow_phys_bits(void)
>  {
>  	/*
> -	 * boot_cpu_data.x86_phys_bits is reduced when MKTME is detected
> -	 * in CPU detection code, but MKTME treats those reduced bits as
> -	 * 'keyID' thus they are not reserved bits. Therefore for MKTME
> -	 * we should still return physical address bits reported by CPUID.
> +	 * boot_cpu_data.x86_phys_bits is reduced when MKTME or SME are detected
> +	 * in CPU detection code, but the processor treats those reduced bits as
> +	 * 'keyID' thus they are not reserved bits. Therefore KVM needs to look at
> +	 * the physical address bits reported by CPUID.
>  	 */
> -	if (!boot_cpu_has(X86_FEATURE_TME) ||
> -	    WARN_ON_ONCE(boot_cpu_data.extended_cpuid_level < 0x80000008))
> -		return boot_cpu_data.x86_phys_bits;
> +	if (likely(boot_cpu_data.extended_cpuid_level >= 0x80000008))
> +		return cpuid_eax(0x80000008) & 0xff;
>  
> -	return cpuid_eax(0x80000008) & 0xff;
> +	/*
> +	 * Quite weird to have VMX or SVM but not MAXPHYADDR; probably a VM with
> +	 * custom CPUID.  Proceed with whatever the kernel found since these features
> +	 * aren't virtualizable (SME/SEV also require CPUIDs higher than 0x80000008).
> +	 */
> +	return boot_cpu_data.x86_phys_bits;
>  }
>  
>  static void kvm_mmu_reset_all_pte_masks(void)
> 
