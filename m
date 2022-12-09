Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F47A647E01
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 07:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229488AbiLIGud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 01:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLIGuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 01:50:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA17F14D03;
        Thu,  8 Dec 2022 22:50:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65666B827BA;
        Fri,  9 Dec 2022 06:50:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF13C433EF;
        Fri,  9 Dec 2022 06:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670568628;
        bh=gcLMa1Cxszp3uT4vPc3LGbMk1Uia/HbaSqKQNjIwtwY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bNrMh0j9QtIgyTYma47eveES/A/s92omIKjQMxfnqmqbc3nC4MEH0ot0Vs0CelvaL
         EMg/EKx1mjsx4+I5DRTX51otmB2lzpgxHPN/PjGpJGaf0a2dXH67rxJHYYcKjT+rnn
         FJtvdVUvPyQpzBIMvwCw1l5OUSGy/YWdrqZZgfRw=
Date:   Fri, 9 Dec 2022 07:50:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Clifton <nickc@redhat.com>,
        Jose Marchesi <jose.marchesi@oracle.com>,
        stable@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 5.15 5.10 5.4 1/1] arm64: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <Y5Lasd7oID6kIiwM@kroah.com>
References: <cover.1670358255.git.tom.saeger@oracle.com>
 <9e387b71ce45d8b7fe9f2b9c52694e3df33f0c7a.1670358255.git.tom.saeger@oracle.com>
 <Y5JKYA53GnPrsr+f@kroah.com>
 <20221208233106.jvss2x4unqvijhgg@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208233106.jvss2x4unqvijhgg@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 05:31:06PM -0600, Tom Saeger wrote:
> On Thu, Dec 08, 2022 at 09:34:40PM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Dec 06, 2022 at 01:43:08PM -0700, Tom Saeger wrote:
> > > Backport of: 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > > breaks arm64 Build ID when CONFIG_MODVERSIONS=y.
> > > 
> > > CONFIG_MODVERSIONS adds extra tooling to calculate symbol versions.
> > > This kernel's KBUILD tooling uses both
> > > relocatable (-r) and (-z noexecstack) to link head.o
> > > which results in ld adding a .note.GNU-stack section.
> > > Final linking of vmlinux should add a .NOTES segment containing the
> > > Build ID, but does NOT if head.o has a .note.GNU-stack section.
> > > 
> > > Selectively remove -z noexecstack from head.o's KBUILD_LDFLAGS to
> > > prevent .note.GNU-stack from being added to head.o.  Final link of
> > > vmlinux then properly adds .NOTES segment containing Build ID that can
> > > be read using tools like 'readelf -n'.
> > > 
> > > Cc: <stable@vger.kernel.org> # 5.15, 5.10, 5.4
> > > Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> > > ---
> > >  arch/arm64/kernel/Makefile | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > 
> > Why isn't this needed in Linus's tree?
> 
> 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> 
> was merged after
> 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> 
> Linus's tree never had -z noexecstack with these same KBUILD rules.

Then it needs to say that, in detail, in this changelog please.

> > And why not cc: everyone involved in this, I would need acks from
> > maintainers to be able to accept this...
> 
> Fair request.
> 
> Between ~5.3 and 5.19-rc1 cherry-picking 
> 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> and building arm64 with CONFIG_MODVERSIONS=y
> results in vmlinux missing Build ID
> 
> head.S is compiled to head.o
> head.o is linked (ld) with -r and -z noexecstack  which adds .note.GNU-stack section in head.o
> head.o is then linked again with vmlinux (resulting vmlinux is missing .NOTE segment)
> 
> 
> Can folks confirm/deny ld behavior is expected (arm64)?
> And whether the above patch would be an acceptable fix for these kernel
> versions?
> 
> repro test in cover letter: https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/#r

Please resend, no need for a cover letter for just one patch, and
include all of the needed info in the changelog itself.

thanks,

greg k-h
