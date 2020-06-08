Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F0B1F1C7F
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 17:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730353AbgFHP6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 11:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730231AbgFHP6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jun 2020 11:58:00 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A82DC08C5C2;
        Mon,  8 Jun 2020 08:58:00 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 82so10537266lfh.2;
        Mon, 08 Jun 2020 08:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d2EOx3YuKGydCVyOfa4Jz+4LCU5cGxDsZmpPpNUfyB4=;
        b=WWWx+MuV4d1OqEJZ3TAt/KAFq+ko1LDmQlZzyzrARjUpx0scfo+cCUbl+3ApejPNpY
         JWJ8+8Yn70c0ZVroC9EF+DYz1va/clE6FLVoPsk3FzBpqJeGQjxRgyNELBt+rIX1hJAP
         4rXRi7TXinK4Y/J0yVOkpn9kFTBnNPwlZk8jl9n2dFNliP+Z9L7Hc5+np/6VC5yIYd9y
         Lby7yWtU4+YeayGP4Gsfk8XolAfznakjx4qg4rebLllTb4xp7QYrgLmGeAzuC9A5Oz/y
         ETo2DIVwhGLRZi+D9cpA/4EFxqbKs3b5RRTDmE17cnmDw0xE+ae7wtqLMUz0pPMEHkG8
         S6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d2EOx3YuKGydCVyOfa4Jz+4LCU5cGxDsZmpPpNUfyB4=;
        b=gemvzjWbP6KwalMTQiLLSMLtxrZHl+Dpc9S/9SQKc9Im7ADxO6PI7IfWtadfgcb9R/
         qp/NV3/iw0KFj4r08wROwoxBgGWiNdNbYDaVNawX9INjkJQNS9TUepUJ3iY1lhiVjq8R
         V5YtlVuT2Ap545MD0Y519RwKAzcZpW1XFHGQGXs4TIo8kpPrsN3g9UBtLtTYPwh7WliE
         fAPqvIUYgdJnbytm6roDnLqfKED9gTlIm4KLubo8aAXeL7AWasTrVr+/7HvRDRHT4rw5
         TVt3EKYCJTimGkLei8jA2905Ag4dKB2KNpMG/a8zVAvanFZ07ew9VKIHi9K1OmW91RLX
         1gIA==
X-Gm-Message-State: AOAM532CzujGCWo9PHk3rFZH0MStAKh4mbQLBZYL11s/YUHZCvQMglA2
        RPKOByJSNRAF2fDd4PvcqcaWh8zkPdy+uOjwRCo=
X-Google-Smtp-Source: ABdhPJyaTbwF/M5Q5hXihzMSg5dnjlz0G6HksHVd39PTe3Y0jMJK5DRcfCw/lVsikvk8HvdUt0QMNNEbeaHGp02sQKg=
X-Received: by 2002:a19:8b06:: with SMTP id n6mr12882248lfd.66.1591631878121;
 Mon, 08 Jun 2020 08:57:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200608151012.7296-1-frieder.schrempf@kontron.de> <CAOMZO5BHF6ftHVgzKQ29o_G7Y+O6nrbDH1+J5+BYaONz==WebQ@mail.gmail.com>
In-Reply-To: <CAOMZO5BHF6ftHVgzKQ29o_G7Y+O6nrbDH1+J5+BYaONz==WebQ@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 8 Jun 2020 12:57:46 -0300
Message-ID: <CAOMZO5D0oifxM3H4WoLmJQ72Zo_2uj8X0RcpVadj4wLJYh6BgQ@mail.gmail.com>
Subject: Re: [PATCH] serial: imx: Fix handling of TC irq in combination with DMA
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 8, 2020 at 12:51 PM Fabio Estevam <festevam@gmail.com> wrote:
>
> On Mon, Jun 8, 2020 at 12:12 PM Schrempf Frieder
> <frieder.schrempf@kontron.de> wrote:
>
> >         if (port->rs485.flags & SER_RS485_ENABLED) {
> >                 temp = readl(port->membase + UCR2);
> > +
>
> This looks like an unrelated change.

Ah, ok, just realized this is a backport. In this case, it is fine then.
