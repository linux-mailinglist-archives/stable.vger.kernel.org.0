Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F043765A3D2
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 12:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiLaLxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 06:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiLaLxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 06:53:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F57BC32;
        Sat, 31 Dec 2022 03:53:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7609760AE2;
        Sat, 31 Dec 2022 11:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A552C433EF;
        Sat, 31 Dec 2022 11:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672487585;
        bh=9dX6SMZkf7URduMqFkyukwyM+4YWlGy+pECqZULED+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OV9zfMZ/zniMdE/u7sHoAFANWLEvZWYYFJ1VOKoxSQ3NU3uw9lu4xkaOkRM3TE1Vz
         KB+odNn9whGizoOzpNxxpz5DRNLjjf/RMrzEL0EWr2TFDSJPtOFOyJ9jDZLkTWvZyT
         ZezIbwrTkNsFWH/OIpJ3mMIIeNWks6I7fh2pvCac=
Date:   Sat, 31 Dec 2022 12:53:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Clifton <nickc@redhat.com>,
        Fangrui Song <maskray@google.com>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <Y7Ain9pj5cfl49tI@kroah.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <CAKwvOdnu6KAgFrwmcn9qhjd+WDyW0ZTSyOzOnSsWhQ1rj0Y-6A@mail.gmail.com>
 <20221221204240.fa3ufl3twepj7357@oracle.com>
 <CAKwvOdkdPNqPQUOqBLqW7m7i-WB0fJLSSpYTPFXnaitBNatoMw@mail.gmail.com>
 <20221221235413.xaisboqmr7dkqwn6@oracle.com>
 <20221222000330.57vazcv6blclpe6o@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222000330.57vazcv6blclpe6o@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 06:03:30PM -0600, Tom Saeger wrote:
> On Wed, Dec 21, 2022 at 05:54:24PM -0600, Tom Saeger wrote:
> > On Wed, Dec 21, 2022 at 01:23:40PM -0800, Nick Desaulniers wrote:
> > > On Wed, Dec 21, 2022 at 12:42 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> > > >
> > > > On Wed, Dec 21, 2022 at 11:56:33AM -0800, Nick Desaulniers wrote:
> > > > > On Thu, Dec 15, 2022 at 3:18 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> > > > > >
> > > > v1 cover has a simple example if someone has capability/time to adapt to
> > > > another architecture.
> > > >
> > > > - enable CONFIG_MODVERSIONS
> > > > - build
> > > > - readelf -n vmlinux
> > > 
> > > Keep this info in the commit message.
> > 
> > Ok.
> > 
> > > 
> > > >
> > > > >
> > > > > >
> > > > > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > > > > after df202b452fe6 which included:
> > > > > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > > > > >
> > > > > > This kernel's KBUILD CONFIG_MODVERSIONS tooling compiles and links .S targets
> > > > > > with relocatable (-r) and now (-z noexecstack)
> > > > > > which results in ld adding a .note.GNU-stack section to .o files.
> > > > > > Final linking of vmlinux should add a .NOTES segment containing the
> > > > > > Build ID, but does NOT (on some architectures like arm64) if a
> > > > > > .note.GNU-stack section is found in .o's supplied during link
> > > > > > of vmlinux.
> > > > >
> > > > > Is that a bug in BFD?  That the behavior differs per target
> > > > > architecture is subtle.  If it's not documented behavior that you can
> > > > > link to, can you file a bug about your findings and cc me?
> > > > > https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils
> > > >
> > > > I've found:
> > > > https://sourceware.org/bugzilla/show_bug.cgi?id=16744
> > > > Comment 1: https://sourceware.org/bugzilla/show_bug.cgi?id=16744#c1
> > > >
> > > > "the semantics of a .note.GNU-stack presence is target-dependent."
> > > 
> > > I wonder if that's an observation, or a statement of intended design.
> > > A comment in a bug tracker is perhaps less normative than explicit
> > > documentation.
> > > 
> > > Probably doesn't hurt to include that link in the commit message as well.
> > > 
> > > >
> > > > corresponding to this commit:
> > > > https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=76f0cad6f4e0fdfc4cfeee135b44b6a090919c60
> > > 
> > > Seems x86 specific...
> > > 
> > > >
> > > > So - I'm not entirely sure if this is a bug or expected behavior.
> > > 
> > > Nick Clifton is cc'ed and might be able to provide more details
> > > (holiday timing permitting; no rush).
> > > 
> > > >
> > > > >
> > > > > If it is a bug in BFD, then I'm not opposed to working around it, but
> > > > > it would be good to have as precise a report as possible in the commit
> > > > > message if we're going to do hijinks in a stable-only patch for
> > > > > existing tooling.
> > > > >
> > > > > If it's a feature, having some explanation _why_ we get per-arch
> > > > > behavior like this may be helpful for us to link to in the future
> > > > > should this come up again.
> > > >
> > > > While I agree - *I* don't have an explanation (despite digging), only
> > > > work-arounds.
> > > 
> > > That's fine. That's why I'd rather have a bug on file that we link to
> > > stating we're working around this until we have a more definitive
> > > review of this surprising behavior.  Please file a bug wrt. this
> > > behavior.
> > > https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils
> > > 
> > > >
> > > > >
> > > > > >
> > > > > > DISCARD .note.GNU-stack sections of .S targets.  Final link of
> > > > >
> > > > > That's going to give them an executable stack again.
> > > > > https://www.redhat.com/en/blog/linkers-warnings-about-executable-stacks-and-segments
> > > > > >> missing .note.GNU-stack section implies executable stack
> > > > > The intent of 0d362be5b142 is that we don't want translation units to
> > > > > have executable stacks, though I do note that assembler sources need
> > > > > to opt in.
> > > > >
> > > > > Is it possible to force a build-id via linker flag `--build-id=sha1`?
> > > > That's an idea - I'll see if this works.
> > > 
> > > Yes, please try this first.
> > 
> > --build-id=sha1 is already being supplied during link of vmlinux
> > 
> > > 
> > > >
> > > > >
> > > > > If not, can we just use `-z execstack` rather than concatenating a
> > > > > DISCARD section into a linker script?
> > > >
> > > > so... something like v1 patch, but replace `-z noexecstack` with `-z
> > > > execstack`?  And for arm64 only?  I'll try this.
> > > 
> > > If --build-id doesn't work, then I'd try this. Doesn't have to be
> > > arm64 only if it's difficult to express that.
> > 
> > I went back to only trying this on arch/arm64/kernel/head.S
> > 
> > -z noexecstack doesn't work
> > -z execstack   also doesn't work
> > but removing both does work.
> > 
> > The flow is roughly:
> > 
> > gcc head.S -> head.o
> > ld -z noexecstack head.o -> .tmp_head.o
> > mv -f .tmp_head.o head.o
> > ld -o vmlinux --whole-archive arch/arm64/kernel/head.o ...
> > 
> > If I supply just the compiled head.o, not .tmp_head.o everything works.
> Sorry, this is incorrect.  ld of vmlinux actually failed.
> 
> relocation R_AARCH64_ABS32 against `__crc_kimage_vaddr' can not be used when making a shared object
> arch/arm64/kernel/head.o.orig: in function `__primary_switch':
> .../arch/arm64/kernel/head.S:897:(.idmap.text+0x458): dangerous relocation: unsupported relocation
> .../arch/arm64/kernel/head.S:897:(.idmap.text+0x460): dangerous relocation: unsupported relocation

Ok, I'm confused and don't know what to do here.  I'll drop this from my
mbox queue and wait for a revised fix to show up.

thanks,

greg k-h
