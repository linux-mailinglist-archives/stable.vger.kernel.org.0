Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4982EEF03
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 10:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727449AbhAHJCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 04:02:17 -0500
Received: from verein.lst.de ([213.95.11.211]:43109 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbhAHJCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 04:02:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id B6DD168B05; Fri,  8 Jan 2021 10:01:33 +0100 (CET)
Date:   Fri, 8 Jan 2021 10:01:33 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jan Kara <jack@suse.cz>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH 01/13] fs: avoid double-writing inodes on lazytime
 expiration
Message-ID: <20210108090133.GD1438@lst.de>
References: <20210105005452.92521-1-ebiggers@kernel.org> <20210105005452.92521-2-ebiggers@kernel.org> <20210107144709.GG12990@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107144709.GG12990@quack2.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> +	/*
> +	 * If inode has dirty timestamps and we need to write them, call
> +	 * mark_inode_dirty_sync() to notify filesystem about it.
> +	 */
> +	if (inode->i_state & I_DIRTY_TIME &&
> +	    (wbc->for_sync || wbc->sync_mode == WB_SYNC_ALL ||
> +	     time_after(jiffies, inode->dirtied_time_when +
> +			dirtytime_expire_interval * HZ))) {

If we're touching this area, it would be nice to split this condition
into a readable helper ala:

static inline bool inode_needs_timestamp_sync(struct writeback_control *wbc,
		struct inode *inode)
{
	if (!(inode->i_state & I_DIRTY_TIME))
		return false;
	if (wbc->for_sync || wbc->sync_mode == WB_SYNC_ALL)
		return true;
	return time_after(jiffies, inode->dirtied_time_when +
			  dirtytime_expire_interval * HZ);
}
