Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660B12003F3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 10:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731507AbgFSIbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 04:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731495AbgFSIbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 04:31:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEDE320890;
        Fri, 19 Jun 2020 08:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592555471;
        bh=QQXFZXnpJpngYW/pGhmCl4XvPE64YPbRdfTvgqFegpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qffqWBqze3+tVQ1lpAhJbh46jVGC/jbS262duJGU1DBaI71oret6XYIdkkt4nhGEC
         6rousjyX19uJy2TDUSp1ndsDbxXbvEDssrLpbLHoXeVX2j8csCYlXJXpJRkGqVEJiS
         bo9ulU1o+3IbJEZWoeG+jxmsNzDYJuCWPAz24qGQ=
Date:   Fri, 19 Jun 2020 10:11:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     mpdesouza@suse.com, dsterba@suse.com, fdmanana@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: send: emit file capabilities after
 chown" failed to apply to 4.4-stable tree
Message-ID: <20200619081113.GA73176@kroah.com>
References: <1592491523186218@kroah.com>
 <20200619011951.GU1931@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619011951.GU1931@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 09:19:51PM -0400, Sasha Levin wrote:
> On Thu, Jun 18, 2020 at 04:45:23PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > > From 89efda52e6b6930f80f5adda9c3c9edfb1397191 Mon Sep 17 00:00:00 2001
> > From: Marcos Paulo de Souza <mpdesouza@suse.com>
> > Date: Sun, 10 May 2020 23:15:07 -0300
> > Subject: [PATCH] btrfs: send: emit file capabilities after chown
> > 
> > Whenever a chown is executed, all capabilities of the file being touched
> > are lost.  When doing incremental send with a file with capabilities,
> > there is a situation where the capability can be lost on the receiving
> > side. The sequence of actions bellow shows the problem:
> > 
> >  $ mount /dev/sda fs1
> >  $ mount /dev/sdb fs2
> > 
> >  $ touch fs1/foo.bar
> >  $ setcap cap_sys_nice+ep fs1/foo.bar
> >  $ btrfs subvolume snapshot -r fs1 fs1/snap_init
> >  $ btrfs send fs1/snap_init | btrfs receive fs2
> > 
> >  $ chgrp adm fs1/foo.bar
> >  $ setcap cap_sys_nice+ep fs1/foo.bar
> > 
> >  $ btrfs subvolume snapshot -r fs1 fs1/snap_complete
> >  $ btrfs subvolume snapshot -r fs1 fs1/snap_incremental
> > 
> >  $ btrfs send fs1/snap_complete | btrfs receive fs2
> >  $ btrfs send -p fs1/snap_init fs1/snap_incremental | btrfs receive fs2
> > 
> > At this point, only a chown was emitted by "btrfs send" since only the
> > group was changed. This makes the cap_sys_nice capability to be dropped
> > from fs2/snap_incremental/foo.bar
> > 
> > To fix that, only emit capabilities after chown is emitted. The current
> > code first checks for xattrs that are new/changed, emits them, and later
> > emit the chown. Now, __process_new_xattr skips capabilities, letting
> > only finish_inode_if_needed to emit them, if they exist, for the inode
> > being processed.
> > 
> > This behavior was being worked around in "btrfs receive" side by caching
> > the capability and only applying it after chown. Now, xattrs are only
> > emmited _after_ chown, making that workaround not needed anymore.
> > 
> > Link: https://github.com/kdave/btrfs-progs/issues/202
> > CC: stable@vger.kernel.org # 4.4+
> > Suggested-by: Filipe Manana <fdmanana@suse.com>
> > Reviewed-by: Filipe Manana <fdmanana@suse.com>
> > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > Signed-off-by: David Sterba <dsterba@suse.com>
> 
> I took 1ec9a1ae1e30 ("Btrfs: fix unreplayable log after snapshot delete
> + parent dir fsync") to work around the conflict.

Great, thanks for this fixup and the others you merged.

greg k-h
