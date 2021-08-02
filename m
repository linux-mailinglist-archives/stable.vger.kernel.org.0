Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD963DD278
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 11:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233020AbhHBJAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 05:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232983AbhHBJA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 05:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6832860EBD;
        Mon,  2 Aug 2021 09:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627894817;
        bh=NpGYxMxPtr0QSqg+p3P23qf5aNI0HOKU5NMbrglC06Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=RdoQGF598VsHZscJC5HMR3we486QnR63NlWZ5ruA3kXqcyZu1Xq5eGtri+xlTiPFZ
         z+Pzx3D4O+YR5+qVkKcRl9Lp7NtBn4jBuNi2KOmY5qq3fzArDmV432u2NUXjwtpPDB
         vX/7/MQbJnNmRXLtumUOdf5EHFZHfKUr96PqD1Yn5PclZQvXQYNketFumi4dcgsI0k
         X7RImEgtiF1tVMlS0ImsrsZ37cnFyq/Aoh533Cjzq/3VH2BABrTQAe4ZoQeEke4/rW
         I6YZb1I5/DL/NEarggj7M4msoiSivQpXYNOVBih4zMEloTJF2bhwC2SSRvDJA9srnB
         q8sIRtOirdNMw==
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
To:     Eric Biggers <ebiggers@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com> <YQS5eBljtztWwOFE@mit.edu>
 <YQd3Hbid/mFm0o24@sol.localdomain>
From:   Chao Yu <chao@kernel.org>
Message-ID: <a3cdd7cb-50a7-1b37-fe58-dced586712a2@kernel.org>
Date:   Mon, 2 Aug 2021 17:00:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQd3Hbid/mFm0o24@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/8/2 12:39, Eric Biggers wrote:
> On Fri, Jul 30, 2021 at 10:46:16PM -0400, Theodore Ts'o wrote:
>> On Fri, Jul 30, 2021 at 12:17:26PM -0700, Eric Biggers wrote:
>>>> Currently, non-overwrite DIO writes are fundamentally unsafe on f2fs as
>>>> they require preallocating blocks, but f2fs doesn't support unwritten
>>>> blocks and therefore has to preallocate the blocks as regular blocks.
>>>> f2fs has no way to reliably roll back such preallocations, so as a
>>>> result, f2fs will leak uninitialized blocks to users if a DIO write
>>>> doesn't fully complete.
>>
>> There's another way of solving this problem which doesn't require
>> supporting unwritten blocks.  What a file system *could* do is to
>> allocate the blocks, but *not* update the on-disk data structures ---
>> so the allocation happens in memory only, so you know that the
>> physical blocks won't get used for another files, and then issue the
>> data block writes.  On the block I/O completion, trigger a workqueue
>> function which updates the on-disk metadata to assign physical blocks
>> to the inode.
>>
>> That way if you crash before the data I/O has a chance to complete,
>> the on-disk logical block -> physical block map hasn't been updated
>> yet, and so you don't need to worry about leaking uninitialized blocks.

Thanks for your suggestion, I think it makes sense.

>>
>> Cheers,
>>
>> 					- Ted
> 
> Jaegeuk and Chao, any idea how feasible it would be for f2fs to do this?

Firstly, let's notice that below metadata will be touched during DIO
preallocation flow:
- log header
- sit bitmap/count
- free seg/sec bitmap/count
- dirty seg/sec bitmap/count

And there is one case we need to concern about is: checkpoint() can be
triggered randomly in between dio_preallocate() and dio_end_io(), we should
not persist any DIO preallocation related metadata during checkpoint(),
otherwise, sudden power-cut after the checkpoint will corrupt filesytem.

So it needs to well separate two kinds of metadata update:
a) belong to dio preallocation
b) the left one

After that, it will simply checkpoint() flow to just flush metadata b), for
other flow, like GC, data/node allocation, it needs to query/update metadata
after we combine metadata a) and b).

In addition, there is an existing in-memory log header framework in f2fs,
based on this fwk, it's very easy for us to add a new in-memory log header
for DIO preallocation.

So it seems feasible for me until now...

Jaegeuk, any other concerns about the implementation details?

Thanks,

> 
> - Eric
> 
