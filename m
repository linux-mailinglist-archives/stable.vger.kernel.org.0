Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0290D65382C
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 22:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiLUVXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 16:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbiLUVXy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 16:23:54 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B8C23BE8
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 13:23:53 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id n3so11560027pfq.10
        for <stable@vger.kernel.org>; Wed, 21 Dec 2022 13:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Iri2ojL2iCd//4TwTeYLxu8ShFvxy4c4m/jzeM1W6s8=;
        b=ZO75Zqhj2O1DqM/YnGUpEjCsJGOb8uA2UCJCs9MKvvn/oNdnh6V+uvDsWjnGyLqdki
         d8Sjx758v8jWYf/o9CA14d187CdiBWV7E5F7pdgYtNUWBu3sEOdSjZKtVzS1v275F3hX
         EyQPKSsOLfkym9GTXtCV2gPuvWnTW5Mby7fF3TjefjeV3DgSb9nu7DUXAFQusriRHmQo
         +QLF+QjSjHtDIsXLBQMxspaE0zO+VtZp4AurK47eM71YjSMe0gAZZvakGMQzfICTsOmG
         tHI3gehz1GkMI3Qa8c2xt6x+TnpdQyR5wm/Xk5cwmMBtGFywmgmNiYTpj9sWdxAfrbHr
         8FnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Iri2ojL2iCd//4TwTeYLxu8ShFvxy4c4m/jzeM1W6s8=;
        b=kW1GdUbYK5Z3DcCwof+tkNrjnX5sQx9LW3GDBpMYo1IaOqfylsc37DLn2jMrZLdNKb
         a+LJQnVO3ViDrA7Qc6XWKDeNtdkEK406f9/34UW0GOynju+R8sYKDMdJdJiQAV68b0w/
         wgsclPbvc52bZMyYzfA0ZzqatXOd6YHMSJzqvUUtgAi4mKnFPc5+XPdDrViknEmDeX6y
         IsctM4b1XGexe5lG32tOvmtGEnuUgDIv5U9iTMsTcyiVNQQWIf5MID3Ok5aDRViJP6yU
         nQmp/Rzj1DmLvIzKfw92hCcDhkRTNow4Dtx/hX0DB17doy2g8r92zQTI9SngBBG6XiUk
         MBnQ==
X-Gm-Message-State: AFqh2kqi4fQqBP6O8hx1ERMSNE8Vag9U09oRmVUrwiYJsPPtoBBjSFCA
        A0WPqiTiRrL3Tua3VKZscTOLgZK2TojCvXeEbBkorA==
X-Google-Smtp-Source: AMrXdXt6qzsYQwXAA3XDvZvryvUtB3O06iA9zHMaZ+kpsSb/E9YuBZtbbqo/VTIqy1bkKLA6Sh4ki4WRcENtzZMCf1k=
X-Received: by 2002:a63:c50:0:b0:494:7a78:4bb0 with SMTP id
 16-20020a630c50000000b004947a784bb0mr50172pgm.427.1671657832041; Wed, 21 Dec
 2022 13:23:52 -0800 (PST)
MIME-Version: 1.0
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <CAKwvOdnu6KAgFrwmcn9qhjd+WDyW0ZTSyOzOnSsWhQ1rj0Y-6A@mail.gmail.com> <20221221204240.fa3ufl3twepj7357@oracle.com>
In-Reply-To: <20221221204240.fa3ufl3twepj7357@oracle.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 21 Dec 2022 13:23:40 -0800
Message-ID: <CAKwvOdkdPNqPQUOqBLqW7m7i-WB0fJLSSpYTPFXnaitBNatoMw@mail.gmail.com>
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

On Wed, Dec 21, 2022 at 12:42 PM Tom Saeger <tom.saeger@oracle.com> wrote:
>
> On Wed, Dec 21, 2022 at 11:56:33AM -0800, Nick Desaulniers wrote:
> > On Thu, Dec 15, 2022 at 3:18 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> > >
> v1 cover has a simple example if someone has capability/time to adapt to
> another architecture.
>
> - enable CONFIG_MODVERSIONS
> - build
> - readelf -n vmlinux

Keep this info in the commit message.

>
> >
> > >
> > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > after df202b452fe6 which included:
> > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > >
> > > This kernel's KBUILD CONFIG_MODVERSIONS tooling compiles and links .S targets
> > > with relocatable (-r) and now (-z noexecstack)
> > > which results in ld adding a .note.GNU-stack section to .o files.
> > > Final linking of vmlinux should add a .NOTES segment containing the
> > > Build ID, but does NOT (on some architectures like arm64) if a
> > > .note.GNU-stack section is found in .o's supplied during link
> > > of vmlinux.
> >
> > Is that a bug in BFD?  That the behavior differs per target
> > architecture is subtle.  If it's not documented behavior that you can
> > link to, can you file a bug about your findings and cc me?
> > https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils
>
> I've found:
> https://sourceware.org/bugzilla/show_bug.cgi?id=16744
> Comment 1: https://sourceware.org/bugzilla/show_bug.cgi?id=16744#c1
>
> "the semantics of a .note.GNU-stack presence is target-dependent."

I wonder if that's an observation, or a statement of intended design.
A comment in a bug tracker is perhaps less normative than explicit
documentation.

Probably doesn't hurt to include that link in the commit message as well.

>
> corresponding to this commit:
> https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=76f0cad6f4e0fdfc4cfeee135b44b6a090919c60

Seems x86 specific...

>
> So - I'm not entirely sure if this is a bug or expected behavior.

Nick Clifton is cc'ed and might be able to provide more details
(holiday timing permitting; no rush).

>
> >
> > If it is a bug in BFD, then I'm not opposed to working around it, but
> > it would be good to have as precise a report as possible in the commit
> > message if we're going to do hijinks in a stable-only patch for
> > existing tooling.
> >
> > If it's a feature, having some explanation _why_ we get per-arch
> > behavior like this may be helpful for us to link to in the future
> > should this come up again.
>
> While I agree - *I* don't have an explanation (despite digging), only
> work-arounds.

That's fine. That's why I'd rather have a bug on file that we link to
stating we're working around this until we have a more definitive
review of this surprising behavior.  Please file a bug wrt. this
behavior.
https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils

>
> >
> > >
> > > DISCARD .note.GNU-stack sections of .S targets.  Final link of
> >
> > That's going to give them an executable stack again.
> > https://www.redhat.com/en/blog/linkers-warnings-about-executable-stacks-and-segments
> > >> missing .note.GNU-stack section implies executable stack
> > The intent of 0d362be5b142 is that we don't want translation units to
> > have executable stacks, though I do note that assembler sources need
> > to opt in.
> >
> > Is it possible to force a build-id via linker flag `--build-id=sha1`?
> That's an idea - I'll see if this works.

Yes, please try this first.

>
> >
> > If not, can we just use `-z execstack` rather than concatenating a
> > DISCARD section into a linker script?
>
> so... something like v1 patch, but replace `-z noexecstack` with `-z
> execstack`?  And for arm64 only?  I'll try this.

If --build-id doesn't work, then I'd try this. Doesn't have to be
arm64 only if it's difficult to express that.

>
>
> > Either command line flags feel
> > cleaner than modifying a linker script at build time, if they work
> > that is.
>
> well... that entire linker script is generated at build-time.

Fair, but yuck!
-- 
Thanks,
~Nick Desaulniers
