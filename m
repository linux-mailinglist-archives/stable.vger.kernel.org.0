Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844A537EDAC
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387944AbhELUlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1382824AbhELTr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 15:47:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F5C56100C;
        Wed, 12 May 2021 19:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620848810;
        bh=pHEDsEIiF7xb0HI2cNnF7HIgdfXVvoEFjM9gav7D0zw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HXNBo3dCKoOv07mUSUPgC4geeynasdd7nKwfC5q69NVZpNxdI3wnGUah7aslxFDcH
         7dOVGltCwkXzFoyg0FatnxH/e1Dt7Fo+vBcjNWZImYYTTChM6V/7ODtyR/QIqhNS7/
         qv3k4+wHeDRxI2f9R13tNYOGJEUrRg5OGov/wMONvWQuFAmxDLTRQ+UkU+2NXMNjWC
         Y6RC83RDSRaCjkpaokWdVrDIGDjJUFFGElfc00xCeepDFuhLZJ7qh41QZLqR9wKvPd
         EVOuY8nMRejbT1wri4dWP12oQ7UC79oM3vl75rxJBhdvC3iBSU6TtGO1R27t1/pRK5
         XOfO24D7Xqpdg==
Date:   Wed, 12 May 2021 12:46:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     heyunlei@hihonor.com, jaegeuk@kernel.org, stable@vger.kernel.org,
        yuchao0@huawei.com
Subject: Re: FAILED: patch "[PATCH] f2fs: fix error handling in
 f2fs_end_enable_verity()" failed to apply to 5.4-stable tree
Message-ID: <YJwwqI47R+FYzsoB@gmail.com>
References: <1620554944177170@kroah.com>
 <YJltfzQoLKumJvpa@gmail.com>
 <YJueVGc6G7nOhYSi@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJueVGc6G7nOhYSi@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 11:22:28AM +0200, Greg KH wrote:
> On Mon, May 10, 2021 at 10:29:35AM -0700, Eric Biggers wrote:
> > On Sun, May 09, 2021 at 12:09:04PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > The patch below does not apply to the 5.4-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > > ------------------ original commit in Linus's tree ------------------
> > > 
> > > >From 3c0315424f5e3d2a4113c7272367bee1e8e6a174 Mon Sep 17 00:00:00 2001
> > > From: Eric Biggers <ebiggers@google.com>
> > > Date: Thu, 4 Mar 2021 21:43:10 -0800
> > > Subject: [PATCH] f2fs: fix error handling in f2fs_end_enable_verity()
> > > 
> > > f2fs didn't properly clean up if verity failed to be enabled on a file:
> > > 
> > > - It left verity metadata (pages past EOF) in the page cache, which
> > >   would be exposed to userspace if the file was later extended.
> > > 
> > > - It didn't truncate the verity metadata at all (either from cache or
> > >   from disk) if an error occurred while setting the verity bit.
> > > 
> > > Fix these bugs by adding a call to truncate_inode_pages() and ensuring
> > > that we truncate the verity metadata (both from cache and from disk) in
> > > all error paths.  Also rework the code to cleanly separate the success
> > > path from the error paths, which makes it much easier to understand.
> > > 
> > > Finally, log a message if f2fs_truncate() fails, since it might
> > > otherwise fail silently.
> > > 
> > > Reported-by: Yunlei He <heyunlei@hihonor.com>
> > > Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
> > > Cc: <stable@vger.kernel.org> # v5.4+
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > Reviewed-by: Chao Yu <yuchao0@huawei.com>
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > 
> > 
> > This is a clean cherry-pick, and it compiles.  So I don't see what the problem
> > is.
> 
> Does not apply for me at all:
> 
> Applying patch f2fs-fix-error-handling-in-f2fs_end_enable_verity.patch
> patching file fs/f2fs/verity.c
> Hunk #1 FAILED at 152.
> 1 out of 1 hunk FAILED -- rejects in file fs/f2fs/verity.c
> Patch f2fs-fix-error-handling-in-f2fs_end_enable_verity.patch does not apply (enforce with -f)
> 
> Can you provide a backport?
> 

Okay I will, but it still cherry-picks cleanly.  I wonder how many other patches
stable is missing for the same reason.

- Eric
