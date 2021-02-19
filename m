Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01C9B31FA13
	for <lists+stable@lfdr.de>; Fri, 19 Feb 2021 14:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbhBSNq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Feb 2021 08:46:58 -0500
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:32928
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229553AbhBSNq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Feb 2021 08:46:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GL7BA1WjMuRjmHdcQjo5K0iLbscPE5Wedqv2IkRiAqwa/7DDNPusBRBejpL0ZIvDfsII4VI2Nz4Dv/L1mnFq9VhashSymaAbnrZvnQA843lhw4M+xbMtWJQjSIFyN/nAqGg3Fi9Dk5a4cJahe+3aY0oaBe6MpRMGutfbDNRgnrY7pk6xgvA4rTrEbBQt0ZvxBEsnW/HaDWJEIoOjte98XzIpXZGSuCojr1Of4HRvKTGwbhrrKyDlIvd04A+OKMtAHrGf9V0zhHSMd0HF7i8df9Abe/ZZkW8ismyhaSg2C2/LhmBX5TEKbHMyvrBjYISw4RWYNZujoBHDrFa5Ml8ucA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2VQOg9C/puvUmpVkltPBhyGlNF6yEgU27PrMxJ1WC0=;
 b=CZB3c/U6yRY+E8QuHWN9UGyGeHuAIP9PSntMlTt/WJaLGfq7onGW/uRIDhiJkXGOHmPgAxpOwCSQDxrWWA1zqtVwfeuHutxs+U84K2i3MkKs1yto4qEGOC6yCNSAvaD2AINBr7aOFUz9R7z9Yjy5mFxgIdCPQDSUlaiiKrojRE4YbUnp6phAavFUw8afHSytjnNu9bM359IZvc302+NIEUTra4sv84puz5wI+PgaD9gJfxTcxDCkUglyzGKIobEfFvw2uK55vLAJ9+ggylqfdRyGjOUTH8A0HtJHOs1z2yNgM2YeozOdk7Sc5GY5XOUMph4+gNCu1TbDzP4lkkOB8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2VQOg9C/puvUmpVkltPBhyGlNF6yEgU27PrMxJ1WC0=;
 b=RJm5Xt6M3Kyv13qocN2Em1swONsA72Qxocs+0AIuGfV1Jyt+jxtOTrAmMZhFObrxSAhSqIReh0f5kli/HsJ+zsunbTPGAKCEYyZdsd9bq14i4iOajI2AhyOqmfkvjWf39/gZAs3QZuBNIF6w95D3u03GCAWWCB1QCowO6TGQAOA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB3728.namprd12.prod.outlook.com (2603:10b6:208:167::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Fri, 19 Feb
 2021 13:46:02 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3846.038; Fri, 19 Feb 2021
 13:46:02 +0000
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
To:     Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sumit.semwal@linaro.org,
        gregkh@linuxfoundation.org
Cc:     dri-devel@lists.freedesktop.org, noralf@tronnes.org,
        Christoph Hellwig <hch@lst.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Felipe Balbi <balbi@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
References: <20210219134014.7775-1-tzimmermann@suse.de>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <02a45c11-fc73-1e5a-3839-30b080950af8@amd.com>
Date:   Fri, 19 Feb 2021 14:45:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210219134014.7775-1-tzimmermann@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2a02:908:1252:fb60:eb81:6e66:649f:1820]
X-ClientProxiedBy: AM0PR04CA0056.eurprd04.prod.outlook.com
 (2603:10a6:208:1::33) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a02:908:1252:fb60:eb81:6e66:649f:1820] (2a02:908:1252:fb60:eb81:6e66:649f:1820) by AM0PR04CA0056.eurprd04.prod.outlook.com (2603:10a6:208:1::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Fri, 19 Feb 2021 13:45:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df590cd8-6cc1-4d02-beec-08d8d4dcb1d9
X-MS-TrafficTypeDiagnostic: MN2PR12MB3728:
X-Microsoft-Antispam-PRVS: <MN2PR12MB37280E3849C1C60E7F40F4B583849@MN2PR12MB3728.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nz6QS5cnutA9GCD9YktMpQhykdtL1En62t/EtnVWexxwOj4FuiyeuCnd7+u+SWrxcj2OB0QAwjkBXy11fH+168BlphB847A0ZedhwpIb9CYJRQ3m6j7D7elBc/1UgSziK3jMOWHiHuV/PSaJNq3mV3ZXQsS9MYtGzJZnqZHNFrkJ/uLrp3ld1+NauNCjVLwMsCgBa0L/FRPZSa9oVpekj+GI7duUq6U4vYYwx3RYN3h0BHlPA9UhHBbNhxP2QSCiIuiPjYfHBxiTjHpYRKUzHKK89g1d2rldvzjhwiJm33j7GEf0A38cxjw2iJeGNtY4OeIirLE0ImkELIPoJncYvoYKEse7WuQVznnagk126H5KuIH9E8Rg1HXifoMfTlGuFWgIjA7ALusfqiVTWGkDqhYlcW8bXdN6Thia+fC/vsXsTqpSwHtq1DQ0AZqfN6U+Tm4d3kXHO3LpMebjd69sSOwucjNqI0ixUPaZLFSKoXquU6D9cn3KsUFp/8i0oYmBLEbNwbheL7eD/ptjosQevWOI2bIveXTQmyU0Ku1mfy2YPr0kWzNuRpbJtSG1b3IePW4Lxay/x3Yk5BXMUzfs8/X7+qNCmXxGiFOr6CjX+Jc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(346002)(136003)(39860400002)(4326008)(5660300002)(6666004)(2616005)(2906002)(8676002)(186003)(7416002)(52116002)(16526019)(86362001)(8936002)(83380400001)(66946007)(478600001)(66476007)(31696002)(316002)(31686004)(36756003)(66556008)(45080400002)(54906003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S1BKeWJUZU8rVEVRT01jamp2RXRQdEpkN01PempEKzdtSjlCVk9nZk1DekZs?=
 =?utf-8?B?cWlSV29NODRBc1FyUnM3R2pEYUk2ajlFMVJadGtGUVh6eGUzRnZmOWlPcHZC?=
 =?utf-8?B?L1FCbVJ4Ty9JcXJLa1Zad3UvclFVWVVOWWFkaUtIL3UrMkgxZUpPSzlxNmNN?=
 =?utf-8?B?cmFSZWZSZnRvc05qUCtXMEJGZmVpMDhER2Yyait2Sk5XRkxtMDZCek9LVVZP?=
 =?utf-8?B?amphZVo2RkxxdERFZHZyeE9TSW9COUpaOWQvdEtmeWV5Qm4yUFNINkJPbHNy?=
 =?utf-8?B?WW9LU0Jqdmg0RE1Ub1hKdW8yUHVId3BhdlhhZXVyQ0c3VVdUdy9la2NSZGpz?=
 =?utf-8?B?dGdSbHd4S1F4eE9iazJwc0RteGVQOWYwOVRMZ09HdHl6aEFXeG9GMkMyMm5J?=
 =?utf-8?B?b2JObTRkK2VNMVl6ZjYrb3ZDOFNOYVJwMFN5eWYzTmUyekdTMnVHd2thcEd2?=
 =?utf-8?B?ZUZyc2FISU5aeW1ydHpibmtWUzJpWlZZZjlXT3ByVG9zUGszRWdHZ3k1V0FN?=
 =?utf-8?B?Tit0TmJmUmwzdVk5L1lGUkFETXJxSWQzTzJYTmxYSm84a0k3ZnQvOWRjYzN4?=
 =?utf-8?B?cTlxc3dNdUpUaWhlelcrYlN0Ui9jaW9qVVRhWUFSSTVSKzFXZDVIdkFkWTYw?=
 =?utf-8?B?YTluOHVCZnkzWk1kRVdybFRrR0Evb0lmMEljSzNZWnM4cHdjbkZTNFEvcGxR?=
 =?utf-8?B?aFFLaG5sd003anprVmFoaE1oSUhrQmxpRWZsS1RVZnJCaGNIb0xWU3AyYTlz?=
 =?utf-8?B?cFRJMTh4UlQyckYrWXl0M1NWSmdCUjhMdnZtcWo3b29uSHZHNFRKdkdQUUhI?=
 =?utf-8?B?b2JWZTZUcEtSSTNvYStwdXFkUCs4c2txSWZ1SGtDaVB2UnFvVHQ5S2U0L1p3?=
 =?utf-8?B?bmh4bXV0cTZ2WWlUaXJOZC9FTS81NlM4Z0FURkpURWN2UGNhZDJJUG9rMjBG?=
 =?utf-8?B?TjNabTQ4cUVtcjZEMDJwd0I1enBRU2RrS3JMcXF2M1hGeEJZaUJpZ1duTVlF?=
 =?utf-8?B?VG5DY2RwQ2cwcUlOSUhFcDFXTEJtSjd4S3ZWeXBsV2VOS3pqZjgwRjlCaHVN?=
 =?utf-8?B?RERpZmhtSENNa21sRFNYRWEramdNaDR4MkNsMXJpVHA4Zkx2NWpSckkwc2ZS?=
 =?utf-8?B?eE1oS00xRzZIRWVBTndOVGJVbVREcFNyTUJxLzZPVEQvd3Z2SVptZi9OMEFJ?=
 =?utf-8?B?ajd4V2ZqRTV4VGFHZVFna1JncXl5SVhpbEdibFhsaDB0d0ZRQzNCSlFUWC95?=
 =?utf-8?B?T0d1VVB6K3dzUVNQb0IxN0IyK2tscWliZXBnNzJQKy9TaFJvWEpaZGJOdmR1?=
 =?utf-8?B?U2lmN080ZlVJdEJ1SGF0ay8weDBvOWIrTHh6bHlzMFEreTNQN1RiK1NlYm1j?=
 =?utf-8?B?eXBNeTdvSlJjcml0TjAzcjNpRU1yNGhTZ2FGZEg0bVRqYi9rcnJYY3dMSkU1?=
 =?utf-8?B?Z1VKRmhURU0xaStncmdRVmpsaWhZbWRoZTJwQ0VhekVrbWN1WUNydm5lRWZj?=
 =?utf-8?B?VTFZc2IweGhNTkw0R3hvbFF4Vnh4aFhOcEY0QnEvTTRhcS9lYU03VGVhYm9Z?=
 =?utf-8?B?bW5yZm1KS25meWtSWjVVWHlPeTFaQXNHTHpGakg4WDdZSTFVblprTjUrSEFV?=
 =?utf-8?B?K3FoYW1aemhiV0lhZzV4ajBNNndXNzlxNUppQk9SdkZVNHFBditjWXBoYWlI?=
 =?utf-8?B?RXV5VEo0VUtXN3dxdE1kVGczbTFJd0VqN2M1UjNFTTBTUlZybVdhYmtMbVNh?=
 =?utf-8?B?bU14VWloZktJRDlqQ05MZWVkSi9Ia2VZUVphTk9rRlMrakhTM2lHdTF4TEYr?=
 =?utf-8?B?S0hOZ1VielFQMGhDbVQxd2dFaUdodkk4STU4aml6MkFaNmVBVGtPbFFqTWVq?=
 =?utf-8?Q?CZ5vOiaSRCctX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df590cd8-6cc1-4d02-beec-08d8d4dcb1d9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2021 13:46:02.1662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlDKgxtGhTqgv+9L8lDIfdYLAlMndmiW8RmmdyaVHeBqe5xoPvM0qTlxci7XTNkC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3728
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Well as far as I can see this is a relative clear NAK.

When a device can't do DMA and has no DMA mask then why it is requesting 
an sg-table in the first place?

The problem is rather in drm_gem_prime_import_dev() which always tries 
to create an sg-table to get a GEM object, even when the device doesn't 
support DMA at all.

Regards,
Christian.

Am 19.02.21 um 14:40 schrieb Thomas Zimmermann:
> Fixes a regression for udl and probably other USB-based drivers where
> joining and mirroring displays fails.
>
> Joining displays requires importing a dma_buf from another DRM driver.
> These devices don't support DMA and therefore have no DMA mask. Trying
> to map imported buffers from a DMA-able memory zone fails with an error.
> An example is shown below.
>
> [   60.050199] ------------[ cut here ]------------
> [   60.055092] WARNING: CPU: 0 PID: 1403 at kernel/dma/mapping.c:190 dma_map_sg_attrs+0x8f/0xc0
> [   60.064331] Modules linked in: af_packet(E) rfkill(E) dmi_sysfs(E) intel_rapl_msr(E) intel_rapl_common(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_codec_hdmi(E) x86_pkg_temp_thermal(E) intel_powerclam)
> [   60.064801]  wmi(E) video(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_intel(E) xor(E) raid6_pq(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) msr(E) efivarfs(E)
> [   60.170778] CPU: 0 PID: 1403 Comm: Xorg.bin Tainted: G            E    5.11.0-rc5-1-default+ #747
> [   60.179841] Hardware name: Dell Inc. OptiPlex 9020/0N4YC8, BIOS A24 10/24/2018
> [   60.187145] RIP: 0010:dma_map_sg_attrs+0x8f/0xc0
> [   60.191822] Code: 4d 85 ff 75 2b 49 89 d8 44 89 e1 44 89 f2 4c 89 ee 48 89 ef e8 62 30 00 00 85 c0 78 36 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b <0f> 0b 31 c0 eb ed 49 8d 7f 50 e8 72 f5 2a 00 49 8b 47 50 49 89 d8
> [   60.210770] RSP: 0018:ffffc90001d6fc18 EFLAGS: 00010246
> [   60.216062] RAX: 0000000000000000 RBX: 0000000000000020 RCX: ffffffffb31e677b
> [   60.223274] RDX: dffffc0000000000 RSI: ffff888212c10600 RDI: ffff8881b08a9488
> [   60.230501] RBP: ffff8881b08a9030 R08: 0000000000000020 R09: ffff888212c10600
> [   60.237710] R10: ffffed10425820df R11: 0000000000000001 R12: 0000000000000000
> [   60.244939] R13: ffff888212c10600 R14: 0000000000000008 R15: 0000000000000000
> [   60.252155] FS:  00007f08ac2b2f00(0000) GS:ffff8887cbe00000(0000) knlGS:0000000000000000
> [   60.260333] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   60.266150] CR2: 000055831c899be8 CR3: 000000015372e006 CR4: 00000000001706f0
> [   60.273369] Call Trace:
> [   60.275845]  drm_gem_map_dma_buf+0xb4/0x120
> [   60.280089]  dma_buf_map_attachment+0x15d/0x1e0
> [   60.284688]  drm_gem_prime_import_dev.part.0+0x5d/0x140
> [   60.289984]  drm_gem_prime_fd_to_handle+0x213/0x280
> [   60.294931]  ? drm_prime_destroy_file_private+0x30/0x30
> [   60.300224]  drm_ioctl_kernel+0x131/0x180
> [   60.304291]  ? drm_setversion+0x230/0x230
> [   60.308366]  ? drm_prime_destroy_file_private+0x30/0x30
> [   60.313659]  drm_ioctl+0x2f1/0x500
> [   60.317118]  ? drm_version+0x150/0x150
> [   60.320903]  ? lock_downgrade+0xa0/0xa0
> [   60.324806]  ? do_vfs_ioctl+0x5f4/0x680
> [   60.328694]  ? __fget_files+0x13e/0x210
> [   60.332591]  ? ioctl_fiemap.isra.0+0x1a0/0x1a0
> [   60.337102]  ? __fget_files+0x15d/0x210
> [   60.340990]  __x64_sys_ioctl+0xb9/0xf0
> [   60.344795]  do_syscall_64+0x33/0x80
> [   60.348427]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   60.353542] RIP: 0033:0x7f08ac7b53cb
> [   60.357168] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 ba 0c 00 f7 d8 64 89 01 48
> [   60.376108] RSP: 002b:00007ffeabc89fc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   60.383758] RAX: ffffffffffffffda RBX: 00007ffeabc8a00c RCX: 00007f08ac7b53cb
> [   60.390970] RDX: 00007ffeabc8a00c RSI: 00000000c00c642e RDI: 000000000000000d
> [   60.398221] RBP: 00000000c00c642e R08: 000055831c691d00 R09: 000055831b2ec010
> [   60.405446] R10: 00007f08acf6ada0 R11: 0000000000000246 R12: 000055831c691d00
> [   60.412667] R13: 000000000000000d R14: 00000000007e9000 R15: 0000000000000000
> [   60.419903] irq event stamp: 672893
> [   60.423441] hardirqs last  enabled at (672913): [<ffffffffb31b796d>] console_unlock+0x44d/0x500
> [   60.432230] hardirqs last disabled at (672922): [<ffffffffb31b7963>] console_unlock+0x443/0x500
> [   60.441021] softirqs last  enabled at (672940): [<ffffffffb46003dd>] __do_softirq+0x3dd/0x554
> [   60.449634] softirqs last disabled at (672931): [<ffffffffb44010f2>] asm_call_irq_on_stack+0x12/0x20
> [   60.458871] ---[ end trace f2f88696eb17806c ]---
>
> For the fix, we don't call dma_map_sgtable() for devices without the
> DMA mask. Drivers for such devices have to map the imported buffer into
> kernel address space and perfom the copy operation in software.
>
> Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
>
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: "Ahmed S. Darwish" <a.darwish@linutronix.de>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: <stable@vger.kernel.org> # v5.10+
> ---
>   drivers/gpu/drm/drm_prime.c | 27 ++++++++++++++++++---------
>   1 file changed, 18 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
> index 2a54f86856af..d5a39fe76b78 100644
> --- a/drivers/gpu/drm/drm_prime.c
> +++ b/drivers/gpu/drm/drm_prime.c
> @@ -603,10 +603,15 @@ EXPORT_SYMBOL(drm_gem_map_detach);
>    * @attach: attachment whose scatterlist is to be returned
>    * @dir: direction of DMA transfer
>    *
> - * Calls &drm_gem_object_funcs.get_sg_table and then maps the scatterlist. This
> - * can be used as the &dma_buf_ops.map_dma_buf callback. Should be used together
> + * Calls &drm_gem_object_funcs.get_sg_table and, if possible, maps the scatterlist.
> + * This can be used as the &dma_buf_ops.map_dma_buf callback. Should be used together
>    * with drm_gem_unmap_dma_buf().
>    *
> + * Devices on some peripheral busses, such as USB, cannot use DMA. In this case,
> + * pages in the scatterlist remain unmapped. Drivers for such devices should acquire
> + * a mapping with dma_buf_vmap() and implement copy operation via bus-specific
> + * interfaces.
> + *
>    * Returns:sg_table containing the scatterlist to be returned; returns ERR_PTR
>    * on error. May return -EINTR if it is interrupted by a signal.
>    */
> @@ -627,12 +632,14 @@ struct sg_table *drm_gem_map_dma_buf(struct dma_buf_attachment *attach,
>   	if (IS_ERR(sgt))
>   		return sgt;
>
> -	ret = dma_map_sgtable(attach->dev, sgt, dir,
> -			      DMA_ATTR_SKIP_CPU_SYNC);
> -	if (ret) {
> -		sg_free_table(sgt);
> -		kfree(sgt);
> -		sgt = ERR_PTR(ret);
> +	if (attach->dev->dma_mask) {
> +		ret = dma_map_sgtable(attach->dev, sgt, dir,
> +				      DMA_ATTR_SKIP_CPU_SYNC);
> +		if (ret) {
> +			sg_free_table(sgt);
> +			kfree(sgt);
> +			sgt = ERR_PTR(ret);
> +		}
>   	}
>
>   	return sgt;
> @@ -654,7 +661,9 @@ void drm_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
>   	if (!sgt)
>   		return;
>
> -	dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
> +	if (attach->dev->dma_mask)
> +		dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
> +
>   	sg_free_table(sgt);
>   	kfree(sgt);
>   }
> --
> 2.30.0
>

