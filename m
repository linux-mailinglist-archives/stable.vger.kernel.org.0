Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B71320DC6
	for <lists+stable@lfdr.de>; Sun, 21 Feb 2021 22:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhBUU6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Feb 2021 15:58:11 -0500
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:37984
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230393AbhBUU5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 21 Feb 2021 15:57:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=liSLJuKTDmRo4hrmcovcjCUQc6Fl/rXXSK/CoYH7hszTQJ7dWJTMg1s/sufwtUdQ8GLWYvjzZaVRXVkPT48jhZ9wJYTWCouhPwq7FZQskFRX1dp6GxuyAGT3P2oRLkgjaCQwscwii0jDMJsMmq9TGC5yPYk8FYgoz+Y5CMm8QJGtK8ti115lMwq0CVwLGNCPwi//KU7IjJWtw6XobVEjv792C5Mj5s4AoYu4fxac2UeRknNuQM6TC7ByfnJ81emzAn+nKp+y//YakwGy8MnQkEJHcGc7gWGpUWcQdzEyFfIfvM5KR59wjSn6AGk571v1Q4JYuIWPiVMIC3dSvsySeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WYBYyBvrX/MmKSsJ9/DhP1jd+ed0M9B7VPzDcPyZck=;
 b=L660tPqrkqtPubradvHP1ech8zIYwaA9RgeuK56txCatQr6Oh1gfqeot01Pb7k+5vBRRUpW7BCD3O6AIuYKoAMYogOZWgdywLZCDhrJAmVHsWPuJ3eN33bjpE1rF58RQraOBpK1kwSo9G96CYBxVeBxxERu8BVYOapeH0JF2O7SCXlx7r11BdhE4B0atI6IgQ5NTQXvb/dgFtIVfh+Bnyit3V/jsl2UXc4/1dAYNaNZpK9jG0yvNLXqKXK9Bq0lxYMxSrvdIp9Q3zqRBc6H2EevFthtI3bVplmpMDpTyPP9/A/0w7zB+CzkzjEPJFsLGXOO7TaCf8IBFnJOpndlO8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WYBYyBvrX/MmKSsJ9/DhP1jd+ed0M9B7VPzDcPyZck=;
 b=r9+mH3GmLmsKaJhAGPQ43rmFZM4jK6Z8v1IG1rtWJ6wzBdInSTa0MxkBIhfYxxGgQ1guXpAFfjw9D3pJ6Y0ulmkA39v/jFv0NblmQaaKp61TnCyeJRMWqE1rJ2P656BCmkgxVX/xLBJFcJlcwJfI+4/Wnov+dLnFTBPijDkUA5c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3775.namprd12.prod.outlook.com (2603:10b6:208:159::19)
 by MN2PR12MB4317.namprd12.prod.outlook.com (2603:10b6:208:1d0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Sun, 21 Feb
 2021 20:56:48 +0000
Received: from MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2]) by MN2PR12MB3775.namprd12.prod.outlook.com
 ([fe80::c1ff:dcf1:9536:a1f2%2]) with mapi id 15.20.3868.031; Sun, 21 Feb 2021
 20:56:48 +0000
Subject: Re: [PATCH] drm/prime: Only call dma_map_sgtable() for devices with
 DMA support
To:     =?UTF-8?Q?Noralf_Tr=c3=b8nnes?= <noralf@tronnes.org>,
        Thomas Zimmermann <tzimmermann@suse.de>, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, sumit.semwal@linaro.org,
        gregkh@linuxfoundation.org
Cc:     dri-devel@lists.freedesktop.org, Christoph Hellwig <hch@lst.de>,
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
 <79e272cb-b010-cb8d-57d3-71999164291a@tronnes.org>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <7a3b93df-ca04-8d0d-f99d-226093b9ed04@amd.com>
Date:   Sun, 21 Feb 2021 21:56:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <79e272cb-b010-cb8d-57d3-71999164291a@tronnes.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [217.91.21.104]
X-ClientProxiedBy: AM3PR07CA0073.eurprd07.prod.outlook.com
 (2603:10a6:207:4::31) To MN2PR12MB3775.namprd12.prod.outlook.com
 (2603:10b6:208:159::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.17.4.54] (217.91.21.104) by AM3PR07CA0073.eurprd07.prod.outlook.com (2603:10a6:207:4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.8 via Frontend Transport; Sun, 21 Feb 2021 20:56:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d4337be3-7801-4453-437e-08d8d6ab3440
X-MS-TrafficTypeDiagnostic: MN2PR12MB4317:
X-Microsoft-Antispam-PRVS: <MN2PR12MB43178094CFD39C1A5414BB9583829@MN2PR12MB4317.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8R9LdOKkA74YVMqfs6+fzJfUArd4xrNvrHxXZeCHOmCETC8gKzmL87P7WN5BecbPnnsWezJggGAI/C+GlML/LBZbHxDpm9bMF8X2buZpvjEVbQkUMKsVdkYr8IH+zKeWUeDSkQw3osFeqcMLYeW52SGnsGoqhAK+XiaijFMQpWrkoKj/ndL+3hxJQTqkZduLKhmjkllVeUEQXQyz2OdV3YMph1+HAqd+b45FIgsar3BAUrzRkjYARkxteqiBIzdXcVQ0W9do8ItWtuG5l7bjMkIuM7NDaD9sBcCdzJ2FKu1UTnGKv5OHayqIYbrE7l2EToYGh/0IL+1Hk9BvuI5UUOXu5uI4HXTaO6rJ84ZoWuORtpWpDvUbSqom3fCKw/kC9cEWT9Kd7Z+k+o24WhWI9BI45FlOvGedea4Tlo/X08cOC8uAW6lrYNvxCuY1/pcykcE6Q2sMtFm4Pb4oPocH3WxAJcP5r0L0EVkFlxtn0TRDXYe6Zv2VaQJQYc8R28tYEI4JYLJyw5LkXiTiVN84cI2satKr0GUBQ7JuKQlKVWojiSJCPAw+Yk8v6DvoOoOjKcrsOCjC19JU/wk5T5MrNodiSWEWvvi0fEDpP4qEMtQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3775.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(31696002)(31686004)(16526019)(186003)(36756003)(110136005)(54906003)(52116002)(316002)(16576012)(7416002)(478600001)(2906002)(2616005)(66946007)(86362001)(66556008)(5660300002)(66476007)(45080400002)(956004)(83380400001)(6486002)(66574015)(26005)(8676002)(8936002)(4326008)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MjI4dnAxS3QvK2VqQk1ta2plakFyQkttM3UxZ1V3ZGFQRHcyZ1RobXJzQkFm?=
 =?utf-8?B?bElUU1FRSENDQjNGQnV4QXJ0eDE4SStYMURXUUFRcGVyVzJNaTRqVVk3UVlM?=
 =?utf-8?B?ZEh3Qm1LRVlrOFF6NjU4OGRIdlBRa2NZc2xYLzE3Q2lWYWoySWtPVVhWYThM?=
 =?utf-8?B?aGlybUdEZGppY2w3ZkhkVzRsZjJOQ3JPVmV2UVMySzNEeFN5YlRjMEpiRzBF?=
 =?utf-8?B?NHQwK3M5VCthdHZ0MFBmb2dlU2R0OUVDVjFZaTRMWmlHUWlNaTFTWEcvVytQ?=
 =?utf-8?B?cUY3RHVNVkxZU0dxQ3NzdDFhdUVnUXlIejNNY1kvYi8wWHd2R1JZVFBmMlps?=
 =?utf-8?B?dERHakdXOTBpbzJBWGR4OVR2TDhwb3JQMWhpbjlnTnhrVEVHNE0rYTBiM0F6?=
 =?utf-8?B?SWhVaGptU1lYN2tqaythbHBNeVZQcW1zdStXMEVNV0M1dTgwUml3ODZUZzV4?=
 =?utf-8?B?UXg3WlIvTVQ4aWt6aWRkUS9IS3Ivd1VxS0daajk2UC9RRVJPSU5URXc2V0kz?=
 =?utf-8?B?cFIreGExZGtBZ1A5bjg4UW9XcS9wbUJLLzFTSVNaTW84Zlo0cEpXaWpIVEZz?=
 =?utf-8?B?V3lDRlZRVW5KYmJWS05rVmtPeGlQMWI5WUZ3RmY0b3RtbWI4K0llNTQ5c1Nu?=
 =?utf-8?B?ZDRGM05ManpqT3UzR014RVI3NU1tQlFNR01FNVI0VU9HR09Yc21PSWw2Mk03?=
 =?utf-8?B?bytUWFBWb0FpNHpxTDFZcENUeGxjRm9hdS9qcUNwSnhQb1k0TkdPckM1NEV5?=
 =?utf-8?B?WUZpc1FUNVFGaE02SUhzRjBXem9EYmhsQmN3elVHZkU4WTdqL2s3VThGN2lO?=
 =?utf-8?B?T1llREJpaEZSRW80WHdmQWJoWStpYU5WRzJVSzVaTDNWRWUyUW9Lc0wxRERS?=
 =?utf-8?B?MEd0QkZMZlIxMEl1ZVhWNnliMzNrR0FYOUtjKzBqODNCWGhpaTZqdDJuWDZQ?=
 =?utf-8?B?LzBxeU1Dcldhbjh5QTlLcGVQNGkwajdMdnZoN1ZWYzRHM0wzSmhuMHpFWktT?=
 =?utf-8?B?eVg1Tkt5TnNHUElHMTFVRHFObFdiaHJiUjZYUEVVUGZWR0FrOHBLci9TeXVB?=
 =?utf-8?B?S3pKSjcxc2pYOGhsME5iTFpSNVFodmM0YnBuR0Rtc3NXQVpESW5yR2dvUGkz?=
 =?utf-8?B?dkZIQ202My9Hd0MxMGJzUEE1NnhraVhPeGZVeFVGK2xZTy9XRVhwSG5KWkpX?=
 =?utf-8?B?QS83QWUvMHpGaFpZS1hJNUFmaUFwdUFWdnRYNm5sSmE0Y2oyQ1pZYTB0Zkt5?=
 =?utf-8?B?cUNUc1JKMkV3TEF2WnhFTXNINXBJbjdnTlRHeE9HbEVzTmxHV2txYVRBblRa?=
 =?utf-8?B?UjlMSCt5VFM1TU4yY0RrSUFLOUFDSzI5THBRYWFDREFhaTVTL3RJUFhqekFG?=
 =?utf-8?B?RmpOeU1OY011M0JINGpWTXNpVGZPalRyc2dWelM2UzliSFg5bi9qZE1qY0JO?=
 =?utf-8?B?SlYyNU00NGM3b3RMZkdvTmZIWTlzRFpXUXVJcm1la09tcjExUDhKYm9INCtF?=
 =?utf-8?B?QmlXektnM3llNGNFRkNMVktuTmtHdy9MQlVtZHpQSGZWdUZqRk1NMjJKMTc1?=
 =?utf-8?B?N3BoWVpCOFM0RVZ6UUt4MVFKSmdjdDByZHBZc01sYUI2MEQ1RzgybVZRVGNk?=
 =?utf-8?B?M0ZmczVWdWF2bzZZT1RVNTRKT0RBZmZWRFY1dzE2MnptMXBYSC9sM0xabllr?=
 =?utf-8?B?WU1nTTkyNzhRS3F5OTdkTEh5cThEUmdRLzdhV0k2SEpqbUlhQUY1MTdXSDZp?=
 =?utf-8?Q?6otyrMkD+H1782MOUa1/CgEa8nO617bME2b40Z3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4337be3-7801-4453-437e-08d8d6ab3440
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3775.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2021 20:56:48.1711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymueDwZWHvi8WMX+JlBD26XTv0Z/o6/okRID6CNosloJo0Y1k30ZbTFNMJJHFHz2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4317
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Am 20.02.21 um 14:02 schrieb Noralf Trønnes:
>
> Den 19.02.2021 14.40, skrev Thomas Zimmermann:
>> Fixes a regression for udl and probably other USB-based drivers where
>> joining and mirroring displays fails.
>>
>> Joining displays requires importing a dma_buf from another DRM driver.
>> These devices don't support DMA and therefore have no DMA mask. Trying
>> to map imported buffers from a DMA-able memory zone fails with an error.
>> An example is shown below.
>>
>> [   60.050199] ------------[ cut here ]------------
>> [   60.055092] WARNING: CPU: 0 PID: 1403 at kernel/dma/mapping.c:190 dma_map_sg_attrs+0x8f/0xc0
>> [   60.064331] Modules linked in: af_packet(E) rfkill(E) dmi_sysfs(E) intel_rapl_msr(E) intel_rapl_common(E) snd_hda_codec_realtek(E) snd_hda_codec_generic(E) ledtrig_audio(E) snd_hda_codec_hdmi(E) x86_pkg_temp_thermal(E) intel_powerclam)
>> [   60.064801]  wmi(E) video(E) btrfs(E) blake2b_generic(E) libcrc32c(E) crc32c_intel(E) xor(E) raid6_pq(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) msr(E) efivarfs(E)
>> [   60.170778] CPU: 0 PID: 1403 Comm: Xorg.bin Tainted: G            E    5.11.0-rc5-1-default+ #747
>> [   60.179841] Hardware name: Dell Inc. OptiPlex 9020/0N4YC8, BIOS A24 10/24/2018
>> [   60.187145] RIP: 0010:dma_map_sg_attrs+0x8f/0xc0
>> [   60.191822] Code: 4d 85 ff 75 2b 49 89 d8 44 89 e1 44 89 f2 4c 89 ee 48 89 ef e8 62 30 00 00 85 c0 78 36 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 0b <0f> 0b 31 c0 eb ed 49 8d 7f 50 e8 72 f5 2a 00 49 8b 47 50 49 89 d8
>> [   60.210770] RSP: 0018:ffffc90001d6fc18 EFLAGS: 00010246
>> [   60.216062] RAX: 0000000000000000 RBX: 0000000000000020 RCX: ffffffffb31e677b
>> [   60.223274] RDX: dffffc0000000000 RSI: ffff888212c10600 RDI: ffff8881b08a9488
>> [   60.230501] RBP: ffff8881b08a9030 R08: 0000000000000020 R09: ffff888212c10600
>> [   60.237710] R10: ffffed10425820df R11: 0000000000000001 R12: 0000000000000000
>> [   60.244939] R13: ffff888212c10600 R14: 0000000000000008 R15: 0000000000000000
>> [   60.252155] FS:  00007f08ac2b2f00(0000) GS:ffff8887cbe00000(0000) knlGS:0000000000000000
>> [   60.260333] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   60.266150] CR2: 000055831c899be8 CR3: 000000015372e006 CR4: 00000000001706f0
>> [   60.273369] Call Trace:
>> [   60.275845]  drm_gem_map_dma_buf+0xb4/0x120
>> [   60.280089]  dma_buf_map_attachment+0x15d/0x1e0
>> [   60.284688]  drm_gem_prime_import_dev.part.0+0x5d/0x140
>> [   60.289984]  drm_gem_prime_fd_to_handle+0x213/0x280
>> [   60.294931]  ? drm_prime_destroy_file_private+0x30/0x30
>> [   60.300224]  drm_ioctl_kernel+0x131/0x180
>> [   60.304291]  ? drm_setversion+0x230/0x230
>> [   60.308366]  ? drm_prime_destroy_file_private+0x30/0x30
>> [   60.313659]  drm_ioctl+0x2f1/0x500
>> [   60.317118]  ? drm_version+0x150/0x150
>> [   60.320903]  ? lock_downgrade+0xa0/0xa0
>> [   60.324806]  ? do_vfs_ioctl+0x5f4/0x680
>> [   60.328694]  ? __fget_files+0x13e/0x210
>> [   60.332591]  ? ioctl_fiemap.isra.0+0x1a0/0x1a0
>> [   60.337102]  ? __fget_files+0x15d/0x210
>> [   60.340990]  __x64_sys_ioctl+0xb9/0xf0
>> [   60.344795]  do_syscall_64+0x33/0x80
>> [   60.348427]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> I'm working on a USB display driver and got the same splat (although
> from i915_gem_map_dma_buf) and silenced it using:
>
> 	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
>
> But I understand now that this is not the solution.
>
> Since the USB host controller can do DMA, would the following be an
> acceptable solution?

I'm not an expert for the USB stuff. But from a 10 mile high view I 
would say that this is the right approach, yes.

Regards,
Christian.

>
> static struct drm_gem_object *gud_gem_prime_import(struct drm_device
> *drm, struct dma_buf *dma_buf)
> {
> 	struct usb_device *usb = gud_to_usb_device(to_gud_device(drm));
>
> 	drm_dbg_prime(drm, "usb->bus->controller=%s\n",
> dev_name(usb->bus->controller));
>
> 	return drm_gem_prime_import_dev(drm, dma_buf, usb->bus->controller);
> }
>
> static const struct drm_driver gud_drm_driver = {
> 	.gem_prime_import	= gud_gem_prime_import,
> };
>
>
> Noralf.
>
>> [   60.353542] RIP: 0033:0x7f08ac7b53cb
>> [   60.357168] Code: 89 d8 49 8d 3c 1c 48 f7 d8 49 39 c4 72 b5 e8 1c ff ff ff 85 c0 78 ba 4c 89 e0 5b 5d 41 5c c3 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 ba 0c 00 f7 d8 64 89 01 48
>> [   60.376108] RSP: 002b:00007ffeabc89fc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> [   60.383758] RAX: ffffffffffffffda RBX: 00007ffeabc8a00c RCX: 00007f08ac7b53cb
>> [   60.390970] RDX: 00007ffeabc8a00c RSI: 00000000c00c642e RDI: 000000000000000d
>> [   60.398221] RBP: 00000000c00c642e R08: 000055831c691d00 R09: 000055831b2ec010
>> [   60.405446] R10: 00007f08acf6ada0 R11: 0000000000000246 R12: 000055831c691d00
>> [   60.412667] R13: 000000000000000d R14: 00000000007e9000 R15: 0000000000000000
>> [   60.419903] irq event stamp: 672893
>> [   60.423441] hardirqs last  enabled at (672913): [<ffffffffb31b796d>] console_unlock+0x44d/0x500
>> [   60.432230] hardirqs last disabled at (672922): [<ffffffffb31b7963>] console_unlock+0x443/0x500
>> [   60.441021] softirqs last  enabled at (672940): [<ffffffffb46003dd>] __do_softirq+0x3dd/0x554
>> [   60.449634] softirqs last disabled at (672931): [<ffffffffb44010f2>] asm_call_irq_on_stack+0x12/0x20
>> [   60.458871] ---[ end trace f2f88696eb17806c ]---
>>
>> For the fix, we don't call dma_map_sgtable() for devices without the
>> DMA mask. Drivers for such devices have to map the imported buffer into
>> kernel address space and perfom the copy operation in software.
>>
>> Tested by joining/mirroring displays of udl and radeon un der Gnome/X11.
>>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Fixes: 6eb0233ec2d0 ("usb: don't inherity DMA properties for USB devices")
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Johan Hovold <johan@kernel.org>
>> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: "Ahmed S. Darwish" <a.darwish@linutronix.de>
>> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Cc: Oliver Neukum <oneukum@suse.com>
>> Cc: Felipe Balbi <balbi@kernel.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: <stable@vger.kernel.org> # v5.10+
>> ---
>>   drivers/gpu/drm/drm_prime.c | 27 ++++++++++++++++++---------
>>   1 file changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
>> index 2a54f86856af..d5a39fe76b78 100644
>> --- a/drivers/gpu/drm/drm_prime.c
>> +++ b/drivers/gpu/drm/drm_prime.c
>> @@ -603,10 +603,15 @@ EXPORT_SYMBOL(drm_gem_map_detach);
>>    * @attach: attachment whose scatterlist is to be returned
>>    * @dir: direction of DMA transfer
>>    *
>> - * Calls &drm_gem_object_funcs.get_sg_table and then maps the scatterlist. This
>> - * can be used as the &dma_buf_ops.map_dma_buf callback. Should be used together
>> + * Calls &drm_gem_object_funcs.get_sg_table and, if possible, maps the scatterlist.
>> + * This can be used as the &dma_buf_ops.map_dma_buf callback. Should be used together
>>    * with drm_gem_unmap_dma_buf().
>>    *
>> + * Devices on some peripheral busses, such as USB, cannot use DMA. In this case,
>> + * pages in the scatterlist remain unmapped. Drivers for such devices should acquire
>> + * a mapping with dma_buf_vmap() and implement copy operation via bus-specific
>> + * interfaces.
>> + *
>>    * Returns:sg_table containing the scatterlist to be returned; returns ERR_PTR
>>    * on error. May return -EINTR if it is interrupted by a signal.
>>    */
>> @@ -627,12 +632,14 @@ struct sg_table *drm_gem_map_dma_buf(struct dma_buf_attachment *attach,
>>   	if (IS_ERR(sgt))
>>   		return sgt;
>>
>> -	ret = dma_map_sgtable(attach->dev, sgt, dir,
>> -			      DMA_ATTR_SKIP_CPU_SYNC);
>> -	if (ret) {
>> -		sg_free_table(sgt);
>> -		kfree(sgt);
>> -		sgt = ERR_PTR(ret);
>> +	if (attach->dev->dma_mask) {
>> +		ret = dma_map_sgtable(attach->dev, sgt, dir,
>> +				      DMA_ATTR_SKIP_CPU_SYNC);
>> +		if (ret) {
>> +			sg_free_table(sgt);
>> +			kfree(sgt);
>> +			sgt = ERR_PTR(ret);
>> +		}
>>   	}
>>
>>   	return sgt;
>> @@ -654,7 +661,9 @@ void drm_gem_unmap_dma_buf(struct dma_buf_attachment *attach,
>>   	if (!sgt)
>>   		return;
>>
>> -	dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
>> +	if (attach->dev->dma_mask)
>> +		dma_unmap_sgtable(attach->dev, sgt, dir, DMA_ATTR_SKIP_CPU_SYNC);
>> +
>>   	sg_free_table(sgt);
>>   	kfree(sgt);
>>   }
>> --
>> 2.30.0
>>

