Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE62E47AFA5
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbhLTPQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237068AbhLTPOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:14:31 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379EFC0D940C
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 06:57:40 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id e3so39456879edu.4
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 06:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HUHmWuXX8VlTF9hpA1y1c+iXS8fi7L43NGXx9Hiegjg=;
        b=dvs02sSsAlxhiB6e0PVeHzVhBcEy2reW7+Wj9pgM3BKiZ/Gjqf8TFrL6XaVgX4k2HS
         ap3rX8JYih7erDXKhcGrmWwesnfbgjInwgVz6xHzv80g88dKY98/ke7o2GkeXbFvhLuG
         XZp3zYy0h/alewh36FJK29g0IxhZsEU8nsl+vCEP23gL/tf03swDjvG7KrM/ZyLLomjz
         Tw99P2+OhpdT3ADZD3wwlo+0ppbE7S1tqHD1tglcdmSivbKrKQZC8LN748Q9cfgLwc8h
         cyb+Y6c2gBfmq+eS/SHjTliQCRXg5SMEqfVqUtHaCXQVaIHhtA4UrJScca/BLpyfcprj
         wwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HUHmWuXX8VlTF9hpA1y1c+iXS8fi7L43NGXx9Hiegjg=;
        b=BGiL2cs4JOLqackoW77LPtpsXL7jLfAEejGjx1I9GiY3Iiai1gyhIOofk/DDsLLtE+
         CVSksXrka4vWcG9Mzx1mqxaYAobUckL1H1mPvC07Mw+2MD6bKGF/n4GUe7lhvs7/7OjI
         kw0bwtefeCXfdinjCO4rfZZK0GUsd6tvw8jJFiGDGXGM2RTMEUH0kJqzMv0icKWW60Sk
         Uv+Er/8aYlKqX9Xmri3LFq2cp64wZksdbN+ERCT31JmaZxxBjxGXC96lEsKlfOcQrMQx
         e20uoLHc+68iQSkqMX6/AVQ6sMgJiICGdFbqRU8Sc9p2ev6/02KSpGo3kH8UMiPWT5xK
         qesQ==
X-Gm-Message-State: AOAM531qTV9uDBh6oEqHvCkzJGES23VLNxcDg9m63sNd1tyMalfosDNd
        Z489p2XRwjsUsyliRqYY1nl0eKm7cjoNOuYC1voz2w==
X-Google-Smtp-Source: ABdhPJz9B8jdW71VfZkn6ik656/P3HPcergQlD1ReF7ru9atjKHTO6NZEt3lypROwqtqHQM4b1hb7fZyG+IO7ljSSQw=
X-Received: by 2002:a17:907:6289:: with SMTP id nd9mr13119600ejc.101.1640012258769;
 Mon, 20 Dec 2021 06:57:38 -0800 (PST)
MIME-Version: 1.0
References: <20211217153555.9413-1-marcelo.jimenez@gmail.com> <a7fbb773-eb85-ccc7-8bfb-0bfab062ffe1@leemhuis.info>
In-Reply-To: <a7fbb773-eb85-ccc7-8bfb-0bfab062ffe1@leemhuis.info>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 20 Dec 2021 15:57:28 +0100
Message-ID: <CAMRc=MfAxzmAfATV2NwfTgpfmyxFx8bgTbaAfWxSi9zmBecPng@mail.gmail.com>
Subject: Re: [PATCH] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>,
        Vidya Sagar <vidyas@nvidia.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Edmond Chung <edmondchung@google.com>,
        Andrew Chant <achant@google.com>,
        Will McVicker <willmcvicker@google.com>,
        Sergio Tanzilli <tanzilli@acmesystems.it>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 18, 2021 at 7:28 AM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> [TLDR: I'm adding this regression to regzbot, the Linux kernel
> regression tracking bot; most text you find below is compiled from a few
> templates paragraphs some of you might have seen already.]
>
> On 17.12.21 16:35, Marcelo Roberto Jimenez wrote:
> > Some GPIO lines have stopped working after the patch
> > commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
> >
> > And this has supposedly been fixed in the following patches
> > commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
> > commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
>
> There seems to be a backstory here. Are there any entries and bug
> trackers or earlier discussions everyone that looks into this should be
> aware of?
>

Agreed with Thorsten. I'd like to first try to determine what's wrong
before reverting those, as they are correct in theory but maybe the
implementation missed something.

Have you tried tracing the execution on your platform in order to see
what the driver is doing?

Bart
