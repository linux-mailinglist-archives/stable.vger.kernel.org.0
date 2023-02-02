Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6CC6888C6
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 22:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbjBBVLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 16:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBBVLt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 16:11:49 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 459B071990
        for <stable@vger.kernel.org>; Thu,  2 Feb 2023 13:11:48 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id u72so3921854ybi.7
        for <stable@vger.kernel.org>; Thu, 02 Feb 2023 13:11:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j+CqMtFrVSGkYiD3673aMvxsTntB2I4HLVlj0tiHNNI=;
        b=CnXXTWGbi5MfdiGnHvkf0MWLYlJ/KDP9fWsDIjlvZ8/zcosRgAlSxNOwf3hzUd0Ky/
         EE8s0lpWmM5P0/d4HqZs6wpEXwUpLd2hgQ97yZRHONrj2x3FiI7c3nXdrndTKbp0xq+S
         sllzBBNnXErmDfXPo1Dub1ZTMsPWgoHAk98QPByIyPrd7SBFtorjpFkKXgOZ3/QMH75z
         NFQ5nbbqcotZid+T1RaUMDRM7HQqEiHaTtLRE2+70QbdyHSLN0xThX06XWXu55efO/7a
         kQVySGOuMwbRMu3SfC+SqQBiJiLCM/sJyKEOCKrwjGUwS/Rdx7feRXMYgLvweeBxZiPt
         pbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+CqMtFrVSGkYiD3673aMvxsTntB2I4HLVlj0tiHNNI=;
        b=p/QggGs1TGsQwn+pm9I3VVfiifX6LWjFgeC0vQoA2BzdbU1F8SjODO7Bcd8UHpOLOh
         eOwtnkYh0Yeiyz+DVfj78BWKN98nrIj7JN+Vk6rLVHHSDywT1UWLLgITm5I2Led3QlSZ
         g5ZssvPVwdFWxLyfe1KVdLJ+8PpaSbgRkH00RP7ARFXc8fiYeB9vzRICU+rn4qkE4d8p
         kFoGelBX6dBbTRD7SOkblYiJVx/UFiM5VDTtFSWqiwsvPOVFeUtMjH99P7jxgDi1ii0q
         FUOE/4KQ6ichPfFknxRb7jzFUPx+XQdAK5c0HLv0a9dHSiJ5hyR/2KwDki3Y8bEcDySv
         ACTQ==
X-Gm-Message-State: AO0yUKVml6GfyckKedpwRLA3jg4fQRWR3I9RKfU8K+dRvvtXjMm4lnk8
        UpUjlNWEAMEiWGDREyC22x0bPA/nOoLw0HDIujnaJQ==
X-Google-Smtp-Source: AK7set8dW/3ELqgHnqlRkiGKJao9L8VMiVvIhM/4TdKtluEAMjhR7nAYm8zA9yi2w+T372MxrWk7KDkhWrmxtayFHUM=
X-Received: by 2002:a25:5007:0:b0:80f:4da9:d5dc with SMTP id
 e7-20020a255007000000b0080f4da9d5dcmr846491ybb.431.1675372307335; Thu, 02 Feb
 2023 13:11:47 -0800 (PST)
MIME-Version: 1.0
References: <CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com>
 <20230202030023.1847084-1-kamatam@amazon.com> <Y9tCl4r/qjqsrVj9@sol.localdomain>
In-Reply-To: <Y9tCl4r/qjqsrVj9@sol.localdomain>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 2 Feb 2023 13:11:36 -0800
Message-ID: <CAJuCfpFb0J5ZwO6kncjRG0_4jQLXUy-_dicpH5uGiWP8aKYEJQ@mail.gmail.com>
Subject: Re: [PATCH] sched/psi: fix use-after-free in ep_remove_wait_queue()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Munehisa Kamata <kamatam@amazon.com>, hannes@cmpxchg.org,
        hdanton@sina.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mengcc@amazon.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 1, 2023 at 8:56 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Feb 01, 2023 at 07:00:23PM -0800, Munehisa Kamata wrote:
> > diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> > index 8ac8b81bfee6..6e66c15f6450 100644
> > --- a/kernel/sched/psi.c
> > +++ b/kernel/sched/psi.c
> > @@ -1343,10 +1343,11 @@ void psi_trigger_destroy(struct psi_trigger *t)
> >
> >       group = t->group;
> >       /*
> > -      * Wakeup waiters to stop polling. Can happen if cgroup is deleted
> > -      * from under a polling process.
> > +      * Wakeup waiters to stop polling and clear the queue to prevent it from
> > +      * being accessed later. Can happen if cgroup is deleted from under a
> > +      * polling process otherwise.
> >        */
> > -     wake_up_interruptible(&t->event_wait);
> > +     wake_up_pollfree(&t->event_wait);
> >
> >       mutex_lock(&group->trigger_lock);
>
> wake_up_pollfree() should only be used in extremely rare cases.  Why can't the
> lifetime of the waitqueue be fixed instead?

waitqueue lifetime in this case is linked to cgroup_file_release(),
which seems appropriate to me here. Unfortunately
cgroup_file_release() is not directly linked to the file's lifetime.
For more details see:
https://lore.kernel.org/all/CAJuCfpFZ3B4530TgsSHqp5F_gwfrDujwRYewKReJru==MdEHQg@mail.gmail.com/#t
.
So, if we want to fix the lifetime of the waitqueue, we would have to
tie cgroup_file_release() to the fput() somehow. IOW, the fix would
have to be done at the cgroups or higher (kernfs?) layer.
Thanks,
Suren.

>
> - Eric
