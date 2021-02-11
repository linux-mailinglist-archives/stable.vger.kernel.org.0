Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F69318B65
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 14:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhBKNBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 08:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:58118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhBKM7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 07:59:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2D4264E23;
        Thu, 11 Feb 2021 12:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613048319;
        bh=Rp2mERnaPj4kuH9Jsjd7wSt+VHabC+3TVaeZun1SIo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2jKDCosxbVtGR5RnkscJGQyE6WMSAzMcYTzMXqHuFaCghAFDKCVvuQ3vNGiRKEwpY
         4pXGVMNYTI6LSLRaBZOdtnRcpGI/03jExmf7QShncJinGtgLliw+4hK4sOhdOrffyY
         OxwT9U+1Rn0YqH95qzSB1emccWUFH4mDGOp58QW8=
Date:   Thu, 11 Feb 2021 13:58:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Weimer <fweimer@redhat.com>
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz, libc-alpha@sourceware.org,
        linux-api@vger.kernel.org
Subject: Re: LINUX_VERSION_CODE overflow (was: Re: Linux 4.9.256)
Message-ID: <YCUp/ZEl0r+BdtGN@kroah.com>
References: <1612535085125226@kroah.com>
 <87o8gqriba.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o8gqriba.fsf@oldenburg.str.redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 11:48:41AM +0100, Florian Weimer wrote:
> * Greg Kroah-Hartman:
> 
> > I'm announcing the release of the 4.9.256 kernel.
> >
> > This, and the 4.4.256 release are a little bit "different" than normal.
> >
> > This contains only 1 patch, just the version bump from .255 to .256
> > which ends up causing the userspace-visable LINUX_VERSION_CODE to
> > behave a bit differently than normal due to the "overflow".
> >
> > With this release, KERNEL_VERSION(4, 9, 256) is the same as KERNEL_VERSION(4, 10, 0).
> >
> > Nothing in the kernel build itself breaks with this change, but given
> > that this is a userspace visible change, and some crazy tools (like
> > glibc and gcc) have logic that checks the kernel version for different
> > reasons, I wanted to do this release as an "empty" release to ensure
> > that everything still works properly.
> 
> As promised, I looked at this from the glibc perspective.
> 
> A dynamically linked glibc reads the LINUX_VERSION_CODE in the ELF note
> in the vDSO.
> 
> Statically linked binaries use the uname system call and parse the
> release field in struct utsname.  If the uname system call fails, there
> is also /proc fallback, but I believe that path is unused.
> 
> The glibc dynamic linker falls back to uname if the vDSO cannot be
> located.
> 
> The LINUX_VERSION_CODE format is also used in /etc/ld.so.cache.  This is
> difficult to change because a newer ldconfig is supposed to build a
> cache that is compatible with older glibc versions (two-way
> compatibility).  The information in /etc/ld.so.cache is copied from the
> ELF_NOTE_ABI/NT_GNU_ABI_TAG ELF note in the DSOs; the note format is not
> subject to overflows because it uses 32-bit values for the component
> versions.
> 
> glibc uses the current kernel's LINUX_VERSION_CODE for two purposes: for
> its own “kernel too old” check (glibc refuses to start in this case),
> and to skip loading DSOs which have an ELF_NOTE_ABI/NT_GNU_ABI_TAG that
> indicates a higher kernel version than the current kernel.  glibc does
> not use LINUX_VERSION_CODE to detect features or activate workarounds
> for kernel bugs.
> 
> The overflow from 4.9.256 to 4.10.0 means that we might get spurious
> passes on these checks.  Worst case, it can happen that if the system
> has a DSO in two versions on the library search path, one for kernel
> 4.10 and one for kernel 4.9 or earlier (in that order), we now load the
> 4.10 version on a 4.9 kernel.  Previously, loading the 4.10 DSO failed,
> and the fallback version for earlier kernels was used.  That would be
> real breakage.
> 
> Our options in userspace are limited because whatever changes we make to
> glibc today are unlikely to reach people running 4.4 or 4.9 kernels
> anytime soon, if ever.  Clamping the sublevel field of
> LINUX_VERSION_CODE in the vDSO to 255 only benefits dynamically linked
> binaries, but it could be that this is sufficient to paper over this
> issue.
> 
> There's also the question whether these glibc checks are valuable at
> all.  It encourages kernel patching to lie about kernel versions, making
> diagnostics harder (e.g., reporting 3.10 if it's really a 2.6.32 with
> lots of system call backports).  The ELF_NOTE_ABI/NT_GNU_ABI_TAG DSO
> selection is known to cause endless problems with Qt, basically the only
> large-scale user of this feature.  Perhaps we should remove it, but it
> would also break the fallback DSO approach mentioned above.

Thank you for looking into this.  Based on the above, I think we are
safe by keeping the LINUX_VERSION_CODE maxed out at 255, and still
increasing the kernel version number itself (which will be returned by
uname(2).)

I have a report of Android systems parsing the uname(2) string output,
and treating the minor number as an 8bit number, but luckily the
decision based on that will not overflow until 5*256 so we are ok for a
few more years on older Android systems :)

If you run into any reports of problems, please let us know.

thanks again,

greg k-h
