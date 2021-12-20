Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3412E47A7F6
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 11:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhLTKwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 05:52:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32802 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhLTKwO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 05:52:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74900B80E4D
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 10:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA079C36AE8;
        Mon, 20 Dec 2021 10:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639997532;
        bh=4vW5mdG/McwHgDDEAH6pWIs8xgjlMq61DuTYkN492G4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GURydp8TQP12aWUPhacVrn56wCURIzOhw3a1IQkiJmV3Vi1WJPezDZR9IItj+P/UD
         0KDFvtKwedT1Zji/FIBS/fTo9iiCuEH/HrTZVLZo7OtzdYBNhm2xjjKypRQJ+JHnvC
         cyAKMtukDwu7XFzxwUVTzYJtRreblbRdyDyWAYNY=
Date:   Mon, 20 Dec 2021 11:52:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ceph: fix up non-directory creation in
 SGID directories" failed to apply to 5.10-stable tree
Message-ID: <YcBgWdVOT6GtICE6@kroah.com>
References: <163974910684103@kroah.com>
 <20211217142301.a5y45b54ut3ika4v@wittgenstein>
 <YbynEbAeWpB5A2sj@kroah.com>
 <41797c9b2bfbd977427bd531db2337edfbcb4c92.camel@kernel.org>
 <20211217155758.3f5em47lqntft2we@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217155758.3f5em47lqntft2we@wittgenstein>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 17, 2021 at 04:57:58PM +0100, Christian Brauner wrote:
> On Fri, Dec 17, 2021 at 10:55:23AM -0500, Jeff Layton wrote:
> > On Fri, 2021-12-17 at 16:04 +0100, Greg KH wrote:
> > > On Fri, Dec 17, 2021 at 03:23:01PM +0100, Christian Brauner wrote:
> > > > On Fri, Dec 17, 2021 at 02:51:46PM +0100, gregkh@linuxfoundation.org wrote:
> > > > > 
> > > > > The patch below does not apply to the 5.10-stable tree.
> > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > tree, then please email the backport, including the original git commit
> > > > > id to <stable@vger.kernel.org>.
> > > > 
> > > > Oh? I just applied the patch on top of:
> > > > 
> > > > commit 272aedd4a305 ("Linux 5.10.87")
> > > > 
> > > > without any issues. Not sure what failed for you.
> > > 
> > > It fails to build :(
> > 
> > I think the issue is probably that capable_wrt_inode_uidgid in kernels
> > of that era didn't take a userns arg. I had to do a similar fixup for
> > the RHEL8 backport.
> 
> Yes, I think this is:
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 5eddee27a688..8ed881fd7440 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -615,7 +615,7 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
>                         mode |= S_ISGID;
>                 else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
>                          !in_group_p(dir->i_gid) &&
> -                        !capable_wrt_inode_uidgid(&init_user_ns, dir, CAP_FSETID))
> +                        !capable_wrt_inode_uidgid(dir, CAP_FSETID))
>                         mode &= ~S_ISGID;
>         } else {
>                 in.gid = cpu_to_le32(from_kgid(&init_user_ns, current_fsgid()));
> 
> on top of my patch.

Can someone submit this in a format that I can apply it in?

thanks,

greg k-h
