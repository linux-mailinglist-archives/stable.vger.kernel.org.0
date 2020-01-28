Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38ACF14BEFC
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 18:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgA1R4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 12:56:03 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38137 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbgA1R4D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 12:56:03 -0500
Received: by mail-oi1-f196.google.com with SMTP id l9so11171863oii.5
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 09:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZY7xaJn7n2xK8pyc24KAivSTBtQ7s0DFRl/UfjgiFDQ=;
        b=CtNJv9u6gdgcpEgO+F9AYTS+Y/zbse1lthV5QHgKUjesjrGCTPaCMLny7uJCmY3C3X
         wOMApwMDTaji20lnDHokBwKeHHspyli2JrF4qHiina6D2KkhhfcvvIIDgwi3JWHhQ9u4
         NdG3fdQHa2LGLGGV8/TGvZwCUd9m1WdD8QFAX2mX78OVSGgacCH5NuksHeyeKeqrTnsn
         zlnMHgESkru9PG5WE6QWNifpIMgKLTcCzxPjKAM9levONhdEkdvHIvA5IFGAWGUgsmTb
         waJDbzcFC5gSf1P0o4boXjpCOBQNSUwQ9kVgH2XG4N9a5204bzS9DFtCY5biZ+92h0Tb
         gwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZY7xaJn7n2xK8pyc24KAivSTBtQ7s0DFRl/UfjgiFDQ=;
        b=p68I049Yt7s9h8M3EPFtjreESKd1tKLxxlzDxevQ30QeAf9VPjM8/1igOwKRyqW0Uo
         bFZiGL9SuR6ZSQ+x8FcnMn1epAdc6DRNsYK47q6G1ALPEL4tq3CoFzOuqwOQhazFpz5G
         K9GUt5iA+N+u7Iwww/H4B30lmUfB897/Yl0ZmnXtpGjxrsfs0I1wqNuC+O1jKZAR+7Cv
         G/wZCgufQtTvSQJIdUusqkQST8kbr1IkiltETXgWnjZfPYfKaLGIJgEaNEdNKRmXel60
         dvnhibazTZR4pHxW7Mx9udeGbGs2rR44xo/cugteK9H5dOKtcGiVTmwdv7sWuEg9KkaJ
         IkOw==
X-Gm-Message-State: APjAAAUEKnf5kDjIe7zWzXMeW0OZHJHW7b7Vpm+hG3fmqdsbO1P7hQCj
        7JyX/ss4Se0Id49axghji4BU4Br8xGFxJ1+ejlY2UQ==
X-Google-Smtp-Source: APXvYqxCYyjifBuv/9egesfFRvxA48CiSpZTWog2nxs8Fpmz0MZ1X+yuH41tBlafJu/bslupZq7PRUe23zMfh1iGeEQ=
X-Received: by 2002:aca:c551:: with SMTP id v78mr3694137oif.161.1580234162434;
 Tue, 28 Jan 2020 09:56:02 -0800 (PST)
MIME-Version: 1.0
References: <20200127193046.110258-1-john.stultz@linaro.org> <87sgjz90lt.fsf@kernel.org>
In-Reply-To: <87sgjz90lt.fsf@kernel.org>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 28 Jan 2020 09:55:50 -0800
Message-ID: <CALAqxLVH6znY-1QrVXdG7YTBd8RuBSm4tHDNqyR3wMERsfvh=Q@mail.gmail.com>
Subject: Re: [PATCH v2] usb: dwc3: gadget: Check for IOC/LST bit in TRB->ctrl fields
To:     Felipe Balbi <balbi@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>,
        Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 5:23 AM Felipe Balbi <balbi@kernel.org> wrote:
>
>
> Hi,
>
> John Stultz <john.stultz@linaro.org> writes:
>
> > From: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
> >
> > The current code in dwc3_gadget_ep_reclaim_completed_trb() will
> > check for IOC/LST bit in the event->status and returns if
> > IOC/LST bit is set. This logic doesn't work if multiple TRBs
> > are queued per request and the IOC/LST bit is set on the last
> > TRB of that request.
> >
> > Consider an example where a queued request has multiple queued
> > TRBs and IOC/LST bit is set only for the last TRB. In this case,
> > the core generates XferComplete/XferInProgress events only for
> > the last TRB (since IOC/LST are set only for the last TRB). As
> > per the logic in dwc3_gadget_ep_reclaim_completed_trb()
> > event->status is checked for IOC/LST bit and returns on the
> > first TRB. This leaves the remaining TRBs left unhandled.
> >
> > Similarly, if the gadget function enqueues an unaligned request
> > with sglist already in it, it should fail the same way, since we
> > will append another TRB to something that already uses more than
> > one TRB.
> >
> > To aviod this, this patch changes the code to check for IOC/LST
> > bits in TRB->ctrl instead.
> >
> > At a practical level, this patch resolves USB transfer stalls seen
> > with adb on dwc3 based HiKey960 after functionfs gadget added
> > scatter-gather support around v4.20.
> >
> > Cc: Felipe Balbi <balbi@kernel.org>
> > Cc: Yang Fei <fei.yang@intel.com>
> > Cc: Thinh Nguyen <thinhn@synopsys.com>
> > Cc: Tejas Joglekar <tejas.joglekar@synopsys.com>
> > Cc: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> > Cc: Jack Pham <jackp@codeaurora.org>
> > Cc: Todd Kjos <tkjos@google.com>
> > Cc: Greg KH <gregkh@linuxfoundation.org>
> > Cc: Linux USB List <linux-usb@vger.kernel.org>
> > Cc: stable <stable@vger.kernel.org>
> > Tested-by: Tejas Joglekar <tejas.joglekar@synopsys.com>
> > Reviewed-by: Thinh Nguyen <thinhn@synopsys.com>
> > Signed-off-by: Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
> > [jstultz: forward ported to mainline, reworded commit log, reworked
> >  to only check trb->ctrl as suggested by Felipe]
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > ---
> > v2:
> > * Rework to only check trb->ctrl as suggested by Felipe
> > * Reword the commit message to include more of Felipe's assessment
> > ---
> >  drivers/usb/dwc3/gadget.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 154f3f3e8cff..9a085eee1ae3 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -2420,7 +2420,8 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> >       if (event->status & DEPEVT_STATUS_SHORT && !chain)
> >               return 1;
> >
> > -     if (event->status & DEPEVT_STATUS_IOC)
> > +     if ((trb->ctrl & DWC3_TRB_CTRL_IOC) ||
> > +         (trb->ctrl & DWC3_TRB_CTRL_LST))
>
> why the LST bit here? It wasn't there before. In fact, we never set LST
> in dwc3 anymore :-)

So, it was in the patch before, just on separate lines:
  https://lore.kernel.org/lkml/20200122222645.38805-2-john.stultz@linaro.org/

- if (event->status & DEPEVT_STATUS_IOC)
+ if ((event->status & DEPEVT_STATUS_IOC) &&
+    (trb->ctrl & DWC3_TRB_CTRL_IOC))
+ return 1;
+
+ if ((event->status & DEPEVT_STATUS_LST) &&
+    (trb->ctrl & DWC3_TRB_CTRL_LST))
  return 1;

So I just merged the two checks into one line. But I'm ok to drop the
CTRL_LST check if that really isn't used.  Let me know and I'll rework
and resend.

thanks
-john
