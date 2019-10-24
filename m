Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF42AE2EEF
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 12:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405433AbfJXKak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 06:30:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:41766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404801AbfJXKak (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Oct 2019 06:30:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB1CBBF14;
        Thu, 24 Oct 2019 10:30:38 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 492A61E4AA6; Thu, 24 Oct 2019 12:30:38 +0200 (CEST)
Date:   Thu, 24 Oct 2019 12:30:38 +0200
From:   Jan Kara <jack@suse.cz>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 04/22] ext4: Fix credit estimate for final inode freeing
Message-ID: <20191024103038.GN31271@quack2.suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
 <20191003220613.10791-4-jack@suse.cz>
 <20191021010723.GB6799@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021010723.GB6799@mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun 20-10-19 21:07:23, Theodore Y. Ts'o wrote:
> On Fri, Oct 04, 2019 at 12:05:50AM +0200, Jan Kara wrote:
> > Estimate for the number of credits needed for final freeing of inode in
> > ext4_evict_inode() was to small. We may modify 4 blocks (inode & sb for
> > orphan deletion, bitmap & group descriptor for inode freeing) and not
> > just 3.
> 
> The modification for the inode should already be included in the
> calculation for ext4_blocks_for_truncate(), no?  So we only need 3
> extra blocks (sb, inode bitmap, and bg descriptor for the inode).

Yes, but 'extra_credits' is also passed to ext4_xattr_delete_inode() and if
that needs to restart a transaction, it needs to reserve enough for inode
modification in that new transaction. This patch is actually a result of
assertion checks I was getting with more accurate transaction restart
handling implemented later in this series...

I agree we can actually subtract 3 from
ext4_blocks_for_truncate(inode)+extra_credits when starting the initial
transaction as inode changes get double-accounted there. I can do that
and I'll also update the changelog to explain this better.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
