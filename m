Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B036515950
	for <lists+stable@lfdr.de>; Sat, 30 Apr 2022 02:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378716AbiD3Aa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 20:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235155AbiD3Aa0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 20:30:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0064ED0808;
        Fri, 29 Apr 2022 17:27:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AAB07B83800;
        Sat, 30 Apr 2022 00:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38725C385A4;
        Sat, 30 Apr 2022 00:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651278424;
        bh=ZY6lCWFeGbK7gENJJ1vDCLA1WWWMx/zm0VeDflagIBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ygg6MGVn6QSNdq7kp3gNjqQmB+hnOtu40Z295SdnBj8b75mTmT4cr+r2YS65ZT3rd
         G85xL5kf/tgTwTbGOK0yKXWvvfL626D4+JyJFG7BlhxefUxwPXnBdQqjiU6bdnQhlv
         xrEKvbOn7h4TBnueU2Y8KeCWjl9AcDNX+nPEDnoyEoG3fC9fNzU1YS3hBnWkpwdzG7
         JwPTSfNJhd9BQFcbkA7+jW6xCz/c/7FhJx5ucds7cClGkvIb2dikZzB4mbSmSuO1+g
         izzp+WcjjDqOyDFr4wkxBW3ptbeejChEpyT/Cr33bUHUXLUwmbNqY2wZOSW9SSmnBO
         nnq9v9yYi4zTQ==
Date:   Fri, 29 Apr 2022 20:27:02 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Shi <shy828301@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mm@kvack.org
Subject: Re: [PATCH AUTOSEL 13/14] mm/thp: ClearPageDoubleMap in first
 page_add_file_rmap()
Message-ID: <YmyCVofxgjqXCqiU@sashalap>
References: <20220428154222.1230793-1-gregkh@linuxfoundation.org>
 <20220428154222.1230793-13-gregkh@linuxfoundation.org>
 <c2ed1fe1-247e-e644-c367-87d32eb92cf5@google.com>
 <YmrHsVZTEzqIDiKd@kroah.com>
 <bec6e6cf-daa7-d632-7f81-471acba69c9d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bec6e6cf-daa7-d632-7f81-471acba69c9d@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 12:27:40PM -0700, Hugh Dickins wrote:
>On Thu, 28 Apr 2022, Greg Kroah-Hartman wrote:
>> On Thu, Apr 28, 2022 at 09:51:58AM -0700, Hugh Dickins wrote:
>> > On Thu, 28 Apr 2022, Greg Kroah-Hartman wrote:
>> >
>> > > From: Hugh Dickins <hughd@google.com>
>> > >
>> > > commit bd55b0c2d64e84a75575f548a33a3dfecc135b65 upstream.
>> > >
>> > > PageDoubleMap is maintained differently for anon and for shmem+file: the
>> > > shmem+file one was never cleared, because a safe place to do so could
>> > > not be found; so it would blight future use of the cached hugepage until
>> > > evicted.
>> > >
>> > > See https://lore.kernel.org/lkml/1571938066-29031-1-git-send-email-yang.shi@linux.alibaba.com/
>> > >
>> > > But page_add_file_rmap() does provide a safe place to do so (though later
>> > > than one might wish): allowing testing to return to an initial state
>> > > without a damaging drop_caches.
>> > >
>> > > Link: https://lkml.kernel.org/r/61c5cf99-a962-9a25-597a-53ab1bd8fbc0@google.com
>> > > Fixes: 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped file huge pages")
>> > > Signed-off-by: Hugh Dickins <hughd@google.com>
>> > > Reviewed-by: Yang Shi <shy828301@gmail.com>
>> > > Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> > > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >
>> > NAK.
>> >
>> > I thought we had a long-standing agreement that AUTOSEL does not try
>> > to add patches from akpm's tree which had not been marked for stable.

I guess it was only between myself and mm/ :p

>> True, this was my attempt at saying "hey these all look like they should
>> go to stable trees, why not?"
>
>Okay, it seems I should have read "AUTOSEL" as "Hey, GregKH here,
>these all look like they should go to stable trees, why not?",
>which would have drawn a friendlier response.

FRIENDLYGREGBOT :)

>The answer is that I considered stable at the time, and akpm did too,
>and none of my three (I've not looked through the other 11) are serious
>enough to be needed in stable; and I'm cautious about backports, because
>I know that the tree they went on top of differs thereabouts from 5.17.
>
>Of course I think the patches in 5.18-rc are good, and yes, they're
>things I've thought worthwhile enough for me personally to port forward
>over several releases until I had time to send in.  But that doesn't
>make them safe stable candidates, without someone to verify and vouch
>for the results in this or that tree - I run on a much slower clock
>than you and most around here, I do not have time for that at present
>(and would prefer not even to be having this conversation).
>
>But I'm happily overruled if any mm guys think they are worth that
>extra effort, and will verify and vouch for them.

What's the extra effort here? We're seeing so many cases where we see
issues with LTS kernels and we end up spending so much time triaging and
diagnosing them only to find out that they've already been fixed.

Honesly, having them in -stable seems like *less* effort to me.

-- 
Thanks,
Sasha
