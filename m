Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811CA1E7C87
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 14:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgE2MDW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 08:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbgE2MDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 08:03:21 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E89BC03E969
        for <stable@vger.kernel.org>; Fri, 29 May 2020 05:03:21 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id z13so2276511ljn.7
        for <stable@vger.kernel.org>; Fri, 29 May 2020 05:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vMjA6Hc6hIkjRiWvhUjavzLBkHkAuzzyci/4r7aQoVk=;
        b=umjUHv6R2CawC/x8CK1YWG842nEbfESWDzVn4wynfcxQiqp2Q3I1itUDOHZm3Ck+aD
         YMigjJO1hnK2CAYw8q8EqCT1vjroZhOJa2EDHaBBGbBmIVZVHkcx1xh+jAlt8r8JmGJM
         rNmlsfppdQUegjlqgT0FdfIznCsXzNP/zxSZH5dhD8I+ooNC8KQMzTdL7dcmVgJwEsJe
         TUjZIjEQqHMvBPVmBG+gDACW5JtnwFdYgsol5U9qBNriVSvtEdq7mqfVQ0wF8p+8bPhd
         uKR6/DzejltvtRgxS0ppXkaIfmk5XHHV590gOCb2jt/bQ1774bWQFmxXk6553R8lIpOh
         Eb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vMjA6Hc6hIkjRiWvhUjavzLBkHkAuzzyci/4r7aQoVk=;
        b=X0512+9TcyUb3HkuoHfKiDV6dv8U4lngc1AJYy6/2V5mm9ZyZRLVQg1fK0qmG/cUSK
         5oKFjojan6XjE2Ba/cIB3LHHpj4yQQiPT/TayVtW+oGgnSdlTGuIytIsg52aaWqcNC27
         HMTGUA2+2UTl8Np3liT8URZBvsUSCH3xcgstRdMU6mh2EIcExzndvC0hrEo+/jDVVp6Z
         SC9d6zNOm+8lGk7Yryoa8tbSl3vrQYvjdbLv/gCu9nq4J3YzAIk9jkW2bm6nSZ0d9Ona
         IfCj+es1vrJCSjV+aq4mtp4tMOBj/Y6CFQODAMh0HW6WMcfgTCzuX6BNRUoy8KeQvdzL
         AQ3A==
X-Gm-Message-State: AOAM532/BDBhK74sTPxPnIEIivMPj474qX631TIwTj8bxFyenfp8uA/k
        I9alBaw9bUUPubOJv4k10JBqi88hxPr1w7PW7Eiiag==
X-Google-Smtp-Source: ABdhPJzcdJjznkl3ebRjgq34cvBkCJmbArDdFm8nniaXEliCWmaQ8v1EHQypI9vMuWe9/3pkJtFxUFFwEI3CsFS5iOk=
X-Received: by 2002:a2e:9716:: with SMTP id r22mr4256021lji.293.1590753799633;
 Fri, 29 May 2020 05:03:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200527140758.162280-1-linus.walleij@linaro.org>
 <79d89e93-4e40-089c-606d-e7787013bc80@xs4all.nl> <3965eb9a-d3ea-2844-68a1-57f88ff9f8b4@xs4all.nl>
In-Reply-To: <3965eb9a-d3ea-2844-68a1-57f88ff9f8b4@xs4all.nl>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 29 May 2020 14:03:08 +0200
Message-ID: <CACRpkdZpVr0O7tn7iqMkuzWo7mL5MtPBJkhPca8go8NwGjKNiA@mail.gmail.com>
Subject: Re: [PATCH] gpio: fix locking open drain IRQ lines
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 29, 2020 at 1:06 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Close, but no cigar. I didn't check the kernel log and I now see this warning:

Oups.

> The fix seems to be to just add this change to the patch:
>
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Thanks a lot Hans, I folded your fix into my fix.

Yours,
Linus Walleij
