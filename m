Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC58B1809BF
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 21:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgCJU7a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 16:59:30 -0400
Received: from mail-mw2nam12on2076.outbound.protection.outlook.com ([40.107.244.76]:6210
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726100AbgCJU7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 16:59:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idvnn0MgsZaieAK5U+6bo2EOX1MUpcLAqE7toRjU+eyKoU+0swsjatlji/Rb9+WeI4Yq6WVVK1w4kQui1f9d5jV7S9SnmVJhAU7/2tk2lmI3YhwE9IwY3gWlZCq6ofYT71jnk4XB3DousjeqNFNvtfTIjW/nu8fKUHAPFmIHsR8pJrvS0Myat+eqW9FhTQ70ZZhiOr/u9tahqRGN7/gv3cBZzG59V840AA2AXHYuNeCQ2bmwnvogAyq7RhTfrPGXiHRNZ/hmI4M5bsrgzofuKcEtjzW+px3LfNtrYjLnQBidSArQ8UI9HT5Xm0lpMVjnM9llVnrqQd1+v/gcluRHHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=092wl3f7D4on7HSq4O35XGzsjMJEZ9u6xCe2zcJhPr4=;
 b=kY4xFnbH2h3FmkHilMT/YiFAa601Xp70OHL2H3tJvtcV93fsB63pQgHiJN+TEepd0d2X4kCJ2NALP4bRjrla6EkJRpKnEw0Q2m2WOxsCesqdqdA4L2SgwUNKiJ3ZiwYqH+MB245oP0Ko0234tWLTjXcycYxM7JHgo9dLlNL+sqdXmF2HGXEVMs0A0HX9iz8d7eX6kiHsxPS1r+Hy4ikctLpPKEREDqVg5K3hGhMV2HDJC5q+B1o7r1+DNNNwwuQ8WGJWRgHUSePBxYIWBLT6zjyI1I5mjz9qcLRzh+sDmA+SJb45Tv9/q30qyw28+FElYcDMrs+SocUJ0yyU3/GioQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=092wl3f7D4on7HSq4O35XGzsjMJEZ9u6xCe2zcJhPr4=;
 b=UOdRYzatyZAnAzRe5xC2qqIxSfDXVMWX0ywMN9qFITXUN7IPRA97JVVM5RX/36g8sH/g+Q2UZbcBKJ+YGgGK6UFk1UAsvKM3IhoWBlj4oCoL8UPwBlcmQ4PbAcP05HO+eMnNK3ul1/RWtk1qFv0p2kEzoJP8GRKe6UR4Jiatmqs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from DM6PR12MB3163.namprd12.prod.outlook.com (2603:10b6:5:15e::26)
 by DM6PR12MB2747.namprd12.prod.outlook.com (2603:10b6:5:4a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 20:59:27 +0000
Received: from DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733]) by DM6PR12MB3163.namprd12.prod.outlook.com
 ([fe80::f0f9:a88f:f840:2733%7]) with mapi id 15.20.2793.018; Tue, 10 Mar 2020
 20:59:27 +0000
Subject: Re: [PATCH 4.14 057/126] KVM: SVM: Override default MMIO mask if
 memory encryption is enabled
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200310124203.704193207@linuxfoundation.org>
 <20200310124207.819562318@linuxfoundation.org>
 <20200310181952.GF9305@linux.intel.com>
 <220a78d4-0e46-a321-49cd-5d1c5827aef0@amd.com>
Message-ID: <0bab862b-0780-38c3-0c60-b078d61613de@amd.com>
Date:   Tue, 10 Mar 2020 15:59:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <220a78d4-0e46-a321-49cd-5d1c5827aef0@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0032.namprd07.prod.outlook.com
 (2603:10b6:3:16::18) To DM6PR12MB3163.namprd12.prod.outlook.com
 (2603:10b6:5:15e::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR07CA0032.namprd07.prod.outlook.com (2603:10b6:3:16::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17 via Frontend Transport; Tue, 10 Mar 2020 20:59:26 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4318bee0-9d6c-4375-3183-08d7c535eb6e
X-MS-TrafficTypeDiagnostic: DM6PR12MB2747:
X-Microsoft-Antispam-PRVS: <DM6PR12MB27472C185AB09C90F7165C3BECFF0@DM6PR12MB2747.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(189003)(199004)(45080400002)(36756003)(16526019)(66476007)(186003)(966005)(52116002)(31686004)(53546011)(66556008)(478600001)(6486002)(5660300002)(2906002)(86362001)(316002)(110136005)(8676002)(16576012)(81156014)(26005)(8936002)(31696002)(956004)(66946007)(2616005)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB2747;H:DM6PR12MB3163.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vhSzasA6BjagWTGD8PjkxUtuqSd+mbtq9zu8rsc6394bki2EUszRTo0mPiC0aReuuoqXfm85bb/ZQtkLUBFeiBoikYSYFmdXhLMz4zI1DkZwXwDfDeBiwmatR/cBWDFfXYAs5rH+UNCFGt0ksqO33hXb8h5INb8p5yWo9BhkP9QEqCJcu6eHuIGGLD97twJWCjLEgIuQHo73zjDBGn0ms9ezdFoeklQgWOwsDHY2mzdr1s214AbX8Ao3EcWVLU+7vr2fkW6oetor6Lf3UBribiCTAaGiAi3Qt66tid5ArSUoTsxo6MOChIG1SGXt9Y/k5pGfCMCeY9j2Lnii3RP3qX4t/7nourY8FmCpZsQ1EgTHh+iILr/rC8Hs0eWLd5EkfqPL8CV0UIQx3b4HY+krMZMHDC77onIBWppzYiCJBzlbhifoVwh2P7eb66uSfSA4Dzyjl00D/WnmAcb8npMyrjfp70uryY+lLRQvi4XQrHCF9aNKQE0LLrGVRaprwZafl7lYb2Icy6I25hWEXPWd8w==
X-MS-Exchange-AntiSpam-MessageData: Aup3ohxiUBy+bEfTb45as4Mr7xX5htqbBsLsURKKCBqPJEfAvRXXZx0VzAEmTw90yUOsSRq/AoY69eXb8OANTbj0PTPP4liOBFUK/mY88Adb/h1003pDSsNpqodXpR/C+13Q/v5zH+rCprg38nm8mA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4318bee0-9d6c-4375-3183-08d7c535eb6e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 20:59:27.1919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7tTT5DRhizJ6ma961SjbT3gd6D7XgS8VpYnjI0nTOEYwHqwjN0Nq4jorWtf1JVz18aKF3P5uUJfu9uB2OFVEQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2747
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 1:42 PM, Tom Lendacky wrote:
> On 3/10/20 1:19 PM, Sean Christopherson wrote:
>> Has this been tested on the stable kernels?  There's a recent bug report[*]
>> that suggests the 4.19 backport of this patch may be causing issues.
> 
> I missed this went the stable patches went by...  when backported to the
> older version of kvm_mmu_set_mmio_spte_mask() in the stable kernels (4.14
> and 4.19), the call should have been:
> 
> kvm_mmu_set_mmio_spte_mask(mask, mask) and not:
> 
> kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);
> 
> The call in the original upstream patch was:
> 
> kvm_mmu_set_mmio_spte_mask(mask, mask, PT_WRITABLE_MASK | PT_USER_MASK);

Greg,

I should have asked in the earlier email...  how do you want to address this?

Thanks,
Tom

> 
> Tom
> 
>>
>> [*] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fbugzilla.kernel.org%2Fshow_bug.cgi%3Fid%3D206795&amp;data=02%7C01%7Cthomas.lendacky%40amd.com%7C559dd742543741e4bc7608d7c51fa1d5%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637194611958586378&amp;sdata=k%2F3WUFrqvibbf%2FEaCFgOIhUWMZ%2BqHjawmmy1GII7KgA%3D&amp;reserved=0
>>
>>
>> On Tue, Mar 10, 2020 at 01:41:18PM +0100, Greg Kroah-Hartman wrote:
>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> commit 52918ed5fcf05d97d257f4131e19479da18f5d16 upstream.
>>>
>>> The KVM MMIO support uses bit 51 as the reserved bit to cause nested page
>>> faults when a guest performs MMIO. The AMD memory encryption support uses
>>> a CPUID function to define the encryption bit position. Given this, it is
>>> possible that these bits can conflict.
>>>
>>> Use svm_hardware_setup() to override the MMIO mask if memory encryption
>>> support is enabled. Various checks are performed to ensure that the mask
>>> is properly defined and rsvd_bits() is used to generate the new mask (as
>>> was done prior to the change that necessitated this patch).
>>>
>>> Fixes: 28a1f3ac1d0c ("kvm: x86: Set highest physical address bits in non-present/reserved SPTEs")
>>> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>
>>> ---
>>>  arch/x86/kvm/svm.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 43 insertions(+)
>>>
>>> --- a/arch/x86/kvm/svm.c
>>> +++ b/arch/x86/kvm/svm.c
>>> @@ -1088,6 +1088,47 @@ static int avic_ga_log_notifier(u32 ga_t
>>>  	return 0;
>>>  }
>>>  
>>> +/*
>>> + * The default MMIO mask is a single bit (excluding the present bit),
>>> + * which could conflict with the memory encryption bit. Check for
>>> + * memory encryption support and override the default MMIO mask if
>>> + * memory encryption is enabled.
>>> + */
>>> +static __init void svm_adjust_mmio_mask(void)
>>> +{
>>> +	unsigned int enc_bit, mask_bit;
>>> +	u64 msr, mask;
>>> +
>>> +	/* If there is no memory encryption support, use existing mask */
>>> +	if (cpuid_eax(0x80000000) < 0x8000001f)
>>> +		return;
>>> +
>>> +	/* If memory encryption is not enabled, use existing mask */
>>> +	rdmsrl(MSR_K8_SYSCFG, msr);
>>> +	if (!(msr & MSR_K8_SYSCFG_MEM_ENCRYPT))
>>> +		return;
>>> +
>>> +	enc_bit = cpuid_ebx(0x8000001f) & 0x3f;
>>> +	mask_bit = boot_cpu_data.x86_phys_bits;
>>> +
>>> +	/* Increment the mask bit if it is the same as the encryption bit */
>>> +	if (enc_bit == mask_bit)
>>> +		mask_bit++;
>>> +
>>> +	/*
>>> +	 * If the mask bit location is below 52, then some bits above the
>>> +	 * physical addressing limit will always be reserved, so use the
>>> +	 * rsvd_bits() function to generate the mask. This mask, along with
>>> +	 * the present bit, will be used to generate a page fault with
>>> +	 * PFER.RSV = 1.
>>> +	 *
>>> +	 * If the mask bit location is 52 (or above), then clear the mask.
>>> +	 */
>>> +	mask = (mask_bit < 52) ? rsvd_bits(mask_bit, 51) | PT_PRESENT_MASK : 0;
>>> +
>>> +	kvm_mmu_set_mmio_spte_mask(mask, PT_WRITABLE_MASK | PT_USER_MASK);
>>> +}
>>> +
>>>  static __init int svm_hardware_setup(void)
>>>  {
>>>  	int cpu;
>>> @@ -1123,6 +1164,8 @@ static __init int svm_hardware_setup(voi
>>>  		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
>>>  	}
>>>  
>>> +	svm_adjust_mmio_mask();
>>> +
>>>  	for_each_possible_cpu(cpu) {
>>>  		r = svm_cpu_init(cpu);
>>>  		if (r)
>>>
>>>
