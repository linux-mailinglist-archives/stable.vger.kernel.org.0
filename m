Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84CA37A61B
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 13:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhEKL4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 07:56:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230519AbhEKL4O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 May 2021 07:56:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B978611CE;
        Tue, 11 May 2021 11:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620734107;
        bh=tmtzaEnnQ53WPoq28nQwKpDaKHGtSVcdQWAFnV8IjgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=enIE1IheTE/n/jkU7UV6Eay3I77tqcJO5VZBvPAbJR1eIJNoCRtBWERpmcyN7iJJL
         JNZnMl67nyIelq2ZsxMO3d8kbsb/zz+j11kce2L8UgA533kVXkfVgqVwZKTe1sGmlC
         pOdC6+uOO7fhcv/lkWdRcyR1iRv9D31Xf1umPk14=
Date:   Tue, 11 May 2021 13:55:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc:     Holger Kiehl <Holger.Kiehl@dwd.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.12 195/384] drm/amdgpu: Fix memory leak
Message-ID: <YJpwmbfnQIYZFgXD@kroah.com>
References: <20210510102014.849075526@linuxfoundation.org>
 <20210510102021.305484238@linuxfoundation.org>
 <8681a9f2-62e6-3aa-d169-653db617f60@diagnostix.dwd.de>
 <MN2PR12MB4488A0EC34EBCE766199AB3DF7549@MN2PR12MB4488.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB4488A0EC34EBCE766199AB3DF7549@MN2PR12MB4488.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 07:56:30PM +0000, Deucher, Alexander wrote:
> [AMD Public Use]
> 
> > -----Original Message-----
> > From: Holger Kiehl <Holger.Kiehl@dwd.de>
> > Sent: Monday, May 10, 2021 2:21 PM
> > To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Pan, Xinhui
> > <Xinhui.Pan@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> > Subject: Re: [PATCH 5.12 195/384] drm/amdgpu: Fix memory leak
> > 
> > On Mon, 10 May 2021, Greg Kroah-Hartman wrote:
> > 
> > > From: xinhui pan <xinhui.pan@amd.com>
> > >
> > > [ Upstream commit 79fcd446e7e182c52c2c808c76f8de3eb6714349 ]
> > >
> > > drm_gem_object_put() should be paired with drm_gem_object_lookup().
> > >
> > > All gem objs are saved in fb->base.obj[]. Need put the old first
> > > before assign a new obj.
> > >
> > > Trigger VRAM leak by running command below $ service gdm restart
> > >
> > > Signed-off-by: xinhui pan <xinhui.pan@amd.com>
> > > Acked-by: Alex Deucher <alexander.deucher@amd.com>
> > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> > > b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> > > index f753e04fee99..cbe050436c7b 100644
> > > --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> > > +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> > > @@ -910,8 +910,9 @@ int amdgpu_display_framebuffer_init(struct
> > drm_device *dev,
> > >  	}
> > >
> > >  	for (i = 1; i < rfb->base.format->num_planes; ++i) {
> > > +		drm_gem_object_get(rfb->base.obj[0]);
> > > +		drm_gem_object_put(rfb->base.obj[i]);
> > >  		rfb->base.obj[i] = rfb->base.obj[0];
> > > -		drm_gem_object_get(rfb->base.obj[i]);
> > >  	}
> > >
> > >  	return 0;
> > > @@ -960,6 +961,7 @@ amdgpu_display_user_framebuffer_create(struct
> > drm_device *dev,
> > >  		return ERR_PTR(ret);
> > >  	}
> > >
> > > +	drm_gem_object_put(obj);
> > >  	return &amdgpu_fb->base;
> > >  }
> > >
> > > --
> > > 2.30.2
> > >
> > This causes the following error on a AMD APU Ryzen 7 4750G:
> > 
> >    May 10 19:29:50 bb8 kernel: [    2.730473] [drm] Initialized amdgpu 3.40.0
> > 20150101 for 0000:04:00.0 on minor 0
> >    May 10 19:29:50 bb8 kernel: [    2.748000] ------------[ cut here ]------------
> >    May 10 19:29:50 bb8 kernel: [    2.748003] refcount_t: underflow; use-after-
> > free.
> >    May 10 19:29:50 bb8 kernel: [    2.748008] WARNING: CPU: 10 PID: 513 at
> > lib/refcount.c:28 refcount_warn_saturate+0xa6/0xf0
> >    May 10 19:29:50 bb8 kernel: [    2.748014] Modules linked in: amdgpu raid1
> > raid0 md_mod drm_ttm_helper ttm mfd_core iommu_v2 gpu_sched
> > i2c_algo_bit crct10dif_pclmul crc32_pclmul crc32c_intel drm_kms_helper
> > syscopyarea sysfillrect sysimgblt fb_sys_fops cec ghash_clmulni_intel drm
> > r8169 ccp realtek pinctrl_amd fuse ecryptfs
> >    May 10 19:29:50 bb8 kernel: [    2.748029] CPU: 10 PID: 513 Comm:
> > plymouthd Not tainted 5.12.3 #1
> >    May 10 19:29:50 bb8 kernel: [    2.748031] Hardware name: To Be Filled By
> > O.E.M. To Be Filled By O.E.M./X300M-STX, BIOS P1.60 04/29/2021
> >    May 10 19:29:50 bb8 kernel: [    2.748032] RIP:
> > 0010:refcount_warn_saturate+0xa6/0xf0
> >    May 10 19:29:50 bb8 kernel: [    2.748034] Code: 05 79 34 17 01 01 e8 cd 51 4a
> > 00 0f 0b c3 80 3d 67 34 17 01 00 75 95 48 c7 c7 a0 90 13 99 c6 05 57 34 17 01 01 e8
> > ae 51 4a 00 <0f> 0b c3 80 3d 46 34 17 01 00 0f 85 72 ff ff ff 48 c7 c7 f8 90 13
> >    May 10 19:29:50 bb8 kernel: [    2.748036] RSP: 0018:ffffb2ccc07f7d58
> > EFLAGS: 00010292
> >    May 10 19:29:50 bb8 kernel: [    2.748038] RAX: 0000000000000026 RBX:
> > ffff90d28d313000 RCX: 0000000000000027
> >    May 10 19:29:50 bb8 kernel: [    2.748039] RDX: ffff90e081c975c8 RSI:
> > 0000000000000001 RDI: ffff90e081c975c0
> >    May 10 19:29:50 bb8 kernel: [    2.748040] RBP: ffff90d290b1b458 R08:
> > 0000000000000000 R09: ffffb2ccc07f7b98
> >    May 10 19:29:50 bb8 kernel: [    2.748040] R10: 0000000000000001 R11:
> > 0000000000000001 R12: ffff90d28d313000
> >    May 10 19:29:50 bb8 kernel: [    2.748041] R13: ffff90d28d313128 R14:
> > ffff90d28d313050 R15: ffff90d28d313000
> >    May 10 19:29:50 bb8 kernel: [    2.748042] FS:  00007fa31f454800(0000)
> > GS:ffff90e081c80000(0000) knlGS:0000000000000000
> >    May 10 19:29:50 bb8 kernel: [    2.748043] CS:  0010 DS: 0000 ES: 0000 CR0:
> > 0000000080050033
> >    May 10 19:29:50 bb8 kernel: [    2.748044] CR2: 00007fa31f42e000 CR3:
> > 000000010e1d2000 CR4: 0000000000350ee0
> >    May 10 19:29:50 bb8 kernel: [    2.748046] Call Trace:
> >    May 10 19:29:50 bb8 kernel: [    2.748049]
> > drm_gem_object_release_handle+0x6b/0x80 [drm]
> >    May 10 19:29:50 bb8 kernel: [    2.748068]  ?
> > drm_mode_destroy_dumb+0x40/0x40 [drm]
> >    May 10 19:29:50 bb8 kernel: [    2.748086]
> > drm_gem_handle_delete+0x4f/0x80 [drm]
> >    May 10 19:29:50 bb8 kernel: [    2.748101]  ?
> > drm_mode_destroy_dumb+0x40/0x40 [drm]
> >    May 10 19:29:50 bb8 kernel: [    2.748117]  drm_ioctl_kernel+0x87/0xd0
> > [drm]
> >    May 10 19:29:50 bb8 kernel: [    2.748133]  drm_ioctl+0x205/0x3a0 [drm]
> >    May 10 19:29:50 bb8 kernel: [    2.748149]  ?
> > drm_mode_destroy_dumb+0x40/0x40 [drm]
> >    May 10 19:29:50 bb8 kernel: [    2.748164]  amdgpu_drm_ioctl+0x49/0x80
> > [amdgpu]
> >    May 10 19:29:50 bb8 kernel: [    2.748263]  __x64_sys_ioctl+0x82/0xb0
> >    May 10 19:29:50 bb8 kernel: [    2.748266]  do_syscall_64+0x33/0x40
> >    May 10 19:29:50 bb8 kernel: [    2.748269]
> > entry_SYSCALL_64_after_hwframe+0x44/0xae
> >    May 10 19:29:50 bb8 kernel: [    2.748271] RIP: 0033:0x7fa31f7d30ab
> >    May 10 19:29:50 bb8 kernel: [    2.748273] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff
> > ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00
> > 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 95 bd 0c 00 f7 d8 64 89 01 48
> >    May 10 19:29:50 bb8 kernel: [    2.748274] RSP: 002b:00007ffe145fb638
> > EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> >    May 10 19:29:50 bb8 kernel: [    2.748275] RAX: ffffffffffffffda RBX:
> > 00007ffe145fb67c RCX: 00007fa31f7d30ab
> >    May 10 19:29:50 bb8 kernel: [    2.748276] RDX: 00007ffe145fb67c RSI:
> > 00000000c00464b4 RDI: 000000000000000a
> >    May 10 19:29:50 bb8 kernel: [    2.748277] RBP: 00000000c00464b4 R08:
> > 00005620f7832c40 R09: 0000000000000007
> >    May 10 19:29:50 bb8 kernel: [    2.748278] R10: 00005620f7832c40 R11:
> > 0000000000000246 R12: 0000000000000001
> >    May 10 19:29:50 bb8 kernel: [    2.748278] R13: 000000000000000a R14:
> > 000000000000000b R15: 00007fa31f8c6e20
> >    May 10 19:29:50 bb8 kernel: [    2.748280] ---[ end trace 57825da3e46ebfc7 ]-
> > --
> > 
> > On another system with a Ryzen 5 3400G a reboot will hang.
> > 
> > If I remove this patch the system boots fine and there is no error message.
> 
> This patch is a fix specifically for:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f258907fdd835e1aed6d666b00cdd0f186676b7c
> It does not make sense on it's own.

Thanks for the information, now dropped.

greg k-h
