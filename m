Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA47B250128
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 17:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgHXP3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 11:29:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgHXP3b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 11:29:31 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F06442074D;
        Mon, 24 Aug 2020 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598282969;
        bh=IjI8fvjIEfhOVOAXuIDWEVYzDDpblvA9NwNkTb3rOMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HHXjXGYHlQ4G+QiNIuNuG5hjhcairpy3o4MSbM3nZHBV/QseGj6hmBK0SYOOl/2AM
         2fesXRmsbe+Tx6BbiDH0s2m/8yyB8GkjxOhLHljtAiypQGgFQ8PYJlvwmfVDvEJwVm
         TjGxzy62LL2dS5/hyDt8fi9uhPSeYXJmroNqkcxo=
Date:   Mon, 24 Aug 2020 11:29:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, aarcange@redhat.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        mike.kravetz@oracle.com, songliubraving@fb.com,
        torvalds@linux-foundation.org, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "khugepaged: khugepaged_test_exit() check
 mmget_still_valid()" has been added to the 5.8-stable tree
Message-ID: <20200824152927.GH8670@sasha-vm>
References: <1597841669128213@kroah.com>
 <alpine.LSU.2.11.2008190625060.24442@eggly.anvils>
 <20200819135306.GA3311904@kroah.com>
 <alpine.LSU.2.11.2008211739460.9564@eggly.anvils>
 <20200822212053.GE8670@sasha-vm>
 <alpine.LSU.2.11.2008221900570.11463@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.2008221900570.11463@eggly.anvils>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 22, 2020 at 07:16:39PM -0700, Hugh Dickins wrote:
>On Sat, 22 Aug 2020, Sasha Levin wrote:
>>
>> I've followed your instructions and backported the patches:
>>
>> bbe98f9cadff ("khugepaged: khugepaged_test_exit() check
>> mmget_still_valid()") - to all branches.
>> f3f99d63a815 ("khugepaged: adjust VM_BUG_ON_MM() in
>> __khugepaged_enter()") - to all branches.
>> 59ea6d06cfa9 ("coredump: fix race condition between collapse_huge_page()
>> and core dumping") - for 4.4.
>
>That's saved me time, thanks a lot for doing that work, Sasha.
>
>I've checked the results (haha, read on) and they're all fine,
>but one minor flaw in bisectability: the added 4.4 backport of
>"coredump: fix race condition..." adds a line (deleted by the next commit)
>	result = SCAN_ANY_PROCESS;
>but neither "result" nor "SCAN_ANY_PROCESS" is defined in that tree,
>so that intermediate step would generate an easily fixed build error.
>
>FWIW - I don't know whether that's something to care about or not.

I'd probably prefer leaving it this way rather than dragging in more
patches or modifying the existing ones given that it doesn't effect
anything beyond bisectability.

-- 
Thanks,
Sasha
