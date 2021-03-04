Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3DC32DCE9
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 23:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhCDWYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 17:24:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:55150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229467AbhCDWYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 17:24:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A261C64FF1;
        Thu,  4 Mar 2021 22:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614896660;
        bh=TdFUuCFCI4O7OYx3gwfS81B/nzcodb1k9TZ5OKOcK+I=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Zzi07XWJRmBorPWAEOPfEUf9URvPZCct8sLKnvVPDajjQlmZhKOO8TmJcHA22BAo1
         8EWBOtLTKRgLmQWUNc47JHMFX6LZ5YTydMV+79PhYMMmGj45i93v+zonftDPAnVKBD
         +Vp/xFB6v+/0Ca1IMY4FB+/BGNHK3wLr2/6Ne8D8mZcXayKZmeMlbkoavWrDUazj0D
         VJfWU9/O5F6ZdfrAfMveDe5VwpdyV5xwPGRjH+dITVkQrOa8nR4fUmdSOtf3CXIcB2
         GFCgs701RHuYxkdEshNDrFTmmaXmeS/eirDmC99Ozp922V9elq4yB18zo/jDRP2aFz
         3XUvdomw1MSeg==
Date:   Thu, 4 Mar 2021 17:24:19 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.11 55/67] btrfs: only let one thread pre-flush
 delayed refs in commit
Message-ID: <YEFdzQOaIdVsN5Li@sashalap>
References: <20210224125026.481804-1-sashal@kernel.org>
 <20210224125026.481804-55-sashal@kernel.org>
 <20210224180820.GY1993@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210224180820.GY1993@twin.jikos.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 07:08:20PM +0100, David Sterba wrote:
>On Wed, Feb 24, 2021 at 07:50:13AM -0500, Sasha Levin wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> [ Upstream commit e19eb11f4f3d3b0463cd897016064a79cb6d8c6d ]
>>
>> I've been running a stress test that runs 20 workers in their own
>> subvolume, which are running an fsstress instance with 4 threads per
>> worker, which is 80 total fsstress threads.  In addition to this I'm
>> running balance in the background as well as creating and deleting
>> snapshots.  This test takes around 12 hours to run normally, going
>> slower and slower as the test goes on.
>>
>> The reason for this is because fsstress is running fsync sometimes, and
>> because we're messing with block groups we often fall through to
>> btrfs_commit_transaction, so will often have 20-30 threads all calling
>> btrfs_commit_transaction at the same time.
>>
>> These all get stuck contending on the extent tree while they try to run
>> delayed refs during the initial part of the commit.
>>
>> This is suboptimal, really because the extent tree is a single point of
>> failure we only want one thread acting on that tree at once to reduce
>> lock contention.
>>
>> Fix this by making the flushing mechanism a bit operation, to make it
>> easy to use test_and_set_bit() in order to make sure only one task does
>> this initial flush.
>>
>> Once we're into the transaction commit we only have one thread doing
>> delayed ref running, it's just this initial pre-flush that is
>> problematic.  With this patch my stress test takes around 90 minutes to
>> run, instead of 12 hours.
>>
>> The memory barrier is not necessary for the flushing bit as it's
>> ordered, unlike plain int. The transaction state accessed in
>> btrfs_should_end_transaction could be affected by that too as it's not
>> always used under transaction lock. Upon Nikolay's analysis in [1]
>> it's not necessary:
>>
>>   In should_end_transaction it's read without holding any locks. (U)
>>
>>   It's modified in btrfs_cleanup_transaction without holding the
>>   fs_info->trans_lock (U), but the STATE_ERROR flag is going to be set.
>>
>>   set in cleanup_transaction under fs_info->trans_lock (L)
>>   set in btrfs_commit_trans to COMMIT_START under fs_info->trans_lock.(L)
>>   set in btrfs_commit_trans to COMMIT_DOING under fs_info->trans_lock.(L)
>>   set in btrfs_commit_trans to COMMIT_UNBLOCK under
>>   fs_info->trans_lock.(L)
>>
>>   set in btrfs_commit_trans to COMMIT_COMPLETED without locks but at this
>>   point the transaction is finished and fs_info->running_trans is NULL (U
>>   but irrelevant).
>>
>>   So by the looks of it we can have a concurrent READ race with a WRITE,
>>   due to reads not taking a lock. In this case what we want to ensure is
>>   we either see new or old state. I consulted with Will Deacon and he said
>>   that in such a case we'd want to annotate the accesses to ->state with
>>   (READ|WRITE)_ONCE so as to avoid a theoretical tear, in this case I
>>   don't think this could happen but I imagine at some point KCSAN would
>>   flag such an access as racy (which it is).
>>
>> [1] https://lore.kernel.org/linux-btrfs/e1fd5cc1-0f28-f670-69f4-e9958b4964e6@suse.com
>>
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> [ add comments regarding memory barrier ]
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop this patch from autosel queue, it's part of a larger series
>that reworks flushing and is not a standalone fix.

Will do, thanks!

-- 
Thanks,
Sasha
