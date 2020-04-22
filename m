Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15EB1B4E4E
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 22:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgDVUYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 16:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbgDVUYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 16:24:20 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F237C03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 13:24:19 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y4so3806568ljn.7
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 13:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BbFm9byYE2NwbVu8KskTAKTAW/3KtzJYnbkby/wkcN4=;
        b=bwNMSlbkxkDYUv6LqF+LHWwF9IpMkDW6+j8lQ3RAV9NP01NBkQIc7R3as7XVhD1C2u
         0uKgL9sRn/rvy9dEaO6ioViwIkjP1TkL+3Vxg/4zhIP+gOIbcKonkX5gK7G9i7B/qsmY
         P/suw0fqZq+uchgqQ7TfY7ocvMjXeXUDyyiMOZRze0iR2XYNmpAimFUSm6xiWofgbxfJ
         9ZmSC5lSfkZ2p3ADGwzAzUbXepm7kzyOGyvnPDI+uTg3auvMTGLxKtJDFxO4zE3RdVse
         RI+evztHwPQ8lag9WwPMxtyvlrr5+8i747HmhfwguC02aR1p88yTX+TkoI19pP4sXJxc
         eTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BbFm9byYE2NwbVu8KskTAKTAW/3KtzJYnbkby/wkcN4=;
        b=nZ8JOtiBGvMsXOgfP1Tghfoazm+9vkYuNdBcfXhgDQRBMdYVWjPWoXiDbkbC/hRUFv
         Iqe2D1hi1N9OVksuz8jaFz3sWDg5wp9IBRKOCJIiNfvAQnajLabuCoJKhbYz0c5+X+9J
         z6AcR2FjF0KmHy2rH92sG2j1CqgDe2jOX32HyExQJDJWbWV9L1cdBDbuEILNvEFCETMg
         atM3tTuMWX6Pv4EMmzQSRX7JbH+3StnhxyxBpF8dkJYjUHsUxwWmUfVl/fgzoQwQCf/C
         ZyYMxNrg6m2kzMHYcC3P+zSiyG+8vkA6LxuY6DgQMkKXV7LrWq3jE/LzHsMGZ2wR+HxF
         Qd5Q==
X-Gm-Message-State: AGi0PubNdZbmtW+F/A//js4inVG61q+B6wjIk0GfbiLiR1qSm6lNjhHv
        gAjemkl09fQQ8pq9nvQV2OOuZwOaTNIqmv8ypA8M+Q==
X-Google-Smtp-Source: APiQypJIdSGo1LKOsh++j2RcuXvYXQA9WKLJSv1NJWcNPZ2nDCOUr0V3G6x4nc7BtZ54l8n/6noZx7ZQ/bAGZ0Bw1HU=
X-Received: by 2002:a2e:9018:: with SMTP id h24mr316478ljg.217.1587587056642;
 Wed, 22 Apr 2020 13:24:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200411115508.284500414@linuxfoundation.org> <20200411115513.709554942@linuxfoundation.org>
 <OSAPR01MB366788E02572D95F246D6DEC92DD0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
 <20200413082137.GB2792388@kroah.com>
In-Reply-To: <20200413082137.GB2792388@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 23 Apr 2020 01:54:04 +0530
Message-ID: <CA+G9fYsq5uADdbUG9RnVYOpmbGX+uEVRC-R6wfPCNtCgTyrj8w@mail.gmail.com>
Subject: Re: [PATCH 4.19 50/54] drm/msm: stop abusing dma_map/unmap for cache
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     nobuhiro1.iwamatsu@toshiba.co.jp,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Stephen Boyd <sboyd@kernel.org>, swboyd@chromium.org,
        jcrouse@codeaurora.org, Rob Clark <robdclark@chromium.org>,
        seanpaul@chromium.org, Lee Jones <lee.jones@linaro.org>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 13 Apr 2020 at 13:56, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Apr 13, 2020 at 05:03:26AM +0000, nobuhiro1.iwamatsu@toshiba.co.j=
p wrote:
> > Hi,
> >
> > > -----Original Message-----
> > > From: stable-owner@vger.kernel.org [mailto:stable-owner@vger.kernel.o=
rg] On Behalf Of Greg Kroah-Hartman
> > > Sent: Saturday, April 11, 2020 9:10 PM
> > > To: linux-kernel@vger.kernel.org
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; stable@vger.kern=
el.org; Stephen Boyd <sboyd@kernel.org>; Stephen
> > > Boyd <swboyd@chromium.org>; Jordan Crouse <jcrouse@codeaurora.org>; R=
ob Clark <robdclark@chromium.org>; Sean Paul
> > > <seanpaul@chromium.org>; Lee Jones <lee.jones@linaro.org>
> > > Subject: [PATCH 4.19 50/54] drm/msm: stop abusing dma_map/unmap for c=
ache
> > >
> > > From: Rob Clark <robdclark@chromium.org>
> > >
> > > commit 0036bc73ccbe7e600a3468bf8e8879b122252274 upstream.
> > >
> > > Recently splats like this started showing up:
> > >
> > >    WARNING: CPU: 4 PID: 251 at drivers/iommu/dma-iommu.c:451 __iommu_=
dma_unmap+0xb8/0xc0
> > >    Modules linked in: ath10k_snoc ath10k_core fuse msm ath mac80211 u=
vcvideo cfg80211 videobuf2_vmalloc videobuf2_memops
> > > vide
> > >    CPU: 4 PID: 251 Comm: kworker/u16:4 Tainted: G        W         5.=
2.0-rc5-next-20190619+ #2317
> > >    Hardware name: LENOVO 81JL/LNVNB161216, BIOS 9UCN23WW(V1.06) 10/25=
/2018
> > >    Workqueue: msm msm_gem_free_work [msm]
> > >    pstate: 80c00005 (Nzcv daif +PAN +UAO)
> > >    pc : __iommu_dma_unmap+0xb8/0xc0
> > >    lr : __iommu_dma_unmap+0x54/0xc0
> > >    sp : ffff0000119abce0
> > >    x29: ffff0000119abce0 x28: 0000000000000000
> > >    x27: ffff8001f9946648 x26: ffff8001ec271068
> > >    x25: 0000000000000000 x24: ffff8001ea3580a8
> > >    x23: ffff8001f95ba010 x22: ffff80018e83ba88
> > >    x21: ffff8001e548f000 x20: fffffffffffff000
> > >    x19: 0000000000001000 x18: 00000000c00001fe
> > >    x17: 0000000000000000 x16: 0000000000000000
> > >    x15: ffff000015b70068 x14: 0000000000000005
> > >    x13: 0003142cc1be1768 x12: 0000000000000001
> > >    x11: ffff8001f6de9100 x10: 0000000000000009
> > >    x9 : ffff000015b78000 x8 : 0000000000000000
> > >    x7 : 0000000000000001 x6 : fffffffffffff000
> > >    x5 : 0000000000000fff x4 : ffff00001065dbc8
> > >    x3 : 000000000000000d x2 : 0000000000001000
> > >    x1 : fffffffffffff000 x0 : 0000000000000000
> > >    Call trace:
> > >     __iommu_dma_unmap+0xb8/0xc0
> > >     iommu_dma_unmap_sg+0x98/0xb8
> > >     put_pages+0x5c/0xf0 [msm]
> > >     msm_gem_free_work+0x10c/0x150 [msm]
> > >     process_one_work+0x1e0/0x330
> > >     worker_thread+0x40/0x438
> > >     kthread+0x12c/0x130
> > >     ret_from_fork+0x10/0x18
> > >    ---[ end trace afc0dc5ab81a06bf ]---
> > >
> > > Not quite sure what triggered that, but we really shouldn't be abusin=
g
> > > dma_{map,unmap}_sg() for cache maint.
> > >
> > > Cc: Stephen Boyd <sboyd@kernel.org>
> > > Tested-by: Stephen Boyd <swboyd@chromium.org>
> > > Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
> > > Signed-off-by: Rob Clark <robdclark@chromium.org>
> > > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > > Link: https://patchwork.freedesktop.org/patch/msgid/20190630124735.27=
786-1-robdclark@gmail.com
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> > This commit also requires the following commits:
> >
> > commit 3de433c5b38af49a5fc7602721e2ab5d39f1e69c
> > Author: Rob Clark <robdclark@chromium.org>
> > Date:   Tue Jul 30 14:46:28 2019 -0700
> >
> >     drm/msm: Use the correct dma_sync calls in msm_gem
> >
> >     [subject was: drm/msm: shake fist angrily at dma-mapping]
> >
> >     So, using dma_sync_* for our cache needs works out w/ dma iommu ops=
, but
> >     it falls appart with dma direct ops.  The problem is that, dependin=
g on
> >     display generation, we can have either set of dma ops (mdp4 and dpu=
 have
> >     iommu wired to mdss node, which maps to toplevel drm device, but md=
p5
> >     has iommu wired up to the mdp sub-node within mdss).
> >
> >     Fixes this splat on mdp5 devices:
> >
> >        Unable to handle kernel paging request at virtual address ffffff=
ff80000000
> >        Mem abort info:
> >          ESR =3D 0x96000144
> >          Exception class =3D DABT (current EL), IL =3D 32 bits
> >          SET =3D 0, FnV =3D 0
> >          EA =3D 0, S1PTW =3D 0
> >        Data abort info:
> >          ISV =3D 0, ISS =3D 0x00000144
> >          CM =3D 1, WnR =3D 1
> >        swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D00000000810e4000
> >        [ffffffff80000000] pgd=3D0000000000000000
> >        Internal error: Oops: 96000144 [#1] SMP
> >        Modules linked in: btqcomsmd btqca bluetooth cfg80211 ecdh_gener=
ic ecc rfkill libarc4 panel_simple msm wcnss_ctrl qrtr_smd drm_kms_helper v=
enus_enc venus_dec videobuf2_dma_sg videobuf2_memops drm venus_core ipv6 qr=
tr qcom_wcnss_pil v4l2_mem2mem qcom_sysmon videobuf2_v4l2 qmi_helpers video=
buf2_common crct10dif_ce mdt_loader qcom_common videodev qcom_glink_smem re=
moteproc bmc150_accel_i2c bmc150_magn_i2c bmc150_accel_core bmc150_magn snd=
_soc_lpass_apq8016 snd_soc_msm8916_analog mms114 mc nf_defrag_ipv6 snd_soc_=
lpass_cpu snd_soc_apq8016_sbc industrialio_triggered_buffer kfifo_buf snd_s=
oc_lpass_platform snd_soc_msm8916_digital drm_panel_orientation_quirks
> >        CPU: 2 PID: 33 Comm: kworker/2:1 Not tainted 5.3.0-rc2 #1
> >        Hardware name: Samsung Galaxy A5U (EUR) (DT)
> >        Workqueue: events deferred_probe_work_func
> >        pstate: 80000005 (Nzcv daif -PAN -UAO)
> >        pc : __clean_dcache_area_poc+0x20/0x38
> >        lr : arch_sync_dma_for_device+0x28/0x30


We have noticed this problem on stable-rc 4.19.118-rc1 running on arm64
qualcomm dragonboard-410c device while booting.

[    5.474942] msm 1a00000.mdss: A306: using IOMMU
[    5.483399] Unable to handle kernel paging request at virtual
address ffffffff80000000
[    5.487564] Mem abort info:
[    5.498182]   ESR =3D 0x96000144
[    5.507101]   SET =3D 0, FnV =3D 0
[    5.507114]   EA =3D 0, S1PTW =3D 0
[    5.509154] Data abort info:
[    5.512253]   ISV =3D 0, ISS =3D 0x00000144
[    5.515376]   CM =3D 1, WnR =3D 1
[    5.518877] swapper pgtable: 4k pages, 48-bit VAs, pgdp =3D (____ptrval_=
___)
[    5.522072] [ffffffff80000000] pgd=3D0000000000000000
[    5.528819] Internal error: Oops: 96000144 [#1] PREEMPT SMP
[    5.533491] Modules linked in: msm(+) crc32_ce adv7511 cec
mdt_loader drm_kms_helper drm drm_panel_orientation_quirks fuse
[    5.539057] Process systemd-udevd (pid: 2807, stack limit =3D
0x(____ptrval____))
[    5.550162] CPU: 0 PID: 2807 Comm: systemd-udevd Not tainted
4.19.118-rc1-00065-gb5f03cd61ab6 #1
[    5.557366] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    5.566392] pstate: 80000005 (Nzcv daif -PAN -UAO)
[    5.573079] pc : __clean_dcache_area_poc+0x20/0x38
[    5.577676] lr : __swiotlb_sync_sg_for_device+0x74/0xa0
[    5.582447] sp : ffff00000dcab490
[    5.587567] x29: ffff00000dcab490 x28: 0000000000000001
[    5.591043] x27: ffff000000d97e40 x26: ffff80003bb9e000
[    5.596423] x25: ffff80003c14c410 x24: ffff000009066178
[    5.601717] x23: ffff80003c14c810 x22: 0000000000000000
[    5.607013] x21: 0000000000000001 x20: 0000000000000001
[    5.612308] x19: ffff80003634cf80 x18: 0000000000000400
[    5.617603] x17: 0000000000000000 x16: 0000000000000000
[    5.622899] x15: 0000000000000400 x14: 0000000000000400
[    5.628194] x13: 0000000000000001 x12: 0000000000000000
[    5.633489] x11: 0000800036c50000 x10: ffff80003639fba8
[    5.638783] x9 : 0000000000001000 x8 : ffff7e0000e7c080
[    5.644079] x7 : 0000000000000001 x6 : 0000000000000000
[    5.649375] x5 : 0000000000000000 x4 : ffffffff80000000
[    5.654669] x3 : 000000000000003f x2 : 0000000000000040
[    5.659964] x1 : ffffffff80001000 x0 : ffffffff80000000
[    5.665260] Call trace:
[    5.670556]  __clean_dcache_area_poc+0x20/0x38
[    5.672850]  get_pages+0x1cc/0x240 [msm]
[    5.677355]  msm_gem_get_iova+0x94/0x138 [msm]
[    5.681428]  _msm_gem_kernel_new+0x40/0xb0 [msm]
[    5.685679]  msm_gem_kernel_new+0x10/0x18 [msm]
[    5.690452]  msm_gpu_init+0x300/0x568 [msm]
[    5.694698]  adreno_gpu_init+0x14c/0x268 [msm]
[    5.698861]  a3xx_gpu_init+0x7c/0x108 [msm]
[    5.703375]  adreno_bind+0x144/0x238 [msm]
[    5.707365]  component_bind_all+0x110/0x270
[    5.711627]  msm_drm_bind+0x104/0x760 [msm]
[    5.715609]  try_to_bring_up_master+0x14c/0x1a8
[    5.719775]  component_master_add_with_match+0xc0/0x100
[    5.724388]  msm_pdev_probe+0x280/0x320 [msm]
[    5.729499]  platform_drv_probe+0x50/0xa0
[    5.734010]  really_probe+0x1f4/0x290
[    5.738003]  driver_probe_device+0x54/0xe8
[    5.741649]  __driver_attach+0xe0/0xe8
[    5.745644]  bus_for_each_dev+0x70/0xb8
[    5.749374]  driver_attach+0x20/0x28
[    5.753108]  bus_add_driver+0x1a0/0x210
[    5.756927]  driver_register+0x60/0x110
[    5.760485]  __platform_driver_register+0x44/0x50
[    5.764407]  msm_drm_register+0x54/0x68 [msm]
[    5.769169]  do_one_initcall+0x54/0x154
[    5.773509]  do_init_module+0x54/0x1c8
[    5.777152]  load_module+0x1bf4/0x2190
[    5.780972]  __se_sys_finit_module+0xb8/0xc8
[    5.784706]  __arm64_sys_finit_module+0x18/0x20
[    5.789135]  el0_svc_common+0x70/0x168
[    5.793385]  el0_svc_handler+0x2c/0x80
[    5.797204]  el0_svc+0x8/0xc
[    5.800939] Code: 9ac32042 8b010001 d1000443 8a230000 (d50b7e20)
[    5.803980] ---[ end trace 004276cd8aee46e8 ]---

Ref:
Full test logs.
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.117-=
65-gb5f03cd61ab6/testrun/1387563/log
https://lkft.validation.linaro.org/scheduler/job/1387568#L3575

kernel configs link,
https://builds.tuxbuild.com/TcvobwCBir3uhOd2MA-ndw/kernel.config

--
Linaro LKFT
https://lkft.linaro.org
