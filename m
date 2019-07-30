Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8FD7B105
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 19:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbfG3R7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 13:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726268AbfG3R7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 13:59:32 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAE95206A2;
        Tue, 30 Jul 2019 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564509572;
        bh=uVk4P8zWnEnqJ8edRiyBuFvTtYccA47B5u5lFmEzpig=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JZcwoo6tdNxJ6UEd4P82NHGyHJ8YzDQE632u0GIpJPS6pqnysL82nLAInj0lqRpzQ
         d7sDbtv5w54TrlQDcbNC0QGUnDdu6UzcDWtQeeUt0G+kQf7qa9ZDVcUB9BK9P81lot
         kZsiXomh+zUIg4h8Oc6V23N+zCgwP7v5NQkY++tY=
Date:   Tue, 30 Jul 2019 13:59:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Matthias Kaehlcke <mka@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
        Nathan Huckleberry <nhuck@google.com>
Subject: Re: [PATCH 5.2 083/215] net/ipv4: fib_trie: Avoid cryptic ternary
 expressions
Message-ID: <20190730175930.GC29162@sasha-vm>
References: <20190729190739.971253303@linuxfoundation.org>
 <20190729190753.998851246@linuxfoundation.org>
 <20190729205422.GH250418@google.com>
 <20190729205746.GI250418@google.com>
 <CAKwvOdmwaUN70e8TLDS4ZXvge7j1a--kYPPO0dm9ycPKLRqfvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOdmwaUN70e8TLDS4ZXvge7j1a--kYPPO0dm9ycPKLRqfvA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 02:01:08PM -0700, Nick Desaulniers wrote:
>On Mon, Jul 29, 2019 at 1:57 PM Matthias Kaehlcke <mka@chromium.org> wrote:
>>
>> On Mon, Jul 29, 2019 at 01:54:22PM -0700, Matthias Kaehlcke wrote:
>> > Hi Greg,
>> >
>> > Toralf just pointed out in another thread that the commit message and
>> > the content of this patch don't match (https://lkml.org/lkml/2019/7/29/1475)
>> >
>> > I did some minor digging, the content of the queued patch is:
>> >
>> > commit 4df607cc6fe8e46b258ff2a53d0a60ca3008ffc7
>> > Author: Nathan Huckleberry <nhuck@google.com>
>> > Date:   Mon Jun 17 10:28:29 2019 -0700
>> >
>> >     kbuild: Remove unnecessary -Wno-unused-value
>> >
>> >
>> > however the commit message is from:
>> >
>> > commit 25cec756891e8733433efea63b2254ddc93aa5cc
>> > Author: Matthias Kaehlcke <mka@chromium.org>
>> > Date:   Tue Jun 18 14:14:40 2019 -0700
>> >
>> >     net/ipv4: fib_trie: Avoid cryptic ternary expressions
>> >
>> >
>> > It seems this hasn't been commited to -stable yet, so we are probably
>> > in time to remove it from the queue before it becomes git history and
>> > have Nathan re-spin the patch(es).
>>
>> s/Nathan/Sasha/
>>
>> For some reason I thought Nathan backported this and wondered that his
>> SOB is missing. The correct SOB is actually there.
>
>I don't think Nathan explicitly tried to backport anything.  This
>looks to me like AUTOSEL maybe took a commit message from a different
>commit, and applied it to this diff.
>
>ie. I don't think this is a bug in a manual backport, I think AUTOSEL
>did something funny and created a backport with commit message A but
>commit diff B.

Thanks for reporting this! It is indeed a bug with my scripts.

The story here is that we have commit A which references commit B, but
commit B ended up getting merged before commit A, which confused my
scripts. I'll go fix up the stable tree and my scripts.

--
Thanks,
Sasha
