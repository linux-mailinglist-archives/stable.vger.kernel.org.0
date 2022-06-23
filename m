Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170925588C3
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiFWT2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiFWT2F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:28:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217688C7E4;
        Thu, 23 Jun 2022 11:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D67FEB82480;
        Thu, 23 Jun 2022 18:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D67C341C8;
        Thu, 23 Jun 2022 18:56:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="mm4ALGWg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656010586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5YpLmQ7Abl0j2shy8v1mtUe5EoOtXzN9rIjE6y2miWk=;
        b=mm4ALGWgXiMkAeh/rW8fCViz2esyFQHn9rhHe3t/wIcygoCe2HJURsEdKfg2nj9T16ocAi
        aT07ugYPUlMDO84QnvDIexAhDIHzvfSA5O+tjvfZzBp4wiFkF8YDn0zM+uOj8zK2VtjgXl
        WOkmkkUPVtgaEF7T9eET7EysDuPhg8Y=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id af793dff (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 23 Jun 2022 18:56:26 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id r133so387754iod.3;
        Thu, 23 Jun 2022 11:56:25 -0700 (PDT)
X-Gm-Message-State: AJIora+paCHaEshhdJ5izq4f5/hMp7YMBJiJPpmj1REMFmg4TikhIP/2
        iuWOmrnBSIccRhvDu9yuILX/wm6QJsQF96UOZKw=
X-Google-Smtp-Source: AGRyM1vnGuVnyGYus/8ipu3FTOK8NaPL5KpSrD9ihTvl2t1z4os/T+QA+XPcOeEeqwFmfXBphzMld+wA51c6a9jfUL4=
X-Received: by 2002:a05:6638:210b:b0:339:e070:518c with SMTP id
 n11-20020a056638210b00b00339e070518cmr5171709jaj.196.1656010585296; Thu, 23
 Jun 2022 11:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9qy0N3BvDo-0jkS+om0N3Yk--ZAyKvSKshzDBzvuoP+UA@mail.gmail.com>
 <20220623180555.1345684-1-Jason@zx2c4.com> <YrS2jtI+mt99AOz1@sol.localdomain>
In-Reply-To: <YrS2jtI+mt99AOz1@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 23 Jun 2022 20:56:14 +0200
X-Gmail-Original-Message-ID: <CAHmME9rbOt14sHkPVgb7yysYSXk-eiwzkp9PzPnyO_9HyrmQ3Q@mail.gmail.com>
Message-ID: <CAHmME9rbOt14sHkPVgb7yysYSXk-eiwzkp9PzPnyO_9HyrmQ3Q@mail.gmail.com>
Subject: Re: [PATCH v2] timekeeping: contribute wall clock to rng on time change
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 8:53 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jun 23, 2022 at 08:05:55PM +0200, Jason A. Donenfeld wrote:
> > The rng's random_init() function contributes the real time to the rng at
> > boot time, so that events can at least start in relation to something
> > particular in the real world. But this clock might not yet be set that
> > point in boot, so nothing is contributed. In addition, the relation
> > between minor clock changes from, say, NTP, and the cycle counter is
> > potentially useful entropic data.
> >
> > This commit addresses this by mixing in a time stamp on calls to
> > settimeofday and adjtimex. No entropy is credited in doing so, so it
> > doesn't make initialization faster, but it is still useful input to
> > have.
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > ---
> >  kernel/time/timekeeping.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index 8e4b3c32fcf9..89b894b3ede8 100644
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/pvclock_gtod.h>
> >  #include <linux/compiler.h>
> >  #include <linux/audit.h>
> > +#include <linux/random.h>
> >
> >  #include "tick-internal.h"
> >  #include "ntp_internal.h"
> > @@ -1331,6 +1332,8 @@ int do_settimeofday64(const struct timespec64 *ts)
> >               goto out;
> >       }
> >
> > +     add_device_randomness(&ts, sizeof(ts));
> > +
> >       tk_set_wall_to_mono(tk, timespec64_sub(tk->wall_to_monotonic, ts_delta));
>
> This is now nested inside:
>
>         raw_spin_lock_irqsave(&timekeeper_lock, flags);
>         write_seqcount_begin(&tk_core.seq);
>
> Could there be a deadlock if random_get_entropy() in add_device_randomness()
> falls back to reading the monotonic clock?

Also nice find as the raw_spin_lock itself is problematic on RT,
because add_device_randomness can take a normal one. I'll do some
hoisting.

Jason
