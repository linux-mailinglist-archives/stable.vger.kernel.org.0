Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBE8228E5A
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 05:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731878AbgGVDDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 23:03:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:46385 "EHLO
        mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731781AbgGVDDo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 23:03:44 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail.windriver.com (8.15.2/8.15.2) with ESMTPS id 06M33eAQ005447
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Tue, 21 Jul 2020 20:03:41 -0700 (PDT)
Received: from [128.224.162.214] (128.224.162.214) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.50) with Microsoft SMTP Server id 14.3.487.0; Tue, 21 Jul 2020
 20:03:40 -0700
Subject: Re: Subject: Re: [PATCH 1/1] iommu/vt-d: Skip TE disabling on quirky
 gfx dedicated iommu
To:     Lu Baolu <baolu.lu@linux.intel.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <DM6PR11MB2587034DFBEDFB091CE9AAD58E790@DM6PR11MB2587.namprd11.prod.outlook.com>
 <0f4b6760-bb8f-ebd3-ab9d-4ecba819883c@linux.intel.com>
From:   Jun Miao <jun.miao@windriver.com>
Message-ID: <afb6b8d8-20b1-b00e-575e-0a4474f723b7@windriver.com>
Date:   Wed, 22 Jul 2020 11:03:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0f4b6760-bb8f-ebd3-ab9d-4ecba819883c@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/22/20 10:40 AM, Lu Baolu wrote:
> Hi Jun,
>
> On 7/22/20 10:26 AM, Miao, Jun wrote:
>>>> Kernel panic - not syncing: DMAR hardware is malfunctioning
>>>> CPU: 0 PID: 347 Comm: rtcwake Not tainted 5.4.0-yocto-standard #124
>>>> Hardware name: Intel Corporation Ice Lake Client Platform/IceLake U 
>>>> DDR4
>>>> SODIMM PD RVP TLC, BIOS ICLSFWR1.R00.3162.A00.1904162000 04/16/2019
>>>> Call Trace:
>>>>    dump_stack+0x59/0x75
>>>>    panic+0xff/0x2d4
>>>>    iommu_disable_translation+0x88/0x90
>>>>    iommu_suspend+0x12f/0x1b0
>>>>    syscore_suspend+0x6c/0x220
>>>>    suspend_devices_and_enter+0x313/0x840
>>>>    pm_suspend+0x30d/0x390
>>>>    state_store+0x82/0xf0
>>>>    kobj_attr_store+0x12/0x20
>>>>    sysfs_kf_write+0x3c/0x50
>>>>    kernfs_fop_write+0x11d/0x190
>>>>    __vfs_write+0x1b/0x40
>>>>    vfs_write+0xc6/0x1d0
>>>>    ksys_write+0x5e/0xe0
>>>>    __x64_sys_write+0x1a/0x20
>>>>    do_syscall_64+0x4d/0x150
>>>>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>> RIP: 0033:0x7f97b8080113
>>>> Code: 8b 15 81 bd 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 
>>>> 0f 1f 00
>>>> 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 01 00 00 00 0f 05 <48> 3d 00 
>>>> f0 ff ff
>>>> 77 55 c3 0f 1f 40 00 48 83 ec 28 48 89 54 24 18
>>>> RSP: 002b:00007ffcfa6f48b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>>>> RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f97b8080113
>>>> RDX: 0000000000000004 RSI: 000055e7db03b700 RDI: 0000000000000004
>>>> RBP: 000055e7db03b700 R08: 000055e7db03b700 R09: 0000000000000004
>>>> R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000004
>>>> R13: 000055e7db039380 R14: 0000000000000004 R15: 00007f97b814d700
>>>> Kernel Offset: 0x38a00000 from 0xffffffff81000000 (relocation range:
>>>> 0xffffffff80000000-0xffffffffbfffffff)
>>>> ---[ end Kernel panic - not syncing: DMAR hardware is 
>>>> malfunctioning ]---
>>
>
> Do you mean that system hangs in iommu_disable_translation() without 
> this fix.
>
Yes ,From the call trace and i also read the DMARD_GCMD_RGS is wrong 
without this patch.
>> [S3 successfully with the patch]
>
> And, this failure disappeared after you applied this fix?
>
> Best regards,
> baolu
