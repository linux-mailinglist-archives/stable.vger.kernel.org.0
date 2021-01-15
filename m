Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8339E2F81D0
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 18:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbhAORMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 12:12:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:41012 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730423AbhAORMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 12:12:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9626EAC24;
        Fri, 15 Jan 2021 17:11:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 803BADA7D5; Fri, 15 Jan 2021 18:09:39 +0100 (CET)
Date:   Fri, 15 Jan 2021 18:09:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        =?iso-8859-1?Q?Ren=E9?= Rebe <rene@exactcode.de>
Subject: Re: [PATCH for 5.10.x] btrfs: shrink delalloc pages instead of full
 inodes
Message-ID: <20210115170939.GI6430@suse.cz>
Reply-To: dsterba@suse.cz
References: <20210114143430.17903-1-dsterba@suse.com>
 <20210115005956.GV4035784@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115005956.GV4035784@sasha-vm>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 14, 2021 at 07:59:56PM -0500, Sasha Levin wrote:
> On Thu, Jan 14, 2021 at 03:34:30PM +0100, David Sterba wrote:
> >From: Josef Bacik <josef@toxicpanda.com>
> >
> >commit e076ab2a2ca70a0270232067cd49f76cd92efe64 upstream.
> >
> >Commit 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in
> >shrink_delalloc") cleaned up how we do delalloc shrinking by utilizing
> >some infrastructure we have in place to flush inodes that we use for
> >device replace and snapshot.  However this introduced a pretty serious
> >performance regression.  To reproduce the user untarred the source
> >tarball of Firefox (360MiB xz compressed/1.5GiB uncompressed), and would
> >see it take anywhere from 5 to 20 times as long to untar in 5.10
> >compared to 5.9. This was observed on fast devices (SSD and better) and
> >not on HDD.
> >
> >The root cause is because before we would generally use the normal
> >writeback path to reclaim delalloc space, and for this we would provide
> >it with the number of pages we wanted to flush.  The referenced commit
> >changed this to flush that many inodes, which drastically increased the
> >amount of space we were flushing in certain cases, which severely
> >affected performance.
> >
> >We cannot revert this patch unfortunately because of 3d45f221ce62
> >("btrfs: fix deadlock when cloning inline extent and low on free
> >metadata space") which requires the ability to skip flushing inodes that
> >are being cloned in certain scenarios, which means we need to keep using
> >our flushing infrastructure or risk re-introducing the deadlock.
> 
> But we don't have 3d45f221ce62 in 5.10, which in turn makes me wonder
> why, as it's tagged for stable.

That commit prevents a revert as a fix, that would be otherwise
considered. The fix for 5.11 also works on 5.10.
> 
> Instead of the backport, I'm going to take:
> 
> e076ab2a2ca7 ("btrfs: shrink delalloc pages instead of full inodes")
> 3d45f221ce62 ("btrfs: fix deadlock when cloning inline extent and low on free metadata space")

That was tagged for stable so ok.

> f2f121ab500d ("btrfs: skip unnecessary searches for xattrs when logging an inode")
> 
> which deals with that missing stable tagged commit too.

Why this one? It's not CCed for stable nor has a Fixes: tag and I don't
see it referenced in any of the above patches as a dependency.
