Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA862EF4F9
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 16:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbhAHPig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 10:38:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:55632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbhAHPig (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Jan 2021 10:38:36 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2A4A1ACC6;
        Fri,  8 Jan 2021 15:37:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B5AACDA6E9; Fri,  8 Jan 2021 16:36:03 +0100 (CET)
Date:   Fri, 8 Jan 2021 16:36:03 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org,
        =?iso-8859-1?Q?Ren=E9?= Rebe <rene@exactcode.de>
Subject: Re: [PATCH v3] btrfs: shrink delalloc pages instead of full inodes
Message-ID: <20210108153603.GA6430@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org,
        =?iso-8859-1?Q?Ren=E9?= Rebe <rene@exactcode.de>
References: <5618514ccb0d1e823fe5ae41b3da6e1e76ddd792.1610057243.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5618514ccb0d1e823fe5ae41b3da6e1e76ddd792.1610057243.git.josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 05:08:30PM -0500, Josef Bacik wrote:
> Commit 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in
> shrink_delalloc") cleaned up how we do delalloc shrinking by utilizing
> some infrastructure we have in place to flush inodes that we use for
> device replace and snapshot.  However this introduced a pretty serious
> performance regression.  To reproduce the user untarred the source
> tarball of Firefox, and would see it take anywhere from 5 to 20 times as
> long to untar in 5.10 compared to 5.9.
> 
> The root cause is because before we would generally use the normal
> writeback path to reclaim delalloc space, and for this we would provide
> it with the number of pages we wanted to flush.  The referenced commit
> changed this to flush that many inodes, which drastically increased the
> amount of space we were flushing in certain cases, which severely
> affected performance.
> 
> We cannot revert this patch unfortunately because of
> 
> 	btrfs: fix deadlock when cloning inline extent and low on free
> 		metadata space
> 
> which requires the ability to skip flushing inodes that are being cloned
> in certain scenarios, which means we need to keep using our flushing
> infrastructure or risk re-introducing the deadlock.
> 
> Instead to fix this problem we can go back to providing
> btrfs_start_delalloc_roots with a number of pages to flush, and then set
> up a writeback_control and utilize sync_inode() to handle the flushing
> for us.  This gives us the same behavior we had prior to the fix, while
> still allowing us to avoid the deadlock that was fixed by Filipe.  I
> redid the users original test and got the following results on one of
> our test machines (256gib of ram, 56 cores, 2tib Intel NVME drive)
> 
> 5.9		0m54.258s
> 5.10		1m26.212s
> 5.10+patch	0m38.800s
> 
> 5.10+patch is significantly faster than plain 5.9 because of my patch
> series "Change data reservations to use the ticketing infra" which
> contained the patch that introduced the regression, but generally
> improved the overall ENOSPC flushing mechanisms.
> 
> CC: stable@vger.kernel.org # 5.10
> Reported-by: René Rebe <rene@exactcode.de>
> Fixes: 38d715f494f2 ("btrfs: use btrfs_start_delalloc_roots in shrink_delalloc")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> v2->v3:
> - modified the changelog to add information about the patches referenced, and
>   detail the specs of the machine I used for the performance numbers.

Great, thanks. Meanwhile I did some other tests, 'dbench 32' is
basically the same and async random write with 'fio --rw=randwrite
--size=4g --ioengine=libaio' as well.

I'm going to send another rc3 pull request with this patch so we can get
it to 5.10 stable.
