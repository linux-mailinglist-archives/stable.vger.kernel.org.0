Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE172E6C92
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgL1XoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 18:44:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:39252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727731AbgL1XoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 18:44:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D6C522262;
        Mon, 28 Dec 2020 23:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609199017;
        bh=t77kNlBpInzvZYtgRIIy/JotvFIIX1nj7qSIgAFhZOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SlrvRjS/QFPLpOukZniwphVeo2KyejJTky7S5tg/5lJ5YjKKVguWrw2ILyudLFyXj
         5rQM9P9dsWtdkyA8cHomI0AWIz4GswDtAAe5gdc8X7Ot/UbCwNRPL8WUa/w/A70gR3
         uMvjGKSlZfqI9qvnW0oCVMsmkJB5H7+bF9be8vyGf9mDbTx6VrnK9IevdM/qvrVV7u
         YAWAC3fwHiNznzKt7PGDDDZN41r3TQSruUuPj31ehqPAnRaoL5WIQeIVY8xfTsSxxY
         2CgwCULAumeKLbePX9gPWUMcccQ2aO2AggK1kqcOKYo0lRW8LSUDGcJifGy5dwskBj
         bm7iCpd7JHt7A==
Date:   Mon, 28 Dec 2020 18:43:36 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Subject: Re: [PATCH 5.10 462/717] ice, xsk: clear the status bits for the
 next_to_use descriptor
Message-ID: <20201228234336.GK2790422@sasha-vm>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125043.105740628@linuxfoundation.org>
 <20201228105423.46e77460@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201228222907.GG2790422@sasha-vm>
 <20201228145105.4eb4a14f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201228145105.4eb4a14f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 02:51:05PM -0800, Jakub Kicinski wrote:
>On Mon, 28 Dec 2020 17:29:07 -0500 Sasha Levin wrote:
>> On Mon, Dec 28, 2020 at 10:54:23AM -0800, Jakub Kicinski wrote:
>> >On Mon, 28 Dec 2020 13:47:40 +0100 Greg Kroah-Hartman wrote:
>> >> From: Björn Töpel <bjorn.topel@intel.com>
>> >>
>> >> [ Upstream commit 8d14768a7972b92c73259f0c9c45b969d85e3a60 ]
>> >>
>> >> On the Rx side, the next_to_use index points to the next item in the
>> >> HW ring to be refilled/allocated, and next_to_clean points to the next
>> >> item to potentially be processed.
>> >>
>> >> When the HW Rx ring is fully refilled, i.e. no packets has been
>> >> processed, the next_to_use will be next_to_clean - 1. When the ring is
>> >> fully processed next_to_clean will be equal to next_to_use. The latter
>> >> case is where a bug is triggered.
>> >>
>> >> If the next_to_use bits are not cleared, and the "fully processed"
>> >> state is entered, a stale descriptor can be processed.
>> >>
>> >> The skb-path correctly clear the status bit for the next_to_use
>> >> descriptor, but the AF_XDP zero-copy path did not do that.
>> >>
>> >> This change adds the status bits clearing of the next_to_use
>> >> descriptor.
>> >>
>> >> Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
>> >> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> >> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> >> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> >
>> >Oh wow, so much for Sasha waiting longer for code to get tested before
>> >auto-pulling things into stable :/
>>
>> The timeline is usually for a commit to appear in a release, and it did.
>> Was it too early?
>
>Hm, I'm not sure of exact semantics but I meant a final release,
>not an -rc.
>
>Plus I thought the point of things being part of a release is that
>people actually get a chance to test that release. -rc1 was cut 24
>hours ago. I guess a "release" is used as a yardstick here, to
>measure time, not for practical reasons?

Note that it wasn't actually released yet, at this point folks are
supposed to be testing 5.10.4-rc1 to make sure that those patches are
okay.

I still think that there are no significant users of Linus's tree, so
the idea of having a patch "in a release" doesn't mean as much as folks
think it does. Sure, we have a lot of folks who test -rc releases, but
are you aware of anyone who runs -rc on real world workloads to test it?

>> >I have this change and other changes here queued, but haven't sent the
>> >submission yet.
>>
>> What do you mean with "queued"? Its in Linus's tree for about two weeks
>> now.
>
>Networking maintainers have their own queue for patches that will go to
>stable:
>
>https://patchwork.kernel.org/bundle/netdev/stable/?state=*

This part has always been tricky to me: some parts of net/ and
drivers/net/ don't go through netdev, and some do. I have a filter to
ignore net/ completely, but I found that quite a lot of drivers/net/
wasn't covered by this process.

How could I blacklist/ignore the parts of the tree you're looking at?

Also, is drivers/net/ stuff covered as well as net/? I found in the past
that it's not the case when I was looking at missing patches for the
hyper-v driver.

-- 
Thanks,
Sasha
