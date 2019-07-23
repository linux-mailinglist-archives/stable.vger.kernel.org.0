Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5C971FA4
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 20:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388880AbfGWSwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 14:52:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36540 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387473AbfGWSwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 14:52:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so44351496wrs.3
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 11:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fyhJlYS/nmZVWKWvi27Hp7abC+DbsGqwswaGohdPOpA=;
        b=zYaV2dx0GCGELJRDEgnEx66kKYH6fLEWGmcTfHxHp8NiO832NO1LV81qL8RIhK9Tsj
         hAmNwACbpLQr/SARJZqkrV5Brs/mkIBkJ66SR8RQrdD3P8Rb74m8ALaG3ZvugP6HISMV
         lVG8R8vkB1aqiPQy4ff57S+GbKMrdWCYRLA27pDhg2fyAUHppqyPmvyBX3EoRwzX4vea
         nDktXIkOmtngTtXxPpPG4fWhlq3hNuDtaCSJjzwI/wh92oa9M7XzcbntymOu0moJLN7+
         2UZTvjHbBH9fBJ04/M14wCNpciOtmbW2JiwZp1oPyB78/W1tEXGQG6PB73YGjqJBft9T
         TwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fyhJlYS/nmZVWKWvi27Hp7abC+DbsGqwswaGohdPOpA=;
        b=S0fLJT7QtLoKGBazz0nFiXxbn4aksUvECB+qZ7DNBY/DUpivwceEdbJSd0vlubRh/0
         5U97Wv0r6xaGKcSmVqZNnlJzvCpICdf3ZkEg/jsKMgzpenKYk5I34EuO2PKbzIcY3z+j
         Z2n66+aFmEeeR7tnlnispiQ9BBQ3/3dUxVeYNGQq7eRMZ5owvu2oqob7Ob9DcrRlS0EO
         uVpZLyg/P6T0CIPU4vVB94WMJeBdoepEi11addlkWNOl8M3Ov68CNP9ap8Hb0ceA2m/J
         wuiwv3WMBAhmNg0bjTz1oFjQk+lS24t18oltDU/CUdyFuc88jp71hNjvkddHXrO9gZsX
         v87Q==
X-Gm-Message-State: APjAAAW3Y0kCDGuJBc/lTsNCAnvtddRavant1vN29MA53ToKzpb9mHiP
        wxnxKziDtzVw+SsCtLIt4ITldQtOoeIs1BPKcIE8ZpGK
X-Google-Smtp-Source: APXvYqzlIepC9KXFaJ7DC2ZH9C3Jxw5UZ5QWzvCKIs/BFU+5pWBvVgbB6otUiss1YIbgTou6fEMr3+zplpwjb1jwh8w=
X-Received: by 2002:a05:6000:145:: with SMTP id r5mr3390652wrx.208.1563907919536;
 Tue, 23 Jul 2019 11:51:59 -0700 (PDT)
MIME-Version: 1.0
References: <1563497183-7114-1-git-send-email-fei.yang@intel.com> <CY4PR1201MB003708ADAD79BF4FD24D3445AACB0@CY4PR1201MB0037.namprd12.prod.outlook.com>
In-Reply-To: <CY4PR1201MB003708ADAD79BF4FD24D3445AACB0@CY4PR1201MB0037.namprd12.prod.outlook.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 23 Jul 2019 11:51:47 -0700
Message-ID: <CALAqxLURCLHf3UJsMWKZUirDE9bWNYEhv-sKb01g7cTfCz5tOg@mail.gmail.com>
Subject: Re: [PATCH v3] usb: dwc3: gadget: trb_dequeue is not updated properly
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     "fei.yang@intel.com" <fei.yang@intel.com>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>,
        "andrzej.p@collabora.com" <andrzej.p@collabora.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 6:12 PM Thinh Nguyen <Thinh.Nguyen@synopsys.com> wrote:
> fei.yang@intel.com wrote:
> > From: Fei Yang <fei.yang@intel.com>
> >
> > If scatter-gather operation is allowed, a large USB request is split into
> > multiple TRBs. These TRBs are chained up by setting DWC3_TRB_CTRL_CHN bit
> > except the last one which has DWC3_TRB_CTRL_IOC bit set instead.
> > Since only the last TRB has IOC set for the whole USB request, the
> > dwc3_gadget_ep_reclaim_trb_sg() gets called only once after the last TRB
> > completes and all the TRBs allocated for this request are supposed to be
> > reclaimed. However that is not what the current code does.
> >
> > dwc3_gadget_ep_reclaim_trb_sg() is trying to reclaim all the TRBs in the
> > following for-loop,
> >       for_each_sg(sg, s, pending, i) {
> >               trb = &dep->trb_pool[dep->trb_dequeue];
> >
> >                 if (trb->ctrl & DWC3_TRB_CTRL_HWO)
> >                         break;
> >
> >                 req->sg = sg_next(s);
> >                 req->num_pending_sgs--;
> >
> >                 ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
> >                                 trb, event, status, chain);
> >                 if (ret)
> >                         break;
> >         }
> > but since the interrupt comes only after the last TRB completes, the
> > event->status has DEPEVT_STATUS_IOC bit set, so that the for-loop ends for
> > the first TRB due to dwc3_gadget_ep_reclaim_completed_trb() returns 1.
> >       if (event->status & DEPEVT_STATUS_IOC)
> >               return 1;
> >
> > This patch addresses the issue by checking each TRB in function
> > dwc3_gadget_ep_reclaim_trb_sg() and maing sure the chained ones are properly
> > reclaimed. dwc3_gadget_ep_reclaim_completed_trb() will return 1 Only for the
> > last TRB.
> >
> > Signed-off-by: Fei Yang <fei.yang@intel.com>
> > Cc: stable <stable@vger.kernel.org>
> > ---
> > v2: Better solution is to reclaim chained TRBs in dwc3_gadget_ep_reclaim_trb_sg()
> >     and leave the last TRB to the dwc3_gadget_ep_reclaim_completed_trb().
> > v3: Checking DWC3_TRB_CTRL_CHN bit for each TRB instead, and making sure that
> >     dwc3_gadget_ep_reclaim_completed_trb() returns 1 only for the last TRB.
> > ---
> >  drivers/usb/dwc3/gadget.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 173f532..88eed49 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -2394,7 +2394,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(struct dwc3_ep *dep,
> >       if (event->status & DEPEVT_STATUS_SHORT && !chain)
> >               return 1;
> >
> > -     if (event->status & DEPEVT_STATUS_IOC)
> > +     if (event->status & DEPEVT_STATUS_IOC && !chain)
> >               return 1;
> >
> >       return 0;
> > @@ -2404,11 +2404,12 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
> >               struct dwc3_request *req, const struct dwc3_event_depevt *event,
> >               int status)
> >  {
> > -     struct dwc3_trb *trb = &dep->trb_pool[dep->trb_dequeue];
> > +     struct dwc3_trb *trb;
> >       struct scatterlist *sg = req->sg;
> >       struct scatterlist *s;
> >       unsigned int pending = req->num_pending_sgs;
> >       unsigned int i;
> > +     int chain = false;
> >       int ret = 0;
> >
> >       for_each_sg(sg, s, pending, i) {
> > @@ -2419,9 +2420,13 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dwc3_ep *dep,
> >
> >               req->sg = sg_next(s);
> >               req->num_pending_sgs--;
> > +             if (trb->ctrl & DWC3_TRB_CTRL_CHN)
> > +                     chain = true;
> > +             else
> > +                     chain = false;
> >
> >               ret = dwc3_gadget_ep_reclaim_completed_trb(dep, req,
> > -                             trb, event, status, true);
> > +                             trb, event, status, chain);
> >               if (ret)
> >                       break;
> >       }
>
> There was already a fix a long time ago by Anurag. But it never made it
> to the kernel mainline. You can check this out:
> https://patchwork.kernel.org/patch/10640137/

So, back from a vacation last week, and just validated that both Fei's
patch and a forward ported version of this patch Thinh pointed out
both seem to resolve the usb stalls I've been seeing sinice 4.20 w/
dwc3 hardware on both hikey960 and dragonboard 845c.

Felipe: Does Anurag's patch above make more sense as a proper fix?

thanks
-john
