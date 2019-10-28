Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD35E73D0
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 15:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbfJ1Oi2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 10:38:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbfJ1Oi2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Oct 2019 10:38:28 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FAC221721;
        Mon, 28 Oct 2019 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572273507;
        bh=8AnMN3wwQju8J0GWPLB6XvFEySdKwM5TJjJdbzXBSR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y53wQSmH37CjFFUVVv0an4xowZScK5yhE0pdEC+NR9x7myuVB+b6bojGS+VZvlVtC
         imzAmlWl+YmKNk0CfUafT0F5fFaes9WwklezGDTb143rhfhJi0+dIjO3Q1lfsxgjtM
         e3cNyiWsQhX/N//8IE6HJdxWggTDtTqHe2j81/9E=
Date:   Mon, 28 Oct 2019 10:38:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mpatocka@redhat.com, guru2018@gmail.com, ntsironis@arrikto.com,
        snitzer@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm snapshot: rework COW throttling to fix
 deadlock" failed to apply to 5.3-stable tree
Message-ID: <20191028143824.GA1554@sasha-vm>
References: <157219064719033@kroah.com>
 <20191028093928.GM1560@sasha-vm>
 <20191028114657.GA7337@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191028114657.GA7337@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 28, 2019 at 12:46:57PM +0100, Greg KH wrote:
>On Mon, Oct 28, 2019 at 05:39:28AM -0400, Sasha Levin wrote:
>> On Sun, Oct 27, 2019 at 04:37:28PM +0100, gregkh@linuxfoundation.org wrote:
>> >
>> > The patch below does not apply to the 5.3-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>> > ------------------ original commit in Linus's tree ------------------
>> >
>> > > From b21555786f18cd77f2311ad89074533109ae3ffa Mon Sep 17 00:00:00 2001
>> > From: Mikulas Patocka <mpatocka@redhat.com>
>> > Date: Wed, 2 Oct 2019 06:15:53 -0400
>> > Subject: [PATCH] dm snapshot: rework COW throttling to fix deadlock
>> >
>> > Commit 721b1d98fb517a ("dm snapshot: Fix excessive memory usage and
>> > workqueue stalls") introduced a semaphore to limit the maximum number of
>> > in-flight kcopyd (COW) jobs.
>> >
>> > The implementation of this throttling mechanism is prone to a deadlock:
>> >
>> > 1. One or more threads write to the origin device causing COW, which is
>> >   performed by kcopyd.
>> >
>> > 2. At some point some of these threads might reach the s->cow_count
>> >   semaphore limit and block in down(&s->cow_count), holding a read lock
>> >   on _origins_lock.
>> >
>> > 3. Someone tries to acquire a write lock on _origins_lock, e.g.,
>> >   snapshot_ctr(), which blocks because the threads at step (2) already
>> >   hold a read lock on it.
>> >
>> > 4. A COW operation completes and kcopyd runs dm-snapshot's completion
>> >   callback, which ends up calling pending_complete().
>> >   pending_complete() tries to resubmit any deferred origin bios. This
>> >   requires acquiring a read lock on _origins_lock, which blocks.
>> >
>> >   This happens because the read-write semaphore implementation gives
>> >   priority to writers, meaning that as soon as a writer tries to enter
>> >   the critical section, no readers will be allowed in, until all
>> >   writers have completed their work.
>> >
>> >   So, pending_complete() waits for the writer at step (3) to acquire
>> >   and release the lock. This writer waits for the readers at step (2)
>> >   to release the read lock and those readers wait for
>> >   pending_complete() (the kcopyd thread) to signal the s->cow_count
>> >   semaphore: DEADLOCK.
>> >
>> > The above was thoroughly analyzed and documented by Nikos Tsironis as
>> > part of his initial proposal for fixing this deadlock, see:
>> > https://www.redhat.com/archives/dm-devel/2019-October/msg00001.html
>> >
>> > Fix this deadlock by reworking COW throttling so that it waits without
>> > holding any locks. Add a variable 'in_progress' that counts how many
>> > kcopyd jobs are running. A function wait_for_in_progress() will sleep if
>> > 'in_progress' is over the limit. It drops _origins_lock in order to
>> > avoid the deadlock.
>> >
>> > Reported-by: Guruswamy Basavaiah <guru2018@gmail.com>
>> > Reported-by: Nikos Tsironis <ntsironis@arrikto.com>
>> > Reviewed-by: Nikos Tsironis <ntsironis@arrikto.com>
>> > Tested-by: Nikos Tsironis <ntsironis@arrikto.com>
>> > Fixes: 721b1d98fb51 ("dm snapshot: Fix excessive memory usage and workqueue stalls")
>> > Cc: stable@vger.kernel.org # v5.0+
>> > Depends-on: 4a3f111a73a8c ("dm snapshot: introduce account_start_copy() and account_end_copy()")
>> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>>
>> Grabbing the listed dependency solved it for 5.3-4.19. For 4.14 and
>> older I've also grabbed the semaphore->mutex conversion.
>
>Ugh, I missed that it said that there.  I'll do this for 4.19, unless
>you have these ready to go for when the tree "opens up" again.

I'll have all of these ready to go when the tree opens up.

-- 
Thanks,
Sasha
