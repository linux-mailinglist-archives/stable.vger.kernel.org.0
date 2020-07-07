Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FFE216E63
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 16:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgGGOKd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 10:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbgGGOKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 10:10:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF01A2064B;
        Tue,  7 Jul 2020 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594131033;
        bh=fS6mwHW4Azmod0g4YK5OopksQeFsmgWg0DrLuXR70dU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KJpsr+HTeXaS6bPz27rREoX4/rxysooNVSnSdp8xkVwHA1Aoh6PH033UAXtY7b2Un
         cJ40dmwHu/GLO0kNAV4SiCAAoV2AkVMRl+LP9+Co0/HZuSdpbjFP7HGUwEO6W3C2fl
         zZbVftnoZHdUlvtKVV3N2eqG70mZzR97lHP5Wwds=
Date:   Tue, 7 Jul 2020 16:10:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Peter Jones <pjones@redhat.com>, "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: WTF: patch "[PATCH] efi: Make it possible to disable efivar_ssdt
 entirely" was seriously submitted to be applied to the 5.7-stable tree?
Message-ID: <20200707141031.GD4064836@kroah.com>
References: <1593422635243184@kroah.com>
 <CAMj1kXHfKHuOdx1MYUzN2QncN6SO6CYcPPXTFsGR67_CniWfAw@mail.gmail.com>
 <20200629154844.GA512815@kroah.com>
 <CAMj1kXFFPO=csSXhxJ5gEpbzKi4r5q2XeLEJvvTfxFh37PhJDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFFPO=csSXhxJ5gEpbzKi4r5q2XeLEJvvTfxFh37PhJDQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 08:30:21PM +0200, Ard Biesheuvel wrote:
> On Mon, 29 Jun 2020 at 17:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Jun 29, 2020 at 05:18:08PM +0200, Ard Biesheuvel wrote:
> > > On Mon, 29 Jun 2020 at 11:32, <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > The patch below was submitted to be applied to the 5.7-stable tree.
> > > >
> > > > I fail to see how this patch meets the stable kernel rules as found at
> > > > Documentation/process/stable-kernel-rules.rst.
> > > >
> > > > I could be totally wrong, and if so, please respond to
> > > > <stable@vger.kernel.org> and let me know why this patch should be
> > > > applied.  Otherwise, it is now dropped from my patch queues, never to be
> > > > seen again.
> > > >
> > >
> > > Without this patch, there is no way to disable sideloading of SSDTs
> > > via EFI variables, which is a security hole. The fact that this is not
> > > governed by the existing ACPI_TABLE_UPGRADE Kconfig option was an
> > > oversight, and so distros currently have this functionality enabled
> > > inadvertently (although most of them have the lockdown check
> > > incorporated as well)
> > >
> > > SSDTs can manipulate any memory (even kernel memory that has been
> > > mapped read-only) by using SystemMemory OpRegions in _INI AML methods,
> > > and setting an EFI variable once will make this persist across
> > > reboots.
> >
> > All of this was not in the description of the patch at all, how were we
> > supposed to know this?
> >
> 
> Good point. This patch was the result of same off-list discussion, so
> it was obvious to those involved but not for anyone else.
> 
> > And this really looks like a new feature now that you are supporting
> > something that we previously could not do.  To know that this is a "fix"
> > is not obvious :(
> >
> > I'll go queue it up, but how far back should it go?
> >
> 
> The feature was added in v4.8, so as close as we can get to that please.

Ok, got it applied back to 4.9 now, thanks.

greg k-h
