Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AB326AA03
	for <lists+stable@lfdr.de>; Tue, 15 Sep 2020 18:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgIOQlU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 12:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:39170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727756AbgIOQkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 12:40:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C65206BE;
        Tue, 15 Sep 2020 16:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600187984;
        bh=hOJ/X6IlY6zvowC02+em2HyjQAPJfpL+zBzL89NhQXI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z/aEqQ3CK8xus7tv48u5o6vZ0BpoPlUe+0Pyuniv3KGdvf2YuEEb0OPkClZ/qu4Sa
         /mctumMZPvEU4JWYowXd5ZXWteD2SrTOub8hq3LNxmtPsGmzr7lkkRKMBmrdYIue5u
         IjgU60FekTpiI7oJo+Jv7DxZcQlbS+v4//IkkSug=
Date:   Tue, 15 Sep 2020 18:40:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        freedreno <freedreno@lists.freedesktop.org>,
        dri-devel@lists.freedesktop.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>
Subject: Re: [PATCH 5.4 000/132] 5.4.66-rc1 review
Message-ID: <20200915164020.GA43543@kroah.com>
References: <20200915140644.037604909@linuxfoundation.org>
 <CA+G9fYv5hvOYNdfX6F40aZPP9Vr6aEsP_-22gX2P+Q95TrfF-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYv5hvOYNdfX6F40aZPP9Vr6aEsP_-22gX2P+Q95TrfF-A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 08:14:34PM +0530, Naresh Kamboju wrote:
> On Tue, 15 Sep 2020 at 19:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.66 release.
> > There are 132 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.66-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> 
> arm and arm64 build breaks on stable rc 5.4.
> 
> make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> arm-linux-gnueabihf-gcc" O=build zImage
> #
> ../kernel/kprobes.c: In function ‘kill_kprobe’:
> ../kernel/kprobes.c:1081:33: warning: statement with no effect [-Wunused-value]
>  1081 | #define disarm_kprobe_ftrace(p) (-ENODEV)
>       |                                 ^
> ../kernel/kprobes.c:2113:3: note: in expansion of macro ‘disarm_kprobe_ftrace’
>  2113 |   disarm_kprobe_ftrace(p);
>       |   ^~~~~~~~~~~~~~~~~~~~
> #
> # make -sk KBUILD_BUILD_USER=TuxBuild -C/linux -j16 ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- HOSTCC=gcc CC="sccache
> arm-linux-gnueabihf-gcc" O=build modules
> #
> ../drivers/gpu/drm/msm/adreno/a5xx_preempt.c: In function ‘preempt_init_ring’:
> ../drivers/gpu/drm/msm/adreno/a5xx_preempt.c:235:21: error:
> ‘MSM_BO_MAP_PRIV’ undeclared (first use in this function)
>   235 |   MSM_BO_UNCACHED | MSM_BO_MAP_PRIV, gpu->aspace, &bo, &iova);
>       |                     ^~~~~~~~~~~~~~~
> ../drivers/gpu/drm/msm/adreno/a5xx_preempt.c:235:21: note: each
> undeclared identifier is reported only once for each function it
> appears in
> make[5]: *** [../scripts/Makefile.build:266:
> drivers/gpu/drm/msm/adreno/a5xx_preempt.o] Error 1
> ../drivers/gpu/drm/msm/adreno/a6xx_gpu.c: In function ‘a6xx_hw_init’:
> ../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:414:6: error: implicit
> declaration of function ‘adreno_is_a640’; did you mean
> ‘adreno_is_a540’? [-Werror=implicit-function-declaration]
>   414 |  if (adreno_is_a640(adreno_gpu) || adreno_is_a650(adreno_gpu)) {
>       |      ^~~~~~~~~~~~~~
>       |      adreno_is_a540
> ../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:414:36: error: implicit
> declaration of function ‘adreno_is_a650’; did you mean
> ‘adreno_is_a540’? [-Werror=implicit-function-declaration]
>   414 |  if (adreno_is_a640(adreno_gpu) || adreno_is_a650(adreno_gpu)) {
>       |                                    ^~~~~~~~~~~~~~
>       |                                    adreno_is_a540
> ../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:415:18: error:
> ‘REG_A6XX_GBIF_QSB_SIDE0’ undeclared (first use in this function)
>   415 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE0, 0x00071620);
>       |                  ^~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:415:18: note: each undeclared
> identifier is reported only once for each function it appears in
> ../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:416:18: error:
> ‘REG_A6XX_GBIF_QSB_SIDE1’ undeclared (first use in this function)
>   416 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE1, 0x00071620);
>       |                  ^~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:417:18: error:
> ‘REG_A6XX_GBIF_QSB_SIDE2’ undeclared (first use in this function)
>   417 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE2, 0x00071620);
>       |                  ^~~~~~~~~~~~~~~~~~~~~~~
> ../drivers/gpu/drm/msm/adreno/a6xx_gpu.c:418:18: error:
> ‘REG_A6XX_GBIF_QSB_SIDE3’ undeclared (first use in this function)
>   418 |   gpu_write(gpu, REG_A6XX_GBIF_QSB_SIDE3, 0x00071620);
>       |                  ^~~~~~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> make[5]: *** [../scripts/Makefile.build:265:
> drivers/gpu/drm/msm/adreno/a6xx_gpu.o] Error 1
> In file included from ../drivers/gpu/drm/msm/msm_gpu.c:7:
> ../drivers/gpu/drm/msm/msm_gpu.c: In function ‘msm_gpu_init’:
> ../drivers/gpu/drm/msm/msm_gpu.h:330:22: error: ‘MSM_BO_MAP_PRIV’
> undeclared (first use in this function)
>   330 |  (((gpu)->hw_apriv ? MSM_BO_MAP_PRIV : 0) | (flags))
>       |                      ^~~~~~~~~~~~~~~
> ../drivers/gpu/drm/msm/msm_gpu.c:935:3: note: in expansion of macro
> ‘check_apriv’
>   935 |   check_apriv(gpu, MSM_BO_UNCACHED), gpu->aspace, &gpu->memptrs_bo,
>       |   ^~~~~~~~~~~
> ../drivers/gpu/drm/msm/msm_gpu.h:330:22: note: each undeclared
> identifier is reported only once for each function it appears in
>   330 |  (((gpu)->hw_apriv ? MSM_BO_MAP_PRIV : 0) | (flags))
>       |                      ^~~~~~~~~~~~~~~
> ../drivers/gpu/drm/msm/msm_gpu.c:935:3: note: in expansion of macro
> ‘check_apriv’
>   935 |   check_apriv(gpu, MSM_BO_UNCACHED), gpu->aspace, &gpu->memptrs_bo,
>       |   ^~~~~~~~~~~
> make[5]: *** [../scripts/Makefile.build:266:
> drivers/gpu/drm/msm/msm_gpu.o] Error 1
> In file included from ../drivers/gpu/drm/msm/msm_ringbuffer.c:8:
> ../drivers/gpu/drm/msm/msm_ringbuffer.c: In function ‘msm_ringbuffer_new’:
> ../drivers/gpu/drm/msm/msm_gpu.h:330:22: error: ‘MSM_BO_MAP_PRIV’
> undeclared (first use in this function)
>   330 |  (((gpu)->hw_apriv ? MSM_BO_MAP_PRIV : 0) | (flags))
>       |                      ^~~~~~~~~~~~~~~
> ../drivers/gpu/drm/msm/msm_ringbuffer.c:30:3: note: in expansion of
> macro ‘check_apriv’
>    30 |   check_apriv(gpu, MSM_BO_WC | MSM_BO_GPU_READONLY),
>       |   ^~~~~~~~~~~
> ../drivers/gpu/drm/msm/msm_gpu.h:330:22: note: each undeclared
> identifier is reported only once for each function it appears in
>   330 |  (((gpu)->hw_apriv ? MSM_BO_MAP_PRIV : 0) | (flags))
>       |                      ^~~~~~~~~~~~~~~
> ../drivers/gpu/drm/msm/msm_ringbuffer.c:30:3: note: in expansion of
> macro ‘check_apriv’
>    30 |   check_apriv(gpu, MSM_BO_WC | MSM_BO_GPU_READONLY),
>       |   ^~~~~~~~~~~
> make[5]: *** [../scripts/Makefile.build:265:
> drivers/gpu/drm/msm/msm_ringbuffer.o] Error 1
> make[5]: Target '__build' not remade because of errors.
> make[4]: *** [../scripts/Makefile.build:500: drivers/gpu/drm/msm] Error 2
> make[4]: Target '__build' not remade because of errors.
> make[3]: *** [../scripts/Makefile.build:500: drivers/gpu/drm] Error 2
> make[3]: Target '__build' not remade because of errors.
> make[2]: *** [../scripts/Makefile.build:500: drivers/gpu] Error 2
> make[2]: Target '__build' not remade because of errors.
> make[1]: *** [/linux/Makefile:1729: drivers] Error 2
> make[1]: Target 'modules' not remade because of errors.
> make: *** [Makefile:179: sub-make] Error 2
> make: Target 'modules' not remade because of errors.

Ah, will go drop that patch, thanks!

greg k-h
