Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAFDE1464C0
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 10:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgAWJpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 04:45:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726103AbgAWJpL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 04:45:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A919217F4;
        Thu, 23 Jan 2020 09:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579772710;
        bh=8Eo6lfID/VSidXUVOi2AIgllUkREaCWWm1hsqGNvKLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=07WJ47GO8dhv2DrGCC4yCTW6bbFFamSwyxc73Qq5v3PyJr3svbMM4joy2pXvYwey2
         g+BXFlYc7XRV0Cs83l1lNdtFeXzkwZyaAxk7ZBy74kWmTbZDVMkUkAWhHuYvHGg4bL
         iDm0NCMHir24M9qMonW+WqpsJlOaYGCbuuuIjOEI=
Date:   Thu, 23 Jan 2020 10:45:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, lwn@lwn.net,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 4.19.98
Message-ID: <20200123094508.GA661791@kroah.com>
References: <20200123084632.GA435419@kroah.com>
 <157976968555.18920.13404367012873725550@skylake-alporthouse-com>
 <20200123092832.GA586919@kroah.com>
 <157977223818.18920.13596879587159565742@skylake-alporthouse-com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157977223818.18920.13596879587159565742@skylake-alporthouse-com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 23, 2020 at 09:37:18AM +0000, Chris Wilson wrote:
> Quoting Greg KH (2020-01-23 09:28:32)
> > On Thu, Jan 23, 2020 at 08:54:45AM +0000, Chris Wilson wrote:
> > > Quoting Greg KH (2020-01-23 08:46:32)
> > > > I'm announcing the release of the 4.19.98 kernel.
> > > 
> > > commit 3e6b472f474accf757e107919f8ee42e7315ac0d
> > > Author: Waiman Long <longman@redhat.com>
> > > Date:   Wed Nov 14 09:55:40 2018 -0800
> > > 
> > >     efi: Fix debugobjects warning on 'efi_rts_work'
> > > 
> > >     [ Upstream commit ef1491e791308317bb9851a0ad380c4a68b58d54 ]
> > > 
> > >     The following commit:
> > > 
> > >       9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")
> > > 
> > >     converted 'efi_rts_work' from an auto variable to a global variable.
> > >     However, when submitting the work, INIT_WORK_ONSTACK() was still used,
> > >     causing the following complaint from debugobjects:
> > > 
> > >       ODEBUG: object 00000000ed27b500 is NOT on stack 00000000c7d38760, but annotated.
> > > 
> > >     Change the macro to just INIT_WORK() to eliminate the warning.
> > > 
> > >     Signed-off-by: Waiman Long <longman@redhat.com>
> > >     Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > >     Acked-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> > >     Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > >     Cc: Peter Zijlstra <peterz@infradead.org>
> > >     Cc: Thomas Gleixner <tglx@linutronix.de>
> > >     Cc: linux-efi@vger.kernel.org
> > >     Fixes: 9dbbedaa6171 ("efi: Make efi_rts_work accessible to efi page fault handler")
> > >     Link: http://lkml.kernel.org/r/20181114175544.12860-2-ard.biesheuvel@linaro.org
> > >     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > >     Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > 
> > > was incorrectly applied to v4.19.41 and causes lockdep complaints for
> > > the onstack efi_rts_work being initialised by INIT_WORK().
> > 
> > Incorrectly how?  Fuzz off, or it shouldn't be applied at all?  Should
> > this be reverted, or just fixed up, and if fixed up, do you have a patch
> > to fix it?
> 
> Just reverted. It applies to 9dbbedaa6171 which moved the efi_rts_work
> off the stack, but is not in v4.19.y, so efi_rts_work is still a local
> and needs the INIT_WORK_ONSTACK annotation.

Ok, thanks, will go revert this and push out a new release with that
fix, thanks for letting me know.

greg k-h
