Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE0A57BB78
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 18:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiGTQhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 12:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbiGTQhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 12:37:08 -0400
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DD653D07
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 09:37:05 -0700 (PDT)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-f2a4c51c45so36802225fac.9
        for <stable@vger.kernel.org>; Wed, 20 Jul 2022 09:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LibJpy8nS3bAQoaRDbF0IQPrPQCsrS+Vj+/glezYG1g=;
        b=UUnTrUjsxUKQyzJAWUmSkRphWD/hynF1gxZt4Qekw2CRTeX7tAb4lOHC0Hmhbhc6c+
         yAy+Kjygut0gpoMRhorRQdN5AoKS3UmHi1gYzbkUCYWGle5XRGWMaWGH8EhhNexIoKzX
         5oN5cizWB9UghXalx6gl65J239NamUTCPEIY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LibJpy8nS3bAQoaRDbF0IQPrPQCsrS+Vj+/glezYG1g=;
        b=EnXZBHTXPgpnWT21uY0EW0jhdlBBWxWJ4M7KMCWtanTb1UuBOttEIJGHNSivavSmQL
         Bm0egyRSpt4lOfxKOShYkMDC3DVCecSnKE2GA78QrKke7cVIMqBk48azdQ7ylEMfMBrG
         HDQ5o4w2ib1Oiky5QFk93yzm4SpeuJuG39tKRqlWAUmkESmLgngvP5kBQyQHbYe39kB/
         ztoUtLdOxrmhPSyTeu2Ltqzosopjg63socPtRw8RAigeTFZ/K7vMF04OkYZ7CJQstnrE
         jxr8a2Z3uOEnH+YuNfMrDD/AwSR/3nYCRNG5+kItqFob7q7hpngXsKw6yY5dH4V0xNPw
         471Q==
X-Gm-Message-State: AJIora9gXBC9b53sF1cNDEUDd5uPz9UZRSdvknz63o9S7dXurshLu0Ze
        JfMqmL0XH63bVxC1eQU1ZNBNrw==
X-Google-Smtp-Source: AGRyM1u/bSj9HK66c1duXFcNh8Rk5I7sedfb2KXJ6aK1Jfei8GfQgBRW4lF87u+Lmd7eG1+n1pxXvg==
X-Received: by 2002:a05:6871:79d:b0:10d:6d35:6fae with SMTP id o29-20020a056871079d00b0010d6d356faemr2959779oap.113.1658335023628;
        Wed, 20 Jul 2022 09:37:03 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id 4-20020a4a0604000000b00435a68593ebsm2827559ooj.27.2022.07.20.09.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 09:37:03 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 20 Jul 2022 11:37:01 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Message-ID: <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 19, 2022 at 12:32:48PM -0700, Linus Torvalds wrote:
> On Tue, Jul 19, 2022 at 10:57 AM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> >
> > Details log:
> > ------------
> > 1. i386 build failures with clang-13 and clang-14
> > make --silent --keep-going --jobs=8
> > O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
> > ARCH=i386 CROSS_COMPILE=i686-linux-gnu- 'HOSTCC=sccache clang'
> > 'CC=sccache clang'
> > ld.lld: error: undefined symbol: __udivdi3
> 
> Looks like the one introduced by aff1e0b09b54 ("drm/i915/ttm: fix
> sg_table construction"), and fixed by ced7866db39f ("drm/i915/ttm: fix
> 32b build").
> 
> > 2. Large number of build warnings on x86 with gcc-11,
> > I do not see these build warnings on mainline,
> ..
> > 'naked' return found in RETPOLINE build
> 
> Hmm. Does your cross-compiler support '-mfunction-return=thunk-extern'?
> 
> Your build does magic things with 'scripts/kconfig/merge_config.sh',
> and I'm wondering if you perhaps end up enabling CONFIG_RETHUNK with a
> compiler that doesn't actually support it, or something like that?

I am seeing these 'naked' return found in RETPOLINE build on the
standard fedora 36 toolchain as well. No cross compiling, nothing fancy.
These were not seen with mainline, or with the 5.18.12-rc1 retbleed
patches.

Justin
