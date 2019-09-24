Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA31BCB2B
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 17:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbfIXPXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 11:23:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:34004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728958AbfIXPXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 11:23:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 457ADAFB6;
        Tue, 24 Sep 2019 15:23:22 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 49C5D1E4427; Tue, 24 Sep 2019 17:23:37 +0200 (CEST)
Date:   Tue, 24 Sep 2019 17:23:37 +0200
From:   Jan Kara <jack@suse.cz>
To:     Boaz Harrosh <openosd@gmail.com>
Cc:     Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        Amir Goldstein <amir73il@gmail.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: Fix stale data exposure when readahead races
 with hole punch
Message-ID: <20190924152337.GE11819@quack2.suse.cz>
References: <20190829131034.10563-1-jack@suse.cz>
 <20190829131034.10563-4-jack@suse.cz>
 <20190829155204.GD5354@magnolia>
 <20190830152449.GA25069@quack2.suse.cz>
 <20190918123123.GC31891@quack2.suse.cz>
 <53b7b7b9-7ada-650c-0a32-291a242601f3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53b7b7b9-7ada-650c-0a32-291a242601f3@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 23-09-19 15:33:05, Boaz Harrosh wrote:
> On 18/09/2019 15:31, Jan Kara wrote:
> <>
> >>> Is there a test on xfstests to demonstrate this race?
> >>
> >> No, but I can try to create one.
> > 
> > I was experimenting with this but I could not reproduce the issue in my
> > test VM without inserting artificial delay at appropriate place... So I
> > don't think there's much point in the fstest for this.
> > 
> > 								Honza
> > 
> 
> If I understand correctly you will need threads that direct-write
> files, then fadvise(WILL_NEED) - in parallel to truncate (punch_hole) these
> files - In parallel to trash caches.
> (Direct-write is so data is not present in cache when you come to WILL_NEED
>  it into the cache, otherwise the xfs b-trees are not exercised. Or are you
>  more worried about the page_cache races?
> )

What I was testing was:
  Fill file with data.
  One process does fadvise(WILLNEED) block by block from end of the file.
  Another process punches hole into the file.

If they race is the right way, following read will show old data instead of
zeros. And as I said I'm able to hit this but only if I add artificial
delay between truncating page cache and actually removing blocks.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
