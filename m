Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE70024E9FD
	for <lists+stable@lfdr.de>; Sat, 22 Aug 2020 23:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgHVVUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Aug 2020 17:20:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbgHVVUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Aug 2020 17:20:55 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81B36206DA;
        Sat, 22 Aug 2020 21:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598131254;
        bh=AyGX+6X+qljY4sPN1FRNMDnRpBADumxGIwungeD0kbQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tiETtzlmQ+o1kY1EYSFafcQft0BbjhhbepBMV8KtY+MapxHwB9N2x61mdk9n1FwKS
         NRH3iH0PfIfr1aISrPXClSZymR/MIaeBNAn/214AJnUqukpIZK+pZkPQAqY4d5gwnz
         rcpl+4MZYjb+O9vpsyghpvjIIUGnge3dze0VgLLQ=
Date:   Sat, 22 Aug 2020 17:20:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, aarcange@redhat.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "khugepaged: khugepaged_test_exit() check
 mmget_still_valid()" has been added to the 5.8-stable tree
Message-ID: <20200822212053.GE8670@sasha-vm>
References: <1597841669128213@kroah.com>
 <alpine.LSU.2.11.2008190625060.24442@eggly.anvils>
 <20200819135306.GA3311904@kroah.com>
 <alpine.LSU.2.11.2008211739460.9564@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2008211739460.9564@eggly.anvils>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 06:26:15PM -0700, Hugh Dickins wrote:
>On Wed, 19 Aug 2020, Greg KH wrote:
>> On Wed, Aug 19, 2020 at 06:32:26AM -0700, Hugh Dickins wrote:
>> > On Wed, 19 Aug 2020, gregkh@linuxfoundation.org wrote:
>> > >
>> > > This is a note to let you know that I've just added the patch titled
>> > >
>> > >     khugepaged: khugepaged_test_exit() check mmget_still_valid()
>> > >
>> > > to the 5.8-stable tree which can be found at:
>> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>> > >
>> > > The filename of the patch is:
>> > >      khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch
>> > > and it can be found in the queue-5.8 subdirectory.
>> > >
>> > > If you, or anyone else, feels it should not be added to the stable tree,
>> > > please let <stable@vger.kernel.org> know about it.
>> >
>> > Please hold this one back for the moment: we shall want it, but syzbot
>> > detected one place where it can lead to a VM_BUG_ON_MM().  The fix to
>> > that is currently in Andrew's tree, but not yet in Linus's - when it
>> > gets there, I'll send you its git commit id in reply to this mail.
>> >
>> > This patch failed to apply to earlier releases: I'll send the fixup for
>> > those at that time.  (Fixups for another patch to follow later today.)
>>
>> Now dropped, thanks!
>
>f3f99d63a815 khugepaged: adjust VM_BUG_ON_MM() in __khugepaged_enter()
>has now reached Linus's tree, so will reach your tree when you next pull.
>
>When that one is ready, please reinstate this commit that we held back:
>bbe98f9cadff khugepaged: khugepaged_test_exit() check mmget_still_valid()
>
>The mmap_sem->mmap_lock change means I must then send you a backport of
>bbe98f9cadff for 5.7, 5.4, 4.19, 4.14, 4.9: one backport will do for all
>of those, and f3f99d63a815 should cherry-pick cleanly into them all.
>
>But you also marked bbe98f9cadff for 4.4: I had not expected that,
>but I think you're right - for whatever reason (probably inertia,
>it was tiresome because khugepaged.c got split from huge_memory.c),
>4.4 lacks a backport of 59ea6d06cfa9 (though it does have the commit
>that depended on), and backports of these two will serve just as well
>to fix what it was required to fix: I'll send them too.
>
>Thanks: I'm sorry that this is all so confusing,
>kudos to syzbot for catching my error as quickly as it did.

I've followed your instructions and backported the patches:

bbe98f9cadff ("khugepaged: khugepaged_test_exit() check
mmget_still_valid()") - to all branches.
f3f99d63a815 ("khugepaged: adjust VM_BUG_ON_MM() in
__khugepaged_enter()") - to all branches.
59ea6d06cfa9 ("coredump: fix race condition between collapse_huge_page()
and core dumping") - for 4.4.

Thanks!

-- 
Thanks,
Sasha
