Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C1514C6E7
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 08:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbgA2HgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 02:36:09 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38462 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbgA2HgI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 02:36:08 -0500
Received: by mail-oi1-f196.google.com with SMTP id l9so13063311oii.5
        for <stable@vger.kernel.org>; Tue, 28 Jan 2020 23:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FgvO10IJ4wBnszEHmPtvEGnuEA/o8QmjSQTp/J33OpI=;
        b=z3IfDOISdaN3RYKwrU29jiKORUsOWPToKO4Jx1+UApeDifFCMXtiIPEHKl3UZCrZci
         /XotVFBJkz/56iooATh6MvasehD0ohtNa8Q330q4mqH2sirBIq26a7soIpi08H9tTwqT
         lyUPtqrbqURAly09xmWwLXJwlKnzNZOsJ1+uilDXinguq6lmcBmOUOSu+/A4qzLpEG8q
         2Y4JUdrK9btUO3ZpH4IsQ77xdl9OYrJp+QCkReAEtQG60+nYeF7YKXpZk5R4sk8vygmW
         Cej/8mWxpHIpMSJH331tNirh7osCFMY3/oISXByImEyJHh5o8V/EMweSFzb2FpwSzEv0
         GgRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FgvO10IJ4wBnszEHmPtvEGnuEA/o8QmjSQTp/J33OpI=;
        b=qjAhDSMqkeiTOs4q5pzGXyXyPbTLL2duR2y4Yy/JrhNti22jjSmx8yPXaOU17PGze0
         5VrdBgrfF9PG5FA1eFRiohX0SzBzlVqBhhct6BlOngPi4OEO5E8CzMe88NbVUP0jpsIV
         LUco2b0qYUZOG9BamgppsWBNXox/iWhbELco/EZim0MVNdlZqvtehlvqhCg0BTWY50F+
         v5Mf6ZRpTg2UNzsBXYDNbcaEytUVm0WsckU8d1KfRWEdOlziYIeygneG2XNtk5PV9PJx
         ra0zYGfuu93IA0dKfzllRm78R3AjW3K4IgO7hNhE+RiZfX7IjH1ixC/QOvjB6hS5idfR
         h8qQ==
X-Gm-Message-State: APjAAAXN2oqt1d8IIsuc9Lah2ch2IfcqOzfyEnhU0eqzoeX/hx2afwnd
        J6OJiYT7zmAz0pPC6noWM/ZUwxvG3ed7BbLojt2Y7Q==
X-Google-Smtp-Source: APXvYqzTJvlxF581XdJ3qT23ZjsRBDTeHvvEXr3D2QI8bFm7TdHeUYS8y9GqAiiKD6S8Pxc+ZizDQMZqFaqtxucP8ig=
X-Received: by 2002:a54:4396:: with SMTP id u22mr5698037oiv.128.1580283367480;
 Tue, 28 Jan 2020 23:36:07 -0800 (PST)
MIME-Version: 1.0
References: <20200127193046.110258-1-john.stultz@linaro.org> <87lfpq915x.fsf@kernel.org>
In-Reply-To: <87lfpq915x.fsf@kernel.org>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 28 Jan 2020 23:35:56 -0800
Message-ID: <CALAqxLUNg_Oww17U=BW9XTzZAdkCoCWCg=92Js17SexhT8gy6g@mail.gmail.com>
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

On Tue, Jan 28, 2020 at 11:23 PM Felipe Balbi <balbi@kernel.org> wrote:
> John Stultz <john.stultz@linaro.org> writes:
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
>
> since v5.5 is already merged, I'll send this to Greg once -rc1 is
> tagged. It's already in my testing/fixes branch waiting for a pull
> request.

Great, thanks so much for queueing this! I'll be digging on the db845c
side wrt the dma-api issue to hopefully get that one sorted as well.

Thanks again for the help and analysis!
-john
