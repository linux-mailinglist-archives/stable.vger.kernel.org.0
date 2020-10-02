Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7ADB2813E9
	for <lists+stable@lfdr.de>; Fri,  2 Oct 2020 15:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387836AbgJBNTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Oct 2020 09:19:45 -0400
Received: from sandeen.net ([63.231.237.45]:33862 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgJBNTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Oct 2020 09:19:45 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 37D7B325D;
        Fri,  2 Oct 2020 08:18:54 -0500 (CDT)
To:     Sasha Levin <sashal@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org
References: <5d2f4fc1-e498-c45e-3d57-9c2d7ac275e6@sandeen.net>
 <20201002130740.GF2415204@sasha-vm>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH STABLE V2] xfs: trim IO to found COW extent limit
Message-ID: <300427ae-6135-29cd-6cbe-8fa2c4efb8d5@sandeen.net>
Date:   Fri, 2 Oct 2020 08:19:43 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201002130740.GF2415204@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/2/20 8:07 AM, Sasha Levin wrote:
> On Thu, Oct 01, 2020 at 08:34:48AM -0500, Eric Sandeen wrote:
>> A bug existed in the XFS reflink code between v5.1 and v5.5 in which
>> the mapping for a COW IO was not trimmed to the mapping of the COW
>> extent that was found.  This resulted in a too-short copy, and
>> corruption of other files which shared the original extent.
>>
>> (This happened only when extent size hints were set, which bypasses
>> delalloc and led to this code path.)
>>
>> This was (inadvertently) fixed upstream with
>>
>> 36adcbace24e "xfs: fill out the srcmap in iomap_begin"
>>
>> and related patches which moved lots of this functionality to
>> the iomap subsystem.
>>
>> Hence, this is a -stable only patch, targeted to fix this
>> corruption vector without other major code changes.
>>
>> Fixes: 78f0cc9d55cb ("xfs: don't use delalloc extents for COW on files with extsize hints")
>> Cc: <stable@vger.kernel.org> # 5.4.x
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>
>> V2: Fix typo in subject, add reviewers
>>
>> I've tested this with a targeted reproducer (in next email) as well as
>> with xfstests.
>>
>> There is also now a testcase for xfstests submitted upstream
>>
>> Stable folk, not sure how to send a "stable only" patch, or if that's even
>> valid.  Assuming you're willing to accept it, I would still like to have
>> some formal Reviewed-by's from the xfs developer community before it gets
>> merged.
> 
> This is perfect stable-process-wise :) Will wait for reviews/acks before
> merging.

Thansk Sasha - the reviews/acks were given for V1 (hch & darrick), V2 adds them to the
commit log (see above) and fixes a typo in the subject.

Thanks,
-Eric

