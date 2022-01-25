Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D971049B8AF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 17:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbiAYQcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 11:32:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44964 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350115AbiAYQ1j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 11:27:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32D2E61754;
        Tue, 25 Jan 2022 16:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8017C340E0;
        Tue, 25 Jan 2022 16:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643128058;
        bh=codRe+0ce2jhIVpOFlFMM/+SmveQjryatk3nmIhBJqM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Os49opvaWLapvJLEp0pWKPiSG1ucqnGoKjidLNPh4gSsTSNUH8fvpEUUjTHQE4rI6
         jWt+PAwC2mVHE7tVpvHR1jT/ipdWsrIpmTAhW+cpncnzPDC0xkdgJHjZAbM2NQ8Iwx
         7cLnaTZ4r/NdaMgNanRi8LuRoa1b40mNW+kMoT1Q=
Date:   Tue, 25 Jan 2022 17:27:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: review for 5.16.3-rc2
Message-ID: <YfAk90OPjlpjruV5@kroah.com>
References: <0af17d6952b3677dcd413fefa74b086d5ffb474b.camel@rajagiritech.edu.in>
 <YfAKYWOMdGJ0NxjE@kroah.com>
 <CAG=yYwksvQmEsfRyFiQTbSxUL39WGf7ryHaywtAxgdL1Nt67OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG=yYwksvQmEsfRyFiQTbSxUL39WGf7ryHaywtAxgdL1Nt67OQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 09:49:00PM +0530, Jeffrin Thalakkottoor wrote:
> On Tue, Jan 25, 2022 at 8:04 PM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Jan 25, 2022 at 06:15:46PM +0530, Jeffrin Jose T wrote:
> > > hello greg,
> > >
> > > compile failed for  5.16.3-rc2 related.
> > > a relevent file attached.
> > >
> > > Tested-by : Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
> >
> > But it failed for you, how did you test it?
> 
> i compiled  5.16.3-rc2  related to "make localmodconfig" and  "make  -j4"

So it somehow failed?

> >
> > >
> > >
> >
> > >       char *                     typetab;              /*    24     8 */
> > >
> > >       /* size: 32, cachelines: 1, members: 4 */
> > >       /* sum members: 28, holes: 1, sum holes: 4 */
> > >       /* last cacheline: 32 bytes */
> > > };
> > > struct klp_modinfo {
> > >       Elf64_Ehdr                 hdr;                  /*     0    64 */
> > >       /* --- cacheline 1 boundary (64 bytes) --- */
> > >       Elf64_Shdr *               sechdrs;              /*    64     8 */
> > >       char *                     secstrings;           /*    72     8 */
> > >       unsigned int               symndx;               /*    80     4 */
> > >
> > >       /* size: 88, cachelines: 2, members: 4 */
> > >       /* padding: 4 */
> > >       /* last cacheline: 24 bytes */
> > > };
> > > Segmentation fault
> >
> > What "faulted"?  Look higher up in the log please.
> 
> a top view...
> 
>   CALL    scripts/atomic/check-atomics.sh
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   AR      init/built-in.a
>   LD      vmlinux.o
>   MODPOST vmlinux.symvers
>   MODINFO modules.builtin.modinfo
>   GEN     modules.builtin
>   LD      .tmp_vmlinux.btf
>   BTF     .btf.vmlinux.bin.o
> struct list_head {
>     struct list_head *         next;                 /*     0     8 */
>     struct list_head *         prev;                 /*     8     8 */
> 
>     /* size: 16, cachelines: 1, members: 2 */
>     /* last cacheline: 16 bytes */
> };
> struct hlist_head {
>     struct hlist_node *        first;                /*     0     8 */
> 
>     /* size: 8, cachelines: 1, members: 1 */
>     /* last cacheline: 8 bytes */
> };
> struct hlist_node {
>     struct hlist_node *        next;                 /*     0     8 */
>     struct hlist_node * *      pprev;                /*     8     8 */
> 
>     /* size: 16, cachelines: 1, members: 2 */
>     /* last cacheline: 16 bytes */
> };
> struct callback_head {
>     struct callback_head *     next;                 /*     0     8 */
>     void                       (*func)(struct callback_head *); /*
> 8     8 */
> .
> .
> .
> .
> .
> .

I do not know what is failing, there is no error message here.  Does
5.16.2 build properly for you?

thanks,

greg k-h
