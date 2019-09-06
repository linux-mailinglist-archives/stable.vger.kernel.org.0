Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63505AB2AB
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 08:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391707AbfIFG7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 02:59:03 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41446 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391689AbfIFG7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 02:59:03 -0400
Received: by mail-io1-f68.google.com with SMTP id r26so10416082ioh.8
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 23:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bfktZU2LgTx6D7En0Wx2Mu5plOyFie+VjtJALYkbimU=;
        b=Yak3xoXIqMKV5zuJXeaGtnIkCfLjFJbvThhEFLgtKC68SrbvkGOBucZ//qS5ymKDDj
         WyyaBeb2JminBNDU6uvZzWy147y3b2D3IhAm5ZpuETBYXdn9u1VGy1zpF9Mjcdmc1kes
         ekmY4xylU70A8hX3eQygyGuAe7cIqMcFCZZck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bfktZU2LgTx6D7En0Wx2Mu5plOyFie+VjtJALYkbimU=;
        b=sWr4lmndyzvmJCQSSxsO9gW9dOM/NuEyy+5KBwgG3I3Od87hgnPvJIxw21c0Fw7LHT
         R/uzpPG8XfJKu39M1p+cRylV5ib0Gh2D/A1xsBHsKjCHrHZqfMM1nfAv6lC80tu1Muug
         8fsbT139Pr5OcAflf1rUStZ1qPGqc9FZdD+EctzSfZLqzuCphn+xHruF0xJnON/magnE
         ZFGXz+VXZ+JqcU312oNn9NEwZzSwNEvQP0fOsQSI5OqCzHrHys0QAMi+Fd7LRQTZp2ky
         ONsmFO4KfZNmEd0uag0zBAYTWfB4WpU6Tt+5w2VB/T2D53Lv13z0t1h3am85ZSlIGalg
         ouHA==
X-Gm-Message-State: APjAAAVikz0xVQU/25+Uu2HLQVMpQloTtK0QNq3fpzkKQMS4z5QJCafT
        1pKmXfNDcYroMDDCWMOvVyLh2y7Y69UxnFsSP4b8GA==
X-Google-Smtp-Source: APXvYqz6GOf3eZ8CIMGHYsCOx3oBkV38YAzTnCm5dhz4Vkacx+VwGnwOL5JYOLIRyClGsyYOX7qR7TsW4MsEHWJess4=
X-Received: by 2002:a02:c94b:: with SMTP id u11mr5163432jao.35.1567753142656;
 Thu, 05 Sep 2019 23:59:02 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000008d8eac05906691ac@google.com> <20190822233529.4176-1-ebiggers@kernel.org>
 <CAJfpegvHgcZGFi-Ydyo2j89zQxqAtZ1Lh0+vC6vWeU-aEFZkYQ@mail.gmail.com>
 <20190903133910.GA5144@zzz.localdomain> <CAJfpegtrkxAYq4_rXVNEhe=6SFCfXGgpNVtaiuyfSdh+kthazA@mail.gmail.com>
 <20190906044324.GE803@sol.localdomain>
In-Reply-To: <20190906044324.GE803@sol.localdomain>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 6 Sep 2019 08:58:51 +0200
Message-ID: <CAJfpegvdh53VSQ9okuUTS3jQFjkbcwPdJFmUorE0nseeFRPaoA@mail.gmail.com>
Subject: Re: [PATCH] fuse: disable irqs for fuse_iqueue::waitq.lock
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-aio <linux-aio@kvack.org>,
        Benjamin LaHaise <bcrl@kvack.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 6, 2019 at 6:43 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Sep 04, 2019 at 04:29:03PM +0200, Miklos Szeredi wrote:

> > TBH, I find the fix disgusting. It's confusing to sprinke code that
> > has absolutely nothing to do with interrupts with spin_lock_irq()
> > calls.
> >
> > I think the lock/unlock calls should at least be done with a helper
> > with a comment explaining why disabling interrupts is needed (though I
> > have not managed to understand why aio needs to actually mess with the
> > waitq lock...)
>
> The aio code is doing a poll(), so it needs to use the wait queue.

Doesn't explain why the irq disabled nested locking is needed in
aio_poll().  poll/select manage to do that without messing with waitq
internals.   How is aio poll different?

> >
> > Probably a better fix would be to just use a separate spinlock to
> > avoid the need to disable interrupts in cases where it's not
> > necessary.
>
> Well, the below is what a separate lock would look like.  Note that it actually
> still disables IRQs in some places; it's just hidden away in the nested
> spin_lock_irqsave() in wake_up().  Likewise, adding something to the fuse_iqueue
> then requires taking 2 spin locks -- one explicit, and one hidden in wake_up().

Right, that's exactly why the waitq lock was used.

> Is this the solution you'd prefer?

I'd actually prefer if aio was fixed.   But I guess that's not
realistic, so yes, the below patch looks okay.  If fiq->lock is in the
same cacheline as fiq->waitq then it shouldn't make a difference.

Thanks,
Miklos
