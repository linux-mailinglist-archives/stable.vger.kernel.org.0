Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B002E60CAFF
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 13:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiJYLgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 07:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJYLgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 07:36:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0903885AAB;
        Tue, 25 Oct 2022 04:36:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F01AB81C4E;
        Tue, 25 Oct 2022 11:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67087C433C1;
        Tue, 25 Oct 2022 11:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666697765;
        bh=FP+xDQm/fMcpABfdVoP8FT/aX0L5t/2j4/YpFeFO+jI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ElviCW5AQEx3xm+RVwc+kjflXkingkanSmARDUD9ctWYLnX094KxT4frshxSfGZf8
         Te/XnFb8OCwwDzpDSgnJy1Nh9ZNKAF62Z2gUvbL7rJpCo7IVxgMhy/6vAECp6SmFVO
         GJywtdr+AsgWITWncPkCi4aBloJgiMhnceg7x+r8=
Date:   Tue, 25 Oct 2022 13:36:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     javierm@redhat.com, deller@gmx.de, sashal@kernel.org,
        stable@vger.kernel.org,
        Andreas Thalhammer <andreas.thalhammer-linux@gmx.net>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Zack Rusin <zackr@vmware.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] video/aperture: Call sysfb_disable() before removing PCI
 devices
Message-ID: <Y1fKI7CtCaqK03tj@kroah.com>
References: <20221025110453.9404-1-tzimmermann@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221025110453.9404-1-tzimmermann@suse.de>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 01:04:53PM +0200, Thomas Zimmermann wrote:
> Call sysfb_disable() from aperture_remove_conflicting_pci_devices()
> before removing PCI devices. Without, simpledrm can still bind to
> simple-framebuffer devices after the hardware driver has taken over
> the hardware. Both drivers interfere with each other and results are
> undefined.
> 
> Reported modesetting errors are shown below.
> 
> ---- snap ----
> rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: { 13-.... } 7 jiffies s: 165 root: 0x2000/.
> rcu: blocking rcu_node structures (internal RCU debug):
> Task dump for CPU 13:
> task:X               state:R  running task     stack:    0 pid: 4242 ppid:  4228 flags:0x00000008
> Call Trace:
>  <TASK>
>  ? commit_tail+0xd7/0x130
>  ? drm_atomic_helper_commit+0x126/0x150
>  ? drm_atomic_commit+0xa4/0xe0
>  ? drm_plane_get_damage_clips.cold+0x1c/0x1c
>  ? drm_atomic_helper_dirtyfb+0x19e/0x280
>  ? drm_mode_dirtyfb_ioctl+0x10f/0x1e0
>  ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>  ? drm_ioctl_kernel+0xc4/0x150
>  ? drm_ioctl+0x246/0x3f0
>  ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>  ? __x64_sys_ioctl+0x91/0xd0
>  ? do_syscall_64+0x60/0xd0
>  ? entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>  </TASK>
> ...
> rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: { 13-.... } 30 jiffies s: 169 root: 0x2000/.
> rcu: blocking rcu_node structures (internal RCU debug):
> Task dump for CPU 13:
> task:X               state:R  running task     stack:    0 pid: 4242 ppid:  4228 flags:0x0000400e
> Call Trace:
>  <TASK>
>  ? memcpy_toio+0x76/0xc0
>  ? memcpy_toio+0x1b/0xc0
>  ? drm_fb_memcpy_toio+0x76/0xb0
>  ? drm_fb_blit_toio+0x75/0x2b0
>  ? simpledrm_simple_display_pipe_update+0x132/0x150
>  ? drm_atomic_helper_commit_planes+0xb6/0x230
>  ? drm_atomic_helper_commit_tail+0x44/0x80
>  ? commit_tail+0xd7/0x130
>  ? drm_atomic_helper_commit+0x126/0x150
>  ? drm_atomic_commit+0xa4/0xe0
>  ? drm_plane_get_damage_clips.cold+0x1c/0x1c
>  ? drm_atomic_helper_dirtyfb+0x19e/0x280
>  ? drm_mode_dirtyfb_ioctl+0x10f/0x1e0
>  ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>  ? drm_ioctl_kernel+0xc4/0x150
>  ? drm_ioctl+0x246/0x3f0
>  ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>  ? __x64_sys_ioctl+0x91/0xd0
>  ? do_syscall_64+0x60/0xd0
>  ? entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>  </TASK>
> 
> The problem was added by commit 5e0137612430 ("video/aperture: Disable
> and unregister sysfb devices via aperture helpers") to v6.0.3 and does
> not exist in the mainline branch.

Why isn't this a problem in Linus's tree?  What commits there cause this
to not be an issue and why can't we just take them instead?

thanks,

greg k-h
