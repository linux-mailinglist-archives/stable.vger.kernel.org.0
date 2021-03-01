Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B51328AAC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239613AbhCASV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239440AbhCASPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 13:15:20 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4F3C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 10:13:37 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id do6so29996765ejc.3
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 10:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=sPAj2CJoK5rr28uv5jhTQj1A8NquCF9kADePUdvjr4E=;
        b=I3I/opudYo4jXNuid0RfBKDgmjk/s0/XzagmCz2nyWnlHYvoBJi9Az2DZ9uOVqcwHe
         6Y9yAZ4miFqAe86WWP3MIFgv3ctZx+8Lj+/aZAJqzvtdquA5vzbwcL0EytkP+itd6mOJ
         TBfEH5/s+0BJhvee4JLMaLqWkHn1veloq6BeQ9IEzyp4ZMGBTNmwea2VQqIRd3NBuSKx
         agPFCQaJihxmkYvqCuv0RtpNR5lmE6q5gXlcVtcwBt3sN17Jg3vGiRi4wKDZyMK9uLlt
         bvFtRG6HNq+Y1L8e9B99qiJ3Fo3p1X6eR6rnk/KSENOmv+QEegP4GEP/NBSmatKvRnWn
         koCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=sPAj2CJoK5rr28uv5jhTQj1A8NquCF9kADePUdvjr4E=;
        b=UjvMb1FIpHX0MHqBtQvpJUxGUsxn3Rn1t5QVZL05vsHTpo9lxbc2VCMpGkpWwBRpYq
         SCw7CRJn2kLmimq9V9Nn8HXLur2Cu7vjr1wDh4FTn6X++hW7LsDmNmHWZRAZznB55CPw
         Ben582KgTaq9HL0fCwOP+hj8oI3Sl1XoTbR1qm2GNpNu+oXGxxQBNskkvJFDFL5Gcx2C
         wMM2zaZNGrAXOnkoSAaql1GWKKYA4QljS2neUTftL9MzH/wAWtC1b8OIsgTccpNQWLtP
         IOsr+XeMIXRvX9a22IK0nvlhJP8EpCTH+W6Wkflb/pazAs38yagAb/fIRDG0GRTGj3wz
         iL8Q==
X-Gm-Message-State: AOAM531JHt5sdsTLkIwawfqdqkOMrM9wd/RHab5UKk99/+4ea5JG48gM
        kBVRVVS5FavSb8vwaxMkgZqW1xjanfNYI6BSP3Venw==
X-Google-Smtp-Source: ABdhPJyHjlf7BODyw4WHtU8uJk4sgay7eSdvtEAAP7XpD7iaYXFbBy2C/PPq4plBaWcCPbMLCK/TaceJ6A5Z7C46p84=
X-Received: by 2002:a17:906:4c85:: with SMTP id q5mr17046384eju.375.1614622416077;
 Mon, 01 Mar 2021 10:13:36 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 1 Mar 2021 23:43:25 +0530
Message-ID: <CA+G9fYsv+xCtoAYXgz5jkMLDGALjXCEvy=HiSWZigA5jLtnytQ@mail.gmail.com>
Subject: [stable-rc 5.4] powerpc/sstep: Fix incorrect return from analyze_instr()
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Ananth N Mavinakayanahalli <ananth@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Sandipan Das <sandipan@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On stable rc 5.10 the ppc defconfig build failed due to below errors/warnings.

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=powerpc
CROSS_COMPILE=powerpc64le-linux-gnu- 'CC=sccache
powerpc64le-linux-gnu-gcc' 'HOSTCC=sccache gcc'
arch/powerpc/lib/sstep.c: In function 'analyse_instr':
arch/powerpc/lib/sstep.c:1415:3: error: label 'unknown_opcode' used
but not defined
   goto unknown_opcode;
   ^~~~
make[3]: *** [scripts/Makefile.build:279: arch/powerpc/lib/sstep.o] Error 1
make[3]: Target '__build' not remade because of errors.


Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

ref:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/1064185056#L114
https://builds.tuxbuild.com/1pAHVbKxYMdzVk0M9veau5gvF3E/build.log

Steps to reproduce:
---------------------
# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.

tuxmake --runtime podman --target-arch powerpc --toolchain gcc-9
--kconfig defconfig

-- 
Linaro LKFT
https://lkft.linaro.org
