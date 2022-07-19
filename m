Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07FA557A75B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 21:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239631AbiGSTlW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 15:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGSTlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 15:41:17 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1ED1A04B
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 12:41:16 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id oy13so29070553ejb.1
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 12:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bZJEcqzpDxUsMV047uEotdB5e23S3+dI1OnJ5Dw86hI=;
        b=RnXne9qFCWJP8CfvFDS57nwqFy6dIAM7iEBRrJzzK561MWgVks8YJ2IPMBQ4iyVL7r
         cpBMCqun7iPOK0wF1zg648E8IUwMEfJZbSmyvr5+XQom8GSfc8HDIj46B8O3cgU4wYET
         Lym20NGU7rTpDScpQe10reGkes4lyRNraHzMI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bZJEcqzpDxUsMV047uEotdB5e23S3+dI1OnJ5Dw86hI=;
        b=fnadzDaO7pLVLdmh64Ik2kJTEZrNCPsvinHO6pDwFZgxDikNuA7oAhbP7RutajWn5w
         ep37eODMhC5SWChHMEwRyZz2oX+kbn8U5c/xpN9r3adDozkuPcgcCIz8qWo56Oz+Utx1
         8pLADFuy/iQkHOIRY13PVxRGlrwwA//5WiWqqVm0xrqE8noaB1UQopt8tHIV3bqz6asE
         zYeZDrbgKGLvMIL2FHt/RljtDABYnkgcQD/1FbG+cVkPWAXPUQniDkVK8HLyBdjKFRcU
         e2pPFnkOU9pc4HKMBxoDpMQRpsoPRxOlXaDXHpzqn5JTetoU5oq6zC8FI5NzG0z4Epxj
         nogw==
X-Gm-Message-State: AJIora+wmcRniYXwuLunjvtXd/MTNJcSXfj8CE52qgd7nnYqTCTRNhnV
        wHDeuOB0IZzl8IhhYcmW3HtuhKvfOlEKB96CKAk=
X-Google-Smtp-Source: AGRyM1tcL849/QqSYWWS/g8wwQFIeFwUTavMZKCiJHcgIRF6AZTqZtpXUTSrKAz1X/MJjj5QzVNYyA==
X-Received: by 2002:a17:907:2ccc:b0:72b:6907:fce6 with SMTP id hg12-20020a1709072ccc00b0072b6907fce6mr32063730ejc.115.1658259674630;
        Tue, 19 Jul 2022 12:41:14 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id q8-20020a1709066b0800b006fed062c68esm6966295ejr.182.2022.07.19.12.41.14
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 12:41:14 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id os14so29184597ejb.4
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 12:41:14 -0700 (PDT)
X-Received: by 2002:a05:6000:1a88:b0:21d:aa97:cb16 with SMTP id
 f8-20020a0560001a8800b0021daa97cb16mr28517559wry.97.1658259184451; Tue, 19
 Jul 2022 12:33:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220719114714.247441733@linuxfoundation.org> <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
In-Reply-To: <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 19 Jul 2022 12:32:48 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
Message-ID: <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Slade Watkins <slade@sladewatkins.com>,
        John Harrison <John.C.Harrison@intel.com>,
        Tejas Upadhyay <tejas.upadhyay@intel.com>,
        Anusha Srivatsa <anusha.srivatsa@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 10:57 AM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
>
> Details log:
> ------------
> 1. i386 build failures with clang-13 and clang-14
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
> ARCH=i386 CROSS_COMPILE=i686-linux-gnu- 'HOSTCC=sccache clang'
> 'CC=sccache clang'
> ld.lld: error: undefined symbol: __udivdi3

Looks like the one introduced by aff1e0b09b54 ("drm/i915/ttm: fix
sg_table construction"), and fixed by ced7866db39f ("drm/i915/ttm: fix
32b build").

> 2. Large number of build warnings on x86 with gcc-11,
> I do not see these build warnings on mainline,
..
> 'naked' return found in RETPOLINE build

Hmm. Does your cross-compiler support '-mfunction-return=thunk-extern'?

Your build does magic things with 'scripts/kconfig/merge_config.sh',
and I'm wondering if you perhaps end up enabling CONFIG_RETHUNK with a
compiler that doesn't actually support it, or something like that?

             Linus
