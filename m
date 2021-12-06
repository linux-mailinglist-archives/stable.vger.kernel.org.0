Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BD046AAEB
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352988AbhLFVvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352983AbhLFVvx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:51:53 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A53C061359
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 13:48:24 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so49158830edd.3
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 13:48:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Eip2d/hVRGSLRlvh3UtzxqF3/zCUzzqztI5oHT+KdI=;
        b=EvMTxmIsfoaSzvFvf70bWgCu1ARC+fwDYdQj+lqJZ4N07cj76CSqLJjaGNO12txDXp
         j6FhDV5fNm0g3TyHS8kLuH03PC5FU4DT0JuLNC1qxdJuQnoGrNKGDEDPhHLKwutb/RJm
         bgB4KLujTRxMH5a9X/em6adrlxpsOgxMiornk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Eip2d/hVRGSLRlvh3UtzxqF3/zCUzzqztI5oHT+KdI=;
        b=XC0QYAmWI08abQSrnUmKSPDKNyZI/TdfejiLQePBr23sTUJ+ptVxZtegwaItB0ZScY
         eLZ7T4DH9sL3hjcVsRICE8GAUTF0aXAWl/8FswPdjaTr67yGDitsbAJdzHfVnhndezof
         nWps8XIK4XMB6XInV42tvzjOyMdnWNnaWcoSlpkU3H7LERE57ASWnCV1EpUxEd/AFH5M
         AEAxkY5vYWwP6tuLlT40BOmb1MWAnOpJxqb46V8+bRwx/4/ShECv5cjjM0xHpPqXCr5M
         INDLmOszDOtiFaRHcfWAPNR5MCUTSBU5zRIbSfQAJ/ZoPK37ER3BdiGFoSRBOw2MCLmg
         eO9A==
X-Gm-Message-State: AOAM530zfWPC9LEBQ9isabn3P8YB97hRPIlDjI4oRcBypG1Z31xAyPxK
        PJsJmPqlzpNIVfMtZSsf07C0/OvLgkTxc0Y1
X-Google-Smtp-Source: ABdhPJzyC19BNEwlAajAfQ5EsSb+0xJRe8U39hKWZU+jxIurF7P+MDthrOSZsQHEvUUIi/40ruQcjw==
X-Received: by 2002:a17:907:6e8e:: with SMTP id sh14mr47545536ejc.536.1638827302224;
        Mon, 06 Dec 2021 13:48:22 -0800 (PST)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com. [209.85.221.50])
        by smtp.gmail.com with ESMTPSA id ar2sm7271346ejc.20.2021.12.06.13.48.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Dec 2021 13:48:20 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id o13so25176439wrs.12
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 13:48:20 -0800 (PST)
X-Received: by 2002:adf:9d88:: with SMTP id p8mr48026383wre.140.1638827300398;
 Mon, 06 Dec 2021 13:48:20 -0800 (PST)
MIME-Version: 1.0
References: <20211204002301.116139-1-ebiggers@kernel.org> <20211204002301.116139-3-ebiggers@kernel.org>
 <CAHk-=wgJ+6qgbB+WCDosxOgDp34ybncUwPJ5Evo8gcXptfzF+Q@mail.gmail.com> <Ya5qWLLv3i4szS4N@gmail.com>
In-Reply-To: <Ya5qWLLv3i4szS4N@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 6 Dec 2021 13:48:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgvt7PH+AU_29H95tJQZ9FnhS8vVmymbhpZ6NZ7yaAigw@mail.gmail.com>
Message-ID: <CAHk-=wgvt7PH+AU_29H95tJQZ9FnhS8vVmymbhpZ6NZ7yaAigw@mail.gmail.com>
Subject: Re: [PATCH 2/2] aio: fix use-after-free due to missing POLLFREE handling
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ramji Jiyani <ramjiyani@google.com>,
        Christoph Hellwig <hch@lst.de>,
        Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 6, 2021 at 11:54 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> It could be fixed by converting signalfd and binder to use something like this,
> right?
>
>         #define wake_up_pollfree(x)  \
>                __wake_up(x, TASK_NORMAL, 0, poll_to_key(EPOLLHUP | POLLFREE))

Yeah, that looks better to me.

That said, maybe it would be even better to then make it more explicit
about what it does, and not make it look like just another wakeup with
an odd parameter.

IOW, maybe that "pollfree()" function itself could very much do the
waitqueue entry removal on each entry using list_del_init(), and not
expect the wakeup code for the entry to do so.

I think that kind of explicit "this removes all entries from the wait
list head" is better than "let's do a wakeup and expect all entries to
magically implicitly remove themselves".

After all, that "implicitly remove themselves" was what didn't happen,
and caused the bug in the first place.

And all the normal cases, that don't care about POLLFREE at all,
because their waitqueues don't go away from under them, wouldn't care,
because "list_del_init()" still  leaves a valid self-pointing list in
place, so if they do list_del() afterwards, nothing happens.

I dunno. But yes, that wake_up_pollfree() of yours certainly looks
better than what we have now.

> As for eliminating POLLFREE entirely, that would require that the waitqueue
> heads be moved to a location which has a longer lifetime.

Yeah, the problem with aio and epoll is exactly that they end up using
waitqueue heads without knowing what they are.

I'm not at all convinced that there aren't other situations where the
thing the waitqueue head is embedded might not have other lifetimes.

The *common* situation is obviously that it's associated with a file,
and the file pointer ends up holding the reference to whatever device
or something (global list in a loadable module, or whatever) it is.

Hmm. The poll_wait() callback function actually does get the 'struct
file *' that the wait is associated with. I wonder if epoll queueing
could actually increment the file ref when it creates its own wait
entry, and release it at ep_remove_wait_queue()?

Maybe epoll could avoid having to remove entries entirely that way -
simply by virtue of having a ref to the files - and remove the need
for having the ->whead pointer entirely (and remove the need for
POLLFREE handling)?

And maybe the signalfd case can do the same - instead of expecting
exit() to clean up the list when sighand->count goes to zero, maybe
the signalfd filp can just hold a ref to that 'struct sighand_struct',
and it gets free'd whenever there are no signalfd users left?

That would involve making signalfd_ctx actually tied to one particular
'struct signal', but that might be the right thing to do regardless
(instead of making it always act on 'current' like it does now).

So maybe with some re-organization, we could get rid of the need for
POLLFREE entirely.. Anybody?

But your patches are certainly simpler in that they just fix the status quo.

             Linus
