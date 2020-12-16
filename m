Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89AF2DBA39
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 05:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgLPEy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 23:54:29 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:37456 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725385AbgLPEy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 23:54:29 -0500
Received: from callcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 0BG4rbZV023995
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 23:53:38 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 661D7420280; Tue, 15 Dec 2020 23:53:37 -0500 (EST)
Date:   Tue, 15 Dec 2020 23:53:37 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        Tahsin Erdogan <tahsin@google.com>
Subject: Re: [PATCH] ext4: Fix deadlock with fs freezing and EA inodes
Message-ID: <X9mS0Vz5UyK79cqp@mit.edu>
References: <20201127110649.24730-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127110649.24730-1-jack@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 12:06:49PM +0100, Jan Kara wrote:
> Xattr code using inodes with large xattr data can end up dropping last
> inode reference (and thus deleting the inode) from places like
> ext4_xattr_set_entry(). That function is called with transaction started
> and so ext4_evict_inode() can deadlock against fs freezing like:
> 
> CPU1					CPU2
> 
> removexattr()				freeze_super()
>   vfs_removexattr()
>     ext4_xattr_set()
>       handle = ext4_journal_start()
>       ...
>       ext4_xattr_set_entry()
>         iput(old_ea_inode)
>           ext4_evict_inode(old_ea_inode)
> 					  sb->s_writers.frozen = SB_FREEZE_FS;
> 					  sb_wait_write(sb, SB_FREEZE_FS);
> 					  ext4_freeze()
> 					    jbd2_journal_lock_updates()
> 					      -> blocks waiting for all
> 					         handles to stop
>             sb_start_intwrite()
> 	      -> blocks as sb is already in SB_FREEZE_FS state
> 
> Generally it is advisable to delete inodes from a separate transaction
> as it can consume quite some credits however in this case it would be
> quite clumsy and furthermore the credits for inode deletion are quite
> limited and already accounted for. So just tweak ext4_evict_inode() to
> avoid freeze protection if we have transaction already started and thus
> it is not really needed anyway.
> 
> CC: stable@vger.kernel.org
> Fixes: dec214d00e0d ("ext4: xattr inode deduplication")
> CC: Tahsin Erdogan <tahsin@google.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

thanks, applied.

					- Ted
