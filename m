Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF7E558800
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbiFWS7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiFWS7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:59:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F9AB8A92;
        Thu, 23 Jun 2022 11:04:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B69261E4D;
        Thu, 23 Jun 2022 18:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3B9C341C4;
        Thu, 23 Jun 2022 18:04:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="h1jvReqM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656007492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LzJvh3uAAxlS7XPNKmja7cqPyHCmYwl3uhL+LI86XF4=;
        b=h1jvReqMvBXzPGruEUf6QnOuWB0q1g/7z+InJx0Gc+vuwV/jv1hYNoJJ9M3dJh3WQh1V0g
        y5lliGqFoo3OGczS44stgB+JrFv7DzAzabcAqQPs/NpAUYlhkUsGBcTVvok4XzIQilVldT
        6J9nGBH2+0422r5VHN0E/C/cyZpTUB0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f16c9940 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Thu, 23 Jun 2022 18:04:52 +0000 (UTC)
Received: by mail-io1-f48.google.com with SMTP id r133so224568iod.3;
        Thu, 23 Jun 2022 11:04:51 -0700 (PDT)
X-Gm-Message-State: AJIora8++2n5R5QwXmvKOcheEoq++RQqZOH6J4O7ITHVfkOi2jEDKKWL
        xufIcnbR16OZl9i/WKVWHsHJ6V5p6GGwLXCEO1c=
X-Google-Smtp-Source: AGRyM1sYzzn49nZdZfpRROYmumtGQOWfZBmeclqVbJXdraACTIjy7c3i4Bfu5YlNhHjODySkAq/8xEAILumFLAY5FLA=
X-Received: by 2002:a02:9709:0:b0:339:ef87:c30b with SMTP id
 x9-20020a029709000000b00339ef87c30bmr1569217jai.214.1656007491034; Thu, 23
 Jun 2022 11:04:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220623165226.1335679-1-Jason@zx2c4.com> <YrSlPUhqhOosqpMH@sol.localdomain>
In-Reply-To: <YrSlPUhqhOosqpMH@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 23 Jun 2022 20:04:39 +0200
X-Gmail-Original-Message-ID: <CAHmME9qy0N3BvDo-0jkS+om0N3Yk--ZAyKvSKshzDBzvuoP+UA@mail.gmail.com>
Message-ID: <CAHmME9qy0N3BvDo-0jkS+om0N3Yk--ZAyKvSKshzDBzvuoP+UA@mail.gmail.com>
Subject: Re: [PATCH] timekeeping: contribute wall clock to rng on time change
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

Hi Eric,

On Thu, Jun 23, 2022 at 7:39 PM Eric Biggers <ebiggers@kernel.org> wrote:
> This doesn't compile:

Doh. I had the missing include, but missed it in `git add -p`. Will be
fixed for v2.

> > @@ -1346,6 +1346,9 @@ int do_settimeofday64(const struct timespec64 *ts)
> >       if (!ret)
> >               audit_tk_injoffset(ts_delta);
> >
> > +     ktime_get_real_ts64(&xt);
> > +     add_device_randomness(&xt, sizeof(xt));
> > +
> >       return ret;
>
> Isn't the new time already available in 'ts'?  Is the call to
> ktime_get_real_ts64() necessary?

Good point; you're right. Will simplify as such.

> >       ntp_notify_cmos_timer();
> >
> > +     ktime_get_real_ts64(&ts);
> > +     add_device_randomness(&ts, sizeof(ts));
> > +
> >       return ret;
> >  }
>
> adjtimex() actually triggers a gradual adjustment of the clock, rather than
> setting it immediately.  Is there a way to mix in the target time rather than
> the current time as this does?

Hmm... I have no idea. But maybe instead I can just call
`add_device_randomness()` on that big struct of offsets and things. If
the kernel is able to use it to set the time, then probably it's a
sufficient encoding of that end state.

Jason
