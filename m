Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01E11E8587
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 19:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgE2RpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 13:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727890AbgE2RpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 13:45:08 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E1BC03E969;
        Fri, 29 May 2020 10:45:08 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l11so4766810wru.0;
        Fri, 29 May 2020 10:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qyilkDkEXs9eRR0aDai46RFr8RI6mIia71DbVroQLVU=;
        b=QBaHbk14iG9YRTPIDgH26JV5us6Yd6RFPJILW7tz8taGcaqrr9mIlhsj9vJhGaDFq+
         qfKEXRifzavH8I54c/tLxqSunkEkVlWh21Gt6sRPbc8lUhXDAr6nauuVZpyKjXkbKJmZ
         MnD/rQk9TB3pUljpVQovYABH0pJYAH+KQWliJWDjjHebs4ff5hS56CY9bpi4WXiRf2iy
         9FpvllK0UNz6bJBDjSsSU85k+WMBKGstzExCTPxy+JecIxbKAj6hhPL3ya+0JbonyKzx
         UXz9VLTFO9bbHT1pbfZ+v4vDsxNKcHH1AGmWkRQKv+xKajqCFx7I9yQM1xb00YJBTDGl
         UiaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qyilkDkEXs9eRR0aDai46RFr8RI6mIia71DbVroQLVU=;
        b=l74uMM0DzF5ffY5ZHJum9NemSBkQtsdENhwbWmuuysqYht0Sw4ihgo1LScUOFFWWW4
         fiHD1pgKWvkCrut2mi3QqSUPjXFZybpPmDeY8vHfkd1S1+iuJDi/Z5O7K9omqejtkqDT
         IdsM+U9eZ9AVCyyln7usrPXss6BBjsTFULwMWuyYSTBHmeNWfub2CSz5H5/ZqSgrLWYu
         ytUVB4OQKfff4DEN8u4gpwQD032b5LtSozstsviZoeqJZ8W4NpaNNokAjiigYS3u5+Qh
         FV6mHZRrXJfpOHjvBubf7dQmiKLIPE8z9XmLSM2qstnhKMPpGSfoTJijwUOWL5q7BhQL
         N1ow==
X-Gm-Message-State: AOAM5324mOVMceaaNy4xAeXbTTPwiq0WR8wDniszR5rOxkbWbvcmE7Yv
        bVCA1EIkiQQVTLjy27aSIR074V2cUyGlB2mL7zk=
X-Google-Smtp-Source: ABdhPJwPloB0m/tm/NkncwwpHlp2HQrubDQbocpXuvAjz21ovS5umtEBdESPCcRDxA0c19JkEgtieM94rFX9YK9+O7c=
X-Received: by 2002:adf:e3c4:: with SMTP id k4mr9620950wrm.262.1590774307312;
 Fri, 29 May 2020 10:45:07 -0700 (PDT)
MIME-Version: 1.0
References: <1d3bae1b3048f5d6e19f7ef569dd77e9e160a026.1590753016.git.hminas@synopsys.com>
 <CAD=FV=W1x_HJNCYMUb11QNA8yGs0heEiZzHZdeMPzFaRHaTOsA@mail.gmail.com>
 <0f6b1580-41d8-b7e7-206b-64cda87abfd5@synopsys.com> <CAD=FV=UCMqyX92o9m7H40E3sHzAFieHSu3TUY953VqNb-vuPPg@mail.gmail.com>
In-Reply-To: <CAD=FV=UCMqyX92o9m7H40E3sHzAFieHSu3TUY953VqNb-vuPPg@mail.gmail.com>
From:   Frank Mori Hess <fmh6jj@gmail.com>
Date:   Fri, 29 May 2020 13:44:56 -0400
Message-ID: <CAJz5OpfDnHfGf=dLbc0hTtaz-CERsQyaBNeqDiRz7u4jMywNow@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: Fix shutdown callback in platform
To:     Doug Anderson <dianders@chromium.org>
Cc:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko.stuebner@collabora.com>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 29, 2020 at 12:37 PM Doug Anderson <dianders@chromium.org> wrote:
>
> I'm not sure I understand.  Are you saying that you'll just add
> shutdown callbacks to all the drivers using this IRQ and call
> disable_irq() there?  That seems like the best solution to me.

I don't get it.  A hypothetical machine could have literally anything
sharing the IRQ line, right?  If it is important to call disable_irq
during shutdown (I have no idea if it is) then shouldn't the kernel
core just disable all irqs after calling all the driver shutdown
callbacks?

Anyways, my screaming interrupt occurs after a a new kernel has been
booted with kexec.  In this case, it doesn't matter if the old kernel
called disable_irq or not.  As soon as the new kernel re-enables the
interrupt line, the kernel immediately disables it again with a
backtrace due to the unhandled screaming interrupt.  That's why the
dwc2 hardware needs to have its interrupts turned off when the old
kernel is shutdown.


-- 
Frank
