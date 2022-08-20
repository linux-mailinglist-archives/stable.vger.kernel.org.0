Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B18C59B263
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 09:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiHUHAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 03:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiHUHAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 03:00:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E44E52A975;
        Sun, 21 Aug 2022 00:00:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEB2860C52;
        Sun, 21 Aug 2022 07:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D1CC433B5;
        Sun, 21 Aug 2022 07:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661065208;
        bh=OjJqqtYsGzxt7o5ysqgUTTDuJ4Zsa+5l27r8mWPgINQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e359K93ScFgODYx6qT9CE7B0Yqi1d2MdbL2+X1EqniYcZVPfMB4nr2Wmvi9Uc1QU6
         lGWOKyGEAdRJuG5xJEdrYSikPD+qL5FPRRjE1BR1HVHsb+XmvMjeCrqv4RcZ43STR+
         eWIOP2LTL1EYtRsJ2Z4urrM1yw7jsJWRKC1nUtp8=
Date:   Sat, 20 Aug 2022 20:09:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Fangrui Song <maskray@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 5.10 002/545] x86: link vdso and boot with -z noexecstack
 --no-warn-rwx-segments
Message-ID: <YwEjZaBvqZ+XDFvK@kroah.com>
References: <20220819153829.135562864@linuxfoundation.org>
 <20220819153829.269574566@linuxfoundation.org>
 <CAKwvOd=DQcLbmk0R+h80s4dQ3NrPy+RXqHKnOrAtyam+-QOCyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=DQcLbmk0R+h80s4dQ3NrPy+RXqHKnOrAtyam+-QOCyw@mail.gmail.com>
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 10:13:36AM -0700, Nick Desaulniers wrote:
> Sorry for not reporting this sooner; been out sick all week with COVID.
> 
> On Fri, Aug 19, 2022 at 8:46 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Nick Desaulniers <ndesaulniers@google.com>
> >
> > commit ffcf9c5700e49c0aee42dcba9a12ba21338e8136 upstream.
> >
> 
> <snip>
> 
> > --- a/arch/x86/boot/compressed/Makefile
> > +++ b/arch/x86/boot/compressed/Makefile
> > @@ -68,6 +68,10 @@ LDFLAGS_vmlinux := -pie $(call ld-option
> >  ifdef CONFIG_LD_ORPHAN_WARN
> >  LDFLAGS_vmlinux += --orphan-handling=warn
> >  endif
> > +LDFLAGS_vmlinux += -z noexecstack
> > +ifeq ($(CONFIG_LD_IS_BFD),y)
> 
> 5.10.y is missing CONFIG_LD_IS_BFD. Specifically
> 
> commit 02aff8592204 ("kbuild: check the minimum linker version in Kconfig")
> which first landed in v5.12-rc1.  I'd recommend simply dropping the
> `ifeq` guards; the ld-option guard will still work.  Otherwise GNU BFD
> 2.39 users will observe linker warnings related to rwx-segments.
> 
> Greg, do you mind dropping this patch and I'll supply a v2, or is it
> too late and I should send a patch on top?

I've fixed it up now, thanks!

greg k-h
