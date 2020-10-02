Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DA8281EF9
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 01:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725536AbgJBXRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 19:17:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgJBXRU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Oct 2020 19:17:20 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79314206FA;
        Fri,  2 Oct 2020 23:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601680639;
        bh=e2EUihFcD8lfBqiDBnxeKrMwnbUKgBWFYDZLug6WDsg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2fSPOtKxiG+B/8ulFUodUjN7kvSSIhJGKKRH0XKScqoZxEjRoSokMhBDL2aK0iP77
         tHn4p+M/R1676cimtCUnJa9CD4EPkVNvIrDk0BhF39pfBYBw8cNrZb8i+ppuTDE97S
         wAUVPwhulQ0nTBa8/0X5/PaFQYZSneJWz82E+4Co=
Date:   Fri, 2 Oct 2020 19:17:18 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     xfs <linux-xfs@vger.kernel.org>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH STABLE V2] xfs: trim IO to found COW extent limit
Message-ID: <20201002231718.GH2415204@sasha-vm>
References: <5d2f4fc1-e498-c45e-3d57-9c2d7ac275e6@sandeen.net>
 <20201002130740.GF2415204@sasha-vm>
 <300427ae-6135-29cd-6cbe-8fa2c4efb8d5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <300427ae-6135-29cd-6cbe-8fa2c4efb8d5@sandeen.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 02, 2020 at 08:19:43AM -0500, Eric Sandeen wrote:
>On 10/2/20 8:07 AM, Sasha Levin wrote:
>> On Thu, Oct 01, 2020 at 08:34:48AM -0500, Eric Sandeen wrote:
>>> A bug existed in the XFS reflink code between v5.1 and v5.5 in which
>>> the mapping for a COW IO was not trimmed to the mapping of the COW
>>> extent that was found.  This resulted in a too-short copy, and
>>> corruption of other files which shared the original extent.
>>>
>>> (This happened only when extent size hints were set, which bypasses
>>> delalloc and led to this code path.)
>>>
>>> This was (inadvertently) fixed upstream with
>>>
>>> 36adcbace24e "xfs: fill out the srcmap in iomap_begin"
>>>
>>> and related patches which moved lots of this functionality to
>>> the iomap subsystem.
>>>
>>> Hence, this is a -stable only patch, targeted to fix this
>>> corruption vector without other major code changes.
>>>
>>> Fixes: 78f0cc9d55cb ("xfs: don't use delalloc extents for COW on files with extsize hints")
>>> Cc: <stable@vger.kernel.org> # 5.4.x
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> ---
>>>
>>> V2: Fix typo in subject, add reviewers
>>>
>>> I've tested this with a targeted reproducer (in next email) as well as
>>> with xfstests.
>>>
>>> There is also now a testcase for xfstests submitted upstream
>>>
>>> Stable folk, not sure how to send a "stable only" patch, or if that's even
>>> valid.  Assuming you're willing to accept it, I would still like to have
>>> some formal Reviewed-by's from the xfs developer community before it gets
>>> merged.
>>
>> This is perfect stable-process-wise :) Will wait for reviews/acks before
>> merging.
>
>Thansk Sasha - the reviews/acks were given for V1 (hch & darrick), V2 adds them to the
>commit log (see above) and fixes a typo in the subject.

Ah, I see. Queued up!

-- 
Thanks,
Sasha
