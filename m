Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DE0240CA2
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 20:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHJSGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 14:06:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:50828 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgHJSGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 14:06:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7B4E2AC8B;
        Mon, 10 Aug 2020 18:06:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0FD08DA7D5; Mon, 10 Aug 2020 20:05:08 +0200 (CEST)
Date:   Mon, 10 Aug 2020 20:05:08 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 09/56] btrfs: inode: Verify inode mode to avoid NULL
 pointer dereference
Message-ID: <20200810180508.GG2026@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yoon Jungyeon <jungyeon@gatech.edu>,
        Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>, Sasha Levin <sashal@kernel.org>
References: <20200803121850.306734207@linuxfoundation.org>
 <20200803121850.766021165@linuxfoundation.org>
 <20200804071132.d6awebnvt7gnqfkb@duo.ucw.cz>
 <20200804071836.GA1416416@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804071836.GA1416416@kroah.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 09:18:36AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 04, 2020 at 09:11:32AM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > 
> > > @@ -6993,6 +7010,14 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
> > >  	extent_start = found_key.offset;
> > >  	if (found_type == BTRFS_FILE_EXTENT_REG ||
> > >  	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
> > > +		/* Only regular file could have regular/prealloc extent */
> > > +		if (!S_ISREG(inode->vfs_inode.i_mode)) {
> > > +			ret = -EUCLEAN;
> > > +			btrfs_crit(fs_info,
> > > +		"regular/prealloc extent found for non-regular inode %llu",
> > > +				   btrfs_ino(inode));
> > > +			goto out;
> > > +		}
> > 
> > This sets ret, but function returns err. Fix was already submitted.
> 
> What is the git commit id of that fix?

The fixup hasn't been merged yet, I'll send a pull request in a few days
so it should be in 5.9-rc1.

There's one more fixup of the stable candidate patch, 9f7fec0ba891
("Btrfs: fix selftests failure due to uninitialized i_mode in test
inodes"), so it would make most sense to take all three patches at once.
