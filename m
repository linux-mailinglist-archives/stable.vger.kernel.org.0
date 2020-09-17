Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1061526E06E
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 18:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgIQQQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 12:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728354AbgIQQQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 12:16:28 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED59C061224
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 09:16:14 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g4so3170343edk.0
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 09:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XXtED6WfkK75LMSgQ8vQsHgOI0yBBTxcCbphfrryf6M=;
        b=pxXpcpXnfAa9lQiUbT1N7VNoozm1D6PgfhboSOd3HXlWtPP7dYn2AhERiYfxBWj37j
         jsduSgKo3fSswcu5jj7rT8R/p1UoiktZNMLCBziOtWuDhQCPfVIjzVBeazVgnC7kRgvb
         cGOIN9WJf/fdeKcuLTS4+4caBpl9TCTVBd0AvPoYPAUTCm0L5Eu+6tCTUkWqTzKAN6Sg
         6hVKODArf8j6huwlEWsNCAN0SmhEWJP+z7xiTEXP/xs+c+C93cyj03dm9fgx6GGdgbZP
         L1l6cPnrFPnghuoXMbTxtMYD3X5cX0CpEDPNPU8W+/vBUg07fEYXXi8zmHuICCNykgYh
         Ljsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XXtED6WfkK75LMSgQ8vQsHgOI0yBBTxcCbphfrryf6M=;
        b=NWhYCRzY7QVcxg4tuIHq+BTkmjwcGnYKj73UBiWujisTsSoeMJb3dYrn3M8y8z+YSG
         an8xjDX9VmA12/9Cc3yL0Od0Mt8sGHhEiInz0ZcIavyFQ9340IyYBzJCO7p97f+ZYhN/
         GbDuRaWeUVlcRip3aID2aF3CaGzZ+wigWAqrddx8Hn4Fk07xsMq0CCw5o3cNhsZtbsD+
         zbmYQyyRvZcNAZZVG7W5yG6cYRLxRRraNXVlP0q8Ei755+5bEkggw3rEoAkj0L3yGROV
         JhlPpxP2036VGoCELKXljQL7CYms2R6C9radpNfkCwgZzp/jVONKlzlV9CO4JV1Mu8Gb
         TEpw==
X-Gm-Message-State: AOAM530l+NjUL0dqSZ0tXgmNHXjkW8wJwWKXrxu7EayKWXKTDBOIdcoK
        7dBqBhIXwtHg1tYCUWzCbsnMjrBAPDw0oEFb1BbJzA==
X-Google-Smtp-Source: ABdhPJwfOaudC9vLJAbRhRYhSHh7q4n3U/sNpTA5Q1/lxT2SwoFxppQHiVyye1h5POHhmPDl/bW1IEH53reBheDklw4=
X-Received: by 2002:a50:9b44:: with SMTP id a4mr32910561edj.12.1600359373655;
 Thu, 17 Sep 2020 09:16:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200914154601.32245-2-brgl@bgdev.pl> <20200917155336.23ECD221E3@mail.kernel.org>
In-Reply-To: <20200917155336.23ECD221E3@mail.kernel.org>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 17 Sep 2020 18:16:02 +0200
Message-ID: <CAMpxmJVhfVZLmepERHSVg9qnuWUJj+BwiOKc_7QopREbHvAZpQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/14] rtc: rx8010: don't modify the global rtc ops
To:     Sasha Levin <sashal@kernel.org>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Alessandro Zummo <a.zummo@towertech.it>,
        linux-rtc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Stable # 4 . 20+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 5:53 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: ed13d89b08e3 ("rtc: Add Epson RX8010SJ RTC driver").
>
> The bot has tested the following trees: v5.8.9, v5.4.65, v4.19.145, v4.14.198, v4.9.236.
>
> v5.8.9: Build OK!
> v5.4.65: Build OK!
> v4.19.145: Failed to apply! Possible dependencies:
>     9d085c54202d ("rtc: rx8010: simplify getting the adapter of a client")
>
> v4.14.198: Failed to apply! Possible dependencies:
>     9d085c54202d ("rtc: rx8010: simplify getting the adapter of a client")
>
> v4.9.236: Failed to apply! Possible dependencies:
>     9d085c54202d ("rtc: rx8010: simplify getting the adapter of a client")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>
> --
> Thanks
> Sasha

I sent out a backport for v4.X branches.

Bartosz
