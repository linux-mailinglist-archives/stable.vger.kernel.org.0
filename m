Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F26304C1C
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 23:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbhAZWAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 17:00:49 -0500
Received: from mail-bn8nam11on2074.outbound.protection.outlook.com ([40.107.236.74]:51232
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727837AbhAZUUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 15:20:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WX+splqaf7N/mjkmNLOHvgfJzYLBncaZybPi/WjDdqfImox2Mp126Qqm0NFy5YDjrkulqK0+HOffwxX2KD0uTu8nQStQ6Y/pUpyu5joS+0Nl9PhYGJxQ5CsZG+UtYa8z3G4+8hJrWvl3BN6anKeWLWWe9Fw6orMD860+NUl2o4tHOO7hGBehXzIsJzoNv6uuNtUbfd/5Y1ywGuB0ALegrglCb3kbILB9SKTTbGuTpeMo/O/1CN1GhH7DlJoCZeznH1kNP4ggGQuhj9zTWpwOzPqfVdhMp4o4LIrKvh1ZdCRUaruVAg6mboYuUWp7ia0mqsz7LpEZoEDchbai1KCs6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66GLq7k059h5QtMfUxDpH8yIm5w3aCtEK4BKvCvB6OQ=;
 b=T7zfjDnLy849qvm8/fA+tDdkOYI94mayV9wlGcNdEUeQWCR1t7udQAdgklIFXzTEwB5yFbmAV/7Wwml0xRo3PEge/AGCbVLu+6JkzfXRfYip6DtTtKM9L8EHiG6SMUVG2MBbQ47ySuFEEOPK3fHn5pAP8v5FQb+oj2xkqq8jTTgKm6Dh1YRgA66ErDEtxRwub00PRqK8IPTcFp3Ysnxa8uywmVkorz6jpZ8sMYORkpJFkT5kGcpr94m/2KU7Q27R98n1QmL0L1w0bj3eJm9VguvnlvNVaW3YJXFgdDh3Kzk8MpDH+g+nIxS8PZZvB/Fuh0gRXI0ONDRbJKZVXIHAew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=66GLq7k059h5QtMfUxDpH8yIm5w3aCtEK4BKvCvB6OQ=;
 b=AsevXr+kF+FSJ+EFi0NqmIbNQW4tGRkLakh4dnXM45Tq/xIkuhqSv0u9l3Ge9qP/qLnUTM63SHV1ogFHnhlCfZM+KxINrUJlzm6iWlJv6t288cAeq5ZmqUvSeADDpdBZlLBduALBCWq0ZNbRJx94czKw4qKbZrJ0J9KO7tHCnhY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3273.namprd12.prod.outlook.com (2603:10b6:5:188::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11; Tue, 26 Jan 2021 20:19:56 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 20:19:55 +0000
Subject: Re: [PATCH] Fix unsynchronized access to sev members through
 svm_register_enc_region
To:     Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210126185431.1824530-1-pgonda@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <6407cdf6-5dc7-96c0-343b-d2c0e1d7aaa4@amd.com>
Date:   Tue, 26 Jan 2021 14:19:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210126185431.1824530-1-pgonda@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:806:22::14) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SA9PR13CA0039.namprd13.prod.outlook.com (2603:10b6:806:22::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.6 via Frontend Transport; Tue, 26 Jan 2021 20:19:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1473cb33-ca7e-4e79-39f4-08d8c237bee5
X-MS-TrafficTypeDiagnostic: DM6PR12MB3273:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3273EDB713C8D25938390E1BECBC9@DM6PR12MB3273.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GN3UlpHklIeogfM3KWm3CFczVxvGA/dR4mdfembGcKWZNjhzcg2JVt51vkd9unPGsTuykkWjlMr9QcVOYGDZBnrmIOs1Z9pDltISPX5Fjm0vPjTFlsX0LZLWqCQ53+V0pyKYlxuLArjOLDzO4KjdkSr8G/1Prix3tdVGagCDiKZJQO0tChmSIqdKByUY+/3splkljqWomZnn1T78/rbAZAREwlYJ09Hby/8EkuFpcP7EBorbBfXEQamRoY9OOZfDUR3raRm9V++0iCUETbUCQDGq+xeEoAexm79lnmW5lHtimDD2tHy5KsRCrHi4kSiRKxycIbOU+CuV5UhhykutBjwQ/Glr5VLq5zNuuU2w9Ic9/EnXAYZeDiutt1mkaLrHRcN9VSIo9mlPUm2qZQ9jB98d9gTGp5RBZLoNFGW/336ubgJmVMCq6G9lFr089dYKw6elKPE9nfebWE2WB3FfWdBTihEylp39ZcR1PJd5Wjg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(186003)(16526019)(2906002)(66946007)(66476007)(26005)(5660300002)(8936002)(16576012)(54906003)(66556008)(316002)(8676002)(31696002)(31686004)(7416002)(36756003)(956004)(52116002)(83380400001)(53546011)(86362001)(478600001)(6486002)(2616005)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VkFwbThCeFlObFdZN3NzVVV3anMvcjhKQUJ2dFFoQXVlcnpZTEpWYUV5K1lY?=
 =?utf-8?B?KzhNZ3pmNXVpUmZ5cGlyMVVnTndxMVEwNmU1TndFdVp6YVR0U2prbStUVFE4?=
 =?utf-8?B?ZTZlS3FIQTNtL3JvUGo5aWtyZ2NkVVlkelhrNG5BZkYwaFJlMkNJS1EvMytO?=
 =?utf-8?B?M3NyWWMwTHJVVE52dE5lMXRsZUtzOFZVWmIrQTRTTkcvaVVLR0hYbnVmMUFu?=
 =?utf-8?B?bng2TVRhRkRqeURkNFhzRmtrNlY1eUlBRzdGNStCNHhRZUoreGRRdVRIWnFn?=
 =?utf-8?B?bVQyNWxjS3htRkh5RXV1eHQ5eEhrWDkyN1BFMXd1Qk9QMnJVZVhqQXZpZHNT?=
 =?utf-8?B?dEFST2J6MUYrZ0pXU3N4TGRVN2V6YjlzSFJpakhkL1JFWFNNRkMwMHp1YlJu?=
 =?utf-8?B?NUVvUWlOemQwUWl1NWl6ZHpXQm9kcUYwQldOdjhSRXlndU1JZXdKdWJqcFFU?=
 =?utf-8?B?S24zVUd0TlNmSytaVVY5RzFjMVYvNDlJaHlHbGhFRnJUcm1UMFlNcVBWWWR4?=
 =?utf-8?B?QVNtN2Jrcy8rMDl4Z2o1WGYvOFBEUUQyY2NIZGhVbjIvSXIrSG14MXhpQ25G?=
 =?utf-8?B?OFd1N2hwdzlBakhOeUZDbGdmeXpZMHBabzZUZjFteEZKRlc2dklETGdHbkxP?=
 =?utf-8?B?czhnNHE2U3N1enhVU09ITkpsZGhUVEhYWHliZCt6WDB0VlRvcE9IU1VTRTB5?=
 =?utf-8?B?QWVZZ0VndjAvTG83enVPTVJiZ21DSlVUV2dTbUdJY3ozT0tUQmdDSkZWUkFQ?=
 =?utf-8?B?dDhjZ1Z6NHJsbGl6ZmMyUHdiZjdraDhoeWR6OHNmQm9YaDIrUzdxNlowV0VX?=
 =?utf-8?B?ODMzVzFYZ09NY01zOTRiQjRSdG9HNENlWEF1eWRmQUUxSlQycmx0TGxoNjE3?=
 =?utf-8?B?dndaOTM3d0ROaWhZT0VPRWpzQTZVamQ2TndvY2R1cU9Bd1VwMVpDMDVlclVV?=
 =?utf-8?B?ZVYrY2l4Vm94d0xDMGxlNmdCWmdUTXpHUVAyRDljclRWRVlLUHc1VWl3WTBZ?=
 =?utf-8?B?azVhTzJOaDVPMWcvcUNPMFdRVEl6bWlrNXhKS0Y4SkRCR3VnVVVrKzdCNFJo?=
 =?utf-8?B?VE5qbjhrWTZjM0JQZ2gzTG5sd0pjdzlsaloraDAzc1g4MWxOQU1TakJHNTFT?=
 =?utf-8?B?U0xwa1BTMEtFTzFYZm9SNFpMSVB4OUhVMVE3WFh4QVdFSURmRStnQWk3Q3di?=
 =?utf-8?B?ejBnblJjbE92cTdOeG9KaTAwL003NDFJbXZFT21EY05hdjhrNmc1MW5HVEty?=
 =?utf-8?B?L0tsVE5qVU03Z29lNFpIM0pSU0E4ZWJpemRvbVFRRnprUUo3L3ZkS3FMSHpa?=
 =?utf-8?B?c3pPcjlYd0dqdlMwZzdTRDV3UVU4VmUvS2ViUlRnZGJGWldlOXIweUlERmdK?=
 =?utf-8?B?NG1haVVCOWd0NW9qdFY4NEh4c0MrVHYrWC9LWml0Y2I4MGJmSzc3SmVCY0h5?=
 =?utf-8?Q?7qM6D+rz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1473cb33-ca7e-4e79-39f4-08d8c237bee5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 20:19:55.6617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pjxwHJey638zdDDV0E7ZRheK2HEeO1uJ9RbqUg/Q5TQq/2/lR1lhZrkdctrM8TECbCMxvPCBUIBjxlmsvedgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3273
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/21 12:54 PM, Peter Gonda wrote:
> sev_pin_memory assumes that callers hold the kvm->lock. This was true for
> all callers except svm_register_enc_region since it does not originate
> from svm_mem_enc_op. Also added lockdep annotation to help prevent
> future regressions.

I'm not exactly sure what the problem is that your fixing? What is the
symptom that you're seeing?

> 
> Tested: Booted SEV enabled VM on host.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: stable@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: 116a2214c5173 (KVM: SVM: Pin guest memory when SEV is active)

I can't find this commit. The Linux and KVM trees have it as:

1e80fdc09d12 ("KVM: SVM: Pin guest memory when SEV is active")

> Signed-off-by: Peter Gonda <pgonda@google.com>
> 
> ---
>  arch/x86/kvm/svm.c | 16 +++++++++-------

This patch won't apply, as it has already been a few releases since svm.c
was moved to the arch/x86/kvm/svm directory and this function now lives in
sev.c.

Thanks,
Tom

>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index afdc5b44fe9f..9884e57f3d0f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1699,6 +1699,8 @@ static struct page **sev_pin_memory(struct kvm *kvm, unsigned long uaddr,
>  	struct page **pages;
>  	unsigned long first, last;
>  
> +	lockdep_assert_held(&kvm->lock);
> +
>  	if (ulen == 0 || uaddr + ulen < uaddr)
>  		return NULL;
>  
> @@ -7228,12 +7230,19 @@ static int svm_register_enc_region(struct kvm *kvm,
>  	if (!region)
>  		return -ENOMEM;
>  
> +	mutex_lock(&kvm->lock);
>  	region->pages = sev_pin_memory(kvm, range->addr, range->size, &region->npages, 1);
>  	if (!region->pages) {
>  		ret = -ENOMEM;
>  		goto e_free;
>  	}
>  
> +	region->uaddr = range->addr;
> +	region->size = range->size;
> +
> +	list_add_tail(&region->list, &sev->regions_list);
> +	mutex_unlock(&kvm->lock);
> +
>  	/*
>  	 * The guest may change the memory encryption attribute from C=0 -> C=1
>  	 * or vice versa for this memory range. Lets make sure caches are
> @@ -7242,13 +7251,6 @@ static int svm_register_enc_region(struct kvm *kvm,
>  	 */
>  	sev_clflush_pages(region->pages, region->npages);
>  
> -	region->uaddr = range->addr;
> -	region->size = range->size;
> -
> -	mutex_lock(&kvm->lock);
> -	list_add_tail(&region->list, &sev->regions_list);
> -	mutex_unlock(&kvm->lock);
> -
>  	return ret;
>  
>  e_free:
> 
