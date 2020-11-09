Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B6C2ABB13
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732801AbgKINYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:24:01 -0500
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:63329
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387820AbgKINTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQY31Q2q2l9Q2TvK6+T4snQuNQ34me/u5ps0D+4Q7X7BYPQisZ13CDvUu9I3S8FudIGWU0qwmlInkzY4ObknnGoxrtdx8nAD+p+nvSKz4l7R/hMQt6UmAITM4RfdtFgUo4/uv0m5uE1OVSdVsGFGeQ5WfLanCsvwRHAieWc743VhXkDWvJ9xGoSax/a+JvrSR2x6fjywYtVUnIw5dWVhZrtwCmCXzFXCIElk1YGr51+jsy6ugpJFFswhgciazkSiSiUb5ZCRENkkQp15GIQYuXVH9HrmE6OArtrNDiZfBDRHR3oH/yTJAxsEaRnqkrg/poaprcSCFWQB6gsiRfqfmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUkCKsmxLhJCBBoCynrm9TmugyYhnhtO9eqiwq3xyT0=;
 b=g7BcoffWcDcr7VKWj4GZGEuTEo4yfOJ5T6CuhDVlOPHG3M43shvyA1ooxv9ayTJ7EOH9It75m+/Zizw8ID3hmAM++RWw7ZhYBAdumFszUVqT+G5DSuizEADrqcD7dsodHCz89xoBT5FABAjdq7tKUgqpYyFBLQUN+YFjGACwcKDyBPiHSBnZlMk7SEIVxP9D7u8MFRjCHc1DAVzL1Fp9Yo0RnQvZEHQOKNeepw5uqk9oDE9nqwXfhSBppl0vVT3AvhbHyViDLr2CYjHBE+g2SsgdYt7iID1EEU0561DPCjVtBPBnW+U6cWoNY5ypn3TMjFqo5iPk0MmIJ7t6UAa9iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HUkCKsmxLhJCBBoCynrm9TmugyYhnhtO9eqiwq3xyT0=;
 b=GlqAOY4MWHGFAnVYx6aj9+F7ZkOMugzNIezEOUVVamEMwMpSpI05EXNMbmLeWEZg6AWEMc5+hgIIIbylCicopzSow4DjydpSfgE/EpIhtSlkL6eLtRjLCmBhWw6Pm+z2pEi6G8ZRIHwmgWawBPzG180ytK5Ux7sJnxB1kVIdMuw=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Mon, 9 Nov
 2020 13:19:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::4888:5f3e:dbbc:c838]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::4888:5f3e:dbbc:c838%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 13:19:46 +0000
Cc:     brijesh.singh@amd.com, stable@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH] KVM: x86: Fix vCPUs >= 64 can't be online and hotplugged
 in some scenarios
To:     Zelin Deng <zelin.deng@linux.alibaba.com>
References: <1600066825-15461-1-git-send-email-zelin.deng@linux.alibaba.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <098e95f3-9f8d-e9df-bc9f-fc1ae2124e24@amd.com>
Date:   Mon, 9 Nov 2020 07:19:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.0
In-Reply-To: <1600066825-15461-1-git-send-email-zelin.deng@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR08CA0024.namprd08.prod.outlook.com
 (2603:10b6:805:66::37) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR08CA0024.namprd08.prod.outlook.com (2603:10b6:805:66::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 13:19:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c64d30f6-65e4-4373-7d6a-08d884b22084
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB28323FEFF4C0B23D79E284A4E5EA0@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0VVql/fdT0fLAGX51UCFvzeWByJEdXrZFWM8GDTn6b3n3sM710ZmcL9jU1KEfLwHRYznkgVaCSBK2/gdkOVIZvloXEq1byC8c03ra//5Mb9+nUGcgQ/9alwohCA2pdgxW//Md3VxUM7qb8QVl/KIHJcicu7FUu09GIbLD8XLnI7rtz4R/iGQVtJxnVnUa5bAi+bM0gPXC4vTSLI2tVC//4lv7RbzkT2CS3HW56dI0y3HKjIDN6qLtliDG1eak0sJPw68dEcb9ypBaQgWLz3OfRtF/lvXBzV0ihFaHiJwbTzN58wqXKij8bmfmucdAt5ir31A0KNG+G94+Gfip81WmoJGhxHLzxL93Q2Qs4fOh1zRgCZcZBfdsjSw2lBB3D3p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(346002)(396003)(376002)(52116002)(316002)(26005)(6506007)(31686004)(53546011)(5660300002)(6916009)(54906003)(83380400001)(6512007)(6486002)(4326008)(956004)(36756003)(478600001)(2616005)(44832011)(31696002)(8676002)(86362001)(2906002)(66476007)(66556008)(66946007)(8936002)(186003)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: eemcfwsrYrRIschrpkSOqwcGBPcLq095zXTn1UjF5RSz4NZGRtKovCTazEc9uGuw+VR2l9htkcwwqIHpkHJ8POTI1z8WQvVTyayUaPI5E+5wOJmDW9YXGMCmX/AxUgXDqojVzaQG+p/8jNQ0ooHfS1YJ+JGBpRXVFZUnomb2bx5qyQ9rh0cszL347+vi+Cv9P6S8OGltPOB60N0X54V5xAj+lil40xWxkBfLQBzPsLdmAF7n52ez+aWVwPD2O/LCmBv6J/kLU1BYOxccNE1oGl/eodSp7B9kh7iOL3qV4g4+BfIU7mfHYUXZG7kSOAp2x1C98zxpB+EIuQKmuCxMRmTQYJFGoubSJYQyIT72WU5w65ATgYA6vGrCC/O+AqD2nu/PkZstvc7SsCgaYyhy6KqeOZOYNeKUIrMXao588gqMx6qzAFxm93ar85Pk5/MODi21PzZ5NF/xdrwj/N1CM/7hjHtpoRRnA0eXOw4ArvyPooMkagLF0sJBLvytHv1J15OvvUdjaUSh3XgDBxFij/NTjEkPKPzLM6OrXTChZGgiR8knSNfU6m32uxgPwYw9RdI2uoYmsGyHZL2NNhsVojXWipfUltPact7/tE5arhPR0QADrWzz1Fgq9+qNxsSQQV2fPOwpC0ciTYsVw+U+qw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64d30f6-65e4-4373-7d6a-08d884b22084
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 13:19:46.0332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dBXLvW9Nj67vZkSAkmMCFlEMWufimg8qtEe2Wmo9xC5OGkzlJfIp32COHxvf3AJjzj+/WpSANiU8e0iy8rIiXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 9/14/20 2:00 AM, Zelin Deng wrote:
> pvclock data pointers of vCPUs >= HVC_BOOT_ARRAY_SIZE (64) are stored in
> hvclock_mem wihch is initialized in kvmclock_init_mem().
> Here're 3 scenarios in current implementation:
>     - no-kvmclock is set in cmdline. kvm pv clock driver is disabled,
>       no impact.
>     - no-kvmclock-vsyscall is set in cmdline. kvmclock_init_mem() won't
>       be called. No memory for storing pvclock data of vCPUs >= 64, vCPUs
>       >= 64 can not be online or hotpluged.
>     - tsc unstable. kvmclock_init_mem() won't be called. vCPUs >= 64 can
>       not be online or hotpluged.
> It's not reasonable that vCPUs hotplug have been impacted by last 2
> scenarios. Hence move kvmclock_init_mem() to front, in case hvclock_mem
> can not be initialized unexpectedly.
>
> Fixes: 6a1cac56f41f9 (x86/kvm: Use __bss_decrypted attribute in shared variables)
> Cc: <stable@vger.kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Zelin Deng <zelin.deng@linux.alibaba.com>
> ---
>  arch/x86/kernel/kvmclock.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
> index 34b18f6eeb2c..1abbda25e037 100644
> --- a/arch/x86/kernel/kvmclock.c
> +++ b/arch/x86/kernel/kvmclock.c
> @@ -271,7 +271,14 @@ static int __init kvm_setup_vsyscall_timeinfo(void)
>  {
>  #ifdef CONFIG_X86_64
>  	u8 flags;
> +#endif
> +
> +	if (!kvmclock)
> +		return 0;


Overall, I agree with the fix to move the kvmclock_init_mem() in the
beginning of the function so that memory hvclock_mem is allocated. But
curious, why do we need this check? The if (kvmclock) did not exist in
original function and I don't think kvmclock_init_mem() has any
dependency with it, am I missing something ?


> +
> +	kvmclock_init_mem();
>  
> +#ifdef CONFIG_X86_64
>  	if (!per_cpu(hv_clock_per_cpu, 0) || !kvmclock_vsyscall)
>  		return 0;
>  
> @@ -282,8 +289,6 @@ static int __init kvm_setup_vsyscall_timeinfo(void)
>  	kvm_clock.vdso_clock_mode = VDSO_CLOCKMODE_PVCLOCK;
>  #endif
>  
> -	kvmclock_init_mem();
> -
>  	return 0;
>  }
>  early_initcall(kvm_setup_vsyscall_timeinfo);
