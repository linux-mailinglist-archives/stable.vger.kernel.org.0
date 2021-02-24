Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59049324397
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 19:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234443AbhBXSLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 13:11:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:40464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233640AbhBXSLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 13:11:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D10B2AAAE;
        Wed, 24 Feb 2021 18:10:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DBF5ADA7B0; Wed, 24 Feb 2021 19:08:20 +0100 (CET)
Date:   Wed, 24 Feb 2021 19:08:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 55/67] btrfs: only let one thread pre-flush
 delayed refs in commit
Message-ID: <20210224180820.GY1993@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20210224125026.481804-1-sashal@kernel.org>
 <20210224125026.481804-55-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224125026.481804-55-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:50:13AM -0500, Sasha Levin wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> [ Upstream commit e19eb11f4f3d3b0463cd897016064a79cb6d8c6d ]
> 
> I've been running a stress test that runs 20 workers in their own
> subvolume, which are running an fsstress instance with 4 threads per
> worker, which is 80 total fsstress threads.  In addition to this I'm
> running balance in the background as well as creating and deleting
> snapshots.  This test takes around 12 hours to run normally, going
> slower and slower as the test goes on.
> 
> The reason for this is because fsstress is running fsync sometimes, and
> because we're messing with block groups we often fall through to
> btrfs_commit_transaction, so will often have 20-30 threads all calling
> btrfs_commit_transaction at the same time.
> 
> These all get stuck contending on the extent tree while they try to run
> delayed refs during the initial part of the commit.
> 
> This is suboptimal, really because the extent tree is a single point of
> failure we only want one thread acting on that tree at once to reduce
> lock contention.
> 
> Fix this by making the flushing mechanism a bit operation, to make it
> easy to use test_and_set_bit() in order to make sure only one task does
> this initial flush.
> 
> Once we're into the transaction commit we only have one thread doing
> delayed ref running, it's just this initial pre-flush that is
> problematic.  With this patch my stress test takes around 90 minutes to
> run, instead of 12 hours.
> 
> The memory barrier is not necessary for the flushing bit as it's
> ordered, unlike plain int. The transaction state accessed in
> btrfs_should_end_transaction could be affected by that too as it's not
> always used under transaction lock. Upon Nikolay's analysis in [1]
> it's not necessary:
> 
>   In should_end_transaction it's read without holding any locks. (U)
> 
>   It's modified in btrfs_cleanup_transaction without holding the
>   fs_info->trans_lock (U), but the STATE_ERROR flag is going to be set.
> 
>   set in cleanup_transaction under fs_info->trans_lock (L)
>   set in btrfs_commit_trans to COMMIT_START under fs_info->trans_lock.(L)
>   set in btrfs_commit_trans to COMMIT_DOING under fs_info->trans_lock.(L)
>   set in btrfs_commit_trans to COMMIT_UNBLOCK under
>   fs_info->trans_lock.(L)
> 
>   set in btrfs_commit_trans to COMMIT_COMPLETED without locks but at this
>   point the transaction is finished and fs_info->running_trans is NULL (U
>   but irrelevant).
> 
>   So by the looks of it we can have a concurrent READ race with a WRITE,
>   due to reads not taking a lock. In this case what we want to ensure is
>   we either see new or old state. I consulted with Will Deacon and he said
>   that in such a case we'd want to annotate the accesses to ->state with
>   (READ|WRITE)_ONCE so as to avoid a theoretical tear, in this case I
>   don't think this could happen but I imagine at some point KCSAN would
>   flag such an access as racy (which it is).
> 
> [1] https://lore.kernel.org/linux-btrfs/e1fd5cc1-0f28-f670-69f4-e9958b4964e6@suse.com
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ add comments regarding memory barrier ]
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this patch from autosel queue, it's part of a larger series
that reworks flushing and is not a standalone fix.
