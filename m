Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6CF2EEEE5
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 09:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbhAHIzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 03:55:24 -0500
Received: from verein.lst.de ([213.95.11.211]:43085 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbhAHIzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 03:55:16 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id E6BBB67373; Fri,  8 Jan 2021 09:54:32 +0100 (CET)
Date:   Fri, 8 Jan 2021 09:54:32 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH 01/13] fs: avoid double-writing inodes on lazytime
 expiration
Message-ID: <20210108085432.GA1438@lst.de>
References: <20210105005452.92521-1-ebiggers@kernel.org> <20210105005452.92521-2-ebiggers@kernel.org> <20210107144709.GG12990@quack2.suse.cz> <X/eBPZ+kLGuz2NDC@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/eBPZ+kLGuz2NDC@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 01:46:37PM -0800, Eric Biggers wrote:
> It looks like that's going to work, and it fixes the XFS bug too.
> 
> Note that if __writeback_single_inode() is called from writeback_single_inode()
> (rather than writeback_sb_inodes()), then the inode might not be queued for
> sync, in which case mark_inode_dirty_sync() will move it to a writeback list.
> 
> That's okay because afterwards, writeback_single_inode() will delete the inode
> from any writeback list if it's been fully cleaned, right?  So clean inodes
> won't get left on a writeback list.
> 
> It's confusing because there are comments in writeback_single_inode() and above
> __writeback_single_inode() that say that the inode must not be moved between
> writeback lists.  I take it that those comments are outdated, as they predate
> I_SYNC_QUEUED being introduced by commit 5afced3bf281 ("writeback: Avoid
> skipping inode writeback")?

Yes.  I think we need to update the comment as well.
