Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE8D5588F9
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 21:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiFWTdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 15:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbiFWTcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 15:32:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CCB4F44A;
        Thu, 23 Jun 2022 12:11:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78310B824BD;
        Thu, 23 Jun 2022 19:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88012C341C0;
        Thu, 23 Jun 2022 19:11:46 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="NWL2BxHI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656011505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KrPWxMJyAdJOhI1osU9RgqZ+wVkEhrBWbK7RJOAjMl8=;
        b=NWL2BxHIsjgB7FSRs2SCmcvc1J23o45nP0A2irXHHPKRoN4OWrL3Ph1NyqyJsa9Xfkr7k2
        8B9kE2WwHm+RHTAnML+mn+5mJh9XzmMIZdVRsPl6gnlasznNhwig5kth0LqeVKujbO+MIn
        IvvYKmjIjlVXx/G0EZhMIvxYDxgnwU0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 0599986e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 23 Jun 2022 19:11:44 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id p69so400756iod.10;
        Thu, 23 Jun 2022 12:11:44 -0700 (PDT)
X-Gm-Message-State: AJIora/DRe+84mglFt3Hkzxmg57/um1uYCOkMBeMTy3fAm83eTsfH6Hi
        Q6qjMMB59+SWBXSCxB2Tc6MiYexh8WByeQFZzzs=
X-Google-Smtp-Source: AGRyM1sQ9+5iD4rRkdV2LPNY4XKTIJ/DRdw53CgFoLLbvR3XH1jbljxPVnfowpglFDUwJ2woG2r44LTnnDgm4jTWHbc=
X-Received: by 2002:a02:9709:0:b0:339:ef87:c30b with SMTP id
 x9-20020a029709000000b00339ef87c30bmr1720807jai.214.1656011503557; Thu, 23
 Jun 2022 12:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9rbOt14sHkPVgb7yysYSXk-eiwzkp9PzPnyO_9HyrmQ3Q@mail.gmail.com>
 <20220623190014.1355583-1-Jason@zx2c4.com> <YrS6l38HDhqJIYS9@sol.localdomain>
In-Reply-To: <YrS6l38HDhqJIYS9@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 23 Jun 2022 21:11:32 +0200
X-Gmail-Original-Message-ID: <CAHmME9qGQrgCEGgQpomq6W2EMUy_D5AxqgYHykmmgND+PPVjjw@mail.gmail.com>
Message-ID: <CAHmME9qGQrgCEGgQpomq6W2EMUy_D5AxqgYHykmmgND+PPVjjw@mail.gmail.com>
Subject: Re: [PATCH v3] timekeeping: contribute wall clock to rng on time change
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

On Thu, Jun 23, 2022 at 9:10 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Jun 23, 2022 at 09:00:14PM +0200, Jason A. Donenfeld wrote:
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
> >  kernel/time/timekeeping.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> > index 8e4b3c32fcf9..49ee8ef16544 100644
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
> > @@ -1343,8 +1344,10 @@ int do_settimeofday64(const struct timespec64 *ts)
> >       /* Signal hrtimers about time change */
> >       clock_was_set(CLOCK_SET_WALL);
> >
> > -     if (!ret)
> > +     if (!ret) {
> >               audit_tk_injoffset(ts_delta);
> > +             add_device_randomness(&ts, sizeof(ts));
> > +     }
>
> It should be:
>
> add_device_randomness(ts, sizeof(*ts));

This simple patch... I swear I know C, I promise...

Thanks again, and sorry.

Jason
