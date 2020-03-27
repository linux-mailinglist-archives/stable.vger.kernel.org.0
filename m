Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB15F1952BC
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 09:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgC0IY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 04:24:57 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36959 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgC0IY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 04:24:56 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20200327082454euoutp01613d19ddef34f550a9bd9a65a3f7a0d4~AG6wLhwgz2624726247euoutp011
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 08:24:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20200327082454euoutp01613d19ddef34f550a9bd9a65a3f7a0d4~AG6wLhwgz2624726247euoutp011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585297494;
        bh=J6wIfr/4kBwlkH1z0bdHoWao2U/GiQ4VZWlKmem7LgQ=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ihUgwq8kmuI1oVCaEDsLheem8YuyO4nU91EbS+DEZNohl3pYTWvwxTGAnehCnmnxy
         7dc3ucPZTF3aEr0QSjSyKjPfjHYMmHy3OIARqFZUG1m0r9ueNSfLwXbzq/ACvYcYq+
         MrhDzCy+gHlU02peP5b4JPQKiPlWhHc6hYSn9BXY=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200327082454eucas1p1ad9b946d9c260dfb2cb30b69619f95d1~AG6v2THVJ2323223232eucas1p12;
        Fri, 27 Mar 2020 08:24:54 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 14.DA.60698.658BD7E5; Fri, 27
        Mar 2020 08:24:54 +0000 (GMT)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200327082453eucas1p15b2371b61f653031408f319cc6d13893~AG6vgWCsl0718307183eucas1p1G;
        Fri, 27 Mar 2020 08:24:53 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200327082453eusmtrp1fd7f6c5003efad254128d1a89166acb3~AG6vfkLuJ2754327543eusmtrp1M;
        Fri, 27 Mar 2020 08:24:53 +0000 (GMT)
X-AuditID: cbfec7f5-a0fff7000001ed1a-ed-5e7db856820c
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 7D.9A.07950.558BD7E5; Fri, 27
        Mar 2020 08:24:53 +0000 (GMT)
Received: from AMDC2765.digital.local (unknown [106.120.51.73]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200327082453eusmtip135cda0fd8cb46f35840d001191c3d9cc~AG6u3bX5P1668016680eusmtip1k;
        Fri, 27 Mar 2020 08:24:53 +0000 (GMT)
From:   Marek Szyprowski <m.szyprowski@samsung.com>
To:     dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Shane Francis <bigbeeshane@gmail.com>,
        "Michael J . Ruhl" <michael.j.ruhl@intel.com>
Subject: [PATCH] drm/prime: fix extracting of the DMA addresses from a
 scatterlist
Date:   Fri, 27 Mar 2020 09:24:46 +0100
Message-Id: <20200327082446.18480-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA0VSfSyUcRzvd889zz1OZ7+OzW+YttuyskWmtseSaeuPp1atWmMxdHi8lPNy
        D4o09GI58lJNZrKTlNdwyXuKeRm3EFkU51JaR8jrcou681D/fb6fl+/nu99+JCYuxa3I0PBo
        Rh4uDZMQQn5d11rffo+G674HcteE1N2+Hh6VM9aMUzW5VTiV3JjBo/7UZWPU+5V5ghpqyieo
        3P5WHlXZMS6gChde8qmBensqJfUpTilrJgFV+yMbdzejbw+uE/SrVSWfbswbF9BFLToerSpL
        Jej6VS1OF/ScpSfSunl0Rm0ZoF+or9FLKtszpl5C10AmLDSWkTu6XRSGaIrqQeQj2VX1dDFI
        Aj99FMCERPAgql7UCRRASIphCUAzv5Z5RkEMlwHKyvbmhCWAJrsWBdsJ3VsV4EzPAHrX5saZ
        DIHXJRu4USCgE1LMKggFEJAWMAgVY0YLBvsxpPnaZthDkubwPFJnio1uPtyDhofWNmkRPIKW
        VTyuaTcqr36zGUVQJUBpcx2AE44h7beZLWyOprtrt06zQer76XwucBOgz32VAm5IB2joRu5W
        4jAa69MTxjYM7kNVTY4cfRQVKps3j0DQDI3M7jLSmAHeq3uIcbQI3UkRc247lNf9/F9t28Ag
        xmEaPZhO4nOv44MaMpOJLGCb979LCUAZsGRiWFkwwzqHM1ccWKmMjQkPdgiIkKmA4QOpN7pX
        GkDrb/92AEkg2SlKSknwFePSWDZO1g4QiUksRFMXDJQoUBoXz8gj/OQxYQzbDqxJvsRS5PxY
        5yOGwdJo5jLDRDLybZVHmlglAS+tuYZID/RUu/izt0ZgzmhL4iHT3uGIqVPq75caP5m7WruG
        eE10avM7PItc3Bd0duVRNWIXWMd6f6jA56Lx4yVRT3ob/Crmx5dteh308efyd+y9EEBq1zMS
        NLjcHUFh/segflB6UqlP/MIWKdJOL4xOdc57bOilZicKkmslfDZE6mSPyVnpX5SGGRA8AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42I5/e/4Xd3QHbVxBoeX6lj0njvJZDHtzm5W
        i40z1rNaNO7sY7L4v20is8WVr+/ZLC7vmsNmMeP8PiaLtUfuslss/LiVxeLCdi2Lts5lrBYL
        Nj5itNjyZiKrA59H66W/bB57vy1g8dg56y67x+I9L5k8Nq3qZPPY/u0Bq8e8k4Ee97uPM3n0
        bVnF6LH5dLXH501yAdxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYp
        qTmZZalF+nYJehn3Fm9nLJibW3H61VLGBsYPsV2MnBwSAiYSL89uYuxi5OIQEljKKNEx8Ts7
        REJG4uS0BlYIW1jiz7UuNoiiT4wSb642MIEk2AQMJbregiQ4OUQEMiTaJ05lBrGZBa4zSxz/
        V9bFyMEhLBAk0b+hFiTMIqAqcfXyT3aQMK+ArcSXTUwQ4+UlVm84wDyBkWcBI8MqRpHU0uLc
        9NxiI73ixNzi0rx0veT83E2MwODfduznlh2MXe+CDzEKcDAq8fBqtNTECbEmlhVX5h5ilOBg
        VhLhfRoJFOJNSaysSi3Kjy8qzUktPsRoCrR7IrOUaHI+MDLzSuINTQ3NLSwNzY3Njc0slMR5
        OwQOxggJpCeWpGanphakFsH0MXFwSjUwTkuaz6T4N8fJrzHUWzogwvr8FfaQzjVvOFYt8c/g
        6plWprlaK93whSNHgmV+ebvS4bt8PfUTtyde+rj0krFI4NZ/08IeR9nstnmYu6OFwXXjvMnz
        GYVS27KOSO1r0zgmzvtqifX/lq83OvbNePp+GqOs7YJdL3fqrbs90WibluNcnU7VtVEzlFiK
        MxINtZiLihMBLwMrvZQCAAA=
X-CMS-MailID: 20200327082453eucas1p15b2371b61f653031408f319cc6d13893
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200327082453eucas1p15b2371b61f653031408f319cc6d13893
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200327082453eucas1p15b2371b61f653031408f319cc6d13893
References: <CGME20200327082453eucas1p15b2371b61f653031408f319cc6d13893@eucas1p1.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Scatterlist elements contains both pages and DMA addresses, but in general,
one cannot assume 1:1 relation between them. The sg->length is the size of
the physical memory chunk described by sg->page, while sg_dma_length(sg) is
the size of the DMA (IO virtual) chunk described by sg_dma_address(sg).

The proper way of extracting both: pages and DMA addresses of the whole
buffer described by a scatterlist it to iterate independently over the
sg->pages/sg->length and sg_dma_address(sg)/sg_dma_len(sg) entries.

Fixes: 42e67b479eab ("drm/prime: use dma length macro when mapping sg")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
This fixes the following kernel panic observed on ARM 32bit Samsung
Exynos5250-based Snow Chromebook since linux-next 20200326, which
introduced the commit 42e67b479eab ("drm/prime: use dma length macro when
mapping sg"):

 [drm] Initialized panfrost 1.1.0 20180908 for 11800000.gpu on minor 0
 [drm] Exynos DRM: using 14400000.fimd device for DMA mapping operations
 exynos-drm exynos-drm: bound 14400000.fimd (ops fimd_component_ops)
 exynos-drm exynos-drm: bound 14450000.mixer (ops mixer_component_ops)
 exynos-drm exynos-drm: bound 145b0000.dp-controller (ops exynos_dp_ops)
 exynos-drm exynos-drm: bound 14530000.hdmi (ops hdmi_component_ops)
 [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 12 at mm/vmalloc.c:163 vmap_page_range_noflush+0x18c/0x1b0
 Modules linked in:
 CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.6.0-rc7-next-20200326-00060-gbb3f893b3f08 #7929
 Hardware name: Samsung Exynos (Flattened Device Tree)
 Workqueue: events deferred_probe_work_func
 [<c0111f20>] (unwind_backtrace) from [<c010d128>] (show_stack+0x10/0x14)
 [<c010d128>] (show_stack) from [<c0a78178>] (dump_stack+0xa4/0xd0)
 [<c0a78178>] (dump_stack) from [<c01271a0>] (__warn+0xf4/0x10c)
 [<c01271a0>] (__warn) from [<c0127268>] (warn_slowpath_fmt+0xb0/0xb8)
 [<c0127268>] (warn_slowpath_fmt) from [<c0294fdc>] (vmap_page_range_noflush+0x18c/0x1b0)
 [<c0294fdc>] (vmap_page_range_noflush) from [<c02952fc>] (map_vm_area+0x30/0x6c)
 [<c02952fc>] (map_vm_area) from [<c0298df8>] (vmap+0x64/0x80)
 [<c0298df8>] (vmap) from [<c05f71f4>] (exynos_drm_fbdev_create+0x148/0x270)
 [<c05f71f4>] (exynos_drm_fbdev_create) from [<c05bde44>] (__drm_fb_helper_initial_config_and_unlock+0x388/0x5dc)
 [<c05bde44>] (__drm_fb_helper_initial_config_and_unlock) from [<c05f743c>] (exynos_drm_fbdev_init+0x78/0xe0)
 [<c05f743c>] (exynos_drm_fbdev_init) from [<c05f59f4>] (exynos_drm_bind+0x14c/0x19c)
 [<c05f59f4>] (exynos_drm_bind) from [<c0614784>] (try_to_bring_up_master+0x208/0x2bc)
 [<c0614784>] (try_to_bring_up_master) from [<c0614ac4>] (__component_add+0xb0/0x178)
 [<c0614ac4>] (__component_add) from [<c05fb488>] (exynos_dp_probe+0x94/0x12c)
 [<c05fb488>] (exynos_dp_probe) from [<c061e330>] (platform_drv_probe+0x48/0x9c)
 [<c061e330>] (platform_drv_probe) from [<c061badc>] (really_probe+0x1c4/0x470)
 [<c061badc>] (really_probe) from [<c061bf1c>] (driver_probe_device+0x78/0x1bc)
 [<c061bf1c>] (driver_probe_device) from [<c0619c9c>] (bus_for_each_drv+0x74/0xb8)
 [<c0619c9c>] (bus_for_each_drv) from [<c061b878>] (__device_attach+0xd4/0x16c)
 [<c061b878>] (__device_attach) from [<c061aa38>] (bus_probe_device+0x88/0x90)
 [<c061aa38>] (bus_probe_device) from [<c061af5c>] (deferred_probe_work_func+0x4c/0xd0)
 [<c061af5c>] (deferred_probe_work_func) from [<c0149f9c>] (process_one_work+0x30c/0x880)
 [<c0149f9c>] (process_one_work) from [<c014a568>] (worker_thread+0x58/0x5a4)
 [<c014a568>] (worker_thread) from [<c0151a5c>] (kthread+0x154/0x19c)
 [<c0151a5c>] (kthread) from [<c0100114>] (ret_from_fork+0x14/0x20)
 Exception stack(0xee8fdfb0 to 0xee8fdff8)
 dfa0:                                     00000000 00000000 00000000 00000000
 dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
 dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
 irq event stamp: 54037
 hardirqs last  enabled at (54055): [<c019ed50>] console_unlock+0x58c/0x6a8
 hardirqs last disabled at (54062): [<c019e890>] console_unlock+0xcc/0x6a8
 softirqs last  enabled at (54078): [<c0101724>] __do_softirq+0x4fc/0x5f4
 softirqs last disabled at (54089): [<c0130248>] irq_exit+0x16c/0x170
 ---[ end trace 74519922e0e4625d ]---
 exynos4-fb 14400000.fimd: [drm:exynos_drm_fbdev_create] *ERROR* failed to map pages to kernel space.
 exynos-drm exynos-drm: [drm:exynos_drm_fbdev_init] *ERROR* failed to set up hw configuration.
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 12 at kernel/locking/mutex-debug.c:103 mutex_destroy+0x84/0x88
 DEBUG_LOCKS_WARN_ON(mutex_is_locked(lock))
 Modules linked in:
 CPU: 0 PID: 12 Comm: kworker/0:1 Tainted: G        W         5.6.0-rc7-next-20200326-00060-gbb3f893b3f08 #7929
 Hardware name: Samsung Exynos (Flattened Device Tree)
 Workqueue: events deferred_probe_work_func
 [<c0111f20>] (unwind_backtrace) from [<c010d128>] (show_stack+0x10/0x14)
 [<c010d128>] (show_stack) from [<c0a78178>] (dump_stack+0xa4/0xd0)
 [<c0a78178>] (dump_stack) from [<c01271a0>] (__warn+0xf4/0x10c)
 [<c01271a0>] (__warn) from [<c012722c>] (warn_slowpath_fmt+0x74/0xb8)
 [<c012722c>] (warn_slowpath_fmt) from [<c01892a4>] (mutex_destroy+0x84/0x88)
 [<c01892a4>] (mutex_destroy) from [<c05be1a4>] (drm_fb_helper_fini.part.1+0x9c/0xd4)
 [<c05be1a4>] (drm_fb_helper_fini.part.1) from [<c05f7464>] (exynos_drm_fbdev_init+0xa0/0xe0)
 [<c05f7464>] (exynos_drm_fbdev_init) from [<c05f59f4>] (exynos_drm_bind+0x14c/0x19c)
 [<c05f59f4>] (exynos_drm_bind) from [<c0614784>] (try_to_bring_up_master+0x208/0x2bc)
 [<c0614784>] (try_to_bring_up_master) from [<c0614ac4>] (__component_add+0xb0/0x178)
 [<c0614ac4>] (__component_add) from [<c05fb488>] (exynos_dp_probe+0x94/0x12c)
 [<c05fb488>] (exynos_dp_probe) from [<c061e330>] (platform_drv_probe+0x48/0x9c)
 [<c061e330>] (platform_drv_probe) from [<c061badc>] (really_probe+0x1c4/0x470)
 [<c061badc>] (really_probe) from [<c061bf1c>] (driver_probe_device+0x78/0x1bc)
 [<c061bf1c>] (driver_probe_device) from [<c0619c9c>] (bus_for_each_drv+0x74/0xb8)
 [<c0619c9c>] (bus_for_each_drv) from [<c061b878>] (__device_attach+0xd4/0x16c)
 [<c061b878>] (__device_attach) from [<c061aa38>] (bus_probe_device+0x88/0x90)
 [<c061aa38>] (bus_probe_device) from [<c061af5c>] (deferred_probe_work_func+0x4c/0xd0)
 [<c061af5c>] (deferred_probe_work_func) from [<c0149f9c>] (process_one_work+0x30c/0x880)
 [<c0149f9c>] (process_one_work) from [<c014a568>] (worker_thread+0x58/0x5a4)
 [<c014a568>] (worker_thread) from [<c0151a5c>] (kthread+0x154/0x19c)
 [<c0151a5c>] (kthread) from [<c0100114>] (ret_from_fork+0x14/0x20)
 Exception stack(0xee8fdfb0 to 0xee8fdff8)
 dfa0:                                     00000000 00000000 00000000 00000000
 dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
 dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
 irq event stamp: 56283
 hardirqs last  enabled at (56283): [<c02b189c>] kfree+0x198/0x3e4
 hardirqs last disabled at (56282): [<c02b17d0>] kfree+0xcc/0x3e4
 softirqs last  enabled at (56262): [<c0101724>] __do_softirq+0x4fc/0x5f4
 softirqs last disabled at (56255): [<c0130248>] irq_exit+0x16c/0x170
 ---[ end trace 74519922e0e4625e ]---
 exynos-sysmmu 14640000.sysmmu: 14400000.fimd: PAGE FAULT occurred at 0x20000000
 ------------[ cut here ]------------
 kernel BUG at drivers/iommu/exynos-iommu.c:447!
 Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
 Modules linked in:
 CPU: 0 PID: 52 Comm: kworker/0:2 Tainted: G        W         5.6.0-rc7-next-20200326-00060-gbb3f893b3f08 #7929
 Hardware name: Samsung Exynos (Flattened Device Tree)
 Workqueue: events output_poll_execute
 PC is at exynos_sysmmu_irq+0x210/0x258
 LR is at report_iommu_fault+0x144/0x1cc
 pc : [<c05a6e34>]    lr : [<c05a13ec>]    psr: a0000193
 sp : cfafdbe8  ip : 2d495ebb  fp : 00000200
 r10: eeb187e0  r9 : 20000000  r8 : cf300000
 r7 : c11d4fb0  r6 : eeb187c0  r5 : 00000000  r4 : c0b59f74
 r3 : cfafc000  r2 : 00010001  r1 : 00000000  r0 : ffffffda
 Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment none
 Control: 10c5387d  Table: 4000406a  DAC: 00000051
 Process kworker/0:2 (pid: 52, stack limit = 0x(ptrval))
 Stack: (0xcfafdbe8 to 0xcfafe000)
 ...
 [<c05a6e34>] (exynos_sysmmu_irq) from [<c01a24f4>] (__handle_irq_event_percpu+0x68/0x42c)
 [<c01a24f4>] (__handle_irq_event_percpu) from [<c01a28e4>] (handle_irq_event_percpu+0x2c/0x7c)
 [<c01a28e4>] (handle_irq_event_percpu) from [<c01a296c>] (handle_irq_event+0x38/0x5c)
 [<c01a296c>] (handle_irq_event) from [<c01a7160>] (handle_level_irq+0xcc/0x150)
 [<c01a7160>] (handle_level_irq) from [<c01a1574>] (generic_handle_irq+0x34/0x44)
 [<c01a1574>] (generic_handle_irq) from [<c0509a5c>] (combiner_handle_cascade_irq+0x8c/0xdc)
 [<c0509a5c>] (combiner_handle_cascade_irq) from [<c01a1574>] (generic_handle_irq+0x34/0x44)
 [<c01a1574>] (generic_handle_irq) from [<c01a1bbc>] (__handle_domain_irq+0x7c/0xec)
 [<c01a1bbc>] (__handle_domain_irq) from [<c050a024>] (gic_handle_irq+0x58/0x9c)
 [<c050a024>] (gic_handle_irq) from [<c0100af0>] (__irq_svc+0x70/0xb0)
 Exception stack(0xcfafdd00 to 0xcfafdd48)
 dd00: c02b189c 00000000 2df3c000 00000000 cf2ed3c0 ee801cc0 60000113 ef1ddda0
 dd20: c05d5500 00000000 cf2c9800 cf2ea8b8 00003220 cfafdd50 c02b189c c02b18a0
 dd40: 60000113 ffffffff
 [<c0100af0>] (__irq_svc) from [<c02b18a0>] (kfree+0x19c/0x3e4)
 [<c02b18a0>] (kfree) from [<c05d5500>] (drm_atomic_state_default_clear+0x1b8/0x2dc)
 [<c05d5500>] (drm_atomic_state_default_clear) from [<c05d5650>] (__drm_atomic_state_free+0x10/0x50)
 [<c05d5650>] (__drm_atomic_state_free) from [<c05e9d88>] (drm_client_modeset_commit_atomic+0x240/0x26c)
 [<c05e9d88>] (drm_client_modeset_commit_atomic) from [<c05e9df8>] (drm_client_modeset_commit_locked+0x44/0x1d0)
 [<c05e9df8>] (drm_client_modeset_commit_locked) from [<c05e9fa8>] (drm_client_modeset_commit+0x24/0x40)
 [<c05e9fa8>] (drm_client_modeset_commit) from [<c05be3ec>] (drm_fb_helper_restore_fbdev_mode_unlocked+0x58/0xa4)
 [<c05be3ec>] (drm_fb_helper_restore_fbdev_mode_unlocked) from [<c05be468>] (drm_fb_helper_set_par+0x30/0x5c)
 [<c05be468>] (drm_fb_helper_set_par) from [<c05be538>] (drm_fb_helper_hotplug_event.part.5+0xa4/0xbc)
 [<c05be538>] (drm_fb_helper_hotplug_event.part.5) from [<c05ac148>] (drm_kms_helper_hotplug_event+0x24/0x30)
 [<c05ac148>] (drm_kms_helper_hotplug_event) from [<c05ac238>] (output_poll_execute+0xb8/0x1b4)
 [<c05ac238>] (output_poll_execute) from [<c0149f9c>] (process_one_work+0x30c/0x880)
 [<c0149f9c>] (process_one_work) from [<c014a568>] (worker_thread+0x58/0x5a4)
 [<c014a568>] (worker_thread) from [<c0151a5c>] (kthread+0x154/0x19c)
 [<c0151a5c>] (kthread) from [<c0100114>] (ret_from_fork+0x14/0x20)
 Exception stack(0xcfafdfb0 to 0xcfafdff8)
 dfa0:                                     00000000 00000000 00000000 00000000
 dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
 dfe0: 00000000 00000000 00000000 00000000 00000013 00000000
 Code: e34c00de e300119e ebee00e1 eaffff81 (e7f001f2) 
 ---[ end trace 74519922e0e4625f ]---
 Kernel panic - not syncing: Fatal exception in interrupt
 CPU1: stopping
 CPU: 1 PID: 0 Comm: swapper/1 Tainted: G      D W         5.6.0-rc7-next-20200326-00060-gbb3f893b3f08 #7929
 Hardware name: Samsung Exynos (Flattened Device Tree)
 [<c0111f20>] (unwind_backtrace) from [<c010d128>] (show_stack+0x10/0x14)
 [<c010d128>] (show_stack) from [<c0a78178>] (dump_stack+0xa4/0xd0)
 [<c0a78178>] (dump_stack) from [<c0110ad4>] (handle_IPI+0x3b4/0x440)
 [<c0110ad4>] (handle_IPI) from [<c050a064>] (gic_handle_irq+0x98/0x9c)
 [<c050a064>] (gic_handle_irq) from [<c0100af0>] (__irq_svc+0x70/0xb0)
 Exception stack(0xee8fff58 to 0xee8fffa0)
 ff40:                                                       c0109534 00000000
 ff60: 2df50000 00000000 ee8fe000 c1108ee8 c1108f2c 00000002 00000000 c0de63c0
 ff80: 00000000 c1075fe8 2d495ebb ee8fffa8 c0109534 c0109538 60000013 ffffffff
 [<c0100af0>] (__irq_svc) from [<c0109538>] (arch_cpu_idle+0x24/0x44)
 [<c0109538>] (arch_cpu_idle) from [<c0163a74>] (do_idle+0x1d8/0x2d4)
 [<c0163a74>] (do_idle) from [<c0163f24>] (cpu_startup_entry+0x18/0x1c)
 [<c0163f24>] (cpu_startup_entry) from [<401018ac>] (0x401018ac)
 ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
---
 drivers/gpu/drm/drm_prime.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 1de2cde2277c..424db18987f6 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -962,27 +962,33 @@ int drm_prime_sg_to_page_addr_arrays(struct sg_table *sgt, struct page **pages,
 	unsigned count;
 	struct scatterlist *sg;
 	struct page *page;
-	u32 len, index;
+	u32 page_len, page_index;
 	dma_addr_t addr;
+	u32 dma_len, dma_index;
 
-	index = 0;
+	page_index = 0;
+	dma_index = 0;
 	for_each_sg(sgt->sgl, sg, sgt->nents, count) {
-		len = sg_dma_len(sg);
+		page_len = sg->length;
 		page = sg_page(sg);
+		dma_len = sg_dma_len(sg);
 		addr = sg_dma_address(sg);
 
-		while (len > 0) {
-			if (WARN_ON(index >= max_entries))
+		while (pages && page_len > 0) {
+			if (WARN_ON(page_index >= max_entries))
 				return -1;
-			if (pages)
-				pages[index] = page;
-			if (addrs)
-				addrs[index] = addr;
-
+			pages[page_index] = page;
 			page++;
+			page_len -= PAGE_SIZE;
+			page_index++;
+		}
+		while (addrs && dma_len > 0) {
+			if (WARN_ON(dma_index >= max_entries))
+				return -1;
+			addrs[dma_index] = addr;
 			addr += PAGE_SIZE;
-			len -= PAGE_SIZE;
-			index++;
+			dma_len -= PAGE_SIZE;
+			dma_index++;
 		}
 	}
 	return 0;
-- 
2.17.1

