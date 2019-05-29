Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A33FC2E46F
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 20:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfE2S0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 14:26:14 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:38460 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfE2S0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 14:26:14 -0400
Received: by mail-it1-f194.google.com with SMTP id i63so898763ita.3;
        Wed, 29 May 2019 11:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TPw4eflGaKI/OKKxvlJQ22C2ftNP7pXq0GeN7f/mbOQ=;
        b=AH62/ckYQ4jBdFzIhVm6Y9tX+W+XJ8LN+DSBwBYxk7Bm9tdpsUtfMOXWZrdZa23+N1
         u52GCBTu11nt5boSjHA+BOio3ozjlwTYumDqAnoM/cr8AxTxvzxvvaCvKnYlSH8h8uvt
         8Wmn/eEVEosthorZkMwvgqH5oelyyuwoLIc/9mKcqnd5MNYls7F3IPlPdwh3pD0gysxe
         Kfu1ovDYlRu6LKMs6HeAy3oIlVcwzFFzgd1N7lHIWyNfomtNweNbdWNwSgiR1z9qSHjp
         Y+8edTj7EW2rS1Bksua0OTS9fhE4BuUGvgAcC7WLnFps5AMZCypbpRQ29+6AvMSnBbPl
         +Trg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TPw4eflGaKI/OKKxvlJQ22C2ftNP7pXq0GeN7f/mbOQ=;
        b=lHhSgSNkcQ49bkv0GZujWBxlBiWn4QRkrCnSkAAdl04PjgifrmcADqlYKc2K9hHGim
         Ydabg82Pfgi+NV8zih0UU4700i45kC3NsyQqWDIceSLPKiEd3HhAcb/t638WO/EH5LJp
         Ii8eiybUCu4Pp0ejJkJjqCvMQ4WYlSSp4QwPLu7GsDC0IMBHpxYkefpNhScUti4G3GRm
         Kur6sEuU6GRrkYVYp4VmsyHkCrjlkOURndaDFv15boog71C+mJ+EBGqu/NwcArKlkviW
         314eJVnuELAbfrClBsYR5H4xJPcqZvBbnOC3ucVnVU7p1jPmfALd0lq9JpUajeaZEyT7
         yQBw==
X-Gm-Message-State: APjAAAXZaCxNBfQEOUbTo5dQ0nN4JbRDbFvhWWdZAmZPQfAHFtg+xHw2
        vE9Lk/mUkSwfuoSiFPQZmfIz+ti4+4eNTpwefMc=
X-Google-Smtp-Source: APXvYqx8sMU5apXzIWkFBSnAKL1oaiM1V8pYGkVXuq937bPfxzmSeuyTclm131eEYdgapPgXhjvxc6wWp+f8woEXtKc=
X-Received: by 2002:a02:bb83:: with SMTP id g3mr11149521jan.139.1559154373608;
 Wed, 29 May 2019 11:26:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190522032144.10995-1-deepa.kernel@gmail.com> <20190529161157.GA27659@redhat.com>
In-Reply-To: <20190529161157.GA27659@redhat.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Wed, 29 May 2019 11:26:02 -0700
Message-ID: <CABeXuvpUQ8rDZYOi8bzq_yAy8Nt4RLwSEGwpk_Pbwd90Q0u7sg@mail.gmail.com>
Subject: Re: pselect/etc semantics (Was: [PATCH v2] signal: Adjust error codes
 according to restore_user_sigmask())
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, dbueso@suse.de, axboe@kernel.dk,
        Davidlohr Bueso <dave@stgolabs.net>, Eric Wong <e@80x24.org>,
        Jason Baron <jbaron@akamai.com>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>,
        Omar Kilani <omar.kilani@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 9:12 AM Oleg Nesterov <oleg@redhat.com> wrote:
>
> Al, Linus, Eric, please help.
>
> The previous discussion was very confusing, we simply can not understand each
> other.
>
> To me everything looks very simple and clear, but perhaps I missed something
> obvious? Please correct me.
>
> I think that the following code is correct
>
>         int interrupted = 0;
>
>         void sigint_handler(int sig)
>         {
>                 interrupted = 1;
>         }
>
>         int main(void)
>         {
>                 sigset_t sigint, empty;
>
>                 sigemptyset(&sigint);
>                 sigaddset(&sigint, SIGINT);
>                 sigprocmask(SIG_BLOCK, &sigint, NULL);
>
>                 signal(SIGINT, sigint_handler);
>
>                 sigemptyset(&empty);    // so pselect() unblocks SIGINT
>
>                 ret = pselect(..., &empty);
>
>                 if (ret >= 0)           // sucess or timeout
>                         assert(!interrupted);
>
>                 if (interrupted)
>                         assert(ret == -EINTR);
>         }
>
> IOW, if pselect(sigmask) temporary unblocks SIGINT according to sigmask, this
> signal should not be delivered if a ready fd was found or timeout. The signal
> handle should only run if ret == -EINTR.

I do not think we discussed this part earlier. But, if this is true
then this is what is wrong as part of 854a6ed56839a. I missed that
before.

> (pselect() can be interrupted by any other signal which has a handler. In this
>  case the handler can be called even if ret >= 0. This is correct, I fail to
>  understand why some people think this is wrong, and in any case we simply can't
>  avoid this).

This patch is wrong because I did not know that it was ok to deliver a
signal and not set the errno before. I also admitted to this. And
proposed another way to revert the patch.:
https://lore.kernel.org/lkml/CABeXuvouBzZuNarmNcd9JgZgvonL1N_p21gat=O_x0-1hMx=6A@mail.gmail.com/

-Deepa
