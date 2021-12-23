Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A28A47E178
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 11:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347617AbhLWKbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 05:31:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52696 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243143AbhLWKbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 05:31:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A5ED61E17
        for <stable@vger.kernel.org>; Thu, 23 Dec 2021 10:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1652C36AE5;
        Thu, 23 Dec 2021 10:31:32 +0000 (UTC)
Date:   Thu, 23 Dec 2021 11:31:29 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christian Brauner <brauner@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v5.10] ceph: fix up non-directory creation in SGID
 directories
Message-ID: <20211223103129.3zc7iswcmaaswmp5@wittgenstein>
References: <https://lore.kernel.org/stable/YcBgWdVOT6GtICE6@kroah.com>
 <20211223095733.587981-1-brauner@kernel.org>
 <YcRNV5z5bkSNu2kr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YcRNV5z5bkSNu2kr@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 23, 2021 at 11:20:07AM +0100, Greg KH wrote:
> On Thu, Dec 23, 2021 at 10:57:33AM +0100, Christian Brauner wrote:
> > From: Christian Brauner <christian.brauner@ubuntu.com>
> > 
> > Ceph always inherits the SGID bit if it is set on the parent inode,
> > while the generic inode_init_owner does not do this in a few cases where
> > it can create a possible security problem (cf. [1]).
> > 
> > Update ceph to strip the SGID bit just as inode_init_owner would.
> > 
> > This bug was detected by the mapped mount testsuite in [3]. The
> > testsuite tests all core VFS functionality and semantics with and
> > without mapped mounts. That is to say it functions as a generic VFS
> > testsuite in addition to a mapped mount testsuite. While working on
> > mapped mount support for ceph, SIGD inheritance was the only failing
> > test for ceph after the port.
> > 
> > The same bug was detected by the mapped mount testsuite in XFS in
> > January 2021 (cf. [2]).
> > 
> > [1]: commit 0fa3ecd87848 ("Fix up non-directory creation in SGID directories")
> > [2]: commit 01ea173e103e ("xfs: fix up non-directory creation in SGID directories")
> > [3]: https://git.kernel.org/fs/xfs/xfstests-dev.git
> > 
> > Cc: stable@vger.kernel.org (adapted to v5.10)
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Reviewed-by: Jeff Layton <jlayton@kernel.org>
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >  fs/ceph/file.c | 18 +++++++++++++++---
> >  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> What is the git commit id in Linus's tree?

commit fd84bfdddd169c219c3a637889a8b87f70a072c2
Author: Christian Brauner <christian.brauner@ubuntu.com>
Date:   Mon Nov 29 12:16:39 2021 +0100

    ceph: fix up non-directory creation in SGID directories
