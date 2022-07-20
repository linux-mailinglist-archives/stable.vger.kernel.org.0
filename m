Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E0657BED0
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 21:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiGTTp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 15:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGTTpz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 15:45:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46F748CB3;
        Wed, 20 Jul 2022 12:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6097CB821DA;
        Wed, 20 Jul 2022 19:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56288C3411E;
        Wed, 20 Jul 2022 19:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658346351;
        bh=y0bRC8GY6L+KuG0VA4SJtAt+x39/ioI+2s5Bd2/LkeM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WD3F8vqItpKYhD+wSeni2MqVW3iBWw0xUXmfzxpE+yEJZAkuvLI//gLGFmBGYlZuO
         EuH0bSbSJd93deNFNKa0lpbkp1zN41SNIXf8ZQyynyPXSNg6+/ZLcdWmo+Hha1+v/m
         bomX1DsSKQG1VqNQi+QJRMtbyxZgwMLNvzvyxnQs=
Date:   Wed, 20 Jul 2022 21:45:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Justin Forbes <jforbes@fedoraproject.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
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
Message-ID: <YthbbBY4JumsBcHU@kroah.com>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
 <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtgvLUMuz+1zpQHR@fedora64.linuxtx.org>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 20, 2022 at 11:37:01AM -0500, Justin Forbes wrote:
> On Tue, Jul 19, 2022 at 12:32:48PM -0700, Linus Torvalds wrote:
> > On Tue, Jul 19, 2022 at 10:57 AM Naresh Kamboju
> > <naresh.kamboju@linaro.org> wrote:
> > >
> > >
> > > Details log:
> > > ------------
> > > 1. i386 build failures with clang-13 and clang-14
> > > make --silent --keep-going --jobs=8
> > > O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
> > > ARCH=i386 CROSS_COMPILE=i686-linux-gnu- 'HOSTCC=sccache clang'
> > > 'CC=sccache clang'
> > > ld.lld: error: undefined symbol: __udivdi3
> > 
> > Looks like the one introduced by aff1e0b09b54 ("drm/i915/ttm: fix
> > sg_table construction"), and fixed by ced7866db39f ("drm/i915/ttm: fix
> > 32b build").
> > 
> > > 2. Large number of build warnings on x86 with gcc-11,
> > > I do not see these build warnings on mainline,
> > ..
> > > 'naked' return found in RETPOLINE build
> > 
> > Hmm. Does your cross-compiler support '-mfunction-return=thunk-extern'?
> > 
> > Your build does magic things with 'scripts/kconfig/merge_config.sh',
> > and I'm wondering if you perhaps end up enabling CONFIG_RETHUNK with a
> > compiler that doesn't actually support it, or something like that?
> 
> I am seeing these 'naked' return found in RETPOLINE build on the
> standard fedora 36 toolchain as well. No cross compiling, nothing fancy.
> These were not seen with mainline, or with the 5.18.12-rc1 retbleed
> patches.

Ok, I think we have a few of the retbleed patches in here that shouldn't
be in there yet.  Let me flush them out and then put out a new -rc
tomorrow with this all fixed up.  Sasha and I got things crossed, I'll
blame the heat here in Europe and me attempting to take a few days
off...

thanks,

greg k-h
