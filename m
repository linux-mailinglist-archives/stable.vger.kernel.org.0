Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD433F3639
	for <lists+stable@lfdr.de>; Sat, 21 Aug 2021 00:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbhHTWCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 18:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229760AbhHTWCF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 18:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05D6260F39;
        Fri, 20 Aug 2021 22:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629496887;
        bh=6Tvf7F8XzySJVAbATDnQkPDRqPuOZ8gtDkb+RLf8JtE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=a+qXY05sok1kXn0ucTlvGUaXS0cVuG6RW8Rg8+OrzmUosd0h64U4VrkHM1eFmTUpy
         dOAL54ZWwyNRPd/6Jca3QOL7sFlUk/bYFhCR/LTpU1MF8QOSC121q8pnqQ4kT4IM8N
         bkXww1I/CT+6LSuFIpsT8/gCJC6nVGSeBxBB/dzUPUY8w35fWNu7XUfRwTbqyhA0ss
         heOKNv873m4IDcP43HGDZ3GK9vNJA/gEGKExVTlklWmeU4d4cf0klrZQ4r86tv7JW0
         AI5PT99NwcZYuuDGtyUDpZyG61xx1a/Wrtl51zW1LgA7GiXFbR0poVZK1WeCjfgOoG
         ckREQ7e93K7Ow==
Subject: Re: [PATCH] f2fs: remove broken support for allocating DIO writes
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20210728015154.171507-1-ebiggers@kernel.org>
 <YQRQRh1zUHSIzcC/@gmail.com> <YQS5eBljtztWwOFE@mit.edu>
 <YQd3Hbid/mFm0o24@sol.localdomain>
 <a3cdd7cb-50a7-1b37-fe58-dced586712a2@kernel.org>
 <YQg4Lukc2dXX3aJc@google.com>
 <b88328b4-db3e-0097-d8cc-f250ee678e5b@kernel.org>
 <YQidOD/zNB17fd9v@google.com> <YRsY6dyHyaChkQ6n@gmail.com>
 <c4e5c71d-1652-7174-fa36-674fab4e61df@kernel.org>
 <YR/wbenc0d3eMAjz@sol.localdomain>
From:   Chao Yu <chao@kernel.org>
Message-ID: <c2d3a733-6caa-2bd8-ebe0-d26fe5132d16@kernel.org>
Date:   Sat, 21 Aug 2021 06:01:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YR/wbenc0d3eMAjz@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021/8/21 2:11, Eric Biggers wrote:
> On Fri, Aug 20, 2021 at 05:35:21PM +0800, Chao Yu wrote:
>>>>>>
>>>>>> Hmm, I'm still trying to deal with this as a corner case where the writes
>>>>>> haven't completed due to an error. How about keeping the preallocated block
>>>>>> offsets and releasing them if we get an error? Do we need to handle EIO right?
>>>>>
>>>>> What about the case that CP + SPO following DIO preallocation? User will
>>>>> encounter uninitialized block after recovery.
>>>>
>>>> I think buffered writes as a workaround can expose the last unwritten block as
>>>> well, if SPO happens right after block allocation. We may need to compromise
>>>> at certain level?
>>>>
>>>
>>> Freeing preallocated blocks on error would be better than nothing, although note
>>> that the preallocated blocks may have filled an arbitrary sequence of holes --
>>> so simply truncating past EOF would *not* be sufficient.
>>>
>>> But really filesystems need to be designed to never expose uninitialized data,
>>> even if I/O errors or a sudden power failure occurs.  It is unfortunate that
>>> f2fs apparently wasn't designed with that goal in mind.
>>>
>>> In any case, I don't think we can proceed with any other f2fs direct I/O
>>> improvements until this data leakage bug can be solved one way or another.  If
>>> my patch to remove support for allocating writes isn't acceptable and the
>>> desired solution is going to require some more invasive f2fs surgery, are you or
>>> Chao going to work on it?  I'm not sure there's much I can do here.
>>
>> I may have time to take look into the implementation as I proposed above, maybe
>> just enabling this in FSYNC_MODE_STRICT mode if user concerns unwritten data?
>> thoughts?
>>
> 
> What does this have to do with fsync?

Oops, maybe a separate option is more appropriate.

> 
> - Eric
> 
