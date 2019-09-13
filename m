Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DC3B2305
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 17:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391029AbfIMPJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 11:09:34 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:44256 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390046AbfIMPJe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 11:09:34 -0400
Received: by mail-vs1-f65.google.com with SMTP id w195so18812272vsw.11;
        Fri, 13 Sep 2019 08:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pIMiAKhzqydevxJ4SfxaOnAOQBbzxpXSTX/hNzVTWH8=;
        b=DjzBNiaKjsMGHR07OIEmEen2+Lt/bBmp1Im7bvBL0Qyigc+KaPcUpSijaBk9qUvjPS
         8xfSM5N0ecxBI+SLJedJHEnX6TEJ0j27vOUx8Jw7FCZk7SUcTjqva1YAQHwjSIUJhkG2
         GEiQHAMjFoj/YGlkmia0w46DElvxbqcHNJpI1iZdYVhZIStFlgXRq8gJyNcoBXCNKZSH
         0iexM3SpO7cNn/bBajlIeVTnbG+kjwHbLwFA2HedyLW3QL7/twvq7bHJc388NUIJRsTi
         FDvnMsRl9dBxXBgGW4J2MjPU5mMBTH9gr7+90lAa5v5r2/0fagq2vKuVajogwmzeCInk
         SO+g==
X-Gm-Message-State: APjAAAUQzT4a0f/FCHNPJOjMVWMeOBcsgt2oTHBGpg9gScXdnqCVXaOR
        q8Gv7DUwXT9t2pkCTa7Tl1dSVierkUbfOUOmwj4=
X-Google-Smtp-Source: APXvYqylu2hrm9+jShjlZBaJJtsqTtMpCZ46oIHdTl6adXUbUxfPuEUiLtfCfDfh1ckXZtmG7LMM+KfUH5p8IZnGJJ4=
X-Received: by 2002:a05:6102:195:: with SMTP id r21mr21052393vsq.210.1568387373173;
 Fri, 13 Sep 2019 08:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190913130559.669563815@linuxfoundation.org> <20190913130606.981926197@linuxfoundation.org>
 <CAKb7UviY0sjFUc6QqjU4eKxm2b-osKoJNO2CSP9HmQ5AdORgkw@mail.gmail.com>
 <20190913144627.GH1546@sasha-vm> <20190913145456.GA456842@kroah.com> <20190913150111.GI1546@sasha-vm>
In-Reply-To: <20190913150111.GI1546@sasha-vm>
From:   Ilia Mirkin <imirkin@alum.mit.edu>
Date:   Fri, 13 Sep 2019 11:09:22 -0400
Message-ID: <CAKb7Uvj31ZuxB6S4EH8WBRsa2mDScpZN=dRjHScZmN94ajD0EA@mail.gmail.com>
Subject: Re: [PATCH 4.19 092/190] drm/nouveau: Dont WARN_ON VCPI allocation failures
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        "# 3.9+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 13, 2019 at 11:01 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Fri, Sep 13, 2019 at 03:54:56PM +0100, Greg Kroah-Hartman wrote:
> >On Fri, Sep 13, 2019 at 10:46:27AM -0400, Sasha Levin wrote:
> >> On Fri, Sep 13, 2019 at 09:33:36AM -0400, Ilia Mirkin wrote:
> >> > Hi Greg,
> >> >
> >> > This feels like it's missing a From: line.
> >> >
> >> > commit b513a18cf1d705bd04efd91c417e79e4938be093
> >> > Author: Lyude Paul <lyude@redhat.com>
> >> > Date:   Mon Jan 28 16:03:50 2019 -0500
> >> >
> >> >    drm/nouveau: Don't WARN_ON VCPI allocation failures
> >> >
> >> > Is this an artifact of your notification-of-patches process and I
> >> > never noticed before, or was the patch ingested incorrectly?
> >>
> >> It was always like this for patches that came through me. Greg's script
> >> generates an explicit "From:" line in the patch, but I never saw the
> >> value in that since git does the right thing by looking at the "From:"
> >> line in the mail header.
> >>
> >> The right thing is being done in stable-rc and for the releases. For
> >> your example here, this is how it looks like in the stable-rc tree:
> >>
> >> commit bdcc885be68289a37d0d063cd94390da81fd8178
> >> Author:     Lyude Paul <lyude@redhat.com>
> >> AuthorDate: Mon Jan 28 16:03:50 2019 -0500
> >> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >> CommitDate: Fri Sep 13 14:05:29 2019 +0100
> >>
> >>    drm/nouveau: Don't WARN_ON VCPI allocation failures
> >
> >Yeah, we should fix your scripts to put the explicit From: line in here
> >as we are dealing with patches in this format and it causes confusion at
> >times (like now.)  It's not the first time and that's why I added those
> >lines to the patches.
>
> Heh, didn't think anyone cared about this scenario for the stable-rc
> patches.
>
> I'll go add it.
>
> But... why do you actually care?

Just a hygiene thing. Everyone else sends patches the normal way, with
accurate attribution. Why should stable be different?

(I was surprised to see Greg contributing to nouveau when I first saw
the patch. But then realized it was the stable ingestion
notification.)

  -ilia
