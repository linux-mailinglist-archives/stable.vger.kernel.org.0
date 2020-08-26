Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362582539EA
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 23:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgHZVq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 17:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726753AbgHZVq0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 17:46:26 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E07207CD;
        Wed, 26 Aug 2020 21:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598478385;
        bh=82XFB/7i5TWDnH2NxU3bR3A631fDgBFkAC19Mgw+OY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vqXJv4v1YCOLauAMozdqLGzCgS3oF04KpHz9NsIYaaM25ZXF64qsdozlmhltkEl2H
         lw5W8BCURLWLfebqIopHt8cMEaqlf3g+qUJgQpILZ8tbZDBUND5vwWcoG6WrKGtM0H
         dlA7RIfwaDvZrcH10l6jwM6WI9cx5FDFASrbDNxs=
Date:   Wed, 26 Aug 2020 17:46:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, aarcange@redhat.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "khugepaged: khugepaged_test_exit() check
 mmget_still_valid()" has been added to the 5.8-stable tree
Message-ID: <20200826214623.GM8670@sasha-vm>
References: <1597841669128213@kroah.com>
 <alpine.LSU.2.11.2008190625060.24442@eggly.anvils>
 <20200819135306.GA3311904@kroah.com>
 <alpine.LSU.2.11.2008211739460.9564@eggly.anvils>
 <20200822212053.GE8670@sasha-vm>
 <alpine.LSU.2.11.2008221900570.11463@eggly.anvils>
 <alpine.LSU.2.11.2008240758110.2486@eggly.anvils>
 <alpine.LSU.2.11.2008261148000.1479@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2008261148000.1479@eggly.anvils>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 26, 2020 at 11:53:24AM -0700, Hugh Dickins wrote:
>On Mon, 24 Aug 2020, Hugh Dickins wrote:
>> On Sat, 22 Aug 2020, Hugh Dickins wrote:
>> > On Sat, 22 Aug 2020, Sasha Levin wrote:
>> > >
>> > > I've followed your instructions and backported the patches:
>> > >
>> > > bbe98f9cadff ("khugepaged: khugepaged_test_exit() check
>> > > mmget_still_valid()") - to all branches.
>> > > f3f99d63a815 ("khugepaged: adjust VM_BUG_ON_MM() in
>> > > __khugepaged_enter()") - to all branches.
>> > > 59ea6d06cfa9 ("coredump: fix race condition between collapse_huge_page()
>> > > and core dumping") - for 4.4.
>> >
>> > That's saved me time, thanks a lot for doing that work, Sasha.
>> >
>> > I've checked the results (haha, read on) and they're all fine,
>> > but one minor flaw in bisectability: the added 4.4 backport of
>> > "coredump: fix race condition..." adds a line (deleted by the next commit)
>> > 	result = SCAN_ANY_PROCESS;
>> > but neither "result" nor "SCAN_ANY_PROCESS" is defined in that tree,
>> > so that intermediate step would generate an easily fixed build error.
>> >
>> > FWIW - I don't know whether that's something to care about or not.
>>
>> Ah, but I missed that this one that we originally held back from 5.8,
>> did not in fact get re-added to 5.8: all the backport series have it,
>> but today's 5.8.4-rc1 does not have it.
>>
>> That's not a disaster - the series builds without it, and having its
>> fix without the fixed commit is just odd, no more unsafe than before;
>> but it should be re-added for a 5.8.4-rc2 or 5.8.5.
>
>I see 5.8 is at 5.8.5-rc1 today, but the commit below still missing:
>please re-add it, then we can all forget about it at last - thanks!

Greg went for a fast release cycle and I didn't have time to queue it
up, sorry. But don't worry - this patch isn't forgotten, I'll queue it
for the next release on Friday/Saturday.

-- 
Thanks,
Sasha
