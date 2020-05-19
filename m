Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B3A1D99CC
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 16:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgESOcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 10:32:33 -0400
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:6231
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726203AbgESOcc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 10:32:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CQIo1tK/OuTeamdDr/EzPMd3lkUfccrsWj1QDeEpw1YqhvRhxl+sC5umM8kpIigMWqrbotwa3QZEtxjLncEi7gsS0E36yZEEmE+lpDSBZGx3jfaSlL2bcOA3hyZlskureq+7IfqrDliULzwWbqrqWKl5HGOwfWc5xLr7r/dH+sLd82gBY5EJzgcn0+D0eLfabbz9KTD5OM2kCWZsRdCVR72cKa3fNEvSq4wartO1Gf+XnNP+kP4b0+Av4sjj2xnyYvgegVBEsRsp/nrODPVHkr9j8W4Os0z4YJqO6inAig3SE0zHUu/YVlqEcmWbnMPE1DbbuyBkl/R+RjBJS6Akog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzXdSJpqZ5ew1lQZDpbRlWTfUQr7MgzG88cvzIeoXwc=;
 b=ILnl8lsvdLcFAuL4kgxwwj0oRhuq1BoGoR3SzkJpDmCU1ueyAWyd/nEszHGS7OL5riSZWZWT6W+OuDACxWzr/CdPzLU/aQ1go9LBSlZjJhHB2ptBqRg8VxbEB6kDFiWxEBkKdh7VcD/efwJXgaYZrrKg5AIVQ5aStDsqY+lRKFpfeKSLzSRo/B2WfuZGkWuHWmaPZKI5u/Da+yiGDfWqeH+NnOqoUjbZeS+S5pQooxSEL78nvYbbTspWEeMzmUt67gCaOz2ZHSslwpqI5sE7ZtR2YezDWhyzPcnJN8KewEthxLnysiIu1Fz4xGOlelloDdv6cPt1CyWHYrFk1pooLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qzXdSJpqZ5ew1lQZDpbRlWTfUQr7MgzG88cvzIeoXwc=;
 b=PIof+W8mUX2aufF6rZLOLkZMMtBncAYl2UbUdE3yeaTFuflPapVdKyz4XFqFHFPDA3UNg16QKB83CBENUw/+zpdg9bzbDOvWDOEM9WiY2q1/HckDjqIF0N8fe9QR9Gmcd51TVvNtFm93+j4XL7xUzwWPOBADpMOrP+0xwNRZwYA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1385.namprd12.prod.outlook.com (2603:10b6:3:6e::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3000.26; Tue, 19 May 2020 14:32:30 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3000.034; Tue, 19 May
 2020 14:32:30 +0000
Subject: Re: [PATCH] KVM: x86: only do L1TF workaround on affected processors
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20200519095008.1212-1-pbonzini@redhat.com>
 <adb8a844689f1569875b1e6574ce7db4962e611c.camel@redhat.com>
 <d1f27df9-2f25-cce1-918e-6471b56db801@amd.com>
 <043b0ee715413433e9ece0cb05f75e3c5f8799ce.camel@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <bcd5c148-ad8e-67e9-5858-8ab79c3e101c@amd.com>
Date:   Tue, 19 May 2020 09:32:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <043b0ee715413433e9ece0cb05f75e3c5f8799ce.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0201CA0071.namprd02.prod.outlook.com
 (2603:10b6:803:20::33) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0201CA0071.namprd02.prod.outlook.com (2603:10b6:803:20::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25 via Frontend Transport; Tue, 19 May 2020 14:32:29 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9412bc8f-e686-4f29-dd57-08d7fc0175c7
X-MS-TrafficTypeDiagnostic: DM5PR12MB1385:
X-Microsoft-Antispam-PRVS: <DM5PR12MB13853714E9BD29ED7944ACACECB90@DM5PR12MB1385.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 040866B734
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Krh6msNmFWXGB/2U3mox7GNXRp8z7DCFwYX3XfCY05J/5EsYb8/D4JslVsP+zL2/czmKcPMxtfvFpfOEeJoPlC1O9gzO/M9X7Ayj40KsE1Kz0skwTmuMpqYhmHT3sJCgRePrUjee9IYVuagc3t34wZCPKWCLO0sJFSh92VxRBenub/5uQPXDuJeLZnbjlu8ezrcnnaGMAVFSs1otArMB8oyiLjB8ho/mFpKWL1L7WLYCqy1bwvbv8iKaADENX2Xf2ScXbZpbIpkrmIg7P4IX1nAdkgMtt5ZJENy+axmH7U7nrDTrptd6oNxkMmI0DuFKq5T8LBXjd+2vIkyYrNyL3N9HkwzlWiT2TkBXoQYrR3JdeROGLhu2hDQTwnMRx5yzJlmPXbRbRjOegSHDaH4v7Lw1ca5fpNhl0yYdpmXdxCn1wA/H4sgQr+2S2LZJRZpRMbU64vKbwX4jzT8qL7rkfpcjXYgBOvFSuj/FL3QoAnHQ1dBQPNspoahjs57f5ETYnWXgPLHg8PFcQSuszCCZoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(39860400002)(136003)(396003)(2906002)(2616005)(16526019)(316002)(186003)(110136005)(26005)(36756003)(6486002)(31686004)(6512007)(956004)(4326008)(31696002)(478600001)(8936002)(5660300002)(66476007)(66556008)(66946007)(52116002)(6506007)(8676002)(53546011)(86362001)(32563001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CFmLwFaf1W4PdfXrhKT50hZCypqYMnBOVnI1N3KMdVX0qnM8CuqcQxBq/1Egrd6ElBW3RmRG61X69MIXb3tK62exkm1J74WIXlabL81zJfEm7KvMG5kSqdlWa4LVjHNwq/KlPeq5K5d1McxZG+wzAcGWsodvwzA9kl31mGyAn1xrarHu9dHU0A+SbToNVOM9p2LdDg/+tcHq1nIzkiCgwEh/3cl42pIhfRPnsG6Y0XhoMeBzkqkJPg8BYio6sfRI2hcxW86xqaLeV4UBFwoT6TBJgHASM5vBaa7D2H+MNV/u0ljhpZZmyTnyoDleGhOhhDMkmjbzxbLUz9FrYq/UVneXqQGEE1OzU1xmKZzuCnHt4xz/2hUs9GxdSd5TUOWowPW/F5SvwuailTAUPeyYlkM4h2/Pro8iDD7ZivDPYXx58ggUfir2TnkA2biC+v2rdFoAx3vEyK1ptUeiRZtIptkka4q50ebFQ7hKcJ701//SfTqFQx1BHMAivXdj7iE3
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9412bc8f-e686-4f29-dd57-08d7fc0175c7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2020 14:32:30.0552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 68LzoChoPwHKMSCJS1M7XYNosp3L6NBokrYmY/f2ZnzOj0LcZMwzevrcyB1nPzPnuVgmJcM2p+L255A8PHWLpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1385
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/19/20 9:06 AM, Maxim Levitsky wrote:
> On Tue, 2020-05-19 at 08:56 -0500, Tom Lendacky wrote:
>> On 5/19/20 5:59 AM, Maxim Levitsky wrote:
>>> On Tue, 2020-05-19 at 05:50 -0400, Paolo Bonzini wrote:
>>>> KVM stores the gfn in MMIO SPTEs as a caching optimization.  These are split
>>>> in two parts, as in "[high 11111 low]", to thwart any attempt to use these bits
>>>> in an L1TF attack.  This works as long as there are 5 free bits between
>>>> MAXPHYADDR and bit 50 (inclusive), leaving bit 51 free so that the MMIO
>>>> access triggers a reserved-bit-set page fault.
>>>
>>> Most of machines I used have MAXPHYADDR=39, however on larger server machines,
>>> isn't MAXPHYADDR already something like 48, thus not allowing enought space for these bits?
>>> This is the case for my machine as well.
>>>
>>> In this case, if I understand correctly, the MAXPHYADDR value reported to the guest can
>>> be reduced to accomodate for these bits, is that true?
>>>
>>>
>>>> The bit positions however were computed wrongly for AMD processors that have
>>>> encryption support.  In this case, x86_phys_bits is reduced (for example
>>>> from 48 to 43, to account for the C bit at position 47 and four bits used
>>>> internally to store the SEV ASID and other stuff) while x86_cache_bits in
>>>> would remain set to 48, and _all_ bits between the reduced MAXPHYADDR
>>>> and bit 51 are set.
>>>
>>> If I understand correctly this is done by the host kernel. I haven't had memory encryption
>>> enabled when I did these tests.
>>>
>>>
>>> FYI, later on, I did some digging about SME and SEV on my machine (3970X), and found out that memory encryption (SME) does actually work,
>>> except that it makes AMD's own amdgpu driver panic on boot and according to google this is a very well known issue.
>>> This is why I always thought that it wasn't supported.
>>>
>>> I tested this issue while SME is enabled with efifb and it seems that its state (enabled/disabled) doesn't affect this bug,
>>> which suggest me that a buggy bios always reports that memory encrypiton is enabled in that msr, or something
>>> like that. I haven't yet studied this area well enought to be sure.
>>
>> If the SMEE MSR bit (bit 23 of 0xc0010010) is enabled then the overall
>> hardware encryption feature is active which means the encryption bit is
>> available and active, regardless of whether the OS supports it or not, and
>> the physical address space is reduced.
> 
> This means if I understand correctly that when I don't enable the encryption in
> the kernel, then basically kernel just doesn't set the 'C' bit in the physical address,
> but it can if it wanted to.
> This makes sense, thanks for the explanation.
> 
> 
>>
>> Some BIOSes provide an option to disable/turn off the SMEE bit, but not all.
>>
> My BIOS indeed doesn't have any option in regard to this.
> 
> 
>>> SEV on the other hand is not active because the system doesn't seem to have PSP firmware loaded,
>>> and only have CCP active (I added some printks to the ccp/psp driver and it shows that PSP reports 0 capability which indicates that it is not there)
>>> It is reported as supported in CPUID (even SEV-ES).
>>
>> Correct, the hardware supports the feature, but you need the SEV firmware,
>> too. The SEV firmware is only available on EPYC processors.
> That what I figured out. Thanks!
> 
> BTW, any ideas on why AMDGPU driver crashes with SME enabled?
> Is it still not supported or this is is a corner case which I can file a bug report about?

I think it is because the GPU doesn't support as high a physical address 
size as the CPU and when the encryption bit is set it appears to be an 
invalid address.

Many BIOSes have an option to enable something called TSME (transparent 
SME). This encrypts everything to/from DRAM without having to use the 
pagetable bits. This allows memory encryption for non-enlightened OSes and 
allows the GPU to function with DRAM encryption.

Thanks,
Tom

> 
> I have Radeon Pro WX 4100, and I am using mainline branch of the kernel.
> 
> I don't yet have means to capture the kernel panic it is getting,
> since I don't yet have a serial port on this machine, and I am looking
> into getting one trying my luck with usb3 debug cable.
> 
> I used to get the kernel panic reports via 'ramoops' mechanism which relies on
> storing the kernel log in a fixed area in the ram, and on the fact that BIOS doesn't really
> clear the memory on reboot, but since memory is encrypted it doesn't work.
> 
> Best regards,
> 	Maxim Levitsky
> 
