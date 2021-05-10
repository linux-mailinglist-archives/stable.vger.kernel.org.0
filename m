Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB6C3796FE
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 20:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbhEJS1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 14:27:48 -0400
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:43523 "EHLO ofcsgdbm.dwd.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhEJS1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 14:27:47 -0400
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2021 14:27:47 EDT
Received: from localhost (localhost [127.0.0.1])
        by ofcsg2dn1.dwd.de (Postfix) with ESMTP id 4Ff8WH3V3Wz1y49
        for <stable@vger.kernel.org>; Mon, 10 May 2021 18:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dwd.de; h=
        content-type:content-type:mime-version:references:message-id
        :in-reply-to:subject:subject:from:from:date:date:received
        :received:received:received:received:received:received:received;
         s=dwd-csg20210107; t=1620670859; x=1621880460; bh=PbGEd7xJw/Xar
        rUAaFNwZLS1XW5vHHllPWQ9YX0h19M=; b=RlmY4DjRwgMOqbsqMlVZT8dYOL7pR
        nZslItqCQwyjcbrRU1RtgyPLFEz6TOHyWo8KXzfkxc2omrzyXmcDtmTzPY1iQzxu
        5rmr6+NDorWGJbU7yidYOKZnWW+OlXudh+KNdehseMaAwf/0wwvUly31vs7ddnyy
        kSBDiY4R0dNzWFmz2VsWoh5lW/tfx/0aZihgRtywIUKMYpkVt3wcc23JAd0Y+QWs
        9iIfPgZl02BT2X3rMTyZWbS5bSZU6MrvNGLRId9tSoFURc+rgfBcUj1NDfoAHvRD
        7bYGpIKWtQAGbbJdnGNLCIhQxGrLOtrx4iauRvjry5CteiOnpJIiriozQ==
X-Virus-Scanned: by amavisd-new at csg.dwd.de
Received: from ofcsg2cteh1.dwd.de ([172.30.232.65])
        by localhost (ofcsg2dn1.dwd.de [172.30.232.24]) (amavisd-new, port 10024)
        with ESMTP id j-uw7dBeWYfV for <stable@vger.kernel.org>;
        Mon, 10 May 2021 18:20:59 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 2C5A5C90297C
        for <root@ofcsg2dn1.dwd.de>; Mon, 10 May 2021 18:20:59 +0000 (UTC)
Received: from ofcsg2cteh1.dwd.de (unknown [127.0.0.1])
        by DDEI (Postfix) with ESMTP id 2A2D4C90296F
        for <root@ofcsg2dn1.dwd.de>; Mon, 10 May 2021 18:20:59 +0000 (UTC)
Received: from ofcsgdbm.dwd.de (unknown [172.30.232.24])
        by ofcsg2cteh1.dwd.de (Postfix) with ESMTP
        for <root@ofcsg2dn1.dwd.de>; Mon, 10 May 2021 18:20:59 +0000 (UTC)
Received: from ofcsgdbm.dwd.de by localhost (Postfix XFORWARD proxy);
 Mon, 10 May 2021 18:20:59 -0000
Received: from ofcsg2dvf2.dwd.de (ofcsg2dvf2.dwd.de [172.30.232.11])
        by ofcsg2dn1.dwd.de (Postfix) with ESMTPS id 4Ff8WH0jP6z1y49;
        Mon, 10 May 2021 18:20:59 +0000 (UTC)
Received: from ofmailhub.dwd.de (ofldap.dwd.de [141.38.39.208])
        by ofcsg2dvf2.dwd.de  with ESMTP id 14AIKwqu001871-14AIKwqv001871;
        Mon, 10 May 2021 18:20:58 GMT
Received: from diagnostix.dwd.de (diagnostix.dwd.de [141.38.44.45])
        by ofmailhub.dwd.de (Postfix) with ESMTP id CF0FF45351;
        Mon, 10 May 2021 18:20:58 +0000 (UTC)
Date:   Mon, 10 May 2021 18:20:58 +0000 (GMT)
From:   Holger Kiehl <Holger.Kiehl@dwd.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        xinhui pan <xinhui.pan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.12 195/384] drm/amdgpu: Fix memory leak
In-Reply-To: <20210510102021.305484238@linuxfoundation.org>
Message-ID: <8681a9f2-62e6-3aa-d169-653db617f60@diagnostix.dwd.de>
References: <20210510102014.849075526@linuxfoundation.org> <20210510102021.305484238@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-FE-Policy-ID: 2:2:1:SYSTEM
X-TMASE-Version: DDEI-5.0-8.6.1014-26144.001
X-TMASE-Result: 10--10.347500-10.000000
X-TMASE-MatchedRID: 6lay9u8oTUNlpmlM1IvJ9vZvT2zYoYOwC/ExpXrHizzkCKFvqJHeydyZ
        D8zO5nCSbIc+aNIzEOkmeKn5slpXrmTVdE6PJsztGtFkgOqGCyBUV5Q8COx3xmww+4tkH8hH035
        U7xRHgyFGO66u731D0o9CL1e45ag4Q+7j+FblbzfG+nS24MzHed2Emh5Z2S/NfvYkgEq56SkSTP
        F1kz6wXNqLGPjfCuopFdd8sIB6r/3jKCpN2c+oPoQ1YU70UZ+oUNr9nJzA3WRG7aLtT3oj++oAT
        1YIElsK6LvuV9SL7QV6KN36LuKEFewy2NhRsPybT7O/YHJhINACzX46RgRBb6ShvRjfn4cUD0nH
        BPteW4qGScsSBcYgtwIrJOPBAlx1Mz0EFG5lnW+lpSWqiMt78k+crEA4+nhZ/+ypkpmpen/X7Qq
        xdrFbPuLzNWBegCW2QiE5bJj38wBt1O49r1VEa8RB0bsfrpPIfiAqrjYtFiRQDwPh5j959+wy3l
        QAx/lZ1XIK12hWQCV+nmXCkpGK3H7cGd19dSFd
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
X-TMASE-INERTIA: 0-0;;;;
X-TMASE-XGENCLOUD: afad1a19-20f5-4841-bc36-a3cf9f728327-0-0-200-0
X-DDEI-PROCESSED-RESULT: Safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 May 2021, Greg Kroah-Hartman wrote:

> From: xinhui pan <xinhui.pan@amd.com>
> 
> [ Upstream commit 79fcd446e7e182c52c2c808c76f8de3eb6714349 ]
> 
> drm_gem_object_put() should be paired with drm_gem_object_lookup().
> 
> All gem objs are saved in fb->base.obj[]. Need put the old first before
> assign a new obj.
> 
> Trigger VRAM leak by running command below
> $ service gdm restart
> 
> Signed-off-by: xinhui pan <xinhui.pan@amd.com>
> Acked-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_display.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> index f753e04fee99..cbe050436c7b 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_display.c
> @@ -910,8 +910,9 @@ int amdgpu_display_framebuffer_init(struct drm_device *dev,
>  	}
>  
>  	for (i = 1; i < rfb->base.format->num_planes; ++i) {
> +		drm_gem_object_get(rfb->base.obj[0]);
> +		drm_gem_object_put(rfb->base.obj[i]);
>  		rfb->base.obj[i] = rfb->base.obj[0];
> -		drm_gem_object_get(rfb->base.obj[i]);
>  	}
>  
>  	return 0;
> @@ -960,6 +961,7 @@ amdgpu_display_user_framebuffer_create(struct drm_device *dev,
>  		return ERR_PTR(ret);
>  	}
>  
> +	drm_gem_object_put(obj);
>  	return &amdgpu_fb->base;
>  }
>  
> -- 
> 2.30.2
> 
This causes the following error on a AMD APU Ryzen 7 4750G:

   May 10 19:29:50 bb8 kernel: [    2.730473] [drm] Initialized amdgpu 3.40.0 20150101 for 0000:04:00.0 on minor 0
   May 10 19:29:50 bb8 kernel: [    2.748000] ------------[ cut here ]------------
   May 10 19:29:50 bb8 kernel: [    2.748003] refcount_t: underflow; use-after-free.
   May 10 19:29:50 bb8 kernel: [    2.748008] WARNING: CPU: 10 PID: 513 at lib/refcount.c:28 refcount_warn_saturate+0xa6/0xf0
   May 10 19:29:50 bb8 kernel: [    2.748014] Modules linked in: amdgpu raid1 raid0 md_mod drm_ttm_helper ttm mfd_core iommu_v2 gpu_sched i2c_algo_bit crct10dif_pclmul crc32_pclmul crc32c_intel drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec ghash_clmulni_intel drm r8169 ccp realtek pinctrl_amd fuse ecryptfs
   May 10 19:29:50 bb8 kernel: [    2.748029] CPU: 10 PID: 513 Comm: plymouthd Not tainted 5.12.3 #1
   May 10 19:29:50 bb8 kernel: [    2.748031] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./X300M-STX, BIOS P1.60 04/29/2021
   May 10 19:29:50 bb8 kernel: [    2.748032] RIP: 0010:refcount_warn_saturate+0xa6/0xf0
   May 10 19:29:50 bb8 kernel: [    2.748034] Code: 05 79 34 17 01 01 e8 cd 51 4a 00 0f 0b c3 80 3d 67 34 17 01 00 75 95 48 c7 c7 a0 90 13 99 c6 05 57 34 17 01 01 e8 ae 51 4a 00 <0f> 0b c3 80 3d 46 34 17 01 00 0f 85 72 ff ff ff 48 c7 c7 f8 90 13
   May 10 19:29:50 bb8 kernel: [    2.748036] RSP: 0018:ffffb2ccc07f7d58 EFLAGS: 00010292
   May 10 19:29:50 bb8 kernel: [    2.748038] RAX: 0000000000000026 RBX: ffff90d28d313000 RCX: 0000000000000027
   May 10 19:29:50 bb8 kernel: [    2.748039] RDX: ffff90e081c975c8 RSI: 0000000000000001 RDI: ffff90e081c975c0
   May 10 19:29:50 bb8 kernel: [    2.748040] RBP: ffff90d290b1b458 R08: 0000000000000000 R09: ffffb2ccc07f7b98
   May 10 19:29:50 bb8 kernel: [    2.748040] R10: 0000000000000001 R11: 0000000000000001 R12: ffff90d28d313000
   May 10 19:29:50 bb8 kernel: [    2.748041] R13: ffff90d28d313128 R14: ffff90d28d313050 R15: ffff90d28d313000
   May 10 19:29:50 bb8 kernel: [    2.748042] FS:  00007fa31f454800(0000) GS:ffff90e081c80000(0000) knlGS:0000000000000000
   May 10 19:29:50 bb8 kernel: [    2.748043] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   May 10 19:29:50 bb8 kernel: [    2.748044] CR2: 00007fa31f42e000 CR3: 000000010e1d2000 CR4: 0000000000350ee0
   May 10 19:29:50 bb8 kernel: [    2.748046] Call Trace:
   May 10 19:29:50 bb8 kernel: [    2.748049]  drm_gem_object_release_handle+0x6b/0x80 [drm]
   May 10 19:29:50 bb8 kernel: [    2.748068]  ? drm_mode_destroy_dumb+0x40/0x40 [drm]
   May 10 19:29:50 bb8 kernel: [    2.748086]  drm_gem_handle_delete+0x4f/0x80 [drm]
   May 10 19:29:50 bb8 kernel: [    2.748101]  ? drm_mode_destroy_dumb+0x40/0x40 [drm]
   May 10 19:29:50 bb8 kernel: [    2.748117]  drm_ioctl_kernel+0x87/0xd0 [drm]
   May 10 19:29:50 bb8 kernel: [    2.748133]  drm_ioctl+0x205/0x3a0 [drm]
   May 10 19:29:50 bb8 kernel: [    2.748149]  ? drm_mode_destroy_dumb+0x40/0x40 [drm]
   May 10 19:29:50 bb8 kernel: [    2.748164]  amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
   May 10 19:29:50 bb8 kernel: [    2.748263]  __x64_sys_ioctl+0x82/0xb0
   May 10 19:29:50 bb8 kernel: [    2.748266]  do_syscall_64+0x33/0x40
   May 10 19:29:50 bb8 kernel: [    2.748269]  entry_SYSCALL_64_after_hwframe+0x44/0xae
   May 10 19:29:50 bb8 kernel: [    2.748271] RIP: 0033:0x7fa31f7d30ab
   May 10 19:29:50 bb8 kernel: [    2.748273] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 95 bd 0c 00 f7 d8 64 89 01 48
   May 10 19:29:50 bb8 kernel: [    2.748274] RSP: 002b:00007ffe145fb638 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
   May 10 19:29:50 bb8 kernel: [    2.748275] RAX: ffffffffffffffda RBX: 00007ffe145fb67c RCX: 00007fa31f7d30ab
   May 10 19:29:50 bb8 kernel: [    2.748276] RDX: 00007ffe145fb67c RSI: 00000000c00464b4 RDI: 000000000000000a
   May 10 19:29:50 bb8 kernel: [    2.748277] RBP: 00000000c00464b4 R08: 00005620f7832c40 R09: 0000000000000007
   May 10 19:29:50 bb8 kernel: [    2.748278] R10: 00005620f7832c40 R11: 0000000000000246 R12: 0000000000000001
   May 10 19:29:50 bb8 kernel: [    2.748278] R13: 000000000000000a R14: 000000000000000b R15: 00007fa31f8c6e20
   May 10 19:29:50 bb8 kernel: [    2.748280] ---[ end trace 57825da3e46ebfc7 ]---

On another system with a Ryzen 5 3400G a reboot will hang.

If I remove this patch the system boots fine and there is no error
message.

Regards,
Holger
