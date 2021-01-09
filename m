Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F072F0220
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 18:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbhAIRMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 12:12:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbhAIRMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 12:12:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52DF32343F;
        Sat,  9 Jan 2021 17:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610212293;
        bh=i8Ku1/73rYowfl/ZwVRB3ZZQr3ISV6I1jnO+n26Fujk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d4xvqIKvtTClFnLpzv7E3zlN8gpkDmspUC18y8blQE4mEjl6J6DwpUtkg0AsMFn1w
         ahciPeIFOIkv0TJP21Q5uwxKXvqczOXaqsxkAdxXVwlK56MB8+oMpWb4Nw+NU/RxLy
         4RN1VQdBnnYwcBHRHIoo4cH8g3cXIMNLklV7weqsNXYImcGPtwbDUg1HEEA2ymKlsX
         7VcGOa7iZHIzvZSbFwgEOJKArpB7AGolFYsXhzq3Vczv2+9gDwbED9svjGEmxeDOix
         AdBRfOG7b7GylsjDdJGyv9ZUWnrgrlXqXp0DGM4CA6dhfjb4ciODpHGf0HPh58yrTa
         6gHyWRrhARYqw==
Date:   Sat, 9 Jan 2021 09:11:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        stable@vger.kernel.org
Subject: Re: [PATCH 01/13] fs: avoid double-writing inodes on lazytime
 expiration
Message-ID: <X/njw9b+qqK3vlMs@sol.localdomain>
References: <20210105005452.92521-1-ebiggers@kernel.org>
 <20210105005452.92521-2-ebiggers@kernel.org>
 <20210107144709.GG12990@quack2.suse.cz>
 <20210108090133.GD1438@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108090133.GD1438@lst.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 08, 2021 at 10:01:33AM +0100, Christoph Hellwig wrote:
> > +	/*
> > +	 * If inode has dirty timestamps and we need to write them, call
> > +	 * mark_inode_dirty_sync() to notify filesystem about it.
> > +	 */
> > +	if (inode->i_state & I_DIRTY_TIME &&
> > +	    (wbc->for_sync || wbc->sync_mode == WB_SYNC_ALL ||
> > +	     time_after(jiffies, inode->dirtied_time_when +
> > +			dirtytime_expire_interval * HZ))) {
> 
> If we're touching this area, it would be nice to split this condition
> into a readable helper ala:
> 
> static inline bool inode_needs_timestamp_sync(struct writeback_control *wbc,
> 		struct inode *inode)
> {
> 	if (!(inode->i_state & I_DIRTY_TIME))
> 		return false;
> 	if (wbc->for_sync || wbc->sync_mode == WB_SYNC_ALL)
> 		return true;
> 	return time_after(jiffies, inode->dirtied_time_when +
> 			  dirtytime_expire_interval * HZ);
> }

I didn't end up doing this since it would only be called once, and IMO it's more
readable to keep it inlined next to the comment that explains what's going on.
Especially considering the later patch that drops the check for wbc->for_sync.

-  Eric
