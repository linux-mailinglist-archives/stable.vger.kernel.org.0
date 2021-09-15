Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B85040CCB3
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 20:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhIOSnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 14:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhIOSnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 14:43:21 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD5FC061575
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 11:42:02 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id i7so7983254lfr.13
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 11:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NJ46yNZedpI+wkzb9wsbjujLref1FzkKQaXKuIRt51c=;
        b=IT1Y5U2ktJo7w9Wg5bowIJJPlhgNhDRPAoHbs2He2eZsAtxlwgVrbfsjQFCw5gxROM
         O5iIJg0MQClA71qDpgmmkp88nEwt2ZQZ/lLLA22UvQcJUR11PZHw3hsCz0ve7UVZcW2e
         j/fpK1p7cnjudgj+yOCsHtVB509FWO6PRw7dA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NJ46yNZedpI+wkzb9wsbjujLref1FzkKQaXKuIRt51c=;
        b=jFafQmeplt/ebxNwAV9OTF0dClx8RpjBgBMzJtNh8sOBp6SV4Zt/yc/EnxTbC/jVqf
         jb1/CU/za4uL8aiY0ozsS3VLwmBytCdeOWnWi1IUXNr4Uf8saWjQ56MMftRVDGvmKqN/
         Js8ndsp6XgvsoB1rdaJUoD0QEDQZFT8UUzA3qobh6yA2wbZtBdxL64VkXWPgz+BdozDf
         gohLPTMIrZHMoLlTtTD8uefDUJ5Nypg7sdBO4hdCPVdduUjWqd0dCtWKF5nKeaR9/XaF
         eYu1JNiApGosghEzc9WxmbrSngw2jFByGT02GFRCbT/Jv7ag1EQ6uBuCUPN9gBUSqZGg
         wFwQ==
X-Gm-Message-State: AOAM532Cs9OsWs179V5OjUTmLrgeO4x1QSSazqVk8HmnbnD/FxhNAae1
        o2QYLpV9bRzyCk4y+PAaLUULmXswTmPQms1247I=
X-Google-Smtp-Source: ABdhPJxLXUF2EFBppXH53qhBqsdTUQGyaJL0khbdTxauowmCq6dLnelSQ1HJjBJl1oKblMh9zOXbBQ==
X-Received: by 2002:a05:6512:304b:: with SMTP id b11mr1002417lfb.190.1631731320063;
        Wed, 15 Sep 2021 11:42:00 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id 26sm56438lfz.40.2021.09.15.11.41.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 11:41:59 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id i7so7982960lfr.13
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 11:41:59 -0700 (PDT)
X-Received: by 2002:a2e:8185:: with SMTP id e5mr1258092ljg.31.1631731318838;
 Wed, 15 Sep 2021 11:41:58 -0700 (PDT)
MIME-Version: 1.0
References: <1631693373201133@kroah.com> <87ilz1pwaq.fsf@wylie.me.uk> <20210915183152.GA22415@lothringen>
In-Reply-To: <20210915183152.GA22415@lothringen>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 15 Sep 2021 11:41:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgiiqmy1jE0i9EYkCiE+KNHDTJQVktczZgyJwqL-okRgA@mail.gmail.com>
Message-ID: <CAHk-=wgiiqmy1jE0i9EYkCiE+KNHDTJQVktczZgyJwqL-okRgA@mail.gmail.com>
Subject: Re: Regression in posix-cpu-timers.c (was Re: Linux 5.14.4)
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     "Alan J. Wylie" <alan@wylie.me.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 11:31 AM Frederic Weisbecker
<frederic@kernel.org> wrote:
>
> Right, this should fix the issue: https://lore.kernel.org/lkml/20210913145332.232023-1-frederic@kernel.org/

Hmm.

Can you explain why the fix isn't just to revert that original commit?

It looks like the only real difference is that now it does *extra
work* with all that tick_nohz_dep_set_signal().

Isn't it easier to just leave any old timer ticking, and not do the
extra work until it expires and you notice "ok, it's not important"?

IOW, that original commit explicitly broke the only case it changed -
the timer being disabled.  So why isn't it just reverted? What is it
that kleeps us wanting to do the extra work for the disabled timer
case?

As long as it's fixed, I'm all ok with this, but I'm looking at the
commit message for that broken commit, and I'm looking at the commit
message for the fix, and I'm not seeing an actual _explanation_ for
this churn.

               Linus
