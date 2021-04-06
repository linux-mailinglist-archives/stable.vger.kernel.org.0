Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEFFE355ED6
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 00:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhDFWcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 18:32:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230160AbhDFWcR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 18:32:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D702061284;
        Tue,  6 Apr 2021 22:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617748328;
        bh=eRMoe/YgEPTSiX+gZtg3ZTJaDtwdttX1NZsHhehUqKw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=u7r8b316Z51vN/ImKoUHJZJIZ+RSuTHqPcc3w6453rqoHkQvV2Pti98F0YCIUbt+D
         cEw//YckhzHJkq60bnWlaPvf5ws0Ry05lvivSPFvrifoclIQq0vxRrKIykHG+Lbs6t
         0V5pNAHbrt9InUBwI29WZ9tTgrz7QAE0qYRlk6UG9JKfXvGUeBXQf+18DyyCe4QaOb
         6dx0P27WoMOP9aUMMsfS0iJtVL0V4+FJXAh5BtHhHg1foz+YzhHajd6umTjKHrOhR0
         9RFJb+zX2iRNsDwbYKX2TSgSMC8uLzCVd6iYAgh7+nkmwPaj/1QpTTswfLOY+hT/0e
         jX/OzC6sJik6g==
Received: by mail-ed1-f50.google.com with SMTP id ba6so10901639edb.1;
        Tue, 06 Apr 2021 15:32:07 -0700 (PDT)
X-Gm-Message-State: AOAM532fvjfdupny6WXskzXc+h2qEmRyo8H+mnEU2K86tBllBi7OwTQK
        pLKLMy38CJe1XY9YPR953+1FrQXAlVzwEshzXw==
X-Google-Smtp-Source: ABdhPJwdESgC/GU++8VxM2LyjZDtBJl2yGCxL1+YwvrHU66u1t6nMvF/pizCBzl6ayrp4J3Evz0YpZB8EYtB1A/kQKI=
X-Received: by 2002:a05:6402:5252:: with SMTP id t18mr736852edd.258.1617748326514;
 Tue, 06 Apr 2021 15:32:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210405031436.2465475-1-ilya.lipnitskiy@gmail.com>
 <CAGETcx9ifDoWeBN1KR4zKfs-q73iGo9C-joz4UqayeE3euDQWg@mail.gmail.com>
 <CALCv0x3-A3PruJJ6wmzBZ5544Zj8_R7wFXkOm6H-a5tG406wYQ@mail.gmail.com>
 <CAGETcx8tgKoWAoqSgEQS8DRyMqzd7fGDfsWwsBEywVAPXRo1_A@mail.gmail.com>
 <20210406174050.GA1963300@robh.at.kernel.org> <CALCv0x2D6Y78XK7aeyyivcXqXZreHZd3kJc49tvtHx9eX+YH2w@mail.gmail.com>
 <CAGETcx8aWReU=bv7FEujQGmJy91CORNQo6nY8x0+T3fOiN3YFQ@mail.gmail.com>
In-Reply-To: <CAGETcx8aWReU=bv7FEujQGmJy91CORNQo6nY8x0+T3fOiN3YFQ@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Tue, 6 Apr 2021 17:31:54 -0500
X-Gmail-Original-Message-ID: <CAL_JsqKAFRM3Zv7oMDY=AUO6kRtC-JRM1iJB-LM5PRd-o8zUOw@mail.gmail.com>
Message-ID: <CAL_JsqKAFRM3Zv7oMDY=AUO6kRtC-JRM1iJB-LM5PRd-o8zUOw@mail.gmail.com>
Subject: Re: [PATCH] of: property: do not create device links from *nr-gpios
To:     Saravana Kannan <saravanak@google.com>
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 6, 2021 at 4:28 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Tue, Apr 6, 2021 at 12:28 PM Ilya Lipnitskiy
> <ilya.lipnitskiy@gmail.com> wrote:
> >
> > On Tue, Apr 6, 2021 at 10:40 AM Rob Herring <robh@kernel.org> wrote:
> > >
> > > On Mon, Apr 05, 2021 at 01:18:56PM -0700, Saravana Kannan wrote:
> > > > On Mon, Apr 5, 2021 at 1:10 PM Ilya Lipnitskiy
> > > > <ilya.lipnitskiy@gmail.com> wrote:
> > > > >
> > > > > Hi Saravana,
> > > > >
> > > > > On Mon, Apr 5, 2021 at 1:01 PM Saravana Kannan <saravanak@google.com> wrote:
> > > > > >
> > > > > > On Sun, Apr 4, 2021 at 8:14 PM Ilya Lipnitskiy
> > > > > > <ilya.lipnitskiy@gmail.com> wrote:
> > > > > > >
> > > > > > > [<vendor>,]nr-gpios property is used by some GPIO drivers[0] to indicate
> > > > > > > the number of GPIOs present on a system, not define a GPIO. nr-gpios is
> > > > > > > not configured by #gpio-cells and can't be parsed along with other
> > > > > > > "*-gpios" properties.
> > > > > > >
> > > > > > > scripts/dtc/checks.c also has a special case for nr-gpio{s}. However,
> > > > > > > nr-gpio is not really special, so we only need to fix nr-gpios suffix
> > > > > > > here.
> > > > > >
> > > > > > The only example of this that I see is "snps,nr-gpios".
> > > > > arch/arm64/boot/dts/apm/apm-shadowcat.dtsi uses "apm,nr-gpios", with
> > > > > parsing code in drivers/gpio/gpio-xgene-sb.c. There is also code in
> > > > > drivers/gpio/gpio-adnp.c and drivers/gpio/gpio-mockup.c using
> > > > > "nr-gpios" without any vendor prefix.
> > > >
> > > > Ah ok. I just grepped the DT files. I'm not sure what Rob's position
> > > > is on supporting DT files not in upstream. Thanks for the
> > > > clarification.
> > >
> > > If it's something we had documented, then we have to support it
> > Do I read this correctly as a sort-of Ack of my proposed [PATCH v2] in
> > this thread, since it aligns the code with the published DT schema?
>
> He's talking about the DT binding documentation in the kernel.
>
> I interpret Rob's reply as, you can do all of this:
> 1. Just fix up all drivers that use "*nr-gpios" that don't have
> binding documentation in the kernel. Change them to use ngpios.
> 2. Try to switch away old defunct ARM server DTs from nr-gpios to
> ngpios (both drivers and DT) and see if people notice.
> 3. Change the fw_devlink parsing code to have exceptions only for
> cases that are using nr-gpios after (1) and (2).

Yes, but (3) is not gated on (1) and (2). I'm applying v2.

Rob
