Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8AA47E109
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 10:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347584AbhLWJ71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 04:59:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60332 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239351AbhLWJ71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Dec 2021 04:59:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 372D3B81FBD
        for <stable@vger.kernel.org>; Thu, 23 Dec 2021 09:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A040CC36AE9;
        Thu, 23 Dec 2021 09:59:23 +0000 (UTC)
Date:   Thu, 23 Dec 2021 10:59:20 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ceph: fix up non-directory creation in
 SGID directories" failed to apply to 5.10-stable tree
Message-ID: <20211223095920.634c6mqxyo6fctgq@wittgenstein>
References: <163974910684103@kroah.com>
 <20211217142301.a5y45b54ut3ika4v@wittgenstein>
 <YbynEbAeWpB5A2sj@kroah.com>
 <41797c9b2bfbd977427bd531db2337edfbcb4c92.camel@kernel.org>
 <20211217155758.3f5em47lqntft2we@wittgenstein>
 <YcBgWdVOT6GtICE6@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YcBgWdVOT6GtICE6@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 11:52:09AM +0100, Greg KH wrote:
> On Fri, Dec 17, 2021 at 04:57:58PM +0100, Christian Brauner wrote:
> > On Fri, Dec 17, 2021 at 10:55:23AM -0500, Jeff Layton wrote:
> > > On Fri, 2021-12-17 at 16:04 +0100, Greg KH wrote:
> > > > On Fri, Dec 17, 2021 at 03:23:01PM +0100, Christian Brauner wrote:
> > > > > On Fri, Dec 17, 2021 at 02:51:46PM +0100, gregkh@linuxfoundation.org wrote:
> > > > > > 
> > > > > > The patch below does not apply to the 5.10-stable tree.
> > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > tree, then please email the backport, including the original git commit
> > > > > > id to <stable@vger.kernel.org>.
> > > > > 
> > > > > Oh? I just applied the patch on top of:
> > > > > 
> > > > > commit 272aedd4a305 ("Linux 5.10.87")
> > > > > 
> > > > > without any issues. Not sure what failed for you.
> > > > 
> > > > It fails to build :(
> > > 
> > > I think the issue is probably that capable_wrt_inode_uidgid in kernels
> > > of that era didn't take a userns arg. I had to do a similar fixup for
> > > the RHEL8 backport.
> > 
> > Yes, I think this is:
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 5eddee27a688..8ed881fd7440 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -615,7 +615,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
> >                         mode |= S_ISGID;
> >                 else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
> >                          !in_group_p(dir->i_gid) &&
> > -                        !capable_wrt_inode_uidgid(&init_user_ns, dir, CAP_FSETID))
> > +                        !capable_wrt_inode_uidgid(dir, CAP_FSETID))
> >                         mode &= ~S_ISGID;
> >         } else {
> >                 in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
> > 
> > on top of my patch.
> 
> Can someone submit this in a format that I can apply it in?

You should've gotten a mail:
https://lore.kernel.org/stable/20211223095733.587981-1-brauner@kernel.org

I'm alredy on holidays so only checking my mails sporadically, sorry!
