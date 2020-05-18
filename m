Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824D61D8875
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 21:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgERTrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 15:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728458AbgERTri (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 15:47:38 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5D8C061A0C
        for <stable@vger.kernel.org>; Mon, 18 May 2020 12:47:38 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id c3so9151956otr.12
        for <stable@vger.kernel.org>; Mon, 18 May 2020 12:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bBFO4lwxkSc+LH1NOlFaVaJnTNT/AhBja3Nhpq3LMZo=;
        b=oBUdzRHMNHiLmelW0hosDtypTPyHRt493bdqwDjTFRuvIEWwISb1RnL8axaggTtTqh
         uNNejrq0cHOKB0cY9oe8iXdVYImLfNBqR97BqDlUqRc9A4xVS2Go+uk0yk6IfaCjB/Dk
         NnXVFTY2FJQCghGW+vh68cb/zoYHMBeOkAJXuhM9Kh/Uxc50ivmv/wEIaBzochvN9QXN
         hi4qwhUKQOUIMzLPRjkhb0MSeYAIlJbNznsXC4wQSy63wT8Mc4TEwYMm2r8Cb8d34DFs
         R131G7BdD20iNUnBj9YD+NssbMfazxN/NYwO3/g249tzyLl0e+tAaDkFGdRTlPlS4oHv
         aQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bBFO4lwxkSc+LH1NOlFaVaJnTNT/AhBja3Nhpq3LMZo=;
        b=qV7gS3lUZGZ28Xul+erxN13DUwnRF0JpdnEJ20Gbf6+BOUyAUhp7jgbyt5i4qIVqdT
         BYmP4REMqTxvBFugVU6p5DWVTlvm0gWVHhDPtFBuEGT+FyS31br4l8uWOaOdgCjAvvN+
         OikLbdPAdItmfJnt/Sz1js2/6KeTaWmQ/GlmlVJJ1hQt0Xq7JGOpD4OzLo7t3RT7Zm5g
         j4Pf1e+y3U7P55GVcZPekVI3pbApbcwVCoLUUrCdbIwJZhkByURUK44kMcFCk1lEEthJ
         94Yx3/K7QfErIGUfLqeDynxWWSZZjTLt67I9/wyoL7ggq+UeVVJQJh1+cSlIiEpm6zMc
         AagA==
X-Gm-Message-State: AOAM531Sa85WfJ8saHwmlTvdqt5oNWDABIRA6rLKDojgw+b95WvkM9yH
        bAlC/e8Nwm5rXdypVEYFLgdEsWYJxnCOthDNqkMmmqtX7vw=
X-Google-Smtp-Source: ABdhPJx+S+VGxK4icqY0mL6oiXyHIyaFLh5EyrnOy//4cOukH88/sp+o301KYy7kjzDc53ynlcWC/sXZqozFE+cmDBc=
X-Received: by 2002:a9d:2622:: with SMTP id a31mr14506353otb.231.1589831257541;
 Mon, 18 May 2020 12:47:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200516080718.166676-1-saravanak@google.com> <CAGETcx8Ro_tsmYEQwzZKsm2xzimw=MBcChbSW5Nx9arUni53wQ@mail.gmail.com>
 <20200518080327.GA3126260@kroah.com>
In-Reply-To: <20200518080327.GA3126260@kroah.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 18 May 2020 12:47:01 -0700
Message-ID: <CAGETcx9gUG-0GW8trnC-xm5DPfXkVjgdzBg0-M+tRWhyz8fgQw@mail.gmail.com>
Subject: Re: [PATCH v1] driver core: Fix memory leak when adding
 SYNC_STATE_ONLY device links
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 18, 2020 at 1:03 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, May 18, 2020 at 12:48:42AM -0700, Saravana Kannan wrote:
> > On Sat, May 16, 2020 at 1:07 AM Saravana Kannan <saravanak@google.com> wrote:
> > >
> > > When SYNC_STATE_ONLY support was added in commit 05ef983e0d65 ("driver
> > > core: Add device link support for SYNC_STATE_ONLY flag"),
> > > device_link_add() incorrectly skipped adding the new SYNC_STATE_ONLY
> > > device link to the supplier's and consumer's "device link" list. So the
> > > "device link" is lost forever from driver core if the caller didn't keep
> > > track of it (typically isn't expected to).
> > >
> > > If the same SYNC_STATE_ONLY device link is created again using
> > > device_link_add(), instead of returning the pointer to the previously
> > > created device link, a new device link is created and returned. This can
> > > cause memory leaks in conjunction with fw_devlinks.
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: 05ef983e0d65 ("driver core: Add device link support for SYNC_STATE_ONLY flag")
> > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> >
> > Greg/Rafael,
> >
> > This patch causes a warning for SYNC_STATE_ONLY links because they
> > allow consumers to probe before suppliers but the device link
> > status/state change code wasn't written with that possibility in mind.
> > So I need to fix up that warning or state change code.
>
> What type of warning happens?

The WARN_ON(link->status != DL_STATE_CONSUMER_PROBE); inside
device_links_driver_bound().

>
> > Depending on how urgent you think memory leak fixes are, you can take
> > it as is for now and I can send a separate patch to fix the
> > warning/state change code later. Or if we can sit on this memory leak
> > for a week, I might be able to fix the warning before then.
>
> memory leaks are not ok, but neither is adding runtime warnings.  Any
> chance we can't just get a fix for both?  :)

Don't pick up this patch. I think I have a fix that fixes the memory
leak without warnings that also coincidentally frees up some memory.
Testing it.

-Saravana
