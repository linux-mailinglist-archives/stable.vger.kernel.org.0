Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E08349EBD
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 02:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhCZBeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 21:34:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229962AbhCZBdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 21:33:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7ECB561935;
        Fri, 26 Mar 2021 01:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616722424;
        bh=wwSBHHa+KMZhIc2xhxHs6zKbrmPV+BlB9WRP2PmnZPQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h0snOM9zAK/fC+z8jH5MVj8ESvRPq5cIHAbJ1ztsfGmhHUtC4g+xrNX7UBV8sIynW
         B1wry/oan2E2Bx9X0vv77d244xd/AMaRXOhSv24b4qO3/1WFk8mfV0pw0R2GwjDlko
         EKJ5wpL2R133vBzmtB66DJKgmXLuMVHGWqwQkz6okCBtxi7XiS09FjLjqKO5nSxvxA
         1ztBNWF90Evvhh3p2gXRFSo2MqRzrUfRmcctNPDOqkjUHbK6wHQgHlDWqYGgFEFTBd
         L2XFra0kjxGFh8HLW1U3uENWwskbKeijYd3bdjnpqB7E9QTko8RqvzTvo8A2XkpOAu
         +77hlJ7oMKS6g==
Date:   Thu, 25 Mar 2021 21:33:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] scripts: stable: add script to validate backports
Message-ID: <YF0594jHAlZAmIms@sashalap>
References: <20210316213136.1866983-1-ndesaulniers@google.com>
 <YFnyHaVyvgYl/qWg@kroah.com>
 <CAKwvOd=9HwLcTD8GaMsbEWiTPfZ+fj=vgFOefqBxDYkFiv_6YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOd=9HwLcTD8GaMsbEWiTPfZ+fj=vgFOefqBxDYkFiv_6YQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 23, 2021 at 11:52:26AM -0700, Nick Desaulniers wrote:
>On Tue, Mar 23, 2021 at 6:56 AM Greg Kroah-Hartman
><gregkh@linuxfoundation.org> wrote:
>>
>> On Tue, Mar 16, 2021 at 02:31:33PM -0700, Nick Desaulniers wrote:
>> > A common recurring mistake made when backporting patches to stable is
>> > forgetting to check for additional commits tagged with `Fixes:`. This
>> > script validates that local commits have a `commit <sha40> upstream.`
>> > line in their commit message, and whether any additional `Fixes:` shas
>> > exist in the `master` branch but were not included. It can not know
>> > about fixes yet to be discovered, or fixes sent to the mailing list but
>> > not yet in mainline.
>> >
>> > To save time, it avoids checking all of `master`, stopping early once
>> > we've reached the commit time of the earliest backport. It takes 0.5s to
>> > validate 2 patches to linux-5.4.y when master is v5.12-rc3 and 5s to
>> > validate 27 patches to linux-4.19.y. It does not recheck dependencies of
>> > found fixes; the user is expected to run this script to a fixed point.
>> > It depnds on pygit2 python library for working with git, which can be
>> > installed via:
>> > $ pip3 install pygit2
>> >
>> > It's expected to be run from a stable tree with commits applied.  For
>> > example, consider 3cce9d44321e which is a fix for f77ac2e378be. Let's
>> > say I cherry picked f77ac2e378be into linux-5.4.y but forgot
>> > 3cce9d44321e (true story). If I ran:
>> >
>> > $ ./scripts/stable/check_backports.py
>> > Checking 1 local commits for additional Fixes: in master
>> > Please consider backporting 3cce9d44321e as a fix for f77ac2e378be
>>
>> While interesting, I don't use a git tree for the stable queue, so this
>> doesn't really fit into my workflow, sorry.
>
>Well, what is your workflow?

That's a trick question :) I don't think something like this should
target our workflow, but rather should be for someone who wants to send
patches over to stable@.

I also think that the formatting patch shouldn't be checking for proper
formatting, but rather should just be doing it on it's own.

What I don't know is the right place to put it in... It can go into
stable-queue.git, but there are very few people who are aware of it's
existance, and even a smaller number who knows how it works.

-- 
Thanks,
Sasha
