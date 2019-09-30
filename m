Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91548C21D8
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 15:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbfI3NW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 09:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbfI3NW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Sep 2019 09:22:57 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE6E820842;
        Mon, 30 Sep 2019 13:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569849777;
        bh=NOoz7jQaPArbbpYeIUf5LoAONRe+G8mQg90pCHdXJE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qjt7PLyXp9eVpDmhw/hnN6sL2hZ5krafz2OHqlgn56cQvIuyNq+vMGO8OimYYXNCv
         twrukf6GU64c7rrxRkEyyYpgGb1tQJDOcb/ukkwhNBD6lk8t9YmG+zzOddxXYyYFFp
         go9NFagMHg2UTbw+XykX/Bw+oTCuc0nLSB2BA6Hw=
Date:   Mon, 30 Sep 2019 09:22:55 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Chao Yu <yuchao0@huawei.com>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 4.19 53/63] f2fs: fix to do sanity check on segment
 bitmap of LFS curseg
Message-ID: <20190930132255.GT8171@sasha-vm>
References: <20190929135031.382429403@linuxfoundation.org>
 <20190929135040.450358370@linuxfoundation.org>
 <20190930072157.GB22914@atrey.karlin.mff.cuni.cz>
 <43edc2f2-5b42-0cd7-1573-af77fd9e6678@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <43edc2f2-5b42-0cd7-1573-af77fd9e6678@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 30, 2019 at 03:36:16PM +0800, Chao Yu wrote:
>Hello,
>
>On 2019/9/30 15:21, Pavel Machek wrote:
>> Hi!
>>
>>
>>> +		for (blkofs += 1; blkofs < sbi->blocks_per_seg; blkofs++) {
>>> +			if (!f2fs_test_bit(blkofs, se->cur_valid_map))
>>> +				continue;
>>> +out:
>>> +			f2fs_msg(sbi->sb, KERN_ERR,
>>> +				"Current segment's next free block offset is "
>>> +				"inconsistent with bitmap, logtype:%u, "
>>> +				"segno:%u, type:%u, next_blkoff:%u, blkofs:%u",
>>> +				i, curseg->segno, curseg->alloc_type,
>>> +				curseg->next_blkoff, blkofs);
>>> +			return -EINVAL;
>>> +		}
>>
>> So this is detecting filesystem corruption, right? Should it be
>> -EUCLEAN?
>
>Was fixed in another commit 10f966bbf521 ("f2fs: use generic
>EFSBADCRC/EFSCORRUPTED"). :)

I've queued up a backport of this for 5.2, 4.19, and 4.14, thanks!.

--
Thanks,
Sasha
