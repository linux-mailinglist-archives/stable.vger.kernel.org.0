Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E471CBE0D
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 08:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgEIGbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 02:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgEIGbF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 May 2020 02:31:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57F7221582;
        Sat,  9 May 2020 06:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589005864;
        bh=81utnN4zrAgW72M9wNpzgp3AaCEP64Akx0SQFZXO09s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MCO6u0J+FoEC3UBoCEJQkSUio6TPBDydtlraYjwL0sYAIuUNBJAJBnIcLavhMtGvs
         W8rQEUe3kIH2BtFlQikqC1ETnSturH7OGt+Z7oMtd2jSedl1ZWkxuE7mf5x3zyR89D
         Iek7AlYmNMNFIfgGbJEwfK2P4sr6s1w8TVm+dT/U=
Date:   Sat, 9 May 2020 08:31:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marcos Paulo de Souza <marcos@mpdesouza.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org, wqu@suse.com,
        fdmanana@suse.com, stable@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH] btrfs: send: Emit file capabilities after chown
Message-ID: <20200509063100.GA1684327@kroah.com>
References: <20200508195436.24320-1-marcos@mpdesouza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508195436.24320-1-marcos@mpdesouza.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 08, 2020 at 04:54:36PM -0300, Marcos Paulo de Souza wrote:
> From: Marcos Paulo de Souza <mpdesouza@suse.com>
> 
> [PROBLEM]
> Whenever a chown is executed, all capabilities of the file being touched are
> lost.  When doing incremental send with a file with capabilities, there is a
> situation where the capability can be lost in the receiving side. The
> sequence of actions bellow shows the problem:
> 
> $ mount /dev/sda fs1
> $ mount /dev/sdb fs2
> 
> $ touch fs1/foo.bar
> $ setcap cap_sys_nice+ep fs1/foo.bar
> $ btrfs subvol snap -r fs1 fs1/snap_init
> $ btrfs send fs1/snap_init | btrfs receive fs2
> 
> $ chgrp adm fs1/foo.bar
> $ setcap cap_sys_nice+ep fs1/foo.bar
> 
> $ btrfs subvol snap -r fs1 fs1/snap_complete
> $ btrfs subvol snap -r fs1 fs1/snap_incremental
> 
> $ btrfs send fs1/snap_complete | btrfs receive fs2
> $ btrfs send -p fs1/snap_init fs1/snap_incremental | btrfs receive fs2
> 
> At this point, only a chown was emitted by "btrfs send" since only the group
> was changed. This makes the cap_sys_nice capability to be dropped from
> fs2/snap_incremental/foo.bar
> 
> [FIX]
> Only emit capabilities after chown is emitted. The current code
> first checks for xattrs that are new/changed, emits them, and later emit
> the chown. Now, __process_new_xattr skips capabilities, letting only
> finish_inode_if_needed to emit them, if they exist, for the inode being
> processed.
> 
> This behavior was being worked around in "btrfs receive"
> side by caching the capability and only applying it after chown. Now,
> xattrs are only emmited _after_ chown, making that hack not needed
> anymore.
> 
> Link: https://github.com/kdave/btrfs-progs/issues/202
> Suggested-by: Filipe Manana <fdmanana@suse.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
