Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B399259DD3
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 20:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgIASEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 14:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728708AbgIASEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 14:04:40 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62665C061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 11:04:40 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id g96so1944186otb.12
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 11:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5+zE7ox0ywDYN1OeLMkgE979l6agCoJMD3xzmvypBDE=;
        b=Ipap6GUqdOvmbNmIjQWTpqSau0ISEVl6saoRlxVssQeZPfHFrOiUiYN/l0bCMfQEsf
         8xyGF3E8+CYBWoDizzB5AVWy7QlCJOJibMR80/hMKKFE67/33cnK0eM23PFGVrcs98cR
         24Gk2cRv6jblswhn7hTasFFu5Rf4MuBOjh1+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5+zE7ox0ywDYN1OeLMkgE979l6agCoJMD3xzmvypBDE=;
        b=j1wrno3JLpnCDI9y7C1xWbbxTLCcuhSJC4X6bRUVgBAXRqpY+lDUcr2FOdylSmiNcA
         LzsSb97V+tfNjnhmvGBM0jt7m9qKXdqvr3F4RLxLJ1pvIlAwc8LvIPlhFYCi/UXyPPg/
         ip5vhaPqI5gGOR7DPhO/2weBQ46mOBx7+ggdjVS77gk4KTooXgxiTfwjX87RmuS+yKXO
         8kjIcEkrf117s4E5gZ0H6Fm+tbwf0RZuK7OLuX6y6oGYcbdOPM9LlhPtDfPSOPDAHpuc
         42CILP/5WtdzuHBKAx44Mv0wQkiAEE6uDvsImgJPf/QzSJNEA9hEyGZgU9kqxSZNRYd1
         AkpQ==
X-Gm-Message-State: AOAM533x2C0hS30jVbS9NjBWyPmsb7p8UWLUL2klLdR2e6OSzvo4p+ql
        k7G/L54aZI1J4le8TCniKtfYclEuyUrloJXzHhqPZQ==
X-Google-Smtp-Source: ABdhPJxg/1XYItddKooMbgmsc5AprWCw5inYHmcfZ/4zjBVFPzx6bgfhLJth6A8xiN7kvxcaHVETKyPw8ppTtJB+g4E=
X-Received: by 2002:a9d:7a52:: with SMTP id z18mr997165otm.281.1598983479593;
 Tue, 01 Sep 2020 11:04:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200820203144.271081-1-linus.walleij@linaro.org> <CACRpkdYHB2SFVqpuL0GtPe-yk7wrA=nFiQk4f7Kj0aFB9rOAvw@mail.gmail.com>
In-Reply-To: <CACRpkdYHB2SFVqpuL0GtPe-yk7wrA=nFiQk4f7Kj0aFB9rOAvw@mail.gmail.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 1 Sep 2020 20:04:28 +0200
Message-ID: <CAKMK7uH1NQZMfzEmmPzUuovON-MhLnvhWnkuwU8qSBGTxKQDaQ@mail.gmail.com>
Subject: Re: [PATCH] drm/tve200: Stabilize enable/disable
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Sean Paul <sean@poorly.run>, stable <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 1, 2020 at 7:52 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Thu, Aug 20, 2020 at 10:32 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> > The TVE200 will occasionally print a bunch of lost interrupts
> > and similar dmesg messages, sometimes during boot and sometimes
> > after disabling and coming back to enablement. This is probably
> > because the hardware is left in an unknown state by the boot
> > loader that displays a logo.
> >
> > This can be fixed by bringing the controller into a known state
> > by resetting the controller while enabling it. We retry reset 5
> > times like the vendor driver does. We also put the controller
> > into reset before de-clocking it and clear all interrupts before
> > enabling the vblank IRQ.
> >
> > This makes the video enable/disable/enable cycle rock solid
> > on the D-Link DIR-685. Tested extensively.
> >
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> Would someone have mercy on this patch and review or
> at least ACK it so I can merge it?

Does what it says on the label, looks symmetric, and "do this five
times for luck" is a classic.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>

The irq reset looks a bit like maybe separate patch, but *shrug*,
since your description says you're missing interrupts, not that you
have too many. But can't hurt (and maybe if we have spurious ones it
then looks like the next vblank went missing, so makes some sense).

Cheers, Daniel

> I offer any reviews in return, on stuff I understand, such
> as panel drivers.


>
> Best regards,
> Linus Walleij
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
