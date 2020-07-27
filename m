Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD3822FBFB
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 00:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgG0WST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 18:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbgG0WSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 18:18:18 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE2A2C061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 15:18:18 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id n141so7376640ybf.3
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 15:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y4AToGLC11QYNl1KBQKdNwb699xIlG7oY11nGnEUTfA=;
        b=KIMvTjtLLu0JWoYkFxxc+Q5rdhiSz5F+OZkV6KRHA6e3kswH8KYnEwn6bs0qbiP/Ak
         vVyrG9jIViM11sAULg/9Nq2CqW7CVmD2COUBCwyTN4gBrOYFopnixQkyWQVsd+goexyl
         zxz0Y+4SlI17pkcxFGlYHODA+jQxawFXMxPcs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y4AToGLC11QYNl1KBQKdNwb699xIlG7oY11nGnEUTfA=;
        b=l96mF0baPTJQaYQ8M2aMH+UAS+B1OuqYTXlgkLFDB7kxrmEU0wJlK4pnbhEbeutzY3
         br45i8Jf6TbQknTX16iMInWwVul7jbakR+fUgaQz4gkHiULtNAag9TRPtJ59xA8GU8oo
         vhcSgMXSVWXsDhjEIhH8MfDU3UlpxE+g19ZcgRyPeSErMwR+RkiVUJl+GDCnSvBCKmng
         QIfLuBwMAxQdygFsAdmKNnB6pusCF1qP/l5QZXqHkd1cu2+jgVfnhyslDwuYO42zUuUx
         m0GuWIbpub0qPVdNLE/UmfakSxTizhEd/anQPyjdURIcruwcdE7qvVHw4cq+P9BYLSsv
         8Z8A==
X-Gm-Message-State: AOAM533CaAR2unXWIqQhYULydX/ObHFDEpxxQEP3+Aa5yTrWtVpeMUPv
        V8Opm5yCqT1ro9IUJAGwssTiMKJLdXXhdMBU2OVr7A==
X-Google-Smtp-Source: ABdhPJzr6zcw+sS34LGrszkKhgELMUGJ6TrMhI9DYMWTLPhj1VElRqJgWMT+dAOcspBFUxlXGZtz5ihBrdYU19W9RgI=
X-Received: by 2002:a25:c60c:: with SMTP id k12mr36831638ybf.407.1595888297688;
 Mon, 27 Jul 2020 15:18:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200727134914.312934924@linuxfoundation.org> <20200727134917.124943291@linuxfoundation.org>
 <20200727212933.pkt6kgescdz7akht@duo.ucw.cz> <20200727220112.GV1665100@dtor-ws>
In-Reply-To: <20200727220112.GV1665100@dtor-ws>
From:   "dbasehore ." <dbasehore@chromium.org>
Date:   Mon, 27 Jul 2020 15:18:06 -0700
Message-ID: <CAGAzgsrTBm0UWM5QwxzePRrpz2xOUsJ4cuyj28q=ik++OQ-dkw@mail.gmail.com>
Subject: Re: [PATCH 4.19 54/86] Input: elan_i2c - only increment wakeup count
 on touch
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 3:01 PM Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Mon, Jul 27, 2020 at 11:29:33PM +0200, Pavel Machek wrote:
> > Hi!
> >
> > > From: Derek Basehore <dbasehore@chromium.org>
> > >
> > > [ Upstream commit 966334dfc472bdfa67bed864842943b19755d192 ]
> > >
> > > This moves the wakeup increment for elan devices to the touch report.
> > > This prevents the drivers from incorrectly reporting a wakeup when the
> > > resume callback resets then device, which causes an interrupt to
> > > occur.
> >
> > Contrary to the changelog, this does not move anything... unlike
> > mainline, it simply adds two pm_wakeup_events.
> >
> > It may still be correct, but maybe someone wants to double-check?
>
> Good catch, I believe the backport is busted.

I don't believe it will break anything, but the backport isn't needed
in 4.19 since "Input: elan_i2c - increment wakeup count if wake
source" wasn't merged into 4.19. It's probably best to drop the
backport.

>
> Thanks.
>
> --
> Dmitry
