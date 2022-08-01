Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0BD586678
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 10:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiHAIiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 04:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiHAIiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 04:38:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3582E9F4
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 01:38:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF168B80EED
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 08:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF5DC433D7;
        Mon,  1 Aug 2022 08:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659343088;
        bh=DHUHFC4mqSxXWnIQiir/A9UFGLcmTxIV2EtRUuHQ22Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yty1OrBhV49G65XLzux9GWTShpw9i6BNAqt/e0YwdNZXd0lqy5eopxIMtjHmOHATf
         4AXiiOJLW6BtgykjHncRgByInC9e1PBIHWUscinWYT1Ud00LoWN3SFaxhCG8/noHFb
         e8tIqHBHCglZAr0aLWTcntnMO7IPFS4lvcK4zIzw=
Date:   Mon, 1 Aug 2022 10:38:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Nicolas Pitre <nico@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] ARM: crypto: comment out gcc warning that breaks clang
 builds
Message-ID: <YueQ7eokc5DbbdTk@kroah.com>
References: <20220731100551.3679874-1-gregkh@linuxfoundation.org>
 <CAMj1kXHPV-EHVQDa5hmJJAQP-dDfTgVpD6+7g65+Q9-C6xdwhg@mail.gmail.com>
 <YuZb5BEORzZ94z0k@kroah.com>
 <CAMj1kXFODDitAF+_UjrPeyV-tdAYv2n=8+hpXcQM4606ygiw=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFODDitAF+_UjrPeyV-tdAYv2n=8+hpXcQM4606ygiw=w@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 31, 2022 at 01:13:14PM +0200, Ard Biesheuvel wrote:
> On Sun, 31 Jul 2022 at 12:39, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Sun, Jul 31, 2022 at 12:17:40PM +0200, Ard Biesheuvel wrote:
> > > On Sun, 31 Jul 2022 at 12:05, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >
> > > > The gcc build warning prevents all clang-built kernels from working
> > > > properly, so comment it out to fix the build.
> > > >
> > > > This is a -stable kernel only patch for now, it will be resolved
> > > > differently in mainline releases in the future.
> > > >
> > > > Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> > > > Cc: "Justin M. Forbes" <jforbes@fedoraproject.org>
> > > > Cc: Ard Biesheuvel <ardb@kernel.org>
> > > > Cc: Arnd Bergmann <arnd@kernel.org>
> > > > Cc: Nicolas Pitre <nico@linaro.org>
> > > > Cc: Nathan Chancellor <nathan@kernel.org>
> > > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  arch/arm/lib/xor-neon.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/arm/lib/xor-neon.c b/arch/arm/lib/xor-neon.c
> > > > index b99dd8e1c93f..7ba6cf826162 100644
> > > > --- a/arch/arm/lib/xor-neon.c
> > > > +++ b/arch/arm/lib/xor-neon.c
> > > > @@ -26,8 +26,9 @@ MODULE_LICENSE("GPL");
> > > >   * While older versions of GCC do not generate incorrect code, they fail to
> > > >   * recognize the parallel nature of these functions, and emit plain ARM code,
> > > >   * which is known to be slower than the optimized ARM code in asm-arm/xor.h.
> > > > + *
> > > > + * #warning This code requires at least version 4.6 of GCC
> > > >   */
> > > > -#warning This code requires at least version 4.6 of GCC
> > > >  #endif
> > > >
> > > >  #pragma GCC diagnostic ignored "-Wunused-variable"
> > >
> > > LGTM but doesn't Clang also complain about the GCC specific pragma?
> >
> > I don't know, all clang builds always failed at the first #warning line :)
> 
> Just tried it, and it appears to ignore the #pragma so we're all good.

Wonderful, thanks for testing.

greg k-h
