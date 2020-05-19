Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17AB1D98AA
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 15:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgESN4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 09:56:14 -0400
Received: from mail-eopbgr770048.outbound.protection.outlook.com ([40.107.77.48]:8191
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728750AbgESN4N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 09:56:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wfzz9aSmDJGqAAmr83I1ddTnKliqBk00HICcVkZ9+XR8iENsieMzXjMFT2qZ/285ycpCLaUDSq5uEHtyUDjjBNZLFB3m2GgvmNA7sUnjndc9CCH5sd/4NNU3rzn5TS4cvGpEUtWVskR42jMH9huysAecULyGvCrih2kuWwSD7O1iKErVzd4lYpgg4cciYbmXD34vOl8eKlcLwFjIuI39/R6WczBsn+5QYJR7YH2Z6K/M15EgXHfRwYiDiN4y7DXG8p+ys45SJ7UQ5EYG6rWA8l9UBJdgu/mPAfKAIAypDkc2N0GeYp4mTZQVrn4cMVx0nBgfWktvEvJ+UFr1yZyEQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90bkR0ailBzcXzWNAWSpIpdydF073Io5nrKOQl3RXTU=;
 b=hB5TYjpj22VWczDTsfzR3qCt6xFdxzNptakPtrBrE2Hj4aXu2XHkNmv46Od0K+mhod6MaiCf8xgIAqQAOuvs942OtMPVe1dh0v4ryUM+llwVETPSyuW6L7cky9DBziXF8qWzW/U4iefi59hMn48kvBQRxwnFF0jetEXvOE8kMC8h2Q3uiy68wuUASVgXoUBhAegSSBfx6ys+KTrCwRfCGaOrJ53P+EKfuZEN7IoF3/RGAydRM/Ynt5jTAcNbGP1YLPElqpvXbfzVhW86pqv9E2irPu8rQ2KH+f4DSrKIzMFF3wuvKvAmYLkPiyaYh9zKecrPBWw+wl/4+qF4h1OCpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=90bkR0ailBzcXzWNAWSpIpdydF073Io5nrKOQl3RXTU=;
 b=2MfUI2woCtMXcT1YPWNcBFOafsIIQ0y6DYSOZ0Cv4/vqYLvHGUDZJ5lk3cIbSkbJ6+Lxjas1iNZfjGeIz2KPZx+340uYUEZxIu26DOWV+N3XcMesD4j0249Phx0AZ6G5YU4eMA7pZ/vAeFyuug2V+kwUwxPYHRMsRxZKffPVoNg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2485.namprd12.prod.outlook.com (2603:10b6:4:bb::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.26; Tue, 19 May 2020 13:56:08 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3000.034; Tue, 19 May
 2020 13:56:08 +0000
Subject: Re: [PATCH] KVM: x86: only do L1TF workaround on affected processors
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200519095008.1212-1-pbonzini@redhat.com>
 <adb8a844689f1569875b1e6574ce7db4962e611c.camel@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d1f27df9-2f25-cce1-918e-6471b56db801@amd.com>
Date:   Tue, 19 May 2020 08:56:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <adb8a844689f1569875b1e6574ce7db4962e611c.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0101.namprd12.prod.outlook.com
 (2603:10b6:802:21::36) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN1PR12CA0101.namprd12.prod.outlook.com (2603:10b6:802:21::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 19 May 2020 13:56:07 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 486359b7-c5fe-4fcd-3c24-08d7fbfc6195
X-MS-TrafficTypeDiagnostic: DM5PR12MB2485:
X-Microsoft-Antispam-PRVS: <DM5PR12MB2485F48CBF6B166DEE23F268ECB90@DM5PR12MB2485.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 040866B734
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s/EMJa3iStTs6YHhWPbtTyczAdy/noT9pb/cxIhUXd1jQZpeub2COQTWECsiXTY54XN5jcwZknkmPZXjenuwvh4sfwvLW/zJv6VKSON7Z3bNP7ZjteRzgtdkvvVULdyVJ1yuPxiDHJZ2ap2UHnwkO+qAR1RNYHSJoydCTohoGiqjfNmPN8scJ0onLm7AaxcU3sQWynET/kxpr8kyW5HaMoGS3eWpAqMD6sGA3mBKLU6l+izzGFrfB0r78EZ5D/j1tV8GUjuW8HX+3VR+BatyUcVd4XzZtPTINhdhTO1uPETAu3Fj5TLA1t2OZ14A2nfOd8NzY+RXFf+I1vAYn9NjOLWKXVLzNQmn8XU+6hR57j3G8vpXs/kVlqf4CO8ZNsRQAgeSW0IMXHP872pEqexwOob/SCHNj9WfDqLDEy/4spwztBXFoYFY91sy1BOy09emY+V9WMi3ukC0NoeQy6Hrq9O3yHI+IbrvkVheeuoLMGvvuTOLlvj1df3BCVTkC9+Ni7ldfzewqbcLYN0B9WusZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(52116002)(110136005)(66476007)(66946007)(8936002)(66556008)(5660300002)(31686004)(6486002)(2616005)(956004)(6506007)(16526019)(186003)(316002)(478600001)(8676002)(6512007)(86362001)(4326008)(53546011)(2906002)(36756003)(31696002)(26005)(32563001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L+uTK3c53XvKpEZt1jSkSaaSRg5sGgDWmBPtFXn0XqO///3pdAp4kzpBtm/ssxY8o2otlbhuwSW3c6f2LKdVBGgpz4rMHRRyqYx79iL6AehRan9wtRLB6IJH26hNT2yki/ULDGL//lkC2QSStGMjNSCXnkBtkWl9eljEizUHcRt5JQScCE/pFnUtI+lBJEUmNKQrRPUTB7jyD6b4AAo/Cd61+pF0EU58g4l5Dxlko7u8lj/14BTFFQr9YdU67MdHO3X6qK4E6r4R3feAN1Tla4r9jwpr0ODaQoiBpzfeMqzP5UEnLwyhpmLyavLQ7qD3XkwgqFBPOCi9j+RimmOEeeWYHk8kTxcKHJZ7zNpf29s/dq5TdQElKN1WIPfhwXFp85vDLb+nIcCq6Ki/irO14DPoMqLTSFZI0zZJ8/F88l4MTD+f6Ccp53pYfOsLeNj1HkrfZzYIWtg8/cGVnXjpM487flTg36Ih1jY0kTRSlUC9qyYzPjVVAAylTuKmJTIy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 486359b7-c5fe-4fcd-3c24-08d7fbfc6195
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2020 13:56:08.6603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WL+MGM54dBbnE6bMysCjjbWvGEskEAtu1hql73Cf3GFLHlcuHuXsUUOQnNJwxKdTqs74BLrYtB4kEBqwR7yS9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2485
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/19/20 5:59 AM, Maxim Levitsky wrote:
> On Tue, 2020-05-19 at 05:50 -0400, Paolo Bonzini wrote:
>> KVM stores the gfn in MMIO SPTEs as a caching optimization.  These are split
>> in two parts, as in "[high 11111 low]", to thwart any attempt to use these bits
>> in an L1TF attack.  This works as long as there are 5 free bits between
>> MAXPHYADDR and bit 50 (inclusive), leaving bit 51 free so that the MMIO
>> access triggers a reserved-bit-set page fault.
> 
> Most of machines I used have MAXPHYADDR=39, however on larger server machines,
> isn't MAXPHYADDR already something like 48, thus not allowing enought space for these bits?
> This is the case for my machine as well.
> 
> In this case, if I understand correctly, the MAXPHYADDR value reported to the guest can
> be reduced to accomodate for these bits, is that true?
> 
> 
>>
>> The bit positions however were computed wrongly for AMD processors that have
>> encryption support.  In this case, x86_phys_bits is reduced (for example
>> from 48 to 43, to account for the C bit at position 47 and four bits used
>> internally to store the SEV ASID and other stuff) while x86_cache_bits in
>> would remain set to 48, and _all_ bits between the reduced MAXPHYADDR
>> and bit 51 are set.
> 
> If I understand correctly this is done by the host kernel. I haven't had memory encryption
> enabled when I did these tests.
> 
> 
> FYI, later on, I did some digging about SME and SEV on my machine (3970X), and found out that memory encryption (SME) does actually work,
> except that it makes AMD's own amdgpu driver panic on boot and according to google this is a very well known issue.
> This is why I always thought that it wasn't supported.
> 
> I tested this issue while SME is enabled with efifb and it seems that its state (enabled/disabled) doesn't affect this bug,
> which suggest me that a buggy bios always reports that memory encrypiton is enabled in that msr, or something
> like that. I haven't yet studied this area well enought to be sure.

If the SMEE MSR bit (bit 23 of 0xc0010010) is enabled then the overall 
hardware encryption feature is active which means the encryption bit is 
available and active, regardless of whether the OS supports it or not, and 
the physical address space is reduced.

Some BIOSes provide an option to disable/turn off the SMEE bit, but not all.

> 
> SEV on the other hand is not active because the system doesn't seem to have PSP firmware loaded,
> and only have CCP active (I added some printks to the ccp/psp driver and it shows that PSP reports 0 capability which indicates that it is not there)
> It is reported as supported in CPUID (even SEV-ES).

Correct, the hardware supports the feature, but you need the SEV firmware, 
too. The SEV firmware is only available on EPYC processors.

Thanks,
Tom

> 
> I tested this patch and it works.
> 
> However note (not related to this patch) that running nested guest,
> makes the L1 guest panic right in the very startup of the guest when npt=1.
> I tested this with many guest/host combinations and even with fedora kernel 5.3 running
> on both host and guest, this is the case.
> 
> Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Overall the patch makes sense to me, however I don't yet know this area well enought
> for a review, but I think I'll dig into it today and once it all makes sense to me,
> I'll review this patch as well.
> 
> Best regards,
> 	Maxim Levitsky
> 
>> Then low_phys_bits would also cover some of the
>> bits that are set in the shadow_mmio_value, terribly confusing the gfn
>> caching mechanism.
>>
>> To fix this, avoid splitting gfns as long as the processor does not have
>> the L1TF bug (which includes all AMD processors).  When there is no
>> splitting, low_phys_bits can be set to the reduced MAXPHYADDR removing
>> the overlap.  This fixes "npt=0" operation on EPYC processors.
>>
>> Thanks to Maxim Levitsky for bisecting this bug.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 52918ed5fcf0 ("KVM: SVM: Override default MMIO mask if memory encryption is enabled")
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c | 19 ++++++++++---------
>>   1 file changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 8071952e9cf2..86619631ff6a 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -335,6 +335,8 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask, u64 mmio_value, u64 access_mask)
>>   {
>>   	BUG_ON((u64)(unsigned)access_mask != access_mask);
>>   	BUG_ON((mmio_mask & mmio_value) != mmio_value);
>> +	WARN_ON(mmio_value & (shadow_nonpresent_or_rsvd_mask << shadow_nonpresent_or_rsvd_mask_len));
>> +	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
>>   	shadow_mmio_value = mmio_value | SPTE_MMIO_MASK;
>>   	shadow_mmio_mask = mmio_mask | SPTE_SPECIAL_MASK;
>>   	shadow_mmio_access_mask = access_mask;
>> @@ -583,16 +585,15 @@ static void kvm_mmu_reset_all_pte_masks(void)
>>   	 * the most significant bits of legal physical address space.
>>   	 */
>>   	shadow_nonpresent_or_rsvd_mask = 0;
>> -	low_phys_bits = boot_cpu_data.x86_cache_bits;
>> -	if (boot_cpu_data.x86_cache_bits <
>> -	    52 - shadow_nonpresent_or_rsvd_mask_len) {
>> +	low_phys_bits = boot_cpu_data.x86_phys_bits;
>> +	if (boot_cpu_has_bug(X86_BUG_L1TF) &&
>> +	    !WARN_ON_ONCE(boot_cpu_data.x86_cache_bits >=
>> +			  52 - shadow_nonpresent_or_rsvd_mask_len)) {
>> +		low_phys_bits = boot_cpu_data.x86_cache_bits
>> +			- shadow_nonpresent_or_rsvd_mask_len;
>>   		shadow_nonpresent_or_rsvd_mask =
>> -			rsvd_bits(boot_cpu_data.x86_cache_bits -
>> -				  shadow_nonpresent_or_rsvd_mask_len,
>> -				  boot_cpu_data.x86_cache_bits - 1);
>> -		low_phys_bits -= shadow_nonpresent_or_rsvd_mask_len;
>> -	} else
>> -		WARN_ON_ONCE(boot_cpu_has_bug(X86_BUG_L1TF));
>> +			rsvd_bits(low_phys_bits, boot_cpu_data.x86_cache_bits - 1);
>> +	}
>>   
>>   	shadow_nonpresent_or_rsvd_lower_gfn_mask =
>>   		GENMASK_ULL(low_phys_bits - 1, PAGE_SHIFT);
> 
> 
