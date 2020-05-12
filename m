Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40F31D00E6
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 23:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731329AbgELVbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 17:31:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:53672 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgELVbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 17:31:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BD606ACCE;
        Tue, 12 May 2020 21:31:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CB639DA70B; Tue, 12 May 2020 23:30:49 +0200 (CEST)
Date:   Tue, 12 May 2020 23:30:49 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Marcos Paulo de Souza <marcos@mpdesouza.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org, wqu@suse.com,
        fdmanana@suse.com, Marcos Paulo de Souza <mpdesouza@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: send: Emit file capabilities after chown
Message-ID: <20200512213049.GD18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Marcos Paulo de Souza <marcos@mpdesouza.com>, dsterba@suse.com,
        linux-btrfs@vger.kernel.org, wqu@suse.com, fdmanana@suse.com,
        Marcos Paulo de Souza <mpdesouza@suse.com>, stable@vger.kernel.org
References: <20200512144038.29498-1-marcos@mpdesouza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512144038.29498-1-marcos@mpdesouza.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 12, 2020 at 11:40:38AM -0300, Marcos Paulo de Souza wrote:
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
> CC: stable@vger.kernel.org
> Suggested-by: Filipe Manana <fdmanana@suse.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>

Added to misc-next, thanks.
