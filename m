Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAC53127F5
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 23:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBGWqz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 17:46:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbhBGWqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Feb 2021 17:46:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 057FB64DC3;
        Sun,  7 Feb 2021 22:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612737974;
        bh=ePzdFyEPP7uF5+gbaAbGfirvexg5ZXrhjAlJNzMj4Z4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O+ajKfDvrfP+SwqvJ4ZPOLuqx8GiM9yZClsARns+SXi3NI5IX9wF8+I6gaf0QvNUX
         jda7hLBFZ5eJX7axalrS6ogwxRhmf14U22qeUZ8BnldS3JCs5BAHKga9fn8zTvm7Ki
         e3nvL08kqpYduei6g7HXOplP9uEOExv8WY3w/KI1ivlh79dcjY+rpfX0YU+BZ7FUMI
         9WBqhG8Z1Otingk2BlXvY8Rg3R5Bs8WH3i/XPi7K14vrg0cnDhruR0lYHjLx2ZQ+YG
         0NDUfz0nb/X1ixAL3HUM3i3t9nPKoI4srub7Pt/skIwe5dDzssNkJu4gkdGIIlu7aZ
         NlAtorZcXikaA==
Date:   Sun, 7 Feb 2021 17:46:12 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jeffle Xu <jefflexu@linux.alibaba.com>, stable@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] virtio-blk: close udev startup race condition as
 default groups
Message-ID: <20210207224612.GY4035784@sasha-vm>
References: <20210207114656.32141-1-jefflexu@linux.alibaba.com>
 <20210207114656.32141-2-jefflexu@linux.alibaba.com>
 <YB/Vgb4y4Dts0Y2G@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YB/Vgb4y4Dts0Y2G@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 07, 2021 at 12:56:49PM +0100, Greg KH wrote:
>On Sun, Feb 07, 2021 at 07:46:54PM +0800, Jeffle Xu wrote:
>> commit fef912bf860e8e7e48a2bfb978a356bba743a8b7 upstream.
>> commit e982c4d0a29b1d61fbe7716a8dcf8984936d6730 upstream.
>>
>> Similar to commit 9e07f4e24379 ("zram: close udev startup race condition
>> as default groups"), this is a merge of [1, 2], since [1] may be too
>> large size to be merged into -stable tree.
>
>Why is it too big?

I took a "merged" fix from Minchan (over 2 years ago!) not because the
related genhd changed are "too big" but rather "too invasive". When I
reviewed that patched it seemed to me that the additional changes it
needed for backport weren't worth it as most of the code it touches is
irrelevant for this fix.

But if now we're going to be getting more fixes that rely on that genhd
patch then let's revert the previous fix and take all the patches
separately.

-- 
Thanks,
Sasha
