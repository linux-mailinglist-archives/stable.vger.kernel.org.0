Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8C72A1D40
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 11:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgKAK3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 05:29:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbgKAK3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 1 Nov 2020 05:29:35 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53C9E20709;
        Sun,  1 Nov 2020 10:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604226574;
        bh=UOlXrUNgm2jyspTnQm6v1OStDWu3z6qFES7jxpfoSI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fo6UCNlmaykNMdGjTvL48cFMlWS9RKr5f6r2XAS4Mnt9s8UeY3yho97zGgBW5ZL8K
         xM8o+1EZ5o5v+DNthjHD7q7VLeOOcQYXzjC+uCdKmrCyVHv1wCY3TKb1xJjajgqW5Z
         pa4G1nQ01OCZQew8ov2lQ4ZXfW0arwUJEB+47oVg=
Date:   Sun, 1 Nov 2020 11:30:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 4.19] fscrypt: return -EXDEV for incompatible rename or
 link into encrypted dir
Message-ID: <20201101103018.GA2558892@kroah.com>
References: <20201031183551.202400-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031183551.202400-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 11:35:51AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit f5e55e777cc93eae1416f0fa4908e8846b6d7825 upstream.
> [Please apply to 4.19-stable.  This is an important fix to have,
> and it will be needed for xfstest generic/398 to pass if
> https://lkml.kernel.org/r/20201031054141.695517-1-ebiggers@kernel.org
> is applied.  This is a clean cherry-pick to 4.19, but it doesn't apply
> to 4.14 and earlier; different backports would be needed for that.]
> 
> Currently, trying to rename or link a regular file, directory, or
> symlink into an encrypted directory fails with EPERM when the source
> file is unencrypted or is encrypted with a different encryption policy,
> and is on the same mountpoint.  It is correct for the operation to fail,
> but the choice of EPERM breaks tools like 'mv' that know to copy rather
> than rename if they see EXDEV, but don't know what to do with EPERM.
> 
> Our original motivation for EPERM was to encourage users to securely
> handle their data.  Encrypting files by "moving" them into an encrypted
> directory can be insecure because the unencrypted data may remain in
> free space on disk, where it can later be recovered by an attacker.
> It's much better to encrypt the data from the start, or at least try to
> securely delete the source data e.g. using the 'shred' program.
> 
> However, the current behavior hasn't been effective at achieving its
> goal because users tend to be confused, hack around it, and complain;
> see e.g. https://github.com/google/fscrypt/issues/76.  And in some cases
> it's actually inconsistent or unnecessary.  For example, 'mv'-ing files
> between differently encrypted directories doesn't work even in cases
> where it can be secure, such as when in userspace the same passphrase
> protects both directories.  Yet, you *can* already 'mv' unencrypted
> files into an encrypted directory if the source files are on a different
> mountpoint, even though doing so is often insecure.
> 
> There are probably better ways to teach users to securely handle their
> files.  For example, the 'fscrypt' userspace tool could provide a
> command that migrates unencrypted files into an encrypted directory,
> acting like 'shred' on the source files and providing appropriate
> warnings depending on the type of the source filesystem and disk.
> 
> Receiving errors on unimportant files might also force some users to
> disable encryption, thus making the behavior counterproductive.  It's
> desirable to make encryption as unobtrusive as possible.
> 
> Therefore, change the error code from EPERM to EXDEV so that tools
> looking for EXDEV will fall back to a copy.
> 
> This, of course, doesn't prevent users from still doing the right things
> to securely manage their files.  Note that this also matches the
> behavior when a file is renamed between two project quota hierarchies;
> so there's precedent for using EXDEV for things other than mountpoints.
> 
> xfstests generic/398 will require an update with this change.
> 
> [Rewritten from an earlier patch series by Michael Halcrow.]
> 
> Cc: Michael Halcrow <mhalcrow@google.com>
> Cc: Joe Richey <joerichey@google.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/filesystems/fscrypt.rst | 12 ++++++++++--
>  fs/crypto/hooks.c                     |  6 +++---
>  fs/crypto/policy.c                    |  3 +--
>  include/linux/fscrypt.h               |  4 ++--
>  4 files changed, 16 insertions(+), 9 deletions(-)

All 4 backports now queued up, thanks!

greg k-h
