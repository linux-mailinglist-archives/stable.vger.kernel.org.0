Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6181F660C
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 12:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgFKK5G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jun 2020 06:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgFKK5G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Jun 2020 06:57:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CDE62063A;
        Thu, 11 Jun 2020 10:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591873023;
        bh=7UNI3BhfJkzy6rRuk8eNE9nW6kc31cYAViF1VNV0ocA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FjpQnzslOpTEFu5I9prkNjavafOYlv1NEom7yn//+IedQ3Twi95b7y9T9Hv1lDaR4
         HnYLLwL/fBAvDt+VQtLo0o4lFklfAilLl/5cQCdBMECUjVbTiL44iHfRyjjgurkYB3
         Ve5mADgwQoLW27dx3eeTwyJw9QhH4xzOuNjcngEQ=
Date:   Thu, 11 Jun 2020 12:56:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miles Chen <miles.chen@mediatek.com>
Cc:     stable@vger.kernel.org
Subject: Re: Suggest make 'user_access_begin()' do 'access_ok()' to stable
 kernel
Message-ID: <20200611105657.GC3802953@kroah.com>
References: <1591811900.26208.17.camel@mtkswgap22>
 <20200610180249.GA5500@kroah.com>
 <1591839462.26208.24.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591839462.26208.24.camel@mtkswgap22>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 09:37:42AM +0800, Miles Chen wrote:
> On Wed, 2020-06-10 at 20:02 +0200, Greg KH wrote:
> > On Thu, Jun 11, 2020 at 01:58:20AM +0800, Miles Chen wrote:
> > > Hi,
> > > 
> > > I suggest to include the commit: 594cc251fdd0 make 'user_access_begin()'
> > > do 'access_ok()' for CVE-2018-20669.
> > > 
> > > stable version to apply to: kernel-4.14.y and kernel-4.19.y.
> > > 
> > > 
> > > From the discussion below, I checked the latest kernel and found that we
> > > should also apply other 4 patches. (total 5 patches)
> > > https://lkml.org/lkml/2020/5/12/943
> > > 
> > > 
> > > patch list:
> > > commit ab10ae1c3bef lib: Reduce user_access_begin() boundaries in
> > > strncpy_from_user() and strnlen_user()
> > > commit 6e693b3ffecb x86: uaccess: Inhibit speculation past access_ok()
> > > in user_access_begin()
> > > commit 9cb2feb4d21d arch/openrisc: Fix issues with access_ok()
> > > commit 94bd8a05cd4d Fix 'acccess_ok()' on alpha and SH
> > > commit 594cc251fdd0 make 'user_access_begin()' do 'access_ok()'
> > > 
> > > 
> > > Where only commit 6e693b3ffecb does not need backport modifications.
> > > I attach my backport patches in this email.
> > > 
> > > I merged the patches with kernel-4.19.127 and kernel-4.14.183 without
> > > conflicts.
> > > Build with arm64 defconfig and bootup on arm64 QEMU environment.
> > > 
> > > cheers,
> > > Miles
> > 
> > > From ac351de9ddd86ef717a3f89236dc5f6b2a108cc7 Mon Sep 17 00:00:00 2001
> > > From: Linus Torvalds <torvalds@linux-foundation.org>
> > > Date: Fri, 4 Jan 2019 12:56:09 -0800
> > > Subject: [PATCH] BACKPORT: make 'user_access_begin()' do 'access_ok()'
> > > 
> > > upstream commit 594cc251fdd0 ("make 'user_access_begin()' do 'access_ok()'")
> > > 
> > > Originally, the rule used to be that you'd have to do access_ok()
> > > separately, and then user_access_begin() before actually doing the
> > > direct (optimized) user access.
> > > 
> > > But experience has shown that people then decide not to do access_ok()
> > > at all, and instead rely on it being implied by other operations or
> > > similar.  Which makes it very hard to verify that the access has
> > > actually been range-checked.
> > > 
> > > If you use the unsafe direct user accesses, hardware features (either
> > > SMAP - Supervisor Mode Access Protection - on x86, or PAN - Privileged
> > > Access Never - on ARM) do force you to use user_access_begin().  But
> > > nothing really forces the range check.
> > > 
> > > By putting the range check into user_access_begin(), we actually force
> > > people to do the right thing (tm), and the range check vill be visible
> > > near the actual accesses.  We have way too long a history of people
> > > trying to avoid them.
> > > 
> > > Bug: 135368228
> > > Change-Id: I4ca0e4566ea080fa148c5e768bb1a0b6f7201c01
> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > No need for "Bug:" or "Change-Id:" for patches for stable trees.
> > 
> > Also, can you please sign off on these as well?
> > 
> > Can you fix that up and resend?  I'll be glad to queue them up then.
> > 
> > thanks,
> 
> Remove the "Bug/Change-Id" from
> 0001-BACKPORT-make-user_access_begin-do-access_ok.patch.
> 
> Actually, I got the patch from
> https://android-review.googlesource.com/c/kernel/common/+/1114632
> Todd backported the patch but there is no Todd's signed-off-by in his
> patch. Should I add "Signed-off-by: Todd Kjos <tkjos@google.com>" as
> well?

Hm, nah, I'll fix these up, we don't need the Android-specific headers
on the patch either.  Thanks for the backports, I'll go try to queue
them up now...

greg k-h
