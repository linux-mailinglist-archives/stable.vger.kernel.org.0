Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D9F4ADDE7
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 17:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242211AbiBHQEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 11:04:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239269AbiBHQEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 11:04:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D6EC061576;
        Tue,  8 Feb 2022 08:04:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53FDD6168C;
        Tue,  8 Feb 2022 16:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3931FC004E1;
        Tue,  8 Feb 2022 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644336260;
        bh=fkcM/cj5TPbLIL53k1xCwKgNr/uerJzMAH9JtGLwnIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W2ObtUKMEXvRy3dBC56Fc90mt+dAL+rivWu2owCuXVq8ZkTywujYcg7GOXvqjaWWp
         k1pRIEVq8nEywWeHrVSZZCzZ9wVomBrnw5TiJO8JAPHGaQs0/XpWJ+ZhMQgghtnEBQ
         zt5+pTF0G8ydZtXrTlgEAMNpnskaa3TOQRqYoTqbb82TLr88AyZNd0B5+TlKhp+HFu
         284mtD2ZKWuxgUlOrQUub9s0VTX9HFVkNtvDeFVONHQTtrxa5k4W0g3Ts8j+0fwE0O
         PEYwLJnJvqSXkdHI2rljnF9jkSuDrQr8mz9byg6MSbhL6JBxS1RdPOBWzerws73Ax6
         NPl8wJWcYhfVQ==
Date:   Tue, 8 Feb 2022 09:04:16 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        llvm@lists.linux.dev, stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] Makefile.extrawarn: Move -Wunaligned-access to W=1
Message-ID: <YgKUgI95kAPKGOZY@dev-arch.archlinux-ax161>
References: <20220202230515.2931333-1-nathan@kernel.org>
 <CAKwvOdkQ__2A3NohrcJgF+JABSDnSyEKzD97qVa4cpM==GPONQ@mail.gmail.com>
 <CAK7LNASCGbLWkDXYqyCf08sFHjGqvqSgmFsJ741MHGSKzkifLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNASCGbLWkDXYqyCf08sFHjGqvqSgmFsJ741MHGSKzkifLg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 08, 2022 at 01:23:32PM +0900, Masahiro Yamada wrote:
> On Thu, Feb 3, 2022 at 8:12 AM Nick Desaulniers <ndesaulniers@google.com> wrote:
> >
> > On Wed, Feb 2, 2022 at 3:07 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > >
> > > -Wunaligned-access is a new warning in clang that is default enabled for
> > > arm and arm64 under certain circumstances within the clang frontend (see
> > > LLVM commit below). On v5.17-rc2, an ARCH=arm allmodconfig build shows
> > > 1284 total/70 unique instances of this warning (most of the instances
> > > are in header files), which is quite noisy.
> > >
> > > To keep a normal build green through CONFIG_WERROR, only show this
> > > warning with W=1, which will allow automated build systems to catch new
> > > instances of the warning so that the total number can be driven down to
> > > zero eventually since catching unaligned accesses at compile time would
> > > be generally useful.
> > >
> > > Cc: stable@vger.kernel.org
> > > Link: https://github.com/llvm/llvm-project/commit/35737df4dcd28534bd3090157c224c19b501278a
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1569
> > > Link: https://github.com/ClangBuiltLinux/linux/issues/1576
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> >
> > Thanks to you and Arnd for working out whether this is important to
> > pursue. Sounds like it is.
> > Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> >
> > > ---
> 
> 
> I assume this should be considered as a bug fix
> to avoid the error for the combination of CONFIG_WERROR=y
> and the latest Clang.
> 
> Applied to linux-kbuild/fixes.
> Thanks.

Yes, this is what I was hoping for! Thank you, I'll try to make that
more clear in the future.

Cheers,
Nathan

> > >
> > > v1 -> v2: https://lore.kernel.org/r/20220201232229.2992968-1-nathan@kernel.org/
> > >
> > > * Move to W=1 instead of W=2 so that new instances are caught (Arnd).
> > > * Add links to the ClangBuiltLinux issue tracker.
> > >
> > >  scripts/Makefile.extrawarn | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> > > index d53825503874..8be892887d71 100644
> > > --- a/scripts/Makefile.extrawarn
> > > +++ b/scripts/Makefile.extrawarn
> > > @@ -51,6 +51,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
> > >  KBUILD_CFLAGS += -Wno-format-zero-length
> > >  KBUILD_CFLAGS += $(call cc-disable-warning, pointer-to-enum-cast)
> > >  KBUILD_CFLAGS += -Wno-tautological-constant-out-of-range-compare
> > > +KBUILD_CFLAGS += $(call cc-disable-warning, unaligned-access)
> > >  endif
> > >
> > >  endif
> > >
> > > base-commit: 26291c54e111ff6ba87a164d85d4a4e134b7315c
> > > --
> > > 2.35.1
> > >
> >
> >
> > --
> > Thanks,
> > ~Nick Desaulniers
> 
> 
> 
> -- 
> Best Regards
> Masahiro Yamada
