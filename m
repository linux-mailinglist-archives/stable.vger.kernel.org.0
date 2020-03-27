Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B8219537C
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 10:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgC0JAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 05:00:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:48873 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgC0JAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 05:00:39 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200327090037euoutp0149c84db7fff8a41dfe00aac113ba1c45~AHZ76Q8kQ2514225142euoutp01F
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 09:00:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200327090037euoutp0149c84db7fff8a41dfe00aac113ba1c45~AHZ76Q8kQ2514225142euoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585299637;
        bh=yW8zlFd5Z8He80Wk0ArTK5SezzIo2NOBo7faH5B3LC0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=B3dbnRGU26ahk492PvBAlisfGkz/CpNMEBYx07v0ANU9yOz97EXnzLQu7nTBJe9kK
         OLsSIjVnPRVCqW6mFh0RmF3ZVhSZD5N6fUGQwTaQqsdejinaNl+vHMR6ndZI5LdfC+
         4h7rZrMnG9/1etG5hh6heWEM25+sLGIHS7x/riiU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200327090037eucas1p21bbc0fc2553f342be4360f5963fe4f4c~AHZ7j2gy10584005840eucas1p2g;
        Fri, 27 Mar 2020 09:00:37 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 99.40.60698.5B0CD7E5; Fri, 27
        Mar 2020 09:00:37 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200327090036eucas1p256abec74ef196f71853b7bc3632c3f2f~AHZ7G2A1f0584005840eucas1p2f;
        Fri, 27 Mar 2020 09:00:36 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200327090036eusmtrp27e38c227b5698427acce50fe1459918f~AHZ7GA_PH0786907869eusmtrp2K;
        Fri, 27 Mar 2020 09:00:36 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-91-5e7dc0b5d57c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 19.AF.08375.4B0CD7E5; Fri, 27
        Mar 2020 09:00:36 +0000 (GMT)
Received: from [106.210.88.143] (unknown [106.210.88.143]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200327090035eusmtip19ea3d204c0a41d15c7f909f1d32835df~AHZ6K_8M41250812508eusmtip13;
        Fri, 27 Mar 2020 09:00:35 +0000 (GMT)
Subject: Re: [PATCH] drm/prime: fix extracting of the DMA addresses from a
 scatterlist
To:     Shane Francis <bigbeeshane@gmail.com>
Cc:     Maling list - DRI developers <dri-devel@lists.freedesktop.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <64025801-10f0-9f28-17b2-2c04d4308ac5@samsung.com>
Date:   Fri, 27 Mar 2020 10:00:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
        Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CABnpCuDySf89HL2AksMB2fOcVCci+1zgB9r8zjRdpCAH3GWhPA@mail.gmail.com>
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTcRjG+e+cM4/axnFavphaji44UhOjThRSEHSCIP0iFaWtPExTp27O
        sgxmkbVp5kxKp+UszFiaaOq8U4qKaN6hi5bLa1YW4aW7y+1k+e33Pu/1gZfERGOEGxkpT2AV
        cmm0mO+AV7d97/GpenIhdKu5B6OvdXfw6JvD9QRdnlNG0Cm1GTzaUq3D6MH5z3x6oC6fT+f0
        NPHowi9VON1rktCpmvsEbSgfRXTlRx2xR8Bc7v/NZxoXDDhTq39tx9xrmOYxFUYNnzEtmAnm
        TkcwM5LWzmMyKo2Iedx5npmt8AxyPOqwO5yNjkxkFX6BJxwi1INdWNzD5LOfWmdxNSoO1yJ7
        Eqht8LVlCNciB1JEPUDwMt3I44I5BIVtmRgXzCIwm4uJ5RZLVwnBJYoR5OkuYtaEiPqMYGrI
        y8rO1GEYy9PxrOxCecPgGzVuZYxaxKBoOszKfMoftDNavhaRpIAKBFPJIauMUxvB2GW0ta6m
        jkFfy3XbXgHlBB2547Yx9lQwpDfcRNzIdWCaycc4doVX4wU2B0BpSNCafv09eh/8zh7BOXaG
        9+2Vdhy7g6V2ueESgrfdpXZckI5g4GIO4qp2wXD3D9ul2JKbsjo/Tt4LhYZ6O6sMlBBezDhx
        Rwghq/oWxskCuJoq4qo3gb790b+1T3v7sUwk1q+wpl9hR7/Cjv7/XgPCjciVVSljZKwyQM6e
        8VVKY5Qqucz3VGxMBVp6vc7F9vka1PTrZDOiSCReJVCnJoeKCGmiMimmGQGJiV0EE0eWJEG4
        NOkcq4gNU6iiWWUzWkviYldBwN3p4yJKJk1go1g2jlUsZ3mkvZsaxQvLd4ynHHTzONS1mFKk
        fr7e8/wO76xLG+beqRpv964xy3f6WLa0JvFxWfF8VOmMthCPfDbhPjlBrs2na4IkcpHhxk/F
        0IEQGAzXE19OZ4pHvRJC4iu+FeADHWmOemGyz6TOU0O6TO3P/iCMbwj1mK6KlW3un8zbfuVn
        rqTPXYwrI6T+EkyhlP4BphP8bHYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t/xu7pbDtTGGczaKWfRe+4kk8W0O7tZ
        LTbOWM9q0bizj8ni/7aJzBZXvr5ns7i8aw6bxYzz+5gsFn7cymJxYbuWRVvnMlaLBRsfMVps
        eTOR1YHXo/XSXzaPvd8WsHjsnHWX3WPxnpdMHptWdbJ5bP/2gNVj3slAj/vdx5k8+rasYvTY
        fLra4/MmuQDuKD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81grI1MlfTublNSczLLU
        In27BL2MhitnmAtW11S8O/qZpYFxeUoXIyeHhICJxP8za1hBbCGBpYwSE/+FQsRlJE5Oa2CF
        sIUl/lzrYuti5AKqecso8X7qazaQhLBAhMTj2ROZQGwRAU2JK/caWECKmAUaWCTW9R5mgui4
        wSgx6e8ksFFsAoYSXW9BRnFw8ArYSWxf4w8SZhFQlVh1ZhXYIFGBGImfe7pYQGxeAUGJkzOf
        gNmcAoESPXumMYLYzAJmEvM2P2SGsOUltr+dA2WLS9x6Mp9pAqPQLCTts5C0zELSMgtJywJG
        llWMIqmlxbnpucWGesWJucWleel6yfm5mxiBcb7t2M/NOxgvbQw+xCjAwajEw6vRUhMnxJpY
        VlyZe4hRgoNZSYT3aSRQiDclsbIqtSg/vqg0J7X4EKMp0HMTmaVEk/OBKSivJN7Q1NDcwtLQ
        3Njc2MxCSZy3Q+BgjJBAemJJanZqakFqEUwfEwenVANjXtvEFYkXpjiek3UvZEi9PXsv549v
        a1dnKmxQrQy9qntkMt+aN5bHm6zEmVYXqf93m6Vs3MJ8bJWvmGjzNs+2Kx1x+8+f5jU7u+Df
        i6/GPkscXmZLSzk+Ck5xuabjvNebN2+vZ80u1tkTdp/QOxbAHusvzNHyzUW9XmmP2sQP0jxJ
        R2RLYx8qsRRnJBpqMRcVJwIArxwFwgkDAAA=
X-CMS-MailID: 20200327090036eucas1p256abec74ef196f71853b7bc3632c3f2f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200327082453eucas1p15b2371b61f653031408f319cc6d13893
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200327082453eucas1p15b2371b61f653031408f319cc6d13893
References: <CGME20200327082453eucas1p15b2371b61f653031408f319cc6d13893@eucas1p1.samsung.com>
        <20200327082446.18480-1-m.szyprowski@samsung.com>
        <CABnpCuDySf89HL2AksMB2fOcVCci+1zgB9r8zjRdpCAH3GWhPA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shane

On 2020-03-27 09:55, Shane Francis wrote:
> On Fri, Mar 27, 2020 at 8:24 AM Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> Scatterlist elements contains both pages and DMA addresses, but in general,
>> one cannot assume 1:1 relation between them. The sg->length is the size of
>> the physical memory chunk described by sg->page, while sg_dma_length(sg) is
>> the size of the DMA (IO virtual) chunk described by sg_dma_address(sg).
>>
>> The proper way of extracting both: pages and DMA addresses of the whole
>> buffer described by a scatterlist it to iterate independently over the
>> sg->pages/sg->length and sg_dma_address(sg)/sg_dma_len(sg) entries.
>>
>> Fixes: 42e67b479eab ("drm/prime: use dma length macro when mapping sg")
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>> This fixes the following kernel panic observed on ARM 32bit Samsung
>> Exynos5250-based Snow Chromebook since linux-next 20200326, which
>> introduced the commit 42e67b479eab ("drm/prime: use dma length macro when
>> mapping sg"):
>>
>>   [drm] Initialized panfrost 1.1.0 20180908 for 11800000.gpu on minor 0
>>   [drm] Exynos DRM: using 14400000.fimd device for DMA mapping operations
>>   exynos-drm exynos-drm: bound 14400000.fimd (ops fimd_component_ops)
>>   exynos-drm exynos-drm: bound 14450000.mixer (ops mixer_component_ops)
>>   exynos-drm exynos-drm: bound 145b0000.dp-controller (ops exynos_dp_ops)
>>   exynos-drm exynos-drm: bound 14530000.hdmi (ops hdmi_component_ops)
>>   [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
>>   ------------[ cut here ]------------
>>   WARNING: CPU: 0 PID: 12 at mm/vmalloc.c:163 vmap_page_range_noflush+0x18c/0x1b0
>>   Modules linked in:
>>   CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.6.0-rc7-next-20200326-00060-gbb3f893b3f08 #7929
>>   Hardware name: Samsung Exynos (Flattened Device Tree)
>>   Workqueue: events deferred_probe_work_func
>>   [<c0111f20>] (unwind_backtrace) from [<c010d128>] (show_stack+0x10/0x14)
>>   [<c010d128>] (show_stack) from [<c0a78178>] (dump_stack+0xa4/0xd0)
>>   [<c0a78178>] (dump_stack) from [<c01271a0>] (__warn+0xf4/0x10c)
>>   [<c01271a0>] (__warn) from [<c0127268>] (warn_slowpath_fmt+0xb0/0xb8)
>>   [<c0127268>] (warn_slowpath_fmt) from [<c0294fdc>] (vmap_page_range_noflush+0x18c/0x1b0)
>>   [<c0294fdc>] (vmap_page_range_noflush) from [<c02952fc>] (map_vm_area+0x30/0x6c)
>>   [<c02952fc>] (map_vm_area) from [<c0298df8>] (vmap+0x64/0x80)
>>   [<c0298df8>] (vmap) from [<c05f71f4>] (exynos_drm_fbdev_create+0x148/0x270)
>>   [<c05f71f4>] (exynos_drm_fbdev_create) from [<c05bde44>] (__drm_fb_helper_initial_config_and_unlock+0x388/0x5dc)
>>   [<c05bde44>] (__drm_fb_helper_initial_config_and_unlock) from [<c05f743c>] (exynos_drm_fbdev_init+0x78/0xe0)
>>   [<c05f743c>] (exynos_drm_fbdev_init) from [<c05f59f4>] (exynos_drm_bind+0x14c/0x19c)
>>   [<c05f59f4>] (exynos_drm_bind) from [<c0614784>] (try_to_bring_up_master+0x208/0x2bc)
>>   [<c0614784>] (try_to_bring_up_master) from [<c0614ac4>] (__component_add+0xb0/0x178)
>>   [<c0614ac4>] (__component_add) from [<c05fb488>] (exynos_dp_probe+0x94/0x12c)
>>   [<c05fb488>] (exynos_dp_probe) from [<c061e330>] (platform_drv_probe+0x48/0x9c)
>>   [<c061e330>] (platform_drv_probe) from [<c061badc>] (really_probe+0x1c4/0x470)
>>   [<c061badc>] (really_probe) from [<c061bf1c>] (driver_probe_device+0x78/0x1bc)
>>   [<c061bf1c>] (driver_probe_device) from [<c0619c9c>] (bus_for_each_drv+0x74/0xb8)
>>   [<c0619c9c>] (bus_for_each_drv) from [<c061b878>] (__device_attach+0xd4/0x16c)
>>   [<c061b878>] (__device_attach) from [<c061aa38>] (bus_probe_device+0x88/0x90)
>>   [<c061aa38>] (bus_probe_device) from [<c061af5c>] (deferred_probe_work_func+0x4c/0xd0)
>>   [<c061af5c>] (deferred_probe_work_func) from [<c0149f9c>] (process_one_work+0x30c/0x880)
>>   [<c0149f9c>] (process_one_work) from [<c014a568>] (worker_thread+0x58/0x5a4)
>>   [<c014a568>] (worker_thread) from [<c0151a5c>] (kthread+0x154/0x19c)
>>   [<c0151a5c>] (kthread) from [<c0100114>] (ret_from_fork+0x14/0x20)
>>   Exception stack(0xee8fdfb0 to 0xee8fdff8)
>>   dfa0:                                     00000000 00000000 00000000 00000000
>>   dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>>   dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
>>   irq event stamp: 54037
>>   hardirqs last  enabled at (54055): [<c019ed50>] console_unlock+0x58c/0x6a8
>>   hardirqs last disabled at (54062): [<c019e890>] console_unlock+0xcc/0x6a8
>>   softirqs last  enabled at (54078): [<c0101724>] __do_softirq+0x4fc/0x5f4
>>   softirqs last disabled at (54089): [<c0130248>] irq_exit+0x16c/0x170
>>   ---[ end trace 74519922e0e4625d ]---
>>   exynos4-fb 14400000.fimd: [drm:exynos_drm_fbdev_create] *ERROR* failed to map pages to kernel space.
>>   exynos-drm exynos-drm: [drm:exynos_drm_fbdev_init] *ERROR* failed to set up hw configuration.
>>   ------------[ cut here ]------------
>>   WARNING: CPU: 0 PID: 12 at kernel/locking/mutex-debug.c:103 mutex_destroy+0x84/0x88
>>   DEBUG_LOCKS_WARN_ON(mutex_is_locked(lock))
>>   Modules linked in:
>>   CPU: 0 PID: 12 Comm: kworker/0:1 Tainted: G        W         5.6.0-rc7-next-20200326-00060-gbb3f893b3f08 #7929
>>   Hardware name: Samsung Exynos (Flattened Device Tree)
>>   Workqueue: events deferred_probe_work_func
>>   [<c0111f20>] (unwind_backtrace) from [<c010d128>] (show_stack+0x10/0x14)
>>   [<c010d128>] (show_stack) from [<c0a78178>] (dump_stack+0xa4/0xd0)
>>   [<c0a78178>] (dump_stack) from [<c01271a0>] (__warn+0xf4/0x10c)
>>   [<c01271a0>] (__warn) from [<c012722c>] (warn_slowpath_fmt+0x74/0xb8)
>>   [<c012722c>] (warn_slowpath_fmt) from [<c01892a4>] (mutex_destroy+0x84/0x88)
>>   [<c01892a4>] (mutex_destroy) from [<c05be1a4>] (drm_fb_helper_fini.part.1+0x9c/0xd4)
>>   [<c05be1a4>] (drm_fb_helper_fini.part.1) from [<c05f7464>] (exynos_drm_fbdev_init+0xa0/0xe0)
>>   [<c05f7464>] (exynos_drm_fbdev_init) from [<c05f59f4>] (exynos_drm_bind+0x14c/0x19c)
>>   [<c05f59f4>] (exynos_drm_bind) from [<c0614784>] (try_to_bring_up_master+0x208/0x2bc)
>>   [<c0614784>] (try_to_bring_up_master) from [<c0614ac4>] (__component_add+0xb0/0x178)
>>   [<c0614ac4>] (__component_add) from [<c05fb488>] (exynos_dp_probe+0x94/0x12c)
>>   [<c05fb488>] (exynos_dp_probe) from [<c061e330>] (platform_drv_probe+0x48/0x9c)
>>   [<c061e330>] (platform_drv_probe) from [<c061badc>] (really_probe+0x1c4/0x470)
>>   [<c061badc>] (really_probe) from [<c061bf1c>] (driver_probe_device+0x78/0x1bc)
>>   [<c061bf1c>] (driver_probe_device) from [<c0619c9c>] (bus_for_each_drv+0x74/0xb8)
>>   [<c0619c9c>] (bus_for_each_drv) from [<c061b878>] (__device_attach+0xd4/0x16c)
>>   [<c061b878>] (__device_attach) from [<c061aa38>] (bus_probe_device+0x88/0x90)
>>   [<c061aa38>] (bus_probe_device) from [<c061af5c>] (deferred_probe_work_func+0x4c/0xd0)
>>   [<c061af5c>] (deferred_probe_work_func) from [<c0149f9c>] (process_one_work+0x30c/0x880)
>>   [<c0149f9c>] (process_one_work) from [<c014a568>] (worker_thread+0x58/0x5a4)
>>   [<c014a568>] (worker_thread) from [<c0151a5c>] (kthread+0x154/0x19c)
>>   [<c0151a5c>] (kthread) from [<c0100114>] (ret_from_fork+0x14/0x20)
>>   Exception stack(0xee8fdfb0 to 0xee8fdff8)
>>   dfa0:                                     00000000 00000000 00000000 00000000
>>   dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>>   dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
>>   irq event stamp: 56283
>>   hardirqs last  enabled at (56283): [<c02b189c>] kfree+0x198/0x3e4
>>   hardirqs last disabled at (56282): [<c02b17d0>] kfree+0xcc/0x3e4
>>   softirqs last  enabled at (56262): [<c0101724>] __do_softirq+0x4fc/0x5f4
>>   softirqs last disabled at (56255): [<c0130248>] irq_exit+0x16c/0x170
>>   ---[ end trace 74519922e0e4625e ]---
>>   exynos-sysmmu 14640000.sysmmu: 14400000.fimd: PAGE FAULT occurred at 0x20000000
>>   ------------[ cut here ]------------
>>   kernel BUG at drivers/iommu/exynos-iommu.c:447!
>>   Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
>>   Modules linked in:
>>   CPU: 0 PID: 52 Comm: kworker/0:2 Tainted: G        W         5.6.0-rc7-next-20200326-00060-gbb3f893b3f08 #7929
>>   Hardware name: Samsung Exynos (Flattened Device Tree)
>>   Workqueue: events output_poll_execute
>>   PC is at exynos_sysmmu_irq+0x210/0x258
>>   LR is at report_iommu_fault+0x144/0x1cc
>>   pc : [<c05a6e34>]    lr : [<c05a13ec>]    psr: a0000193
>>   sp : cfafdbe8  ip : 2d495ebb  fp : 00000200
>>   r10: eeb187e0  r9 : 20000000  r8 : cf300000
>>   r7 : c11d4fb0  r6 : eeb187c0  r5 : 00000000  r4 : c0b59f74
>>   r3 : cfafc000  r2 : 00010001  r1 : 00000000  r0 : ffffffda
>>   Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
>>   Control: 10c5387d  Table: 4000406a  DAC: 00000051
>>   Process kworker/0:2 (pid: 52, stack limit = 0x(ptrval))
>>   Stack: (0xcfafdbe8 to 0xcfafe000)
>>   ...
>>   [<c05a6e34>] (exynos_sysmmu_irq) from [<c01a24f4>] (__handle_irq_event_percpu+0x68/0x42c)
>>   [<c01a24f4>] (__handle_irq_event_percpu) from [<c01a28e4>] (handle_irq_event_percpu+0x2c/0x7c)
>>   [<c01a28e4>] (handle_irq_event_percpu) from [<c01a296c>] (handle_irq_event+0x38/0x5c)
>>   [<c01a296c>] (handle_irq_event) from [<c01a7160>] (handle_level_irq+0xcc/0x150)
>>   [<c01a7160>] (handle_level_irq) from [<c01a1574>] (generic_handle_irq+0x34/0x44)
>>   [<c01a1574>] (generic_handle_irq) from [<c0509a5c>] (combiner_handle_cascade_irq+0x8c/0xdc)
>>   [<c0509a5c>] (combiner_handle_cascade_irq) from [<c01a1574>] (generic_handle_irq+0x34/0x44)
>>   [<c01a1574>] (generic_handle_irq) from [<c01a1bbc>] (__handle_domain_irq+0x7c/0xec)
>>   [<c01a1bbc>] (__handle_domain_irq) from [<c050a024>] (gic_handle_irq+0x58/0x9c)
>>   [<c050a024>] (gic_handle_irq) from [<c0100af0>] (__irq_svc+0x70/0xb0)
>>   Exception stack(0xcfafdd00 to 0xcfafdd48)
>>   dd00: c02b189c 00000000 2df3c000 00000000 cf2ed3c0 ee801cc0 60000113 ef1ddda0
>>   dd20: c05d5500 00000000 cf2c9800 cf2ea8b8 00003220 cfafdd50 c02b189c c02b18a0
>>   dd40: 60000113 ffffffff
>>   [<c0100af0>] (__irq_svc) from [<c02b18a0>] (kfree+0x19c/0x3e4)
>>   [<c02b18a0>] (kfree) from [<c05d5500>] (drm_atomic_state_default_clear+0x1b8/0x2dc)
>>   [<c05d5500>] (drm_atomic_state_default_clear) from [<c05d5650>] (__drm_atomic_state_free+0x10/0x50)
>>   [<c05d5650>] (__drm_atomic_state_free) from [<c05e9d88>] (drm_client_modeset_commit_atomic+0x240/0x26c)
>>   [<c05e9d88>] (drm_client_modeset_commit_atomic) from [<c05e9df8>] (drm_client_modeset_commit_locked+0x44/0x1d0)
>>   [<c05e9df8>] (drm_client_modeset_commit_locked) from [<c05e9fa8>] (drm_client_modeset_commit+0x24/0x40)
>>   [<c05e9fa8>] (drm_client_modeset_commit) from [<c05be3ec>] (drm_fb_helper_restore_fbdev_mode_unlocked+0x58/0xa4)
>>   [<c05be3ec>] (drm_fb_helper_restore_fbdev_mode_unlocked) from [<c05be468>] (drm_fb_helper_set_par+0x30/0x5c)
>>   [<c05be468>] (drm_fb_helper_set_par) from [<c05be538>] (drm_fb_helper_hotplug_event.part.5+0xa4/0xbc)
>>   [<c05be538>] (drm_fb_helper_hotplug_event.part.5) from [<c05ac148>] (drm_kms_helper_hotplug_event+0x24/0x30)
>>   [<c05ac148>] (drm_kms_helper_hotplug_event) from [<c05ac238>] (output_poll_execute+0xb8/0x1b4)
>>   [<c05ac238>] (output_poll_execute) from [<c0149f9c>] (process_one_work+0x30c/0x880)
>>   [<c0149f9c>] (process_one_work) from [<c014a568>] (worker_thread+0x58/0x5a4)
>>   [<c014a568>] (worker_thread) from [<c0151a5c>] (kthread+0x154/0x19c)
>>   [<c0151a5c>] (kthread) from [<c0100114>] (ret_from_fork+0x14/0x20)
>>   Exception stack(0xcfafdfb0 to 0xcfafdff8)
>>   dfa0:                                     00000000 00000000 00000000 00000000
>>   dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
>>   dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
>>   Code: e34c00de e300119e ebee00e1 eaffff81 (e7f001f2)
>>   ---[ end trace 74519922e0e4625f ]---
>>   Kernel panic - not syncing: Fatal exception in interrupt
>>   CPU1: stopping
>>   CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D W         5.6.0-rc7-next-20200326-00060-gbb3f893b3f08 #7929
>>   Hardware name: Samsung Exynos (Flattened Device Tree)
>>   [<c0111f20>] (unwind_backtrace) from [<c010d128>] (show_stack+0x10/0x14)
>>   [<c010d128>] (show_stack) from [<c0a78178>] (dump_stack+0xa4/0xd0)
>>   [<c0a78178>] (dump_stack) from [<c0110ad4>] (handle_IPI+0x3b4/0x440)
>>   [<c0110ad4>] (handle_IPI) from [<c050a064>] (gic_handle_irq+0x98/0x9c)
>>   [<c050a064>] (gic_handle_irq) from [<c0100af0>] (__irq_svc+0x70/0xb0)
>>   Exception stack(0xee8fff58 to 0xee8fffa0)
>>   ff40:                                                       c0109534 00000000
>>   ff60: 2df50000 00000000 ee8fe000 c1108ee8 c1108f2c 00000002 00000000 c0de63c0
>>   ff80: 00000000 c1075fe8 2d495ebb ee8fffa8 c0109534 c0109538 60000013 ffffffff
>>   [<c0100af0>] (__irq_svc) from [<c0109538>] (arch_cpu_idle+0x24/0x44)
>>   [<c0109538>] (arch_cpu_idle) from [<c0163a74>] (do_idle+0x1d8/0x2d4)
>>   [<c0163a74>] (do_idle) from [<c0163f24>] (cpu_startup_entry+0x18/0x1c)
>>   [<c0163f24>] (cpu_startup_entry) from [<401018ac>] (0x401018ac)
>>   ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
>> ---
>>   drivers/gpu/drm/drm_prime.c | 30 ++++++++++++++++++------------
>>   1 file changed, 18 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
>> index 1de2cde2277c..424db18987f6 100644
>> --- a/drivers/gpu/drm/drm_prime.c
>> +++ b/drivers/gpu/drm/drm_prime.c
>> @@ -962,27 +962,33 @@ int drm_prime_sg_to_page_addr_arrays(struct sg_table *sgt, struct page **pages,
>>          unsigned count;
>>          struct scatterlist *sg;
>>          struct page *page;
>> -       u32 len, index;
>> +       u32 page_len, page_index;
>>          dma_addr_t addr;
>> +       u32 dma_len, dma_index;
>>
>> -       index = 0;
>> +       page_index = 0;
>> +       dma_index = 0;
>>          for_each_sg(sgt->sgl, sg, sgt->nents, count) {
>> -               len = sg_dma_len(sg);
>> +               page_len = sg->length;
>>                  page = sg_page(sg);
>> +               dma_len = sg_dma_len(sg);
>>                  addr = sg_dma_address(sg);
>>
>> -               while (len > 0) {
>> -                       if (WARN_ON(index >= max_entries))
>> +               while (pages && page_len > 0) {
>> +                       if (WARN_ON(page_index >= max_entries))
>>                                  return -1;
>> -                       if (pages)
>> -                               pages[index] = page;
>> -                       if (addrs)
>> -                               addrs[index] = addr;
>> -
>> +                       pages[page_index] = page;
>>                          page++;
>> +                       page_len -= PAGE_SIZE;
>> +                       page_index++;
>> +               }
>> +               while (addrs && dma_len > 0) {
>> +                       if (WARN_ON(dma_index >= max_entries))
>> +                               return -1;
>> +                       addrs[dma_index] = addr;
>>                          addr += PAGE_SIZE;
>> -                       len -= PAGE_SIZE;
>> -                       index++;
>> +                       dma_len -= PAGE_SIZE;
>> +                       dma_index++;
>>                  }
>>          }
>>          return 0;
>> --
>> 2.17.1
>>
> I have tested the above patch against my original issues with amdgpu
> and radeon drivers and everything is still working as expected.
>
> Sorry I missed this in my original patches.

No problem. Thanks for testing!

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

