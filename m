Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C32154147
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 10:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgBFJlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 04:41:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:41638 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbgBFJlt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 04:41:49 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88F9DB3B7;
        Thu,  6 Feb 2020 09:41:47 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 0580A1E0E31; Thu,  6 Feb 2020 10:41:44 +0100 (CET)
Date:   Thu, 6 Feb 2020 10:41:43 +0100
From:   Jan Kara <jack@suse.cz>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix checksum errors with indexed dirs
Message-ID: <20200206094143.GG14001@quack2.suse.cz>
References: <20200205173025.12221-1-jack@suse.cz>
 <BC1AA070-8C16-4399-B4D8-1E9F24D05D8D@dilger.ca>
 <20200206074944.GA14001@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206074944.GA14001@quack2.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu 06-02-20 08:49:44, Jan Kara wrote:
> On Wed 05-02-20 11:04:23, Andreas Dilger wrote:
> > On Feb 5, 2020, at 10:30 AM, Jan Kara <jack@suse.cz> wrote:
> > > DIR_INDEX is not enabled. This is harsh but it should be very rare (it
> > > means someone disabled DIR_INDEX on existing filesystem and didn't run
> > > e2fsck), e2fsck can fix the problem, and we don't want to answer the
> > > difficult question: "Should we rather corrupt the directory more or
> > > should we ignore that DIR_INDEX feature is not set?"
> > 
> > Wouldn't it be better to continue allowing the directory to be read, but
> > not modified?  Otherwise, essentially, metadata_csum is making the
> > filesystem _less_ robust rather than making it more robust.  We don't
> > _need_ the htree index to do a lookup in the directory.
> 
> Hum, I was somewhat afraid it may be a bit fragile but thinking about it
> now, there aren't that many places that need to check. OK, I will try to do
> this and see how it looks.

When I actually implemented this and started testing, I found out why I
didn't want to do it this way :) - the directories are not readable anyway
because checksums are failing for block 0 (which used to be htree root
node). And I'd rather not pile up further hacks in the kernel trying to
work around this. As I wrote in the changelog, chances of anyone hitting
this in practice are rather low and e2fsck can do the right thing...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
