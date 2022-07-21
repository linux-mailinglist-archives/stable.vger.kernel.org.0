Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F166B57D363
	for <lists+stable@lfdr.de>; Thu, 21 Jul 2022 20:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiGUSgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Jul 2022 14:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGUSgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Jul 2022 14:36:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A921D30E;
        Thu, 21 Jul 2022 11:36:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66E6BB82629;
        Thu, 21 Jul 2022 18:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61980C3411E;
        Thu, 21 Jul 2022 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658428592;
        bh=MZP+I0Nutf91zBdThCr63T4SR+BgbUMjLXAfRXtWb+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gZjGvsPCTfDB8LcJ6I0xCwWL338agCcdfj2v5g5VWkM0vJ8rXfMuY7A5oLzsu+dJw
         L4tIhFEPnHaU/qpD1w4CRNgh7Jw3H9tE5kqESZRuiVIOL6mndq4oMYx/Orcww5FxhV
         osHYpa7FIh4YWmONzy/eceXMHlDSBCB4KxNSD9io=
Date:   Thu, 21 Jul 2022 20:36:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
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
Message-ID: <Ytmcrd1TRvFqmbGr@kroah.com>
References: <20220719114714.247441733@linuxfoundation.org>
 <CA+G9fYsCL48P5zFMKUxoJ-1vwUJSWhcn17rUx=1rxOdzdw_Mmg@mail.gmail.com>
 <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjo-u8=yJQJQnaP41FkQw7we9A-zJH3UELx5x_1ynPDfw@mail.gmail.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Thanks, I've queued this one up now in the -rc3 update.

greg k-h
