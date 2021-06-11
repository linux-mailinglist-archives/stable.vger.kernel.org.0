Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298D43A4330
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 15:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhFKNsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 09:48:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:39276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229685AbhFKNsg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 09:48:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD7A6613C3;
        Fri, 11 Jun 2021 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623419182;
        bh=veOmLFQrxOl5B5e9lJZZlXx8SeGBOiFlmMT1L62hjms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jZnwgCsMnWcjYbqcTra7Ms5UcvnfgJuTVPDfCjexl/TzyR6+/9xipMmLEI2wMWyVw
         7g/LnwLuPgpOoK5heKTequiFUGy7fewjJj5P4NUfNyKmvfNE8NofPov2wVRSZqKQFh
         hEL1nTpvOGOgUG2vCOefIwlcfyE+ELKo6hYXp42Y=
Date:   Fri, 11 Jun 2021 15:46:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     stable@vger.kernel.org, daniel@ffwll.ch, airlied@linux.ie,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        robdclark@gmail.com, sean@poorly.run, tomi.valkeinen@ti.com,
        vegard.nossum@oracle.com, dhaval.giani@oracle.com,
        dan.carpenter@oracle.com, dvyukov@google.com
Subject: Re: [PATCH 5.4.y 0/2] 5.4.y missing upstream commits 7beb691f and
 51f644b4, causing: WARNING in vkms_vblank_simulate
Message-ID: <YMNpKy79t/xM7umS@kroah.com>
References: <1621630400-22972-1-git-send-email-george.kennedy@oracle.com>
 <YLTP5/8h4BsqnTL9@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLTP5/8h4BsqnTL9@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 02:00:39PM +0200, Greg KH wrote:
> On Fri, May 21, 2021 at 03:53:18PM -0500, George Kennedy wrote:
> > During Syzkaller reproducer testing on 5.4.y (5.4.121-rc1) the following warning occurred:
> > 
> > WARNING in vkms_vblank_simulate
> > https://syzkaller.appspot.com//bug?id=0ba17d70d062b2595e1f061231474800f076c7cb
> > 
> > These 2 upstream commits are needed to fix the warning:
> > 7beb691f drm: Initialize struct drm_crtc_state.no_vblank from device settings
> > 51f644b4 drm/atomic-helper: reset vblank on crtc reset
> > 
> > 51f644b4 has conflicts (which were resolved).
> > 
> > [  101.335429] ------------[ cut here ]------------
> > [  101.336576] WARNING: CPU: 1 PID: 0 at drivers/gpu/drm/vkms/vkms_crtc.c:91 vkms_get_vblank_timestamp+0x10a/0x140
> > [  101.338952] Modules linked in:
> > [  101.339701] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.4.121-rc1-syzk #1
> > [  101.344331] RIP: 0010:vkms_get_vblank_timestamp+0x10a/0x140
> > [  101.345660] Code: 03 80 3c 02 00 75 4f 4d 2b b5 80 10 00 00 4d 89 34 24 e8 d9 4e a7 fc b8 01 00 00 00 5b 41 5c 41 5d 41 5e 5d c3 e8 c6 4e a7 fc <0f> 0b eb e4 e8 3d a0 e6 fc e9 27 ff ff ff e8 33 a0 e6 fc eb 91 4c
> > [  101.351293] RAX: ffff888107a65d00 RBX: 000000179647991a RCX: ffffffff84cde2af
> > [  101.352976] RDX: 0000000000000100 RSI: ffffffff84cde2fa RDI: 0000000000000006
> > [  101.354662] RBP: ffff88810b289ba8 R08: ffff888107a65d00 R09: ffffed1021651398
> > [  101.356361] R10: ffffed1021651398 R11: 0000000000000003 R12: ffff88810b289cb0
> > [  101.358037] R13: ffff88810a89c000 R14: 000000179647991a R15: 0000000000004e20
> > [  101.359718] FS:  0000000000000000(0000) GS:ffff88810b280000(0000) knlGS:0000000000000000
> > [  101.361627] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  101.362992] CR2: 00007f82b0154000 CR3: 0000000109460000 CR4: 00000000000006e0
> > [  101.364684] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  101.366369] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [  101.368043] Call Trace:
> > [  101.368652]  <IRQ>
> > [  101.369159]  ? vkms_crtc_atomic_flush+0x2d0/0x2d0
> > [  101.370296]  drm_get_last_vbltimestamp+0x106/0x1b0
> > [  101.371446]  ? drm_crtc_set_max_vblank_count+0x1a0/0x1a0
> > [  101.372715]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> > [  101.374001]  drm_update_vblank_count+0x17a/0x800
> > [  101.375107]  ? store_vblank+0x1d0/0x1d0
> > [  101.376038]  ? __kasan_check_write+0x14/0x20
> > [  101.377071]  drm_vblank_disable_and_save+0x13a/0x3d0
> > [  101.378265]  ? vblank_disable_fn+0x101/0x180
> > [  101.379296]  vblank_disable_fn+0x14b/0x180
> > [  101.380282]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
> > [  101.381508]  call_timer_fn+0x50/0x310
> > [  101.382393]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
> > [  101.383621]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
> > [  101.384849]  run_timer_softirq+0x76f/0x13e0
> > [  101.385857]  ? del_timer_sync+0xb0/0xb0
> > [  101.386792]  ? irq_work_interrupt+0xf/0x20
> > [  101.387776]  ? irq_work_interrupt+0xa/0x20
> > [  101.388761]  __do_softirq+0x18d/0x623
> > [  101.389647]  irq_exit+0x1fc/0x220
> > [  101.390454]  smp_apic_timer_interrupt+0xf0/0x380
> > [  101.391565]  apic_timer_interrupt+0xf/0x20
> > [  101.392547]  </IRQ>
> > [  101.393073] RIP: 0010:native_safe_halt+0x12/0x20
> > [  101.394178] Code: 96 fe ff ff 48 89 df e8 ac c1 fc f3 eb 92 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 e9 07 00 00 00 0f 00 2d 10 ee 50 00 fb f4 <5d> c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 e9 07 00 00
> > [  101.398541] RSP: 0018:ffff888107aafd48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
> > [  101.400326] RAX: ffffffff8db7b830 RBX: ffff888107a65d00 RCX: ffffffff8db7c532
> > [  101.402004] RDX: 1ffff11020f4cba0 RSI: 0000000000000008 RDI: ffff888107a65d00
> > [  101.403680] RBP: ffff888107aafd48 R08: ffffed1020f4cba1 R09: ffffed1020f4cba1
> > [  101.405361] R10: ffffed1020f4cba0 R11: ffff888107a65d07 R12: 0000000000000001
> > [  101.407041] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
> > [  101.408729]  ? __cpuidle_text_start+0x8/0x8
> > [  101.409735]  ? default_idle_call+0x32/0x70
> > [  101.410722]  default_idle+0x24/0x2c0
> > [  101.411589]  arch_cpu_idle+0x15/0x20
> > [  101.412459]  default_idle_call+0x5f/0x70
> > [  101.413405]  do_idle+0x30f/0x3d0
> > [  101.414185]  ? arch_cpu_idle_exit+0x40/0x40
> > [  101.415188]  ? complete+0x67/0x80
> > [  101.415992]  cpu_startup_entry+0x1d/0x20
> > [  101.416937]  start_secondary+0x2ec/0x3d0
> > [  101.417879]  ? set_cpu_sibling_map+0x2620/0x2620
> > [  101.418986]  secondary_startup_64+0xb6/0xc0
> > [  101.420001] ---[ end trace 6143b67a4d795a3a ]---
> > 
> > Daniel Vetter (1):
> >   drm/atomic-helper: reset vblank on crtc reset
> > 
> > Thomas Zimmermann (1):
> >   drm: Initialize struct drm_crtc_state.no_vblank from device settings
> > 
> >  drivers/gpu/drm/arm/display/komeda/komeda_crtc.c |  7 ++---
> >  drivers/gpu/drm/arm/malidp_drv.c                 |  1 -
> >  drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c   |  7 ++---
> >  drivers/gpu/drm/drm_atomic_helper.c              | 10 ++++++-
> >  drivers/gpu/drm/drm_atomic_state_helper.c        |  4 +++
> >  drivers/gpu/drm/drm_vblank.c                     | 28 +++++++++++++++++++
> >  drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c        |  2 --
> >  drivers/gpu/drm/omapdrm/omap_crtc.c              |  8 +++---
> >  drivers/gpu/drm/omapdrm/omap_drv.c               |  4 ---
> >  drivers/gpu/drm/rcar-du/rcar_du_crtc.c           |  6 +----
> >  drivers/gpu/drm/tegra/dc.c                       |  1 -
> >  include/drm/drm_crtc.h                           | 34 +++++++++++++++++++-----
> >  include/drm/drm_simple_kms_helper.h              |  7 +++--
> >  include/drm/drm_vblank.h                         |  1 +
> >  14 files changed, 84 insertions(+), 36 deletions(-)
> > 
> > -- 
> > 1.8.3.1
> > 
> 
> I need the drm developers/maintainers to ack these changes before I can
> take them into the stable tree...  {hint}

Now dropping from my "to review" queue as there was no response from the
DRM maintainers.  Please get them to ack this before resending it again.

thanks,

greg k-h
