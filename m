Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0289B633E
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 14:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbfIRMbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 08:31:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:36768 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725902AbfIRMbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 08:31:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ED106AD2B;
        Wed, 18 Sep 2019 12:31:13 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 07F751E4201; Wed, 18 Sep 2019 14:31:24 +0200 (CEST)
Date:   Wed, 18 Sep 2019 14:31:24 +0200
From:   Jan Kara <jack@suse.cz>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: Fix stale data exposure when readahead races
 with hole punch
Message-ID: <20190918123123.GC31891@quack2.suse.cz>
References: <20190829131034.10563-1-jack@suse.cz>
 <20190829131034.10563-4-jack@suse.cz>
 <20190829155204.GD5354@magnolia>
 <20190830152449.GA25069@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830152449.GA25069@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 30-08-19 17:24:49, Jan Kara wrote:
> On Thu 29-08-19 08:52:04, Darrick J. Wong wrote:
> > On Thu, Aug 29, 2019 at 03:10:34PM +0200, Jan Kara wrote:
> > > Hole puching currently evicts pages from page cache and then goes on to
> > > remove blocks from the inode. This happens under both XFS_IOLOCK_EXCL
> > > and XFS_MMAPLOCK_EXCL which provides appropriate serialization with
> > > racing reads or page faults. However there is currently nothing that
> > > prevents readahead triggered by fadvise() or madvise() from racing with
> > > the hole punch and instantiating page cache page after hole punching has
> > > evicted page cache in xfs_flush_unmap_range() but before it has removed
> > > blocks from the inode. This page cache page will be mapping soon to be
> > > freed block and that can lead to returning stale data to userspace or
> > > even filesystem corruption.
> > > 
> > > Fix the problem by protecting handling of readahead requests by
> > > XFS_IOLOCK_SHARED similarly as we protect reads.
> > > 
> > > CC: stable@vger.kernel.org
> > > Link: https://lore.kernel.org/linux-fsdevel/CAOQ4uxjQNmxqmtA_VbYW0Su9rKRk2zobJmahcyeaEVOFKVQ5dw@mail.gmail.com/
> > > Reported-by: Amir Goldstein <amir73il@gmail.com>
> > > Signed-off-by: Jan Kara <jack@suse.cz>
> > 
> > Is there a test on xfstests to demonstrate this race?
> 
> No, but I can try to create one.

I was experimenting with this but I could not reproduce the issue in my
test VM without inserting artificial delay at appropriate place... So I
don't think there's much point in the fstest for this.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
