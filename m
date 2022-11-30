Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450A563DA68
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 17:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiK3QUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 11:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiK3QUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 11:20:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9A02B61A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 08:20:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 563B361CE4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 16:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63844C433D6;
        Wed, 30 Nov 2022 16:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669825207;
        bh=HYUiCgM5PSjQT8bNJolzNy64UwjWQ0WHbBtYdsHNp98=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sx4HXk8b5gsA6M3zlWXC0Zp8Rs4zx6ESkKcVvBpUv2SoqzIspPs7S5l6b0XH/Apts
         HOlevAgEhucgF8DimIYhJPW+Q6lneqdEf/LHILhhckxxTeqt1H7Alf1sicj6HMR8Qt
         hFZI7s8KXDk2oaxJmZ3S/QG4e6cJDem1+2wotL3Zmv9J5B2gwvIL2UnbWwiF7rKq9O
         z0ijHpICHgHm6AvH7IRRnRpPKrRKEonBhPYeyvmOwNROEEo0WXUQYMrzLLwlLK+Jqw
         s3x/K9GR22K4g8I0x2xrm2L/KxUDLatsZQlStfOf7+7yuYPKlOZYBi1OzWsapx7o/y
         TMm+3yuSsc49w==
Date:   Wed, 30 Nov 2022 09:20:05 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 and earlier only] mm: Fix '.data.once' orphan section
 warning
Message-ID: <Y4eCteHv8XpkpWmj@dev-arch.thelio-3990X>
References: <20221128225345.9383-1-nathan@kernel.org>
 <103aa792-661f-396b-82d4-4507df636b9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <103aa792-661f-396b-82d4-4507df636b9@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 29, 2022 at 10:28:33PM -0800, Hugh Dickins wrote:
> On Mon, 28 Nov 2022, Nathan Chancellor wrote:
> 
> > Portions of upstream commit a4055888629b ("mm/memcg: warning on !memcg
> > after readahead page charged") were backported as commit cfe575954ddd
> > ("mm: add VM_WARN_ON_ONCE_PAGE() macro"). Unfortunately, the backport
> > did not account for the lack of commit 33def8498fdd ("treewide: Convert
> > macro and uses of __section(foo) to __section("foo")") in kernels prior
> > to 5.10, resulting in the following orphan section warnings on PowerPC
> > clang builds with CONFIG_DEBUG_VM=y:
> > 
> >   powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
> >   powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
> >   powerpc64le-linux-gnu-ld: warning: orphan section `".data.once"' from `mm/huge_memory.o' being placed in section `".data.once"'
> > 
> > This is a difference between how clang and gcc handle macro
> > stringification, which was resolved for the kernel by not stringifying
> > the argument to the __section() macro. Since that change was deemed not
> > suitable for the stable kernels by commit 59f89518f510 ("once: fix
> > section mismatch on clang builds"), do that same thing as that change
> > and remove the quotes from the argument to __section().
> > 
> > Fixes: cfe575954ddd ("mm: add VM_WARN_ON_ONCE_PAGE() macro")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> 
> Yes indeed: thanks Nathan, sorry about that.
> 
> Acked-by: Hugh Dickins <hughd@google.com>

No worries, it is a really subtle problem that I would not expect
someone doing normal backports to catch. Thanks for taking a look!

> > ---
> > 
> > As far as I can tell, this should be applied to 5.4 and earlier. It
> > should apply cleanly but let me know if not.
> 
> I think it should be good for 4.19 also, but I don't know what happens
> or would happen in 4.14 and 4.9 trees, since those have no other example
> of .data.once or ".data.once" (and I've lost what little I ever knew of
> that linker script stuff).
> 
> Since we're not hearing complaints about those (or are you?), perhaps
> those trees are not clang-ready in other ways, and for gcc it all works
> out by itself: I'd be inclined to just leave them as is myself, if there
> are no reports of breakage; but you may know better, and prefer to remove
> the ' __section(".data.once")' from the 4.14 and 4.9 versions.

Those trees have very rudimentary clang support, they are far from
warning and issue clean in all configurations (even mainline has known
issues for some architectures, including powerpc). Since this
specifically requires CONFIG_DEBUG_VM to see, I am perfectly fine with
just applying it to 4.19 and 5.4.

Cheers,
Nathan

> > 
> >  include/linux/mmdebug.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> > index 5d0767cb424a..4ed52879ce55 100644
> > --- a/include/linux/mmdebug.h
> > +++ b/include/linux/mmdebug.h
> > @@ -38,7 +38,7 @@ void dump_mm(const struct mm_struct *mm);
> >  		}							\
> >  	} while (0)
> >  #define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
> > -	static bool __section(".data.once") __warned;			\
> > +	static bool __section(.data.once) __warned;			\
> >  	int __ret_warn_once = !!(cond);					\
> >  									\
> >  	if (unlikely(__ret_warn_once && !__warned)) {			\
> > 
> > base-commit: 4d2a309b5c28a2edc0900542d22fec3a5a22243b
> > -- 
> > 2.38.1
