Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C953968E887
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 07:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjBHGzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 01:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjBHGzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 01:55:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9DA442E5;
        Tue,  7 Feb 2023 22:55:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DF53B81AC8;
        Wed,  8 Feb 2023 06:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CE1C433EF;
        Wed,  8 Feb 2023 06:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675839301;
        bh=a4B+YQizzgDC8DXHAt6Dn68H073j/R65LXUWrw/mnN4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bCdbBqPNxyun/OrzZym2xp1aFRk04ycqTlzzYXtalpV1P3lBGfqzsLeWnON+m144Y
         KQzUy6KGGWFGuV8ui+3zHAIb5T19uy8BEMOO9cAgFioWb6legHXLN5+SAxB1DYbOX9
         NxUgBy8mxlIbLUgnuZw8Oh/in33wOVSD6c6lBDoF0QZVTYI4wMcUYPAcKqKIBWkpdf
         YB7x9v1yKzS1SzoZ910vPHWlh9mAhXnctLSO5GKMSfhUfBKf3iD1/721Rvr9sE6/zz
         hjpLK2MUuAfpR7OeLbeJTV1NyeVJv1o3LGtk9SqSV8stIE0tMUCCMwn59u0SKm/awA
         LL4XlW1D18JdQ==
Date:   Tue, 7 Feb 2023 22:55:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Bill Wendling <morbo@google.com>
Subject: Re: [PATCH] randstruct: temporarily disable clang support
Message-ID: <Y+NHRHsp9u4ooOdf@sol.localdomain>
References: <20230203194201.92015-1-ebiggers@kernel.org>
 <63deacb1.170a0220.f078.6779@mx.google.com>
 <CAFP8O3Kwa2V7GvJPEbr87o6hMi8i2JquWniFOaiFR3nv9pGc_g@mail.gmail.com>
 <CAKwvOdm8F_VcdegPGw3vPu+-H1Gyh0rqQWpf=+Yh9YAowVuWSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOdm8F_VcdegPGw3vPu+-H1Gyh0rqQWpf=+Yh9YAowVuWSA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 10:01:21AM -0800, Nick Desaulniers wrote:
> On Mon, Feb 6, 2023 at 3:41 PM Fangrui Song <maskray@google.com> wrote:
> >
> > On Sat, Feb 4, 2023 at 11:06 AM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > On Fri, Feb 03, 2023 at 11:42:01AM -0800, Eric Biggers wrote:
> > > > From: Eric Biggers <ebiggers@google.com>
> > > >
> > > > Randstruct with clang is currently unsafe to use in any clang release
> > > > that supports it, due to a clang bug that is causing miscompilations:
> > > > "-frandomize-layout-seed inconsistently randomizes all-function-pointers
> > > > structs" (https://github.com/llvm/llvm-project/issues/60349).  Disable
> > > > it temporarily until the bug is fixed and the fix is released in a clang
> > > > version that can be checked for.
> > > >
> > > > Fixes: 035f7f87b729 ("randstruct: Enable Clang support")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > > ---
> > > >  security/Kconfig.hardening | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> > > > index 53baa95cb644..aad16187148c 100644
> > > > --- a/security/Kconfig.hardening
> > > > +++ b/security/Kconfig.hardening
> > > > @@ -280,7 +280,8 @@ config ZERO_CALL_USED_REGS
> > > >  endmenu
> > > >
> > > >  config CC_HAS_RANDSTRUCT
> > > > -     def_bool $(cc-option,-frandomize-layout-seed-file=/dev/null)
> > > > +     # Temporarily disabled due to https://github.com/llvm/llvm-project/issues/60349
> > > > +     def_bool n
> > > >
> > > >  choice
> > > >       prompt "Randomize layout of sensitive kernel structures"
> > > >
> > > > base-commit: 7b753a909f426f2789d9db6f357c3d59180a9354
> > > > --
> > > > 2.39.1
> > >
> > > This should be fixed with greater precision -- i.e. this is nearly fixed
> > > in Clang now, and is likely to be backported. So I think we'll need
> > > versioned checks here.
> > >
> > > --
> > > Kees Cook
> > >
> >
> > Bill has requested cherry-pick the llvm-project fix into the
> > release/16.x branch [1].
> > https://github.com/llvm/llvm-project-release-prs/pull/276
> > It may take one day to land.
> >
> > [1]: https://github.com/llvm/llvm-project/tree/release/16.x
> >
> > --
> > 宋方睿
> >
> 
> All landed; the version check should be for 16+. (And the link to the
> issue report would be nice to retain).

Thanks!  Done in "[PATCH] randstruct: disable Clang 15 support"
(https://lore.kernel.org/linux-hardening/20230208065133.220589-1-ebiggers@kernel.org).

- Eric
