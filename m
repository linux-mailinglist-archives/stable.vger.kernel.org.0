Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE526656C9
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 10:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237885AbjAKJCp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 04:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236707AbjAKJBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 04:01:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8C112768
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 01:01:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A022261AC7
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 09:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DAAC433F0;
        Wed, 11 Jan 2023 09:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673427708;
        bh=xopWUTIxaQuBkujPR0pK0X2KUmShsJQGyOAjccVQsiQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y6av0nIrkN6QL5e88/YgIFYWakXSJa8ur4jAkP91ftqzBKOWNFKwmWWYIEl6B9c5r
         fo6QEOlfonQYNkKDDqZpyPn5/J89zovTqLmNjiU55itMfyKZi0LEfIfBSWEsXGDmRO
         DMeaO53BtqNYErXlCpCA6yRuZePNSvzNraArAj3U=
Date:   Wed, 11 Jan 2023 10:01:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: Re: [PATCH stable] efi: random: combine bootloader provided RNG seed
 with RNG protocol output
Message-ID: <Y756+Pji1SAIsSw2@kroah.com>
References: <20230110160416.2590-1-Jason@zx2c4.com>
 <Y72YyXw5HcsbDac1@kroah.com>
 <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com>
 <Y72bx/IyZ0zl6opA@kroah.com>
 <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
 <CAMj1kXFXxuWuM7gfMxRnF9tKvJSFO=dFMbkn97jPC2gafC7jvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFXxuWuM7gfMxRnF9tKvJSFO=dFMbkn97jPC2gafC7jvA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 11, 2023 at 09:44:34AM +0100, Ard Biesheuvel wrote:
> On Tue, 10 Jan 2023 at 20:45, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Tue, Jan 10, 2023 at 6:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Jan 10, 2023 at 05:57:21PM +0100, Jason A. Donenfeld wrote:
> > > > Thanks! IIRC, this applies to all current stable kernels (now that
> > > > you've sunsetted 4.9).
> > >
> > > It does not apply cleanly to 5.4.y or 4.19.y or 4.14.y so can you
> > > provide working backports for them?
> >
> > I did 5.4.y, which turned out to be hairy than I wanted. You and Ard
> > can decide if you want it or not. I'll leave 4.19 and 4.14 for another
> > day.
> 
> I appreciate you spending the effort, but I'm not convinced this is
> worth the risk. You are backporting new functionality (invoking the
> firmware's RNG protocol at boot on x86), and we might end up
> regressing on systems where the firmware's implementation is
> problematic, even if the patch by itself is correct. This applies to
> mixed mode especially, as the conversion between Win64 and i386
> calling conventions has kicked up some very surprising issues in the
> past.

Yeah, I'll leave this alone on those old kernel trees.  They are
primarily only used in Android (i.e. arm64) systems and shouldn't be
messing with efi.  Those x86 systems still stuck using these old kernels
are fragile enough, and should have moved to newer kernels anyway...

thanks,

greg k-h
