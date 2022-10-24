Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC01609F38
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 12:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJXKlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 06:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJXKlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 06:41:50 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B4965276
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 03:41:45 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1omuts-0002An-Ch; Mon, 24 Oct 2022 12:41:44 +0200
Message-ID: <958fd763-01b6-0167-ba6b-97cbd3bddcb6@leemhuis.info>
Date:   Mon, 24 Oct 2022 12:41:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
Content-Language: en-US, de-DE
To:     Greg KH <gregkh@linuxfoundation.org>,
        Andreas <andreas.thalhammer@linux.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Javier Martinez Canillas <javierm@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
References: <bbf7afe7-6ed2-6708-d302-4ba657444c45@leemhuis.info>
 <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1666608107;ef297178;
X-HE-SMSGID: 1omuts-0002An-Ch
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi! Thx for the reply.

On 24.10.22 12:26, Thomas Zimmermann wrote:
> Am 23.10.22 um 10:04 schrieb Thorsten Leemhuis:
>>
>> I noticed a regression report in bugzilla.kernel.org. As many (most?)
>> kernel developer don't keep an eye on it, I decided to forward it by
>> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216616  :
>>
>>>   Andreas 2022-10-22 14:25:32 UTC
>>>
>>> Created attachment 303074 [details]
>>> dmesg
> 
> I've looked at the kernel log and found that simpledrm has been loaded
> *after* amdgpu, which should never happen. The problematic patch has
> been taken from a long list of refactoring work on this code. No wonder
> that it doesn't work as expected.
> 
> Please cherry-pick commit 9d69ef183815 ("fbdev/core: Remove
> remove_conflicting_pci_framebuffers()") into the 6.0 stable branch and
> report on the results. It should fix the problem.

Greg, is that enough for you to pick this up? Or do you want Andreas to
test first if it really fixes the reported problem?

Ciao, Thorsten


>>> 6.0.2 works.
>>>
>>> On 6.0.3 the system is very sluggish with graphic glitches all over
>>> the place in KDE Plasma Desktop X11 (no graphic glitches when using
>>> Wayland, but also sluggish). SDDM works fine.
>>>
>>> Hardware: Lenovo Legion 5 Pro 16ACH6H: AMD Ryzen 7 5800H "Cezanne",
>>> hybrid graphics AMD "Green Sardine" (Vega 8 GCN 5.1, AMDGPU) and
>>> Nvidia GeForce RTX 3070 Mobile (GA104M, not working with nouveau, I'm
>>> not using the proprietary nvidia driver).
>>>
>>> [reply] [−] Comment 1 Andreas 2022-10-22 14:27:15 UTC
>>>
>>> Created attachment 303075 [details]
>>> my kernel .config for 6.0.3
>>>
>>> Only was CONFIG_HID_TOPRE added in 6.0.3, otherwise it is identical
>>> as my .config for 6.0.2.
>>>
>>> [reply] [−] Comment 2 Andreas 2022-10-22 14:51:23 UTC
>>>
>>> In /var/log/Xorg.0.log the only obvious difference is the last line:
>>> ---- snap
>>> randr: falling back to unsynchronized pixmap sharing
>>> ---- snap
>>> The line is present when I boot with 6.0.3, but isn't when I boot 6.0.2.
>>>
>>> (Obviously this is when I login to KDE with X11, not with Wayland,
>>> from SDDM.)
>>>
>>> [reply] [−] Comment 3 Andreas 2022-10-22 22:10:19 UTC
>>>
>>> I did a git bisect on stable kernels 5.0.3 as bad and 5.0.2 as good,
>>> this is the result:
>>>
>>> cfecfc98a78d97a49807531b5b224459bda877de is the first bad commit
>>> commit cfecfc98a78d97a49807531b5b224459bda877de (HEAD, refs/bisect/bad)
>>> Author: Thomas Zimmermann <tzimmermann@suse.de>
>>> Date:   Mon Jul 18 09:23:18 2022 +0200
>>>
>>>      video/aperture: Disable and unregister sysfb devices via
>>> aperture helpers
>>>           [ Upstream commit 5e01376124309b4dbd30d413f43c0d9c2f60edea ]
>>>           Call sysfb_disable() before removing conflicting devices in
>>> aperture
>>>      helpers. Fixes sysfb state if fbdev has been disabled.
>>>           Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>>>      Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
>>>      Fixes: fb84efa28a48 ("drm/aperture: Run fbdev removal before
>>> internal helpers")
>>>
>>> [reply] [−] Comment 4 Andreas 2022-10-22 22:11:51 UTC
>>>
>>> Link to the suspect patch:
>>>
>>> https://patchwork.freedesktop.org/patch/msgid/20220718072322.8927-8-tzimmermann@suse.de
>>> (or https://patchwork.freedesktop.org/patch/494608/)
>>>
>>> [reply] [−] Comment 5 Andreas 2022-10-22 22:38:14 UTC
>>>
>>> Okay, so I reverted
>>> v2-07-11-video-aperture-Disable-and-unregister-sysfb-devices-via-aperture-helpers.patch on stable 5.0.3 and the fault is gone.
>>>
>>> I always logged out immediately, which worked (even though everything
>>> is very very sluggish). Also, when I killed the X session within a
>>> couple of seconds (15 or so), no error was shown (I used "systemctl
>>> stop sddm" from another virtual console).
>>>
>>> Noteworthy: I once compiled a kernel from within the Plasma Desktop,
>>> while it was sluggish. The kernel compiled alright. When it was
>>> finished I moved the mouse to reboot, at which point it completely
>>> froze and I had to hard-reset the system.
>>>
>>> While still running, after > 15 seconds, the fault looked like this
>>> (dmesg):
>>> ---- snap ----
>>> rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: {
>>> 13-.... } 7 jiffies s: 165 root: 0x2000/.
>>> rcu: blocking rcu_node structures (internal RCU debug):
>>> Task dump for CPU 13:
>>> task:X               state:R  running task     stack:    0 pid: 4242
>>> ppid:  4228 flags:0x00000008
>>> Call Trace:
>>>   <TASK>
>>>   ? commit_tail+0xd7/0x130
>>>   ? drm_atomic_helper_commit+0x126/0x150
>>>   ? drm_atomic_commit+0xa4/0xe0
>>>   ? drm_plane_get_damage_clips.cold+0x1c/0x1c
>>>   ? drm_atomic_helper_dirtyfb+0x19e/0x280
>>>   ? drm_mode_dirtyfb_ioctl+0x10f/0x1e0
>>>   ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>>>   ? drm_ioctl_kernel+0xc4/0x150
>>>   ? drm_ioctl+0x246/0x3f0
>>>   ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>>>   ? __x64_sys_ioctl+0x91/0xd0
>>>   ? do_syscall_64+0x60/0xd0
>>>   ? entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>>>   </TASK>
>>> rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: {
>>> 13-.... } 29 jiffies s: 165 root: 0x2000/.
>>> rcu: blocking rcu_node structures (internal RCU debug):
>>> Task dump for CPU 13:
>>> task:X               state:R  running task     stack:    0 pid: 4242
>>> ppid:  4228 flags:0x00000008
>>> Call Trace:
>>>   <TASK>
>>>   ? commit_tail+0xd7/0x130
>>>   ? drm_atomic_helper_commit+0x126/0x150
>>>   ? drm_atomic_commit+0xa4/0xe0
>>>   ? drm_plane_get_damage_clips.cold+0x1c/0x1c
>>>   ? drm_atomic_helper_dirtyfb+0x19e/0x280
>>>   ? drm_mode_dirtyfb_ioctl+0x10f/0x1e0
>>>   ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>>>   ? drm_ioctl_kernel+0xc4/0x150
>>>   ? drm_ioctl+0x246/0x3f0
>>>   ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>>>   ? __x64_sys_ioctl+0x91/0xd0
>>>   ? do_syscall_64+0x60/0xd0
>>>   ? entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>>>   </TASK>
>>> rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: {
>>> 13-.... } 8 jiffies s: 169 root: 0x2000/.
>>> rcu: blocking rcu_node structures (internal RCU debug):
>>> Task dump for CPU 13:
>>> task:X               state:R  running task     stack:    0 pid: 4242
>>> ppid:  4228 flags:0x0000400e
>>> Call Trace:
>>>   <TASK>
>>>   ? memcpy_toio+0x76/0xc0
>>>   ? drm_fb_memcpy_toio+0x76/0xb0
>>>   ? drm_fb_blit_toio+0x75/0x2b0
>>>   ? simpledrm_simple_display_pipe_update+0x132/0x150
>>>   ? drm_atomic_helper_commit_planes+0xb6/0x230
>>>   ? drm_atomic_helper_commit_tail+0x44/0x80
>>>   ? commit_tail+0xd7/0x130
>>>   ? drm_atomic_helper_commit+0x126/0x150
>>>   ? drm_atomic_commit+0xa4/0xe0
>>>   ? drm_plane_get_damage_clips.cold+0x1c/0x1c
>>>   ? drm_atomic_helper_dirtyfb+0x19e/0x280
>>>   ? drm_mode_dirtyfb_ioctl+0x10f/0x1e0
>>>   ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>>>   ? drm_ioctl_kernel+0xc4/0x150
>>>   ? drm_ioctl+0x246/0x3f0
>>>   ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>>>   ? __x64_sys_ioctl+0x91/0xd0
>>>   ? do_syscall_64+0x60/0xd0
>>>   ? entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>>>   </TASK>
>>> rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: {
>>> 13-.... } 30 jiffies s: 169 root: 0x2000/.
>>> rcu: blocking rcu_node structures (internal RCU debug):
>>> Task dump for CPU 13:
>>> task:X               state:R  running task     stack:    0 pid: 4242
>>> ppid:  4228 flags:0x0000400e
>>> Call Trace:
>>>   <TASK>
>>>   ? memcpy_toio+0x76/0xc0
>>>   ? memcpy_toio+0x1b/0xc0
>>>   ? drm_fb_memcpy_toio+0x76/0xb0
>>>   ? drm_fb_blit_toio+0x75/0x2b0
>>>   ? simpledrm_simple_display_pipe_update+0x132/0x150
>>>   ? drm_atomic_helper_commit_planes+0xb6/0x230
>>>   ? drm_atomic_helper_commit_tail+0x44/0x80
>>>   ? commit_tail+0xd7/0x130
>>>   ? drm_atomic_helper_commit+0x126/0x150
>>>   ? drm_atomic_commit+0xa4/0xe0
>>>   ? drm_plane_get_damage_clips.cold+0x1c/0x1c
>>>   ? drm_atomic_helper_dirtyfb+0x19e/0x280
>>>   ? drm_mode_dirtyfb_ioctl+0x10f/0x1e0
>>>   ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>>>   ? drm_ioctl_kernel+0xc4/0x150
>>>   ? drm_ioctl+0x246/0x3f0
>>>   ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>>>   ? __x64_sys_ioctl+0x91/0xd0
>>>   ? do_syscall_64+0x60/0xd0
>>>   ? entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>>>   </TASK>
>>> rcu: INFO: rcu_sched detected expedited stalls on CPUs/tasks: {
>>> 13-.... } 52 jiffies s: 169 root: 0x2000/.
>>> rcu: blocking rcu_node structures (internal RCU debug):
>>> Task dump for CPU 13:
>>> task:X               state:R  running task     stack:    0 pid: 4242
>>> ppid:  4228 flags:0x0000400e
>>> Call Trace:
>>>   <TASK>
>>>   ? memcpy_toio+0x76/0xc0
>>>   ? memcpy_toio+0x1b/0xc0
>>>   ? drm_fb_memcpy_toio+0x76/0xb0
>>>   ? drm_fb_blit_toio+0x75/0x2b0
>>>   ? simpledrm_simple_display_pipe_update+0x132/0x150
>>>   ? drm_atomic_helper_commit_planes+0xb6/0x230
>>>   ? drm_atomic_helper_commit_tail+0x44/0x80
>>>   ? commit_tail+0xd7/0x130
>>>   ? drm_atomic_helper_commit+0x126/0x150
>>>   ? drm_atomic_commit+0xa4/0xe0
>>>   ? drm_plane_get_damage_clips.cold+0x1c/0x1c
>>>   ? drm_atomic_helper_dirtyfb+0x19e/0x280
>>>   ? drm_mode_dirtyfb_ioctl+0x10f/0x1e0
>>>   ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>>>   ? drm_ioctl_kernel+0xc4/0x150
>>>   ? drm_ioctl+0x246/0x3f0
>>>   ? drm_mode_getfb2_ioctl+0x2d0/0x2d0
>>>   ? __x64_sys_ioctl+0x91/0xd0
>>>   ? do_syscall_64+0x60/0xd0
>>>   ? entry_SYSCALL_64_after_hwframe+0x4b/0xb5
>>>   </TASK>
>>> traps: avahi-ml[4447] general protection fault ip:7fdde6a37bc1
>>> sp:7fdde07fc920 error:0 in module-zeroconf-publish.so[7fdde6a37000+3000]
>>>
>>
>> See the ticket for more details.
>>
>> BTW, let me use this mail to also add the report to the list of tracked
>> regressions to ensure it's doesn't fall through the cracks:
>>
>> #regzbot introduced: cfecfc98a78d9
>> https://bugzilla.kernel.org/show_bug.cgi?id=216616
>> #regzbot ignore-activity
>>
>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>>
>> P.S.: As the Linux kernel's regression tracker I deal with a lot of
>> reports and sometimes miss something important when writing mails like
>> this. If that's the case here, don't hesitate to tell me in a public
>> reply, it's in everyone's interest to set the public record straight.
> 
