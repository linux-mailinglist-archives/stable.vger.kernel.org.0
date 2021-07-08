Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3306F3BF8AE
	for <lists+stable@lfdr.de>; Thu,  8 Jul 2021 13:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbhGHLMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Jul 2021 07:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231522AbhGHLMF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Jul 2021 07:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 080D061606;
        Thu,  8 Jul 2021 11:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625742564;
        bh=O9K4Dy/jCMCCdUkBLxKjOpkYRQKnlt2h/CJQif++SME=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=qknINIEsuRSXOyI6xbCItD101O4iVSmVeuFRkakW69Y+k5b/878uv+w1U6SFqXeiB
         cdRwGF0kCgyfHgHxEh40AQ7njzwXRf57H6emEjsbzajwLvCOtfP9LhWiv8JMlBpARP
         6v5z67ehURIeGKlcqvaHNVyK3Hvp63ME21+N4zMH0INNxzb8n4c2/wAyYe0KJoERpX
         zTEp7P4tjiJhuVeWZmvYRV+eMW19fC8tb0Tbo/5Nb+J411KfCSB4+LBodCCsdv6X8e
         qUEOEJFAFFbxe0S1mlHlkbMpsnSI30qCEbW7BdRq0gCkNR40zPEL9mGEjglHLcxRSq
         3t0LnAeQ+U1lA==
Date:   Thu, 8 Jul 2021 07:09:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     dsterba@suse.cz, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 75/85] btrfs: make Private2 lifespan more
 consistent
Message-ID: <YObc45mLr/L++VKj@sashalap>
References: <20210704230420.1488358-1-sashal@kernel.org>
 <20210704230420.1488358-75-sashal@kernel.org>
 <20210707111005.GI2610@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210707111005.GI2610@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 07, 2021 at 01:10:05PM +0200, David Sterba wrote:
>On Sun, Jul 04, 2021 at 07:04:10PM -0400, Sasha Levin wrote:
>> From: Qu Wenruo <wqu@suse.com>
>>
>> [ Upstream commit 87b4d86baae219a9a79f6b0a1434b2a42fd40d09 ]
>>
>> Currently we use page Private2 bit to indicate that we have ordered
>> extent for the page range.
>>
>> But the lifespan of it is not consistent, during regular writeback path,
>> there are two locations to clear the same PagePrivate2:
>>
>>     T ----- Page marked Dirty
>>     |
>>     + ----- Page marked Private2, through btrfs_run_dealloc_range()
>>     |
>>     + ----- Page cleared Private2, through btrfs_writepage_cow_fixup()
>>     |       in __extent_writepage_io()
>>     |       ^^^ Private2 cleared for the first time
>>     |
>>     + ----- Page marked Writeback, through btrfs_set_range_writeback()
>>     |       in __extent_writepage_io().
>>     |
>>     + ----- Page cleared Private2, through
>>     |       btrfs_writepage_endio_finish_ordered()
>>     |       ^^^ Private2 cleared for the second time.
>>     |
>>     + ----- Page cleared Writeback, through
>>             btrfs_writepage_endio_finish_ordered()
>>
>> Currently PagePrivate2 is mostly to prevent ordered extent accounting
>> being executed for both endio and invalidatepage.
>> Thus only the one who cleared page Private2 is responsible for ordered
>> extent accounting.
>>
>> But the fact is, in btrfs_writepage_endio_finish_ordered(), page
>> Private2 is cleared and ordered extent accounting is executed
>> unconditionally.
>>
>> The race prevention only happens through btrfs_invalidatepage(), where
>> we wait for the page writeback first, before checking the Private2 bit.
>>
>> This means, Private2 is also protected by Writeback bit, and there is no
>> need for btrfs_writepage_cow_fixup() to clear Priavte2.
>>
>> This patch will change btrfs_writepage_cow_fixup() to just check
>> PagePrivate2, not to clear it.
>> The clearing will happen in either btrfs_invalidatepage() or
>> btrfs_writepage_endio_finish_ordered().
>>
>> This makes the Private2 bit easier to understand, just meaning the page
>> has unfinished ordered extent attached to it.
>>
>> And this patch is a hard requirement for the incoming refactoring for
>> how we finished ordered IO for endio context, as the coming patch will
>> check Private2 to determine if we need to do the ordered extent
>> accounting.  Thus this patch is definitely needed or we will hang due to
>> unfinished ordered extent.
>>
>> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop this patch from all autosel stable backports. This is not a
>standalone fix and the CC: stable@ is not there intentionally.

Will do.

>All patches that go through my tree are evaluated for stable backports
>up to 4.4 so it's unlikely the machinery you're using can find something
>I've overlooked.

If you'd like, I can make it ignore fs/btrfs/. The tool is there to help
maintainers who aren't as diligent w.r.t tagging patches for stable, not
to create extra noise for something.

We can ofcourse also keep the current workflow if you think that it's
helpful in some way.

>The patches that autosel picks and do not get a complain^Wreply for me
>are below the bar I'd consider it for stable but if after another review
>the patch "does no harm", I let it pass because you're obviously
>handling the backports. I would not tag it myself to avoid increasing
>load of Greg with patches that don't matter much.

I'd say don't worry about this side of things: we're trying to get any
fixes in, without too much regard to whether the fix is for something
"big" or "small". We'd prefer to go over extra patches here in exchange
for a much better user experience :)

-- 
Thanks,
Sasha
