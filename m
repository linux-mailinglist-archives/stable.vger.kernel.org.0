Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE76D47FCB7
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 13:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236724AbhL0MqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 07:46:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40078 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233722AbhL0MqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 07:46:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75A5160FE4
        for <stable@vger.kernel.org>; Mon, 27 Dec 2021 12:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 881E5C36AEA;
        Mon, 27 Dec 2021 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640609160;
        bh=AbuUPdSkik+xp/fNHo0nTHVxIuXHk5reig1PGYypCNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2XWLkZkl5ypI0Bqvmy56k+EvXbzQUW7rsLaSK1xO18og2ZLP6YJGntLLHhAhOG+s2
         2PStinkC7sbA6eCSsemWrLPVTWfctNcx9AJDN3yZSnEBsoo9DtsM0zc9PLlxvyZn4f
         MAt58mqlES6Oua3jj38jAjAJznwynwVNXzj0AW4M=
Date:   Mon, 27 Dec 2021 13:45:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v5.10] ceph: fix up non-directory creation in SGID
 directories
Message-ID: <Ycm1hvHTIvk23dHg@kroah.com>
References: <https://lore.kernel.org/stable/YcBgWdVOT6GtICE6@kroah.com>
 <20211223095733.587981-1-brauner@kernel.org>
 <YcRNV5z5bkSNu2kr@kroah.com>
 <20211223103129.3zc7iswcmaaswmp5@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211223103129.3zc7iswcmaaswmp5@wittgenstein>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 11:31:29AM +0100, Christian Brauner wrote:
> On Thu, Dec 23, 2021 at 11:20:07AM +0100, Greg KH wrote:
> > On Thu, Dec 23, 2021 at 10:57:33AM +0100, Christian Brauner wrote:
> > > From: Christian Brauner <christian.brauner@ubuntu.com>
> > > 
> > > Ceph always inherits the SGID bit if it is set on the parent inode,
> > > while the generic inode_init_owner does not do this in a few cases where
> > > it can create a possible security problem (cf. [1]).
> > > 
> > > Update ceph to strip the SGID bit just as inode_init_owner would.
> > > 
> > > This bug was detected by the mapped mount testsuite in [3]. The
> > > testsuite tests all core VFS functionality and semantics with and
> > > without mapped mounts. That is to say it functions as a generic VFS
> > > testsuite in addition to a mapped mount testsuite. While working on
> > > mapped mount support for ceph, SIGD inheritance was the only failing
> > > test for ceph after the port.
> > > 
> > > The same bug was detected by the mapped mount testsuite in XFS in
> > > January 2021 (cf. [2]).
> > > 
> > > [1]: commit 0fa3ecd87848 ("Fix up non-directory creation in SGID directories")
> > > [2]: commit 01ea173e103e ("xfs: fix up non-directory creation in SGID directories")
> > > [3]: https://git.kernel.org/fs/xfs/xfstests-dev.git
> > > 
> > > Cc: stable@vger.kernel.org (adapted to v5.10)
> > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > Reviewed-by: Jeff Layton <jlayton@kernel.org>
> > > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > > ---
> > >  fs/ceph/file.c | 18 +++++++++++++++---
> > >  1 file changed, 15 insertions(+), 3 deletions(-)
> > 
> > What is the git commit id in Linus's tree?
> 
> commit fd84bfdddd169c219c3a637889a8b87f70a072c2
> Author: Christian Brauner <christian.brauner@ubuntu.com>
> Date:   Mon Nov 29 12:16:39 2021 +0100
> 
>     ceph: fix up non-directory creation in SGID directories

Great, now queued up, thanks.

greg k-h
