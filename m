Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8461C202264
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 09:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgFTHnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 03:43:51 -0400
Received: from mail.itouring.de ([188.40.134.68]:44616 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgFTHnu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 03:43:50 -0400
Received: from tux.applied-asynchrony.com (p5ddd79e0.dip0.t-ipconnect.de [93.221.121.224])
        by mail.itouring.de (Postfix) with ESMTPSA id F3D4A4168D1E;
        Sat, 20 Jun 2020 09:43:48 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 0FF38F01605;
        Sat, 20 Jun 2020 09:43:48 +0200 (CEST)
Subject: Re: [PATCH 5.7 000/376] 5.7.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20200619141710.350494719@linuxfoundation.org>
 <1b6c9c26-04af-eb91-ef06-23d09bd31d91@applied-asynchrony.com>
 <1797f3d4-d3b6-00ac-30fc-a10f584acae9@applied-asynchrony.com>
 <20200620072236.GB66401@kroah.com>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <44a85676-c69d-3dd1-80c6-82cc7b0a6c60@applied-asynchrony.com>
Date:   Sat, 20 Jun 2020 09:43:47 +0200
MIME-Version: 1.0
In-Reply-To: <20200620072236.GB66401@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-06-20 09:22, Greg Kroah-Hartman wrote:
> On Sat, Jun 20, 2020 at 03:18:30AM +0200, Holger Hoffstätte wrote:
>> On 2020-06-19 21:31, Holger Hoffstätte wrote:
>>> On 2020-06-19 16:28, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 5.7.5 release.
>>>> There are 376 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>
>>> Applied to 5.7.4 and running fine on two different systems (server, desktop)
>>> without problems.
>>
>> Uh-oh: I have to take the above back. This release no longer suspends to RAM;
>> display and NIC shut down (box is no longer remotely accessible) but the power
>> stays on and I have to power-cycle.
>> Will try to revert a bunch of things tomorrow..
> 
> Is this a new problem?  Or is it a regression?

5.7.(0,1,2,3,4) all suspended & woke up without problem, every night.
Just a moment ago I also got a GPU lockup out of the blue, probably caused by
something else (looks like mm/THP/memory mapping/userfault related):

--snip--
Jun 20 08:57:06 ragnarok kernel: radeon 0000:01:00.0: GPU lockup (current fence id 0x00000000000008fa last fence id 0x000000000000091d on ring 0)
Jun 20 08:57:06 ragnarok kernel: BUG: unable to handle page fault for address: ffffc904009ecffc
Jun 20 08:57:06 ragnarok kernel: #PF: supervisor read access in kernel mode
Jun 20 08:57:06 ragnarok kernel: #PF: error_code(0x0000) - not-present page
Jun 20 08:57:06 ragnarok kernel: PGD 604128067 P4D 604128067 PUD 0
Jun 20 08:57:06 ragnarok kernel: Oops: 0000 [#1] SMP
Jun 20 08:57:06 ragnarok kernel: CPU: 0 PID: 4994 Comm: compton Not tainted 5.7.5 #1
Jun 20 08:57:06 ragnarok kernel: Hardware name: Gigabyte Technology Co., Ltd. P67-DS3-B3/P67-DS3-B3, BIOS F1 05/06/2011
Jun 20 08:57:06 ragnarok kernel: RIP: 0010:radeon_ring_backup+0xc3/0x140 [radeon]
Jun 20 08:57:06 ragnarok kernel: Code: 89 45 00 48 85 c0 74 6a 41 8d 7c 24 ff 31 d2 48 c1 e7 02 eb 08 49 8b 45 00 48 83 c2 04 48 8b 75 08 8d 4b 01 89 db 48 8d 34 9e <8b> 36 89 34 10 23 4d 54 89 cb 48 39 d7 75 dc 4c 89 f7 e8 26 8c 19
Jun 20 08:57:06 ragnarok kernel: RSP: 0018:ffffc90000df3c00 EFLAGS: 00010202
Jun 20 08:57:06 ragnarok kernel: RAX: ffff888585f80000 RBX: 00000000ffffffff RCX: 0000000000000000
Jun 20 08:57:06 ragnarok kernel: RDX: 0000000000000000 RSI: ffffc904009ecffc RDI: 0000000000049380
Jun 20 08:57:06 ragnarok kernel: RBP: ffff8885fc7413d8 R08: 0000000000000080 R09: ffff88861f7e6000
Jun 20 08:57:06 ragnarok kernel: R10: 000000000002f100 R11: 0000000000000006 R12: 00000000000124e1
Jun 20 08:57:06 ragnarok kernel: R13: ffffc90000df3c68 R14: ffff8885fc7413b8 R15: ffff8885fc740000
Jun 20 08:57:06 ragnarok kernel: FS:  00007f9cb8edb7c0(0000) GS:ffff888607400000(0000) knlGS:0000000000000000
Jun 20 08:57:06 ragnarok kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 20 08:57:06 ragnarok kernel: CR2: ffffc904009ecffc CR3: 0000000592e24003 CR4: 00000000000606f0
Jun 20 08:57:06 ragnarok kernel: Call Trace:
Jun 20 08:57:06 ragnarok kernel:  radeon_gpu_reset+0x98/0x280 [radeon]
Jun 20 08:57:06 ragnarok kernel:  ? dma_fence_wait_timeout+0x3f/0xf0
Jun 20 08:57:06 ragnarok kernel:  ? dma_resv_wait_timeout_rcu+0x15a/0x3e0
Jun 20 08:57:06 ragnarok kernel:  ? radeon_gem_busy_ioctl+0x70/0x70 [radeon]
Jun 20 08:57:06 ragnarok kernel:  radeon_gem_wait_idle_ioctl+0xcb/0x100 [radeon]
Jun 20 08:57:06 ragnarok kernel:  ? radeon_gem_busy_ioctl+0x70/0x70 [radeon]
Jun 20 08:57:06 ragnarok kernel:  drm_ioctl_kernel+0x84/0xd0 [drm]
Jun 20 08:57:06 ragnarok kernel:  drm_ioctl+0x1e1/0x370 [drm]
Jun 20 08:57:06 ragnarok kernel:  ? radeon_gem_busy_ioctl+0x70/0x70 [radeon]
Jun 20 08:57:06 ragnarok kernel:  ? do_iter_write+0xdf/0x190
Jun 20 08:57:06 ragnarok kernel:  radeon_drm_ioctl+0x49/0x80 [radeon]
Jun 20 08:57:06 ragnarok kernel:  ksys_ioctl+0x33a/0x770
Jun 20 08:57:06 ragnarok kernel:  __x64_sys_ioctl+0x16/0x19
Jun 20 08:57:06 ragnarok kernel:  do_syscall_64+0x4e/0x310
Jun 20 08:57:06 ragnarok kernel:  ? do_user_addr_fault+0x1df/0x460
Jun 20 08:57:06 ragnarok kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Jun 20 08:57:06 ragnarok kernel: RIP: 0033:0x7f9cb91bd317
Jun 20 08:57:06 ragnarok kernel: Code: 00 00 00 48 8b 05 69 9b 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 9b 0c 00 f7 d8 64 89 01 48
Jun 20 08:57:06 ragnarok kernel: RSP: 002b:00007ffc69dcf778 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Jun 20 08:57:06 ragnarok kernel: RAX: ffffffffffffffda RBX: 00007ffc69dcf7c0 RCX: 00007f9cb91bd317
Jun 20 08:57:06 ragnarok kernel: RDX: 00007ffc69dcf7c0 RSI: 0000000040086464 RDI: 0000000000000007
Jun 20 08:57:06 ragnarok kernel: RBP: 0000000040086464 R08: 00005654ee7d4900 R09: 0000000000000011
Jun 20 08:57:06 ragnarok kernel: R10: 00005654ee7834e0 R11: 0000000000000246 R12: 0000000000000001
Jun 20 08:57:06 ragnarok kernel: R13: 0000000000000007 R14: 0000000000000000 R15: 00005654ee911c00
Jun 20 08:57:06 ragnarok kernel: Modules linked in: autofs4 nfs lockd grace sunrpc tcp_bbr2 sch_fq_codel it87 hwmon_vid drivetemp radeon snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi x86_pkg_temp_thermal i2c_algo_bit bfq mq_deadline snd_usb_audio drm_kms_helper snd_hda_intel uvcvideo coretemp syscopyarea snd_hwdep snd_intel_dspcfg sysfillrect videobuf2_vmalloc snd_usbmidi_lib sysimgblt videobuf2_memops crc32_pclmul snd_hda_codec fb_sys_fops videobuf2_v4l2 snd_rawmidi ttm aesni_intel snd_hda_core snd_seq_device snd_pcm crypto_simd videodev cryptd drm snd_timer glue_helper i2c_i801 videobuf2_common usbhid drm_panel_orientation_quirks snd atlantic backlight i2c_core soundcore parport_pc parport
Jun 20 08:57:06 ragnarok kernel: CR2: ffffc904009ecffc
Jun 20 08:57:06 ragnarok kernel: ---[ end trace 882fcc4b8349558d ]---
Jun 20 08:57:06 ragnarok kernel: RIP: 0010:radeon_ring_backup+0xc3/0x140 [radeon]
Jun 20 08:57:06 ragnarok kernel: Code: 89 45 00 48 85 c0 74 6a 41 8d 7c 24 ff 31 d2 48 c1 e7 02 eb 08 49 8b 45 00 48 83 c2 04 48 8b 75 08 8d 4b 01 89 db 48 8d 34 9e <8b> 36 89 34 10 23 4d 54 89 cb 48 39 d7 75 dc 4c 89 f7 e8 26 8c 19
Jun 20 08:57:06 ragnarok kernel: RSP: 0018:ffffc90000df3c00 EFLAGS: 00010202
Jun 20 08:57:06 ragnarok kernel: RAX: ffff888585f80000 RBX: 00000000ffffffff RCX: 0000000000000000
Jun 20 08:57:06 ragnarok kernel: RDX: 0000000000000000 RSI: ffffc904009ecffc RDI: 0000000000049380
Jun 20 08:57:06 ragnarok kernel: RBP: ffff8885fc7413d8 R08: 0000000000000080 R09: ffff88861f7e6000
Jun 20 08:57:06 ragnarok kernel: R10: 000000000002f100 R11: 0000000000000006 R12: 00000000000124e1
Jun 20 08:57:06 ragnarok kernel: R13: ffffc90000df3c68 R14: ffff8885fc7413b8 R15: ffff8885fc740000
Jun 20 08:57:06 ragnarok kernel: FS:  00007f9cb8edb7c0(0000) GS:ffff888607400000(0000) knlGS:0000000000000000
Jun 20 08:57:06 ragnarok kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun 20 08:57:06 ragnarok kernel: CR2: ffffc904009ecffc CR3: 0000000592e24003 CR4: 00000000000606f0
--snip--

Since this is my primary machine I'll have to revert to stable working conditions first
and then see whether that was a one-off or caused by 5.7.5-rc1.
