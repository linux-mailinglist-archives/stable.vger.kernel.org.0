Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CA09BEF1
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 19:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfHXRNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 13:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725924AbfHXRNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 24 Aug 2019 13:13:31 -0400
Received: from localhost (unknown [8.46.76.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD1A921670;
        Sat, 24 Aug 2019 17:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566666810;
        bh=R7sHU4zQtG6rbSYkQso7eOhf8wN1tHWIK/bhSi3f7Ls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UGy3diyv5n7rzfeBd3pV5c/HLCmK2maIwp47NNkXiszRCIxZIc8t2fCVXwBNi8TvB
         rwDNMVNa/P4/YjDsOasgO9Inq0nF8kGuryTvZw9JSu+gRWJ79wpoPtiePOepFbXnQM
         63UO4iLdO6tzKrrIsxhuZyYNqprOH2EG5EhhPpeo=
Date:   Sat, 24 Aug 2019 10:33:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Alexander.Levin@microsoft.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org,
        amir73il@gmail.com
Subject: Re: [PATCH 0/6] xfs: stable fixes for v4.19.y - circa v4.19.60
Message-ID: <20190824143315.GK1581@sasha-vm>
References: <20190724063451.26190-1-mcgrof@kernel.org>
 <20190823154459.GU16384@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190823154459.GU16384@42.do-not-panic.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 23, 2019 at 03:44:59PM +0000, Luis Chamberlain wrote:
>On Wed, Jul 24, 2019 at 06:34:45AM +0000, Luis Chamberlain wrote:
>> Sasha,
>>
>> you merged my last set of XFS fixes. I asked for one patch to not be
>> merged yet as one issue was not yet properly fixed. After some further
>> review I have identified commits which do fix the kernel crash reported
>> on kz#204223 [0] with generic/388, this patch set applies on top of the
>> last one I sent you.
>>
>> These commits do quite a bit of code refactoring, and the actual fix
>> lies hidden in the last commit by Darrick. Due to the amount of changes
>> trying to extract the fix is riskier than just carring the code
>> refactoring. If we're OK with the code refactor for stable, its my
>> recommendation we keep the changes to match more with upstream and
>> benefit from other fixes. The code refactoring was merged on v4.20 and
>> Darrick's fix is the only fix upstream since the code was merged.
>>
>> If others disagree with this approach please speak up.
>>
>> I've run a full set of fstests against the following sections 12 times and
>> have found no regressions against the baseline:
>>
>> xfs
>> xfs_logdev
>> xfs_nocrc_512
>> xfs_nocrc
>> xfs_realtimedev
>> xfs_reflink_1024
>> xfs_reflink_dev
>>
>> Review from others is appreciated.
>>
>> [0] https://bugzilla.kernel.org/show_bug.cgi?id=204223
>>
>> Allison Henderson (4):
>>   xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
>>   xfs: Add helper function xfs_attr_try_sf_addname
>>   xfs: Add attibute set and helper functions
>>   xfs: Add attibute remove and helper functions
>>
>> Brian Foster (1):
>>   xfs: don't trip over uninitialized buffer on extent read of corrupted
>>     inode
>>
>> Darrick J. Wong (1):
>>   xfs: always rejoin held resources during defer roll
>>
>>  fs/xfs/libxfs/xfs_attr.c       | 231 ++++++++++++++++++---------------
>>  fs/xfs/{ => libxfs}/xfs_attr.h |   2 +
>>  fs/xfs/libxfs/xfs_bmap.c       |  54 +++++---
>>  fs/xfs/libxfs/xfs_bmap.h       |   1 +
>>  fs/xfs/libxfs/xfs_defer.c      |  14 +-
>>  fs/xfs/xfs_dquot.c             |  17 +--
>>  6 files changed, 183 insertions(+), 136 deletions(-)
>>  rename fs/xfs/{ => libxfs}/xfs_attr.h (98%)
>
>*poke*

I was hoping for an ack from the xfs folks...

>BTW I'm off on vacation for a while after today.

I saw the ticket; have fun! :)

--
Thanks,
Sasha
