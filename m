Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84F14295B5
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 19:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhJKRfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 13:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhJKRfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 13:35:40 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BABC061570
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 10:33:40 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id d9so46746296edh.5
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 10:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NDVLB8xPEyLszowX8zbQaP4kuxGHzigHw40S/JGzNKI=;
        b=YzwuSI3Y6D8mgkVik1RX7o5JwXiK5ttPZQZ18wUS9yWZXjd1e6E7HvBm6SYQPs3RmA
         7FTHNwC71RYlJcUvziljdiy8gTPeQ5s1tF8UCAckuljpeXHg1HGMGfH70kYgPprG1ft5
         PTvtDcpWmIEPa9BdHY1rn5NXiOWeydZ1vJiBhacC5FB1rertiw8T5WDH3xEl0My4e0cr
         GEIUc+YrbCRqgfwgwkVDpE00yGR9zqi8n4d97NSi3UikyVKCKFl78rAlwdn4Jv3AtyTo
         rIm+AdUGythc/hThwluuSbF2gFmGhEVBfckvKKUtls3xM7FAzlMDcjYcpepoYqrLEnXG
         uyUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NDVLB8xPEyLszowX8zbQaP4kuxGHzigHw40S/JGzNKI=;
        b=TiKWJFbXZ9qnDZ8lNawDbuQhHslaSM88CRiwSF7M7GBgoc90J1tvQj6rzo3h4pvKe5
         uqbOywhl7yEck31T1ulvSRIifIXQNvVHDXxpcmSM8SFSd7KQnkRsaLLsFUwSlhuif75x
         a8ruZkEes3piOBvL/JgQw6eR5i0ByEZ6QPtpRmJhj0e5vt9cl881UcbkJQCjKGBgeMUb
         eMiCIhnWz7Nt6JRCKSiuRhRBJ0bM18bxb6qkQUafDTdV/9FWeDWGBD7x1EzZ1IvcN8A3
         Aqcl5xXvAD/SQZD3U+AM+s/HzNlvNcnEEsi8Sky5FOUXl4H2x14HTuL/p2zyYBgIcNGb
         yO4g==
X-Gm-Message-State: AOAM531+O40Vl9puLDnXvyQ/z8SY80T9vRzAml+E/0SuthYG3OuDVuZ5
        QSyMoDu8srk7Sq7izbNAv/HHMp34WszicPCsAqjwkg==
X-Google-Smtp-Source: ABdhPJxsov/zONBIshswr6zn+hWI1hEeFMOyXDMsMIvOspM/pRy2bQXnubWg7aap0FAjHdQsVxWRvzXr1E9zJykq2c8=
X-Received: by 2002:a17:906:c302:: with SMTP id s2mr26221966ejz.499.1633973618445;
 Mon, 11 Oct 2021 10:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211011134503.715740503@linuxfoundation.org> <20211011134505.420785540@linuxfoundation.org>
In-Reply-To: <20211011134505.420785540@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 11 Oct 2021 23:03:27 +0530
Message-ID: <CA+G9fYtUcnJioz4rPonLvjhwwNFmXYfiqE+0uUDO5aZcuoa0MQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 49/52] powerpc/bpf: Fix BPF_MOD when imm == 1
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Song Liu <songliubraving@fb.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc 5.4 build failed due this patch.
 - powerpc gcc-10-defconfig - FAILED
 - powerpc gcc-11-defconfig - FAILED
 - powerpc gcc-8-defconfig - FAILED
 - powerpc gcc-9-defconfig - FAILED


On Mon, 11 Oct 2021 at 19:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>
> [ Upstream commit 8bbc9d822421d9ac8ff9ed26a3713c9afc69d6c8 ]
>
> Only ignore the operation if dividing by 1.

<trim>

In file included from arch/powerpc/net/bpf_jit64.h:11,
                 from arch/powerpc/net/bpf_jit_comp64.c:19:
arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
arch/powerpc/net/bpf_jit_comp64.c:415:46: error: implicit declaration
of function 'PPC_RAW_LI'; did you mean 'PPC_RLWIMI'?
[-Werror=implicit-function-declaration]
  415 |                                         EMIT(PPC_RAW_LI(dst_reg, 0));
      |                                              ^~~~~~~~~~
arch/powerpc/net/bpf_jit.h:32:34: note: in definition of macro 'PLANT_INSTR'
   32 |         do { if (d) { (d)[idx] = instr; } idx++; } while (0)
      |                                  ^~~~~
arch/powerpc/net/bpf_jit_comp64.c:415:41: note: in expansion of macro 'EMIT'
  415 |                                         EMIT(PPC_RAW_LI(dst_reg, 0));
      |                                         ^~~~
cc1: all warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
ReplyReply to allForward
