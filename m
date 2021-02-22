Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE1F321841
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 14:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBVNOQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 08:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhBVNLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 08:11:30 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2BDC06174A;
        Mon, 22 Feb 2021 05:10:49 -0800 (PST)
Date:   Mon, 22 Feb 2021 14:10:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1613999447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H4B9rcV1m3AHoiHdzIXK2JYlUTNObuP+34RDVfp55Lg=;
        b=HFyEVgqJcoSHusXyuvlJvLM3lOtlnXLAFhwOFGp2cagtMZNyA4T+fcULESpeCU+u+967Aj
        pVRvW65ikol10N2CbfJHps7Z4DYZ3d1NaQu9T0D/Re2qFN2z5qZ21xlUyGZ1tYzH4uMMJN
        mDSacymCaQSNsZTJLjWyOyHv5tdCpsFvxRX3y0Zeoel1v0xDg6nwUOL0MDrNVOgNRAc9GD
        KjVjrfg8J5Iggx7k1v3ovCKCj29m/GUbaTHlLT3NMPSOeImy1YVq3+iqu8vTBJrYznDve/
        3I1NCdgZJHa64scqHHkV+4wJa3ar1bvVBVmfCngb9gGJmgDWYwly5m6sb436lQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1613999447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H4B9rcV1m3AHoiHdzIXK2JYlUTNObuP+34RDVfp55Lg=;
        b=Ac1vaQ+bo/VpkpgdqhkaSN/0bKtv3tHRO749WmVhSuMUdNu9lHUsjcplCMnVlXZaOitJqD
        RDKR9MTmAc8o7wAw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        yuq825@gmail.com, robh@kernel.org, tomeu.vizoso@collabora.com,
        steven.price@arm.com, alyssa.rosenzweig@collabora.com,
        eric@anholt.net, sumit.semwal@linaro.org, christian.koenig@amd.com,
        stern@rowland.harvard.edu, dri-devel@lists.freedesktop.org,
        lima@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Felipe Balbi <balbi@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] drm: Support importing dmabufs into drivers
 without DMA
Message-ID: <YDOtVZEtUZ17UNN9@lx-t490>
References: <20210222124328.27340-1-tzimmermann@suse.de>
 <20210222124328.27340-2-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222124328.27340-2-tzimmermann@suse.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:43:26PM +0100, Thomas Zimmermann wrote:
...
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

Copy-pasting the etnire stack trace to the commit log really hurts
readability and provides no additional value to the reader, IMHO.

> This patch introduces struct drm_driver.gem_prime_create_object, which
  ^

Documentation/process/submitting-patches.rst:

  Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour.

> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
> Cc: "Ahmed S. Darwish" <a.darwish@linutronix.de>
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Felipe Balbi <balbi@kernel.org>

That's a *huge* Cc list, and a most of it seems to be generated by
"scripts/get_maintainer.pl --git", which can be overly verbose.

Thanks,

--
Ahmed S. Darwish
