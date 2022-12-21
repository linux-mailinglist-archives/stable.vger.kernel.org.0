Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC936530AF
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 13:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiLUMTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 07:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiLUMTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 07:19:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2371220DD;
        Wed, 21 Dec 2022 04:19:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A9B461792;
        Wed, 21 Dec 2022 12:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68142C433D2;
        Wed, 21 Dec 2022 12:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671625174;
        bh=pthlogEooDT8pRMqu/J+s3iAWMMQL8B8jIrFyvSiPCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tY5pRXgPybIyKKTS6VpOarrkA9PBVNAmZvFCJJTwZAShEaNsskzK01hTqiOctDeey
         Jr2sQPbwmFW8PDB6xSKIsrnr8yxd1G8Ljq2AJ3WPkg9BzSa0kapE2pIRTiWTRgZacH
         nXnVve8gfcGcgjnAfx0EdiTvM+x+MvTF1FCPhNpiZpO8LgmhgD+GtmaYYIfSdK/Jxj
         WBEA1lhIXQcAg9FkaMjBMSTZEpbnoMhxrkNFt47NT8HFMKf2BsRsZB1TdxxsGhMSXD
         Cdvn1KqTb/aGAnwBiEbocggxBoqXXUzLMg7I9kARDKVnM0g74+/4I9xFYGs4BA1NkB
         wxeNFpKPoVaww==
Date:   Wed, 21 Dec 2022 07:19:33 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <djwong@kernel.org>, hch@infradead.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.1 13/16] iomap: write iomap validity checks
Message-ID: <Y6L51cR5EZ//cw8J@sashalap>
References: <20221220012053.1222101-1-sashal@kernel.org>
 <20221220012053.1222101-13-sashal@kernel.org>
 <20221220040112.GG1971568@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221220040112.GG1971568@dread.disaster.area>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 20, 2022 at 03:01:12PM +1100, Dave Chinner wrote:
>On Mon, Dec 19, 2022 at 08:20:50PM -0500, Sasha Levin wrote:
>> From: Dave Chinner <dchinner@redhat.com>
>>
>> [ Upstream commit d7b64041164ca177170191d2ad775da074ab2926 ]
>>
>> A recent multithreaded write data corruption has been uncovered in
>> the iomap write code. The core of the problem is partial folio
>> writes can be flushed to disk while a new racing write can map it
>> and fill the rest of the page:
>>
>> writeback			new write
>>
>> allocate blocks
>>   blocks are unwritten
>> submit IO
>> .....
>> 				map blocks
>> 				iomap indicates UNWRITTEN range
>> 				loop {
>> 				  lock folio
>> 				  copyin data
>> .....
>> IO completes
>>   runs unwritten extent conv
>>     blocks are marked written
>> 				  <iomap now stale>
>> 				  get next folio
>> 				}
>>
>> Now add memory pressure such that memory reclaim evicts the
>> partially written folio that has already been written to disk.
>>
>> When the new write finally gets to the last partial page of the new
>> write, it does not find it in cache, so it instantiates a new page,
>> sees the iomap is unwritten, and zeros the part of the page that
>> it does not have data from. This overwrites the data on disk that
>> was originally written.
>>
>> The full description of the corruption mechanism can be found here:
>>
>> https://lore.kernel.org/linux-xfs/20220817093627.GZ3600936@dread.disaster.area/
>>
>> To solve this problem, we need to check whether the iomap is still
>> valid after we lock each folio during the write. We have to do it
>> after we lock the page so that we don't end up with state changes
>> occurring while we wait for the folio to be locked.
>>
>> Hence we need a mechanism to be able to check that the cached iomap
>> is still valid (similar to what we already do in buffered
>> writeback), and we need a way for ->begin_write to back out and
>> tell the high level iomap iterator that we need to remap the
>> remaining write range.
>>
>> The iomap needs to grow some storage for the validity cookie that
>> the filesystem provides to travel with the iomap. XFS, in
>> particular, also needs to know some more information about what the
>> iomap maps (attribute extents rather than file data extents) to for
>> the validity cookie to cover all the types of iomaps we might need
>> to validate.
>>
>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This commit is not a standalone backport candidate. It is a pure
>infrastructure change that does nothing by itself except to add more
>code that won't get executed. There are another 7-8 patches that
>need to be backported along with this patch to fix the data
>corruption that is mentioned in this commit.
>
>I'd stronly suggest that you leave this whole series of commits to
>the XFS LTS maintainers to backport if they so choose to - randomly
>backporting commits from the middle of the series only makes their
>job more complex....

Ack, I'll drop it, thanks!

-- 
Thanks,
Sasha
