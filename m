Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B29133F655
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 18:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhCQRNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 13:13:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231186AbhCQRNC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 13:13:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 291FC64E61;
        Wed, 17 Mar 2021 17:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616001181;
        bh=Yy8+rIl8hJOPF5TcVWrRHzlF76+dwyLxuLeM0ZJyIhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BuOLD1GaPpobOy17d1RyPBBneqsNYqBj77CIJh64IYaTPc1jqM9U8vXBX8CX+aTKG
         4WA0hcHp0mFBapSStOkczlE0gUC6QZFnhsXIxzV08yYTnvIm9pduZ/RePFUeTGLdXP
         isgnhBtQVsp385J8fryAIdEwT/Es2Jg6tdVgRwXU=
Date:   Wed, 17 Mar 2021 18:12:59 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jan Kara <jack@suse.cz>
Cc:     stable@vger.kernel.org, Wolfgang Frisch <wolfgang.frisch@suse.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH stable 4.19.y] ext4: check journal inode extents more
 carefully
Message-ID: <YFI4mwMJNBn8cc3I@kroah.com>
References: <20210317162331.16712-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317162331.16712-1-jack@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 17, 2021 at 05:23:31PM +0100, Jan Kara wrote:
> [Upstream commit ce9f24cccdc019229b70a5c15e2b09ad9c0ab5d1]
> 
> Currently, system zones just track ranges of block, that are "important"
> fs metadata (bitmaps, group descriptors, journal blocks, etc.). This
> however complicates how extent tree (or indirect blocks) can be checked
> for inodes that actually track such metadata - currently the journal
> inode but arguably we should be treating quota files or resize inode
> similarly. We cannot run __ext4_ext_check() on such metadata inodes when
> loading their extents as that would immediately trigger the validity
> checks and so we just hack around that and special-case the journal
> inode. This however leads to a situation that a journal inode which has
> extent tree of depth at least one can have invalid extent tree that gets
> unnoticed until ext4_cache_extents() crashes.
> 
> To overcome this limitation, track inode number each system zone belongs
> to (0 is used for zones not belonging to any inode). We can then verify
> inode number matches the expected one when verifying extent tree and
> thus avoid the false errors. With this there's no need to to
> special-case journal inode during extent tree checking anymore so remove
> it.
> 
> Fixes: 0a944e8a6c66 ("ext4: don't perform block validity checks on the journal inode")
> Reported-by: Wolfgang Frisch <wolfgang.frisch@suse.com>
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Link: https://lore.kernel.org/r/20200728130437.7804-4-jack@suse.cz
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>

Now queued up, thanks!

greg k-h
