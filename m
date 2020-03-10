Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 649E1180725
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 19:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCJSmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 14:42:45 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:39265
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbgCJSmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 14:42:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fSEh1FD18VgjGmBHzj5L5V5t8qK9J4KXQUZPYc5s56mORy1KDLNHf5bBiu3FBt1WjI8KBw7WIrDS6n0xLqFM2TeSaX1wez6eGi0LzdOYgyRx5udqohmfGV7ghZjaW7f3xd26HIGmxilZ8gpyCBxnxzN0Ur3XPi5aGNeECjmE/7ibzJdiGjc77Uqn4tM9ZMULAjaYQfk0m5rXJqMLkaWnn42EBSad1gKYEKS1aMadGJg1hkpEBAzjmGWmWNWqz1v8klC7LRSD7LJ3C5eCSE6T/aPV2YkcYSkd3d8MChOiJ6jcHxM8joZI8li8rP4CmQ0j6oUag32auw3lIM/KdtDFag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DscffCazgRP+Lo4ZlqPPKtLXcoTQjaJfOj/3CVqH/BQ=;
 b=LT0bS7775pzD6hLljfNKuSD+tJNvodUybezidi1kGwRfCW9BXVIsxfmissCml8CRHVE5co0YKNrk5fghTQ4sJt4HNfJEfrbKI6i1l3wnFqVxmuagyUZB7o/LPPr0Wy5gFKIRLiJeIciEhHEjsIyezFHbZeE9mvvVDYNIHtz1iYajnn+fC8XTyxhQiaY/+moSkOmy+EwFokuJMVVaDOrjZYA7JOojvS3tJaTGjrTwtT0CAz5+uuPsXZSsO9iQqSYLKmml3idPwtEs1cVPi7lXOjetrqWgMnGANsGQMUI5UJhWTai2AMCmJExqU8D+1RsaMJVLgo+Xk47vDqz6NNv4UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DscffCazgRP+Lo4ZlqPPKtLXcoTQjaJfOj/3CVqH/BQ=;
 b=Ap/ZznNiVJR3LvVcKhA85o7wYQJjxzUH0uy3uUbnbo/aB1a0HbH0GMjq3ostTEGeDtU1ajJlscJPHB8gqaaJ67krZtNDFtKrbwvP3hwHleWkRQWuXgBXT8N4/JqJIcGH+C5yBEf59CVHeY4mFUqX0oBdK9WDJdA8MOVfNDouZUQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB2601.namprd12.prod.outlook.com (2603:10b6:5:45::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 18:42:43 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2793.018; Tue, 10 Mar 2020
 18:42:42 +0000
Subject: Re: [PATCH 4.14 057/126] KVM: SVM: Override default MMIO mask if
 memory encryption is enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200310124203.704193207@linuxfoundation.org>
 <20200310124207.819562318@linuxfoundation.org>
 <20200310181952.GF9305@linux.intel.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <220a78d4-0e46-a321-49cd-5d1c5827aef0@amd.com>
Date:   Tue, 10 Mar 2020 13:42:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200310181952.GF9305@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0132.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::34) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM6PR02CA0132.namprd02.prod.outlook.com (2603:10b6:5:1b4::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17 via Frontend Transport; Tue, 10 Mar 2020 18:42:42 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bde5bab1-19b6-4499-336c-08d7c522d140
X-MS-TrafficTypeDiagnostic: DM6PR12MB2601:
X-Microsoft-Antispam-PRVS: <DM6PR12MB26011E7B89E973FAED996E1BECFF0@DM6PR12MB2601.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(189003)(199004)(478600001)(45080400002)(16526019)(8676002)(26005)(186003)(956004)(2616005)(5660300002)(66556008)(66476007)(81156014)(966005)(31686004)(66946007)(81166006)(316002)(31696002)(16576012)(86362001)(2906002)(52116002)(36756003)(4326008)(110136005)(8936002)(53546011)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2601;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wx9FXB+0nKvCj2BS9hNBHoaddmVaMgqH+0yKkS6uj2JJDWFTYmJq5/aqkoZsAKnr4tudmBFu+dRgwZH9ODPTKEK9rfQqpAHr+UxjzWgpC+U85ShVgpjVNreQycun7w72sz5S2MJKkV0UvncOStG8/024araWI+8AzMTV1z75BcvSo9V+/nf2SM8WZnk00lbdoUx2c1igiJTFm5ByuyplQxSJ7EJ2DFMx7KAoiJinKX0sJKH9MF6m9y3viL8kh3EmyqFERK55A2sxsNFCRXFR0cPARXmHtL0rlOMiFtoEYbRrWbYr39DculT8x7IUz9UYFYgoYiT/Dv1XEAAt2+5WO2EjTn7OTIyhYeWTSQ4UoYRLlofeDgR4nOzpMMLWYqbu8Zl4w8xhX+D2q9vyroRM4GAplmFbmonTyrP4Vrq9nCyx317FvLFZupxAVj0nWusqjrx7kQlf+eUYm+bMIC7T74ocZfC0CM/nHSGv6B58TK98Pb70oVsgjmPBhU83Fbgj26sFjwtYHcvv9A/IvmP94w==
X-MS-Exchange-AntiSpam-MessageData: tm1RhedvY3olYyvDUTG9C9CrAD05sXLs7ggiHPBbZ/5F9sMRUSxPGqj+QPY4geXiT7CRhxNLXC2oKKFKqXjqg2udbH+gbMtikK1VmicCxLaWYtRaJ2wI+3NNwrSVYL+g8qg48W56PD2ddTZgYV++yg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde5bab1-19b6-4499-336c-08d7c522d140
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 18:42:42.7669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jj/Br+/hFkRjq+elk9Tc7Qc6Dw1eY5s2qBMAXZOa/TQRqGxwkD7mtRPbyioZawqzV3GVXIAj5gugJB2oQ113mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2601
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 1:19 PM, Sean Christopherson wrote:
> Has this been tested on the stable kernels?  There's a recent bug report[*]
> that suggests the 4.19 backport of this patch may be causing issues.

I missed this went the stable patches went by...  when backported to the
older version of kvm_mmu_set_mmio_spte_mask() in the stable kernels (4.14
and 4.19), the call should have been:

kvm_mmu_set_mmio_spte_mask(mask, mask) and not:

kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);

The call in the original upstream patch was:

kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);

Tom

> 
> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D206795&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7C559dd742543741e4bc7608d7c51fa1d5%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637194611958586378&amp;sdata=k%2F3WUFrqvibbf%2FEaCFgOIhUWMZ%2BqHjawmmy1GII7KgA%3D&amp;reserved=0
> 
> 
> On Tue, Mar 10, 2020 at 01:41:18PM +0100, Greg Kroah-Hartman wrote:
>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> commit 52918ed5fcf05d97d257f4131e19479da18f5d16 upstream.
>>
>> The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
>> faults when a guest performs MMIO. The AMD memory encryption support uses
>> a CPUID function to define the encryption bit position. Given this, it is
>> possible that these bits can conflict.
>>
>> Use svm_hardware_setup() to override the MMIO mask if memory encryption
>> support is enabled. Various checks are performed to ensure that the mask
>> is properly defined and rsvd_bits() is used to generate the new mask (as
>> was done prior to the change that necessitated this patch).
>>
>> Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
>> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> ---
>>  arch/x86/kvm/svm.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 43 insertions(+)
>>
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -1088,6 +1088,47 @@ static int avic_ga_log_notifier(u32 ga_t
>>  	return 0;
>>  }
>>  
>> +/*
>> + * The default MMIO mask is a single bit (excluding the present bit),
>> + * which could conflict with the memory encryption bit. Check for
>> + * memory encryption support and override the default MMIO mask if
>> + * memory encryption is enabled.
>> + */
>> +static __init void svm_adjust_mmio_mask(void)
>> +{
>> +	unsigned int enc_bit, mask_bit;
>> +	u64 msr, mask;
>> +
>> +	/* If there is no memory encryption support, use existing mask */
>> +	if (cpuid_eax(0x80000000) < 0x8000001f)
>> +		return;
>> +
>> +	/* If memory encryption is not enabled, use existing mask */
>> +	rdmsrl(MSR_K8_SYSCFG, msr);
>> +	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
>> +		return;
>> +
>> +	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
>> +	mask_bit = boot_cpu_data.x86_phys_bits;
>> +
>> +	/* Increment the mask bit if it is the same as the encryption bit */
>> +	if (enc_bit == mask_bit)
>> +		mask_bit++;
>> +
>> +	/*
>> +	 * If the mask bit location is below 52, then some bits above the
>> +	 * physical addressing limit will always be reserved, so use the
>> +	 * rsvd_bits() function to generate the mask. This mask, along with
>> +	 * the present bit, will be used to generate a page fault with
>> +	 * PFER.RSV = 1.
>> +	 *
>> +	 * If the mask bit location is 52 (or above), then clear the mask.
>> +	 */
>> +	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
>> +
>> +	kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);
>> +}
>> +
>>  static __init int svm_hardware_setup(void)
>>  {
>>  	int cpu;
>> @@ -1123,6 +1164,8 @@ static __init int svm_hardware_setup(voi
>>  		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>>  	}
>>  
>> +	svm_adjust_mmio_mask();
>> +
>>  	for_each_possible_cpu(cpu) {
>>  		r = svm_cpu_init(cpu);
>>  		if (r)
>>
>>
