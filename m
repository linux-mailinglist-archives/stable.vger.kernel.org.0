Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D401331FB22
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 15:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhBSOoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 09:44:24 -0500
Received: from mail-dm6nam10on2076.outbound.protection.outlook.com ([40.107.93.76]:33889
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229527AbhBSOoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 09:44:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/YwgWZWwbQxrsZtarhsIFV6I78hhKHEPwBbhDCOxDB+HIrzq4dw/7SA7T/NuulEpHeXNincom2kStEaevWHoDXhh2ybBmgh978JMpxbXYmH7WNX7E7+m+IC/qehVNex+OklTHd25e4UOR57X6gzHMtLXp9iwUAFeH/N0IcmTR+rbs5aHHMwpMFssx1/qrKjKrgx3JgPeD5+QZzeq8ymd3FdybZbiD4hWeAXya+8gIIEyR4hTSe3NbzJ9T77Gw2KiDcgINRMwDFRye1+RA7Dxl6Gf6rJ/hbIABoBoOMmBXdK2sZR1PMCJO6bsfKCnVqaX+obPkU9jYG4noDAiJSrtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7Ad47WmeesF1ZACPQ2MrN1CXEofAVdgqrERlccwaRY=;
 b=B/51SBH1IHZk/wVcIPq++w9RoM+WNEuXhzYjeZkIQ6MWIFC/eZlwcQ0RFMy5E1Bqr5bXGEsy/1nTH802ucPMIPTNmJaLA5rU7wOf5LF5gxm7frwN1yL5RrdldcaKxUJMlf6M33lPe0136GLjtCmV9ThMvGehWNqY0i2yQMybPQuUeqINgXqs3F2+Z4oPSLl9Lu3SeqvJ2ttVhMeB+kXjfAeaw5/vhhShFKD7V/iu/YNslIgBPI0z8RW0oI6flR3OnVg2ArJmgSX/pqSbWwwGL1qbAMq4f16cz0B0zTx4tM8ykmqI/OG7WYsPqNlkU5xQoR9ZhFyWtoRjvwpDrJ+I3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7Ad47WmeesF1ZACPQ2MrN1CXEofAVdgqrERlccwaRY=;
 b=0AVA+VwgtXE+dkVZhVvuFCOpkrYRgp+35uZ9lYwohjIzE8RDe9/+aAB4zEau/AnVO/F12/AZZbXzvPxwbMinN+WA9ErIgWgnCeg/f10pdl4LgfyJLT+6xNZ++VQJKN78t7wOehEGpr9MmBweL3LERV+C0v8EK/RE4vt5+w7wFYI=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4223.namprd12.prod.outlook.com (2603:10b6:208:1d3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 19 Feb
 2021 14:43:28 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3846.038; Fri, 19 Feb 2021
 14:43:28 +0000
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
To:     Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sumit.semwal@linaro.org,
        gregkh@linuxfoundation.org
Cc:     Felipe Balbi <balbi@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        Johan Hovold <johan@kernel.org>,
        dri-devel@lists.freedesktop.org,
        Alan Stern <stern@rowland.harvard.edu>, stable@vger.kernel.org,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>
References: <20210219134014.7775-1-tzimmermann@suse.de>
 <02a45c11-fc73-1e5a-3839-30b080950af8@amd.com>
 <1169bf2d-ce01-9852-edd3-7d2df037012b@suse.de>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <4e1b8bd6-7f1d-043e-349b-9369621b4eab@amd.com>
Date:   Fri, 19 Feb 2021 15:43:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <1169bf2d-ce01-9852-edd3-7d2df037012b@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:eb81:6e66:649f:1820]
X-ClientProxiedBy: AM0PR04CA0016.eurprd04.prod.outlook.com
 (2603:10a6:208:122::29) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:eb81:6e66:649f:1820] (2a02:908:1252:fb60:eb81:6e66:649f:1820) by AM0PR04CA0016.eurprd04.prod.outlook.com (2603:10a6:208:122::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Fri, 19 Feb 2021 14:43:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2d1f4bc8-5c3c-4235-185e-08d8d4e4b804
X-MS-TrafficTypeDiagnostic: MN2PR12MB4223:
X-Microsoft-Antispam-PRVS: <MN2PR12MB42239FDD0B111D2200B5545183849@MN2PR12MB4223.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RT27/YBeONOjdYGnYE1Poe4+nHAckeu1rKbemWQRklK20NL2TmvcoHsp5dVDoW8jDMatrChEdIrZXo5UvKLl5/6TRP++a4ZbUeJY57Uk8/frkiwzxYEs83qQyxLSNhJAtCUq0ksua8jJIBxld+TbqhWo0vEP6/61gmaSif9PoJH15ptxij8FwHeA/tMtqqblq+MOY6YBNQf790MZ+m5A3R6xh5sx/fZruWWAsUXUnGeiXME0UfnZEQc+NRvHoo1m+fcM5EI8fejRYTInlO6s9YhrngDngmbjieqc61bTRqup/qY5heTOKkthgW9CqDu5N0RoLqezFDydostCtBeHMw2mz6JuKYqNx1SL/AioDgfi4LQOqieQhYnf/Je4rH396ioP9A8mzZ0px5q/OVUtYf2uv1yKgbpXv1qBH++A6MPV4jsRP4zAjn3Q1ft4Uu8Wfz7D9abgwZlzse2rl6G8FnHdMMjpqdaqH5I2eY/q8iK3ede23X99pRzNEC9IYMGngopUsQMsZFRWYp5xppkuWiNZWk6HCtWWhPI/pOF53DHez65xWqPCpdtxZcXqYrzRH0KGPkvEuTKAj5OU65W63NrIFUSM+Cmru6ptYvt3Mhku3ViSjRGB9ux4Qjw+/4xIC5UsYwNRIzMQ6+svJ8DwOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(186003)(31696002)(2906002)(86362001)(16526019)(66476007)(36756003)(316002)(6486002)(31686004)(5660300002)(478600001)(66946007)(45080400002)(966005)(7416002)(2616005)(54906003)(8936002)(4326008)(52116002)(6666004)(8676002)(66574015)(83380400001)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TDhhb0JZcXV1MjR2NTE1NDltVXpiYzRncWw4cXM0NWlOamtZZlg5a0lkVWxs?=
 =?utf-8?B?NUMrelF2L2pqdGUzeFdqMVlmLzN3UU0yTTQrcy9wUXpYY3R2TDYwdlh4NExF?=
 =?utf-8?B?bUhBbnZjYVo2V3NPUDEvU3BZK1V1L1NjYWxqQktsMi9qeUs4Y2w5eGJXZ05L?=
 =?utf-8?B?QlRtcUhDd1g2V3dNL2lxcVFKaGgxNmd6SHBkdWU4a21Nbk5WNCswK0tZT2kx?=
 =?utf-8?B?aUJ4VzBnR2NtbUlvd0pqU0hmdjlkVnFMT1U0NFNFb1B3dFBqLzBPUmdhQ2NQ?=
 =?utf-8?B?YkVmUzBJSWxEc1MwTVJDRCtCdCtXa0FQdE9nWXVZbUxZcUQzaURqL3dkWkNk?=
 =?utf-8?B?TVdPY3pyeFhQODR1MGhxUWdnQXFkdlp2UityempnSzR2ZzI3OUNaOFp6aEts?=
 =?utf-8?B?WDI5VGFTLzRwQ2dYZTJTNHB5Q3RiTHFKNkFmcHZ6OUR5a3U0cEpNSitqYmhM?=
 =?utf-8?B?WGtwSmZlUWZ4ZVRCS3BpUmZSQlVESlArMGJWYW9XLzgvZWcxZDVEeHBkbDkx?=
 =?utf-8?B?TVFzTFZwNVVjVHExV2RuT0V1Njl4K3YxZnRnMGNZVGFjK1Z5YUZFMzF3dEpD?=
 =?utf-8?B?K2xQMlltazBTSjZqU0V0bFZNako3VGpySTRnVUJUY2ttTGNBRTVBZzJtTXp6?=
 =?utf-8?B?VW5tQXNKZFczU3pXUE5rbFA3V01sNVovSnlrK3o3WSt0ZWM0Uk1mbnJTWFl5?=
 =?utf-8?B?TFkyam5rVmtUUlYrUmlJRlVYV0hTeHdvek92UklHTHpnT0tmam1kNC8wTlRH?=
 =?utf-8?B?UlhRbk1rOFRNck03aG5MeTV4REdUcFRXYU5CRFE1Z3loNjMrNWNkT1dJVGNx?=
 =?utf-8?B?aWE2WnNiZ1d0S0ZaNGJzVmxXajBHWVFpbW1wOTFWQUZGcE1CUXZjUUI5OFEz?=
 =?utf-8?B?MkxBRjQ2Q0V1NWMxR0FSYlJMSnZLTjNhRHlEYzQyWmpKUHFDKzBKZC9qWnZ2?=
 =?utf-8?B?Ty9MU0I2M1ZycFd2S09wRFpNTS84SXpZOXpMUkZ1ZWFuL3ZNRUY1Zkl0SUpT?=
 =?utf-8?B?T1MzWWtHNG9GTEZMbURQaEdhdU1LaU1RZjYvREVuN3p2VStjcS9CVkdxOTV2?=
 =?utf-8?B?OER5M1h6YWliYll0d3Z6eW41QzJNK2dkbWhaRmR2MWR5ZVpibVdLMXFEVlo0?=
 =?utf-8?B?aXY1b0p2cVNrWG52dVhkaFFFdHdXZDRnbTcxMlpwL01icWFzVi9hZndFVThY?=
 =?utf-8?B?QUU3NUdmRlRsT3NLMWtacnVHa3hNaWdrK0wyVW9Wd2loTVhZWmtZQ1V3STJE?=
 =?utf-8?B?Z1dzckwvdDNEVm9RWEJVaGNvVDV3QmFiS0lLQjJWaFkzTFgzUkYxZ3U4SVls?=
 =?utf-8?B?UXUrVWNQZktXQ3hydDIyRU9laUlRQXNuY3RxY1NTYllnWngwbnp5eEZySUVi?=
 =?utf-8?B?MSt0dngybWFPR2hlcjNXNUc4SitRY1hpR0lDUGN4ZE4vWTVBZ0hxR2ZKYVQ3?=
 =?utf-8?B?MllJNlZBU0ZwNy9MVi9peG9zNkJyRnNRN21SSFh5Q1B1R2hTUlZQUmVaWDYw?=
 =?utf-8?B?Z2RyeFpSRmNkTHY0eUtGb2V6TDBKTis2K1hLRjRUWlR1bzlWTHRZY1UrRVRY?=
 =?utf-8?B?R1NMMjZyZUZSOFQvVlJSZDROdjN6cjlpcTFoUjdKRTRraUhQZUkzMGFERTJ0?=
 =?utf-8?B?dlVNWVNvZFd4SDhwR1Ewai9naWgyT2l1bmc5M3hvem1takdobm8rKzZONmha?=
 =?utf-8?B?cXN4dVRya2dpcGUyWFpLbXRqUXhJTTlMdWpJQlF3OXVjbG16MUt4RXdKTnJx?=
 =?utf-8?B?SENJdVQ3b2JLN3dPa3dSb25kdGVENSttUE9BQmM4eDhxNkFlczQ4Z2k5OHRY?=
 =?utf-8?B?UzhmNjJjTmcyQ1JiWlo3K2RIekpWZURlOXUxa3hhd0xtM014VVV6a3MrcnYy?=
 =?utf-8?Q?Xj8SEvbe0bbja?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d1f4bc8-5c3c-4235-185e-08d8d4e4b804
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 14:43:28.1101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uAbPXWslIeImQ3TvgCSGM+jBpY64Hb5N+oWIcfr0sP+99loCc31bIOJw7qSrdF0A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4223
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 19.02.21 um 15:34 schrieb Thomas Zimmermann:
> Hi
>
> Am 19.02.21 um 14:45 schrieb Christian König:
>> Well as far as I can see this is a relative clear NAK.
>>
>> When a device can't do DMA and has no DMA mask then why it is 
>> requesting an sg-table in the first place?
>>
>> The problem is rather in drm_gem_prime_import_dev() which always 
>> tries to create an sg-table to get a GEM object, even when the device 
>> doesn't support DMA at all.
>
> Sure, that's the clean solution. But it also needs a bit of work on 
> the way the importing works. Our generic code assumes that an SG table 
> is being used. Most driver's memory managers as well, I guess.
>
> The regressing patch has already been in upstream kernels for a while. 
> The fix at hand is backport-able at least.
>
> Can we add a TODO item for the real thing?

Not really.

The "fix" here is a hack for the export handling code in DRM. That only 
works because the USB device tries to communicate with another DRM 
driver, but is not a general solution you could backport.

What you can do instead for example to fix this is to implement the 
gem_prime_import callback in the USB device so that the GEM object is 
created without trying to get an sg-table without being DMA capable.

Regards,
Christian.

>
> Best regards
> Thomas
>
>>
>> Regards,
>> Christian.
>>
>> Am 19.02.21 um 14:40 schrieb Thomas Zimmermann:
>>> Fixes a regression for udl and probably other USB-based drivers where
>>> joining and mirroring displays fails.
>>>
>>> Joining displays requires importing a dma_buf from another DRM driver.
>>> These devices don't support DMA and therefore have no DMA mask. Trying
>>> to map imported buffers from a DMA-able memory zone fails with an 
>>> error.
>>> An example is shown below.
>>>
>>> [   60.050199] ------------[ cut here ]------------
>>> [   60.055092] WARNING: CPU: 0 PID: 1403 at kernel/dma/mapping.c:190 
>>> dma_map_sg_attrs+0x8f/0xc0
>>> [   60.064331] Modules linked in: af_packet(E) rfkill(E) 
>>> dmi_sysfs(E) intel_rapl_msr(E) intel_rapl_common(E) 
>>> snd_hda_codec_realtek(E) snd_hda_codec_generic(E) ledtrig_audio(E) 
>>> snd_hda_codec_hdmi(E) x86_pkg_temp_thermal(E) intel_powerclam)
>>> [   60.064801]  wmi(E) video(E) btrfs(E) blake2b_generic(E) 
>>> libcrc32c(E) crc32c_intel(E) xor(E) raid6_pq(E) sg(E) 
>>> dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) 
>>> scsi_dh_alua(E) msr(E) efivarfs(E)
>>> [   60.170778] CPU: 0 PID: 1403 Comm: Xorg.bin Tainted: G            
>>> E    5.11.0-rc5-1-default+ #747
>>> [   60.179841] Hardware name: Dell Inc. OptiPlex 9020/0N4YC8, BIOS 
>>> A24 10/24/2018
>>> [   60.187145] RIP: 0010:dma_map_sg_attrs+0x8f/0xc0
>>> [   60.191822] Code: 4d 85 ff 75 2b 49 89 d8 44 89 e1 44 89 f2 4c 89 
>>> ee 48 89 ef e8 62 30 00 00 85 c0 78 36 5b 5d 41 5c 41 5d 41 5e 41 5f 
>>> c3 0f 0b <0f> 0b 31 c0 eb ed 49 8d 7f 50 e8 72 f5 2a 00 49 8b 47 50 
>>> 49 89 d8
>>> [   60.210770] RSP: 0018:ffffc90001d6fc18 EFLAGS: 00010246
>>> [   60.216062] RAX: 0000000000000000 RBX: 0000000000000020 RCX: 
>>> ffffffffb31e677b
>>> [   60.223274] RDX: dffffc0000000000 RSI: ffff888212c10600 RDI: 
>>> ffff8881b08a9488
>>> [   60.230501] RBP: ffff8881b08a9030 R08: 0000000000000020 R09: 
>>> ffff888212c10600
>>> [   60.237710] R10: ffffed10425820df R11: 0000000000000001 R12: 
>>> 0000000000000000
>>> [   60.244939] R13: ffff888212c10600 R14: 0000000000000008 R15: 
>>> 0000000000000000
>>> [   60.252155] FS:  00007f08ac2b2f00(0000) GS:ffff8887cbe00000(0000) 
>>> knlGS:0000000000000000
>>> [   60.260333] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   60.266150] CR2: 000055831c899be8 CR3: 000000015372e006 CR4: 
>>> 00000000001706f0
>>> [   60.273369] Call Trace:
>>> [   60.275845]  drm_gem_map_dma_buf+0xb4/0x120
>>> [   60.280089]  dma_buf_map_attachment+0x15d/0x1e0
>>> [   60.284688]  drm_gem_prime_import_dev.part.0+0x5d/0x140
>>> [   60.289984]  drm_gem_prime_fd_to_handle+0x213/0x280
>>> [   60.294931]  ? drm_prime_destroy_file_private+0x30/0x30
>>> [   60.300224]  drm_ioctl_kernel+0x131/0x180
>>> [   60.304291]  ? drm_setversion+0x230/0x230
>>> [   60.308366]  ? drm_prime_destroy_file_private+0x30/0x30
>>> [   60.313659]  drm_ioctl+0x2f1/0x500
>>> [   60.317118]  ? drm_version+0x150/0x150
>>> [   60.320903]  ? lock_downgrade+0xa0/0xa0
>>> [   60.324806]  ? do_vfs_ioctl+0x5f4/0x680
>>> [   60.328694]  ? __fget_files+0x13e/0x210
>>> [   60.332591]  ? ioctl_fiemap.isra.0+0x1a0/0x1a0
>>> [   60.337102]  ? __fget_files+0x15d/0x210
>>> [   60.340990]  __x64_sys_ioctl+0xb9/0xf0
>>> [   60.344795]  do_syscall_64+0x33/0x80
>>> [   60.348427]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> [   60.353542] RIP: 0033:0x7f08ac7b53cb
>>> [   60.357168] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c 
>>> ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 
>>> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 ba 0c 00 f7 d8 64 
>>> 89 01 48
>>> [   60.376108] RSP: 002b:00007ffeabc89fc8 EFLAGS: 00000246 ORIG_RAX: 
>>> 0000000000000010
>>> [   60.383758] RAX: ffffffffffffffda RBX: 00007ffeabc8a00c RCX: 
>>> 00007f08ac7b53cb
>>> [   60.390970] RDX: 00007ffeabc8a00c RSI: 00000000c00c642e RDI: 
>>> 000000000000000d
>>> [   60.398221] RBP: 00000000c00c642e R08: 000055831c691d00 R09: 
>>> 000055831b2ec010
>>> [   60.405446] R10: 00007f08acf6ada0 R11: 0000000000000246 R12: 
>>> 000055831c691d00
>>> [   60.412667] R13: 000000000000000d R14: 00000000007e9000 R15: 
>>> 0000000000000000
>>> [   60.419903] irq event stamp: 672893
>>> [   60.423441] hardirqs last  enabled at (672913): 
>>> [<ffffffffb31b796d>] console_unlock+0x44d/0x500
>>> [   60.432230] hardirqs last disabled at (672922): 
>>> [<ffffffffb31b7963>] console_unlock+0x443/0x500
>>> [   60.441021] softirqs last  enabled at (672940): 
>>> [<ffffffffb46003dd>] __do_softirq+0x3dd/0x554
>>> [   60.449634] softirqs last disabled at (672931): 
>>> [<ffffffffb44010f2>] asm_call_irq_on_stack+0x12/0x20
>>> [   60.458871] ---[ end trace f2f88696eb17806c ]---
>>>
>>> For the fix, we don't call dma_map_sgtable() for devices without the
>>> DMA mask. Drivers for such devices have to map the imported buffer into
>>> kernel address space and perfom the copy operation in software.
>>>
>>> Tested by joining/mirroring displays of udl and radeon un der 
>>> Gnome/X11.
>>>
>>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB 
>>> devices")
>>> Cc: Christoph Hellwig <hch@lst.de>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: Alan Stern <stern@rowland.harvard.edu>
>>> Cc: Johan Hovold <johan@kernel.org>
>>> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>>> Cc: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>>> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
>>> Cc: Oliver Neukum <oneukum@suse.com>
>>> Cc: Felipe Balbi <balbi@kernel.org>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: <stable@vger.kernel.org> # v5.10+
>>> ---
>>>   drivers/gpu/drm/drm_prime.c | 27 ++++++++++++++++++---------
>>>   1 file changed, 18 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
>>> index 2a54f86856af..d5a39fe76b78 100644
>>> --- a/drivers/gpu/drm/drm_prime.c
>>> +++ b/drivers/gpu/drm/drm_prime.c
>>> @@ -603,10 +603,15 @@ EXPORT_SYMBOL(drm_gem_map_detach);
>>>    * @attach: attachment whose scatterlist is to be returned
>>>    * @dir: direction of DMA transfer
>>>    *
>>> - * Calls &drm_gem_object_funcs.get_sg_table and then maps the 
>>> scatterlist. This
>>> - * can be used as the &dma_buf_ops.map_dma_buf callback. Should be 
>>> used together
>>> + * Calls &drm_gem_object_funcs.get_sg_table and, if possible, maps 
>>> the scatterlist.
>>> + * This can be used as the &dma_buf_ops.map_dma_buf callback. 
>>> Should be used together
>>>    * with drm_gem_unmap_dma_buf().
>>>    *
>>> + * Devices on some peripheral busses, such as USB, cannot use DMA. 
>>> In this case,
>>> + * pages in the scatterlist remain unmapped. Drivers for such 
>>> devices should acquire
>>> + * a mapping with dma_buf_vmap() and implement copy operation via 
>>> bus-specific
>>> + * interfaces.
>>> + *
>>>    * Returns:sg_table containing the scatterlist to be returned; 
>>> returns ERR_PTR
>>>    * on error. May return -EINTR if it is interrupted by a signal.
>>>    */
>>> @@ -627,12 +632,14 @@ struct sg_table *drm_gem_map_dma_buf(struct 
>>> dma_buf_attachment *attach,
>>>       if (IS_ERR(sgt))
>>>           return sgt;
>>>
>>> -    ret = dma_map_sgtable(attach->dev, sgt, dir,
>>> -                  DMA_ATTR_SKIP_CPU_SYNC);
>>> -    if (ret) {
>>> -        sg_free_table(sgt);
>>> -        kfree(sgt);
>>> -        sgt = ERR_PTR(ret);
>>> +    if (attach->dev->dma_mask) {
>>> +        ret = dma_map_sgtable(attach->dev, sgt, dir,
>>> +                      DMA_ATTR_SKIP_CPU_SYNC);
>>> +        if (ret) {
>>> +            sg_free_table(sgt);
>>> +            kfree(sgt);
>>> +            sgt = ERR_PTR(ret);
>>> +        }
>>>       }
>>>
>>>       return sgt;
>>> @@ -654,7 +661,9 @@ void drm_gem_unmap_dma_buf(struct 
>>> dma_buf_attachment *attach,
>>>       if (!sgt)
>>>           return;
>>>
>>> -    dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
>>> +    if (attach->dev->dma_mask)
>>> +        dma_unmap_sgtable(attach->dev, sgt, dir, 
>>> DMA_ATTR_SKIP_CPU_SYNC);
>>> +
>>>       sg_free_table(sgt);
>>>       kfree(sgt);
>>>   }
>>> -- 
>>> 2.30.0
>>>
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>

