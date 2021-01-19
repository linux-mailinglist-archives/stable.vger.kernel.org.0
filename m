Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706ED2FC2BB
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 22:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbhASVt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 16:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727854AbhASVtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 16:49:52 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36A1C0613CF
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 13:49:08 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id h205so31212311lfd.5
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 13:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PrDa/GcFpT6LoUj6UTSVAgQ+27Gb3Nc2g1qmr4GkWe8=;
        b=llma2u9uC8Y+8nRRAaYuyv6eAPFkLh+OsHjtLx8I26wo0EwsaLZUeu07JGiuupKtMA
         As12eCwQJ/jhGqEMoaIqDv4YrwTuNAP175D1AYphtJp8TcntwuNyfYma9210lO0iaK8L
         4iBgN3XbAqZCfyT+ZLFZbSOKsuQD4O7aNCBdzimnBJCWAVTPikjPAZW9gzOPkAz5romB
         hgp2jsNlsZw5qx8Mt5l67Iw4i/oHtv6br91X5ZCIDd1vavVhJ9CwBCq8c7b6R6vs7qWn
         3put5GLXA7AaD6SWRx81OMH6iYQ0gkFmhiT8tzk01SpAoHNnp+bVIdMv8x+dAydSTp7u
         kFLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PrDa/GcFpT6LoUj6UTSVAgQ+27Gb3Nc2g1qmr4GkWe8=;
        b=ghsb0X2SfQZLofJhGhrdukJyEvXlJ1LW28QNWwdlP6DCO4SMZOTSpde68ZZDP+Iws4
         afizr16PRTbnekOHVyGXUqtuQOFlcap4eyCDWiE1L41HHxkNU3F/WWtdNO8tRHHsUBqh
         7j89WA2QbnoUUliAmWxRPtnlAeEm4EckljcghcXKKomBd47yHlCUoWdrYoCctGo9Eve1
         HtxjOjdNiK7ijdi3b5V5Osq1kJUSPF7yrkzeczHyZjxzy1dTT9czKEw8ukjmLpWrDDfF
         7k/KC8TycMO3CfpyAsel2uzW6nLx5iQVOlKEUvCO84UbNoqJwRt2WoPOZ/ZZfU6bUFm2
         qo1A==
X-Gm-Message-State: AOAM532Iu+tDsjofZIGnFaMRVqc+mwlKmeShhmaVkFfQKNbrlPn1NAAs
        fwN1O0i9ixJD+rTS0oJ9405Xq0tcg/cFxPqUyVg=
X-Google-Smtp-Source: ABdhPJyFGNjrOhs85NpFbCVRjHk36N9OgMw1AgLlnC/Y6oJnb9RTRCjv8f7eQFTDPcmZlTdCbGLrMiGAOP/V+Syb2eo=
X-Received: by 2002:a05:6512:3288:: with SMTP id p8mr2484418lfe.443.1611092947400;
 Tue, 19 Jan 2021 13:49:07 -0800 (PST)
MIME-Version: 1.0
References: <20210119174455.2423205-1-festevam@gmail.com> <CAKMK7uE5vo8G8AYTUAndy7Jj2wqmQGR1kcjjRn-ymGsxw-EvQQ@mail.gmail.com>
In-Reply-To: <CAKMK7uE5vo8G8AYTUAndy7Jj2wqmQGR1kcjjRn-ymGsxw-EvQQ@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 19 Jan 2021 18:48:55 -0300
Message-ID: <CAOMZO5A0ixdNjxeeaKwuC4PufFpwMVm3jqV0X4yicb8TyL13SQ@mail.gmail.com>
Subject: Re: [PATCH] drm/msm: Call shutdown conditionally
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     "Clark, Rob" <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Dave Airlie <airlied@linux.ie>,
        Krishna Manikandan <mkrishn@codeaurora.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel,

On Tue, Jan 19, 2021 at 3:01 PM Daniel Vetter <daniel@ffwll.ch> wrote:

> Don't we need the same treatment for suspend/resume too? Also if you

Yes, you are right. I have just tested suspend/resume and the problem
is there too:

[   69.708552] 8<--- cut here ---
[   69.711970] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[   69.720240] pgd = (ptrval)
[   69.723000] [00000000] *pgd=ca217831
[   69.726664] Internal error: Oops: 17 [#1] SMP ARM
[   69.731387] Modules linked in:
[   69.734463] CPU: 0 PID: 167 Comm: sh Not tainted
5.11.0-rc3-next-20210118-dirty #383
[   69.742223] Hardware name: Freescale i.MX53 (Device Tree Support)
[   69.748326] PC is at msm_atomic_commit_tail+0x50/0xb90
[   69.753505] LR is at commit_tail+0x9c/0x18c
[   69.757705] pc : [<c07755f0>]    lr : [<c06e7218>]    psr: 60000013
[   69.763982] sp : c28bfcd8  ip : fffffffa  fp : c24c20a0
[   69.769217] r10: c0f82720  r9 : 00000010  r8 : 3a62b298
[   69.774452] r7 : c23a3000  r6 : c2816c00  r5 : 00000000  r4 : 00000000
[   69.780990] r3 : c24c2c00  r2 : 00000000  r1 : 00000000  r0 : 00000000
[   69.787529] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[   69.794679] Control: 10c5387d  Table: 72870019  DAC: 00000051
[   69.800434] Process sh (pid: 167, stack limit = 0x(ptrval))
[   69.806019] Stack: (0xc28bfcd8 to 0xc28c0000)
[   69.810391] fcc0:
    ffffffff 20bfa1e1
[   69.818584] fce0: 00000010 00000000 8a7c54c5 00000000 00000000
c2816c00 00000000 c23a3000
[   69.826778] fd00: 00000000 3a62b298 00000010 c0f82720 c24c20a0
c06e7218 00000000 c2816c00
[   69.834972] fd20: c23a3000 00000000 c2816c2c c16093d4 c17682f0
c0e2920c 00000000 00000000
[   69.843166] fd40: 00000000 c12ca028 c23a3000 c23a3494 c2816c00
c23a349c c24c2010 c06e74d4
[   69.851359] fd60: 00000000 c23a3000 c2816480 c07050ec c24c2010
c0e2943c c1609798 c296a880
[   69.859552] fd80: 00000009 00000001 00000000 00000000 c175f454
00000000 c175f458 c1c669cc
[   69.867745] fda0: 00000000 c12c9acc 00000000 00000001 00000009
00000000 c23a32e4 c23a32e4
[   69.875938] fdc0: 00000000 c1609388 c28be000 c23a3000 c28be000
c1765220 c17682f0 c06e84bc
[   69.884132] fde0: c24c2138 c28be000 c1765220 c07e9f58 00000010
c176833c 00000002 c0777850
[   69.892326] fe00: 00000000 c1e08a9c 00000002 00000010 396ed042
00000001 c1e08ac0 00000000
[   69.900519] fe20: 00000000 c07ea57c c296ae28 c0e33ba0 00000000
c1e08a9c 00000003 c125a7c8
[   69.908714] fe40: c17fa154 c01954a8 c16093d4 00000001 c1e08ac0
00000000 00000000 c1609388
[   69.916907] fe60: c28bfe74 00000003 00000000 c125a7c8 c17fa154
00000001 c1e08ac0 00000000
[   69.925100] fe80: 00000000 c01963a4 00000003 c2a9f040 00000003
00000004 c1254a00 c01943b0
[   69.933294] fea0: 00000004 c2901f10 c2a9f040 c2901f00 00d220f0
c28bff78 00000000 c0374f0c
[   69.941488] fec0: 00000000 00000000 00d220f0 c29488c0 00000000
00000004 00d220f0 c28bff78
[   69.949681] fee0: c02c31c4 c0374e00 c2803000 c02c2bfc 00000001
00000000 c02c31c4 c2943bd0
[   69.957876] ff00: c02e7428 c17ee19c c296adc8 00000000 c2943bd0
c0183a34 c2943bd0 c02e7428
[   69.966070] ff20: c28be000 c296a880 c1609798 c018ced8 c296adc8
c0e33ba0 c17ee2de 60000013
[   69.974264] ff40: 00000000 00000001 00000000 c1609388 c17ee2de
c29488c0 c29488c0 00d220f0
[   69.982457] ff60: 00000004 00000000 00000000 00000004 00d20284
c02c31c4 00000000 00000000
[   69.990651] ff80: c010019c c1609388 c1609798 00000001 00000000
000d7b54 00000004 c0100264
[   69.998844] ffa0: c28be000 c0100080 00000001 00000000 00000001
00d220f0 00000004 00000000
[   70.007039] ffc0: 00000001 00000000 000d7b54 00000004 00000004
00000020 00d20410 00d20284
[   70.015232] ffe0: 000d7258 be831960 0001b93c b6ee97a0 60000010
00000001 00000000 00000000
[   70.023427] [<c07755f0>] (msm_atomic_commit_tail) from [<c06e7218>]
(commit_tail+0x9c/0x18c)
[   70.031890] [<c06e7218>] (commit_tail) from [<c0e2920c>]
(drm_atomic_helper_commit+0x1a0/0x1d4)
[   70.040627] [<c0e2920c>] (drm_atomic_helper_commit) from
[<c06e74d4>] (drm_atomic_helper_disable_all+0x1c4/0x1d4)
[   70.050913] [<c06e74d4>] (drm_atomic_helper_disable_all) from
[<c0e2943c>] (drm_atomic_helper_suspend+0xb8/0x170)
[   70.061198] [<c0e2943c>] (drm_atomic_helper_suspend) from
[<c06e84bc>] (drm_mode_config_helper_suspend+0x24/0x58)
[   70.071486] [<c06e84bc>] (drm_mode_config_helper_suspend) from
[<c07e9f58>] (dpm_prepare+0x1ac/0x7b0)
[   70.080738] [<c07e9f58>] (dpm_prepare) from [<c07ea57c>]
(dpm_suspend_start+0x20/0x98)
[   70.088679] [<c07ea57c>] (dpm_suspend_start) from [<c01954a8>]
(suspend_devices_and_enter+0xfc/0xcb8)
[   70.097931] [<c01954a8>] (suspend_devices_and_enter) from
[<c01963a4>] (pm_suspend+0x340/0x3e8)
[   70.106651] [<c01963a4>] (pm_suspend) from [<c01943b0>]
(state_store+0x68/0xc8)
[   70.113982] [<c01943b0>] (state_store) from [<c0374f0c>]
(kernfs_fop_write+0x10c/0x22c)
[   70.122016] [<c0374f0c>] (kernfs_fop_write) from [<c02c2bfc>]
(vfs_write+0xc4/0x53c)
[   70.129795] [<c02c2bfc>] (vfs_write) from [<c02c31c4>] (ksys_write+0x60/0xec)
[   70.136952] [<c02c31c4>] (ksys_write) from [<c0100080>]
(ret_fast_syscall+0x0/0x2c)
[   70.144630] Exception stack(0xc28bffa8 to 0xc28bfff0)
[   70.149697] ffa0:                   00000001 00000000 00000001
00d220f0 00000004 00000000
[   70.157891] ffc0: 00000001 00000000 000d7b54 00000004 00000004
00000020 00d20410 00d20284
[   70.166083] ffe0: 000d7258 be831960 0001b93c b6ee97a0
[   70.171156] Code: 1592208c 1184421c e1530000 1afffff8 (e595c000)
[   70.177483] ---[ end trace 2775110cb98281db ]---

> feel like follow up patch to push this into the helpers with a
> DRIVER_MODESET check like I described would be kinda neat.

I tried using use drm_core_check_feature(dev, DRIVER_MODESET), but
since the drivers/gpu/drm/imx/imx-drm-core.c also sets the
DRIVER_MODESET flag, I am not sure how we can differentiate the fact
that imx5 is not running on a Qualcomm display driver.

Just to be clear: would it be OK to proceed with this original patch
as a minimum fix so that it can reach upstream and also stable-trees
(5.4 and 5.10)?

I am glad to work on a more generic solution that would also fix the
suspend/resume case. Just need some more guidance on that as I am not
familiar with this area.

Thanks,

Fabio Estevam
