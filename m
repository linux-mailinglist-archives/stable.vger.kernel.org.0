Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495F5668593
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 22:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjALVhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 16:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbjALVhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 16:37:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3447859D3C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673558933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Af/YXShLP9oV7U9zc/OSq6LcFZD/5nvdb67AvzkpNZw=;
        b=Q3D/t4ywTSDTZjKWruQF4USzPozjXJQXfEPJt+lqmksiefHPkPmLMOeWg2LlSyovQDE8Li
        OHqOCPknUFCKQvT13k5wXUUt7AHS2ABdZf3vT7BEVmXX4pWpADBvpq/eSbKhuZ2tRSrEOQ
        L1ryIgAUFnIrbXmvRJhtnFsu8Wu8x7I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-UXvouLztN1S1kxB7G1LSCg-1; Thu, 12 Jan 2023 16:28:47 -0500
X-MC-Unique: UXvouLztN1S1kxB7G1LSCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3C36E1815CF2;
        Thu, 12 Jan 2023 21:28:47 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CD2A140C2064;
        Thu, 12 Jan 2023 21:28:46 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Seth Jenkins <sethjenkins@google.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>,
        Pavel Emelyanov <xemul@parallels.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: fix mremap after fork null-deref
References: <20221104212519.538108-1-sethjenkins@google.com>
        <x49tu0wlv0c.fsf@segfault.boston.devel.redhat.com>
        <CALxfFW5d05H-nFuDdUDS4xVDKMgkV1vvEBAmw10h3-jMVb-PZw@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 12 Jan 2023 16:32:42 -0500
Message-ID: <x49ilhbl9qd.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Seth,

Seth Jenkins <sethjenkins@google.com> writes:

>> I wonder if it would be better to not copy the ring mapping on fork.
>> Something like the below?  I think that would be more in line with
>> expectations (the ring isn't available in the child process).
>
> I like this idea a lot, but would this be viewed as subtly changing
> the userland to kernel interface?

Yes, but...

The way things stand today, if you setup an io context in a process and
then fork a child, the child will be unable to use the aio system calls
to submit and reap I/Os.  This is because the ioctx_table was cleared
during fork, which means that lookup_ioctx() will not find the io
context.  However, the child still has access to the ring through the
memory mapping.  As a result, the child can reap I/O completions
directly from the ring.  That wasn't always the case.  The aio ring used
to be a MAP_PRIVATE mapping.  Commit 36bc08cc0170 ("fs/aio: Add support
to aio ring pages migration") changed it from a private to a shared
mapping, and I'm not sure why.  (That patch was included in v3.12, so
it's been this way for quite some time.)

With the patch I proposed (flagging the ring buffer with VM_DONTCOPY),
the child process would still be unable to submit and reap I/Os via the
aio system calls.  What changes is that the child process would now be
unable to reap completions via the shared ring buffer.  In fact, because
the ring is no longer mapped in the child process, any attempt to access
that memory would result in a segmentation fault.  However, I would be
very surprised if the interface was being used in this way.

> If we're okay with this change though, I think it makes sense.

My preference is to make the interface consistent.  I think setting
VM_DONTCOPY on the mapping is the right way forward.  I'd welcome other
opinions on whether the potential risk is worth it.

Cheers,
Jeff

>
>
> On Wed, Jan 11, 2023 at 2:37 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> Hi, Seth,
>>
>> Seth Jenkins <sethjenkins@google.com> writes:
>>
>> > Commit e4a0d3e720e7 ("aio: Make it possible to remap aio ring") introduced
>> > a null-deref if mremap is called on an old aio mapping after fork as
>> > mm->ioctx_table will be set to NULL.
>> >
>> > Fixes: e4a0d3e720e7 ("aio: Make it possible to remap aio ring")
>> > Cc: stable@vger.kernel.org
>> > Signed-off-by: Seth Jenkins <sethjenkins@google.com>
>> > ---
>> >  fs/aio.c | 20 +++++++++++---------
>> >  1 file changed, 11 insertions(+), 9 deletions(-)
>> >
>> > diff --git a/fs/aio.c b/fs/aio.c
>> > index 5b2ff20ad322..74eae7de7323 100644
>> > --- a/fs/aio.c
>> > +++ b/fs/aio.c
>> > @@ -361,16 +361,18 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
>> >       spin_lock(&mm->ioctx_lock);
>> >       rcu_read_lock();
>> >       table = rcu_dereference(mm->ioctx_table);
>> > -     for (i = 0; i < table->nr; i++) {
>> > -             struct kioctx *ctx;
>> > -
>> > -             ctx = rcu_dereference(table->table[i]);
>> > -             if (ctx && ctx->aio_ring_file == file) {
>> > -                     if (!atomic_read(&ctx->dead)) {
>> > -                             ctx->user_id = ctx->mmap_base = vma->vm_start;
>> > -                             res = 0;
>> > +     if (table) {
>> > +             for (i = 0; i < table->nr; i++) {
>> > +                     struct kioctx *ctx;
>> > +
>> > +                     ctx = rcu_dereference(table->table[i]);
>> > +                     if (ctx && ctx->aio_ring_file == file) {
>> > +                             if (!atomic_read(&ctx->dead)) {
>> > +                                     ctx->user_id = ctx->mmap_base = vma->vm_start;
>> > +                                     res = 0;
>> > +                             }
>> > +                             break;
>> >                       }
>> > -                     break;
>> >               }
>> >       }
>>
>> I wonder if it would be better to not copy the ring mapping on fork.
>> Something like the below?  I think that would be more in line with
>> expectations (the ring isn't available in the child process).
>>
>> -Jeff
>>
>> diff --git a/fs/aio.c b/fs/aio.c
>> index 562916d85cba..dbf3b0749cb4 100644
>> --- a/fs/aio.c
>> +++ b/fs/aio.c
>> @@ -390,7 +390,7 @@ static const struct vm_operations_struct aio_ring_vm_ops = {
>>
>>  static int aio_ring_mmap(struct file *file, struct vm_area_struct *vma)
>>  {
>> -       vma->vm_flags |= VM_DONTEXPAND;
>> +       vma->vm_flags |= VM_DONTEXPAND|VM_DONTCOPY;
>>         vma->vm_ops = &aio_ring_vm_ops;
>>         return 0;
>>  }
>>

