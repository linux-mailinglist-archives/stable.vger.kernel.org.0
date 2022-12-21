Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B282653749
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 20:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiLUT4s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 14:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLUT4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 14:56:47 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EF2BE26
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 11:56:46 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id v23so11581496pju.3
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 11:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pLiBfRWUs9BOPgKrJICXorDk9e4J0stvsfhKEHmrvvE=;
        b=X2wf5chFSPExKxSTcXEzdY2POilg8eONfyRHQXqrtXfNAufz7Ux6iRQK/4Yy4GnZrb
         gku8J2Tin+5MWQadsVFsMVYf1iFMlHwe2tTDxwMnh4UotEBy4K/v4H15KogODPCIIU9q
         FmluLv1KpTAMdt46oyQolL+IIRsPOQLfMsmZSRD6C+qNxvEVppNcdQu4a6AxChs4G1aK
         YdJp8K7wXLgGxR4bd7gNo5gk5qXga+pGSljuOXfMVsChOzuQSbyk4Ly6v9l50zPfqA2G
         ml7bBuOugz8PLqPUrbgfrszFZPad173HFcNNFa8AL+uHJx07nRK4sX+yZjpo1GgPcXlX
         ktBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pLiBfRWUs9BOPgKrJICXorDk9e4J0stvsfhKEHmrvvE=;
        b=mlyCjDRMWFqMmzMIGbpW0oJ78NkyYFBViuiexL29ob5a61GfNVEr3IX+MOiFW5UV4f
         QybXE3vVG4bRxEhO6JqARI3uLWtyqRjKN8JavjsuTwAUMb8U4KITJY5B2swzZYPvKyAR
         Gt6n9VnYebGnAI6u6wM2yzzDG+CKCHBNaxWPtr0pew3/NydtJUDydYKm1TZmingjcwQe
         eQa5vc2dXKw7nrOP77rJprkRDqxBQxf7bVzLsW4P66Zeg3r81ROwNKbfL4LEgpcM+T4F
         mdwsr62mqP3pxgeHpwUqLW/G8bOOo1NHn5JSyemormN+zYCYRBcVHz0uCEaDsUw3QvE8
         0tug==
X-Gm-Message-State: AFqh2kqPTetgAzw1c25p+LZX4BpMR+MjgPpbvRRluCneEyLIDbt8TpV7
        0OIYlJc406BmPGEhZnfDKC7LyaSukfUariQt+HniXA==
X-Google-Smtp-Source: AMrXdXvAOzZSkEW5/FH02Lpo5clkD2hKQdF20PFNP+YXkIBp9lpfeM/YRPq9gm5Saudbq9HnXwtE0tUmmCTvUUiHo/A=
X-Received: by 2002:a17:90a:e2d2:b0:225:af73:8197 with SMTP id
 fr18-20020a17090ae2d200b00225af738197mr35200pjb.107.1671652605363; Wed, 21
 Dec 2022 11:56:45 -0800 (PST)
MIME-Version: 1.0
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
In-Reply-To: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 21 Dec 2022 11:56:33 -0800
Message-ID: <CAKwvOdnu6KAgFrwmcn9qhjd+WDyW0ZTSyOzOnSsWhQ1rj0Y-6A@mail.gmail.com>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if CONFIG_MODVERSIONS
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Clifton <nickc@redhat.com>,
        Fangrui Song <maskray@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tom, thanks for pursuing this. Sorry I'm falling behind in reviews
(going offline soon for the holidays).  Some additional questions:


On Thu, Dec 15, 2022 at 3:18 PM Tom Saeger <tom.saeger@oracle.com> wrote:
>
> Backport of:
> commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")

Just arm64? Why not other architectures?

>
> Linus's tree doesn't have this issue since 0d362be5b142 was merged
> after df202b452fe6 which included:
> commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
>
> This kernel's KBUILD CONFIG_MODVERSIONS tooling compiles and links .S targets
> with relocatable (-r) and now (-z noexecstack)
> which results in ld adding a .note.GNU-stack section to .o files.
> Final linking of vmlinux should add a .NOTES segment containing the
> Build ID, but does NOT (on some architectures like arm64) if a
> .note.GNU-stack section is found in .o's supplied during link
> of vmlinux.

Is that a bug in BFD?  That the behavior differs per target
architecture is subtle.  If it's not documented behavior that you can
link to, can you file a bug about your findings and cc me?
https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils

If it is a bug in BFD, then I'm not opposed to working around it, but
it would be good to have as precise a report as possible in the commit
message if we're going to do hijinks in a stable-only patch for
existing tooling.

If it's a feature, having some explanation _why_ we get per-arch
behavior like this may be helpful for us to link to in the future
should this come up again.

>
> DISCARD .note.GNU-stack sections of .S targets.  Final link of

That's going to give them an executable stack again.
https://www.redhat.com/en/blog/linkers-warnings-about-executable-stacks-and-segments
>> missing .note.GNU-stack section implies executable stack
The intent of 0d362be5b142 is that we don't want translation units to
have executable stacks, though I do note that assembler sources need
to opt in.

Is it possible to force a build-id via linker flag `--build-id=sha1`?

If not, can we just use `-z execstack` rather than concatenating a
DISCARD section into a linker script?  Either command line flags feel
cleaner than modifying a linker script at build time, if they work
that is.

> vmlinux then properly adds .NOTES segment containing Build ID that can
> be read using tools like 'readelf -n'.
>
> Fixes: 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> Cc: <stable@vger.kernel.org> # 5.15, 5.10, 5.4
> Cc: <linux-kbuild@vger.kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Masahiro Yamada <masahiroy@kernel.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Michal Marek <michal.lkml@markovi.net>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> ---
>
> v2:
>   - Changed approach to append DISCARD section to generated linker script.
>     - ld no longer emits warning (which was intent of 0d362b35b142) this
>       addresses Nick's v1 feedback.
>     - this is applied to all arches, not just arm64
>   - added commit refs and notes why this doesn't occur in Linus's tree
>     to address Greg's v1 feedback.
>   - added Fixes: 0d362b35b142 requested by Nick
>   - added note to changelog for 7b4537199a4a requested by Nick
>   - build tested on arm64 and x86
>
>    version           works(vmlinux contains Build ID)
>    v4.14.302         x86, arm64
>    v4.14.302.patched x86, arm64
>    v4.19.269         x86, arm64
>    v4.19.269.patched x86, arm64
>    v5.4.227          x86
>    v5.4.227.patched  x86, arm64
>    v5.10.159         x86
>    v5.10.159.patched x86, arm64
>    v5.15.83          x86
>    v5.15.83.patched  x86, arm64
>
> v1: https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/
>
>
>  scripts/Makefile.build | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 17aa8ef2d52a..e3939676eeb5 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -379,6 +379,8 @@ cmd_modversions_S =                                                         \
>         if $(OBJDUMP) -h $@ | grep -q __ksymtab; then                           \
>                 $(call cmd_gensymtypes_S,$(KBUILD_SYMTYPES),$(@:.o=.symtypes))  \
>                     > $(@D)/.tmp_$(@F:.o=.ver);                                 \
> +               echo "SECTIONS { /DISCARD/ : { *(.note.GNU-stack) } }"          \
> +               >> $(@D)/.tmp_$(@F:.o=.ver);                                    \
>                                                                                 \
>                 $(LD) $(KBUILD_LDFLAGS) -r -o $(@D)/.tmp_$(@F) $@               \
>                         -T $(@D)/.tmp_$(@F:.o=.ver);                            \
>
> base-commit: fd6d66840b4269da4e90e1ea807ae3197433bc66
> --
> 2.38.1
>


-- 
Thanks,
~Nick Desaulniers
