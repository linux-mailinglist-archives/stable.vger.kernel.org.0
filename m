Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2071348D9B7
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 15:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiAMObz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 09:31:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52284 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiAMObz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 09:31:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F136FB82011;
        Thu, 13 Jan 2022 14:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22134C36AEA;
        Thu, 13 Jan 2022 14:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642084312;
        bh=E70HnYbnMJdzhG2CRSxrMh0xvse1sxYz5rbqdIl2JgI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RThv5Xh7JFOAyBuEaeYNwB8F4o8u19b4xrIFajVQgfGFsUAWJIiR8PbNzhRs9iN28
         5PQZlkVlQRsYRO3xcEKaGjLnJBQrIVdq8ieDQ+HwhXOsw001O2W8OdZKyy5fS7iJ87
         0ttE0N3ISym4GQFNBXlcIDLcNSoYL2+uSqHsPMAg=
Date:   Thu, 13 Jan 2022 15:31:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@suse.de>
Cc:     stable-commits@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Patch "x86/mce: Remove noinstr annotation from mce_setup()" has
 been added to the 5.15-stable tree
Message-ID: <YeA31erBrPKu755G@kroah.com>
References: <164207874020173@kroah.com>
 <YeAnLb7OkkmTWtf/@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeAnLb7OkkmTWtf/@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 02:20:45PM +0100, Borislav Petkov wrote:
> On Thu, Jan 13, 2022 at 01:59:00PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     x86/mce: Remove noinstr annotation from mce_setup()
> > 
> > to the 5.15-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      x86-mce-remove-noinstr-annotation-from-mce_setup.patch
> > and it can be found in the queue-5.15 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> > From 487d654db3edacc31dee86b10258cc740640fad8 Mon Sep 17 00:00:00 2001
> > From: Borislav Petkov <bp@suse.de>
> > Date: Tue, 5 Oct 2021 19:54:47 +0200
> > Subject: x86/mce: Remove noinstr annotation from mce_setup()
> > 
> > From: Borislav Petkov <bp@suse.de>
> > 
> > commit 487d654db3edacc31dee86b10258cc740640fad8 upstream.
> > 
> > Instead, sandwitch around the call which is done in noinstr context and
> > mark the caller - mce_gather_info() - as noinstr.
> > 
> > Also, document what the whole instrumentation strategy with #MC is going
> > to be in the future and where it all is supposed to be going to.
> > 
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Link: https://lore.kernel.org/r/20211208111343.8130-5-bp@alien8.de
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  arch/x86/kernel/cpu/mce/core.c |   26 ++++++++++++++++++++------
> >  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> I wonder how that can ever be stable material... or are you backporting
> something else and you need this?

I was trying to get rid of this build warning I see with 5.16:
	vmlinux.o: warning: objtool: mce_setup()+0x22: call to memset() leaves .noinstr.text section
	vmlinux.o: warning: objtool: do_machine_check()+0x9b: call to mce_gather_info() leaves .noinstr.text section

But with this commit applied I now see this:
	vmlinux.o: warning: objtool: mce_gather_info()+0x5f: call to v8086_mode.constprop.0() leaves .noinstr.text section
	vmlinux.o: warning: objtool: do_machine_check()+0x183: call to memset() leaves .noinstr.text section

So it didn't help that much.

Any hints on how to get rid of this?  More patches in the series this
one came from?

thanks,

greg k-h
