Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35FCFE73E4
	for <lists+stable@lfdr.de>; Mon, 28 Oct 2019 15:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390270AbfJ1OnI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Oct 2019 10:43:08 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36841 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727982AbfJ1OnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Oct 2019 10:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572273786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c/p+nEw9XLryW8ofJ0EVLNy5WBWywnB4VJDiaIornnU=;
        b=Ry5EmUGgGL8+NZLSSizNXmS9sZjYWT2bNwR1v4nKlMRgwnQ9SbLGQrEJiawmU4vCkqpOz3
        6mWUSphJWhG3bhYsOVUZmGy+hGTI8d1/yoVP5NqTLIsnN+bEeLjG4fJW2JsLmowu3x+8T3
        7o7b5p5VjDbwr0aawb7gn7bby6uOk7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-ihVyU3doN5GRNjTtNesk9Q-1; Mon, 28 Oct 2019 10:43:02 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4E5D107AD28;
        Mon, 28 Oct 2019 14:43:01 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FC94600C9;
        Mon, 28 Oct 2019 14:43:01 +0000 (UTC)
Date:   Mon, 28 Oct 2019 10:43:00 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, mpatocka@redhat.com,
        guru2018@gmail.com, ntsironis@arrikto.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] dm snapshot: rework COW throttling to fix
 deadlock" failed to apply to 5.3-stable tree
Message-ID: <20191028144300.GA26993@redhat.com>
References: <157219064719033@kroah.com>
 <20191028093928.GM1560@sasha-vm>
 <20191028114657.GA7337@kroah.com>
 <20191028143824.GA1554@sasha-vm>
MIME-Version: 1.0
In-Reply-To: <20191028143824.GA1554@sasha-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: ihVyU3doN5GRNjTtNesk9Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 28 2019 at 10:38am -0400,
Sasha Levin <sashal@kernel.org> wrote:

> On Mon, Oct 28, 2019 at 12:46:57PM +0100, Greg KH wrote:
> >On Mon, Oct 28, 2019 at 05:39:28AM -0400, Sasha Levin wrote:
> >>On Sun, Oct 27, 2019 at 04:37:28PM +0100, gregkh@linuxfoundation.org wr=
ote:
> >>>
> >>> The patch below does not apply to the 5.3-stable tree.
> >>> If someone wants it applied there, or to any other stable or longterm
> >>> tree, then please email the backport, including the original git comm=
it
> >>> id to <stable@vger.kernel.org>.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>>
> >>> ------------------ original commit in Linus's tree ------------------
> >>>
> >>> > From b21555786f18cd77f2311ad89074533109ae3ffa Mon Sep 17 00:00:00 2=
001
> >>> From: Mikulas Patocka <mpatocka@redhat.com>
> >>> Date: Wed, 2 Oct 2019 06:15:53 -0400
> >>> Subject: [PATCH] dm snapshot: rework COW throttling to fix deadlock
> >>>
> >>> Commit 721b1d98fb517a ("dm snapshot: Fix excessive memory usage and
> >>> workqueue stalls") introduced a semaphore to limit the maximum number=
 of
> >>> in-flight kcopyd (COW) jobs.
> >>>
> >>> The implementation of this throttling mechanism is prone to a deadloc=
k:
> >>>
> >>> 1. One or more threads write to the origin device causing COW, which =
is
> >>>   performed by kcopyd.
> >>>
> >>> 2. At some point some of these threads might reach the s->cow_count
> >>>   semaphore limit and block in down(&s->cow_count), holding a read lo=
ck
> >>>   on _origins_lock.
> >>>
> >>> 3. Someone tries to acquire a write lock on _origins_lock, e.g.,
> >>>   snapshot_ctr(), which blocks because the threads at step (2) alread=
y
> >>>   hold a read lock on it.
> >>>
> >>> 4. A COW operation completes and kcopyd runs dm-snapshot's completion
> >>>   callback, which ends up calling pending_complete().
> >>>   pending_complete() tries to resubmit any deferred origin bios. This
> >>>   requires acquiring a read lock on _origins_lock, which blocks.
> >>>
> >>>   This happens because the read-write semaphore implementation gives
> >>>   priority to writers, meaning that as soon as a writer tries to ente=
r
> >>>   the critical section, no readers will be allowed in, until all
> >>>   writers have completed their work.
> >>>
> >>>   So, pending_complete() waits for the writer at step (3) to acquire
> >>>   and release the lock. This writer waits for the readers at step (2)
> >>>   to release the read lock and those readers wait for
> >>>   pending_complete() (the kcopyd thread) to signal the s->cow_count
> >>>   semaphore: DEADLOCK.
> >>>
> >>> The above was thoroughly analyzed and documented by Nikos Tsironis as
> >>> part of his initial proposal for fixing this deadlock, see:
> >>> https://www.redhat.com/archives/dm-devel/2019-October/msg00001.html
> >>>
> >>> Fix this deadlock by reworking COW throttling so that it waits withou=
t
> >>> holding any locks. Add a variable 'in_progress' that counts how many
> >>> kcopyd jobs are running. A function wait_for_in_progress() will sleep=
 if
> >>> 'in_progress' is over the limit. It drops _origins_lock in order to
> >>> avoid the deadlock.
> >>>
> >>> Reported-by: Guruswamy Basavaiah <guru2018@gmail.com>
> >>> Reported-by: Nikos Tsironis <ntsironis@arrikto.com>
> >>> Reviewed-by: Nikos Tsironis <ntsironis@arrikto.com>
> >>> Tested-by: Nikos Tsironis <ntsironis@arrikto.com>
> >>> Fixes: 721b1d98fb51 ("dm snapshot: Fix excessive memory usage and wor=
kqueue stalls")
> >>> Cc: stable@vger.kernel.org # v5.0+
> >>> Depends-on: 4a3f111a73a8c ("dm snapshot: introduce account_start_copy=
() and account_end_copy()")
> >>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >>
> >>Grabbing the listed dependency solved it for 5.3-4.19. For 4.14 and
> >>older I've also grabbed the semaphore->mutex conversion.
> >
> >Ugh, I missed that it said that there.  I'll do this for 4.19, unless
> >you have these ready to go for when the tree "opens up" again.
>=20
> I'll have all of these ready to go when the tree opens up.

Not sure what all the trees are but a sufficiently older kernel could
have problems with these fixes if they are missing commit d3775354
(specifically the change to use kzalloc in dm-snap.c).

This came up in the context of 4.4 recently.  But hopefully none of your
staable branches are missing commit d3775354.

Thanks,
Mike

