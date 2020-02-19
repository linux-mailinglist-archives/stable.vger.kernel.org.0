Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E68F16387A
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 01:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgBSAV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 19:21:59 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35084 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbgBSAV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 19:21:59 -0500
Received: by mail-oi1-f196.google.com with SMTP id b18so22099395oie.2
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 16:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iwevfYaMGMnWqDp7BRBH9ndZK1ueB9FpG7BWDRha664=;
        b=uXpGi2JtCaKA3afhjgPnx3+k6bu9jRJFFsxC1tdxkFA2xmvGo813n+ZBpK+kHNH/39
         aZ7yNwhZeAq6N113hFT+Z7i3q+igLWsyXdAmQCx0FBwKnVkgREb0kVWKfguOHKueZveq
         ZvOaEfMgOMt2ySw4a1QyCrQJC2t/FNxIRmHkuSurQ9D6XOB2qmC2ne59d1ee/3/6jwaM
         JtifkDeTXpnBdsiIlxZf5GoQkjGQc5fpmIu0DLDptiQoBobekKlKZo6hn+pha4aLWmPr
         B+bYAjtTgusI/aORPogBkG+bpo4h/Bu6olv6xoFBj2IjpY4R4Lva9xceCo8cbzAhNQPZ
         v9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iwevfYaMGMnWqDp7BRBH9ndZK1ueB9FpG7BWDRha664=;
        b=SYXb3c/eVvaBF7t03WAjMF8hJwAbe1xTGFv3+gCOpItdTdAlrelST6lguYgQ4/I3rU
         6uEp/kUzWdh+DwPsU1hO8qeRNTLCSeuNabx3UNX2QwiTTt8Opf8qE7shEXya1KuY2Y3w
         OfWdvNZjnRbnynu9+9Dgy1t1I1XQUNCst+UUvIHm7WxAkFerbRNKnb6B8+Shn/lOuZv9
         wTa5MfXJsWictvtxcrloledTYTaLydEaWj308oowzgaQjhSzAfU12IbrwdLzmEtGqyid
         3nfBLeSPG1R9eU9F7Ilf8mrUW4P+BzU2fNmOtvkLSS9lu6po6mO6RIaEf+g0+/5+CsrR
         JNiA==
X-Gm-Message-State: APjAAAULEZp5HN4QVkpoGJAiK1VcDOSQcuUAI206+R3qiYWQeVlxBzvE
        cfBMWKdPZ3zUjiU9mrKlG66LJgtXSSgTFHdP5o0+pw==
X-Google-Smtp-Source: APXvYqyYiXJ4jQH3RxiDV6J7/uaLgk6BiS53+aqHNeUal6TNgdsW5hDDsiGSQ/HeW/6snAkmK42XqN3LCG9NUaItzAg=
X-Received: by 2002:a54:4396:: with SMTP id u22mr3027403oiv.128.1582071718379;
 Tue, 18 Feb 2020 16:21:58 -0800 (PST)
MIME-Version: 1.0
References: <20200218235104.112323-1-john.stultz@linaro.org> <20200219000736.GA5511@jackp-linux.qualcomm.com>
In-Reply-To: <20200219000736.GA5511@jackp-linux.qualcomm.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 18 Feb 2020 16:21:47 -0800
Message-ID: <CALAqxLUSU4j3G6zBsxeOanF2A4fi-Q+JKu6FVDXOwAzpnZvWNQ@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc3: gadget: Update chain bit correctly when using
 sg list
To:     Jack Pham <jackp@codeaurora.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        Pratham Pratap <prathampratap@codeaurora.org>,
        Felipe Balbi <balbi@kernel.org>, Yang Fei <fei.yang@intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 18, 2020 at 4:07 PM Jack Pham <jackp@codeaurora.org> wrote:
>
> Hi John,
>
> Thanks for following-up with this! While you're doing minor tweaks
> anyway, I hope you don't mind me picking some nits below.
>
> On Tue, Feb 18, 2020 at 11:51:04PM +0000, John Stultz wrote:
> > From: Pratham Pratap <prathampratap@codeaurora.org>
> >
> > If scatter-gather operation is allowed, a large USB request is split
> > into multiple TRBs. For preparing TRBs for sg list, driver iterates
> > over the list and creates TRB for each sg and mark the chain bit to
> > false for the last sg. The current IOMMU driver is clubbing the list
> > of sgs which shares a page boundary into one and giving it to USB driver.
> > With this the number of sgs mapped it not equal to the the number of sgs
> > passed. Because of this USB driver is not marking the chain bit to false
> > since it couldn't iterate to the last sg. This patch addresses this issue
> > by marking the chain bit to false if it is the last mapped sg.
> >
> > At a practical level, this patch resolves USB transfer stalls
> > seen with adb on dwc3 based db845c, pixel3 and other qcom
> > hardware after functionfs gadget added scatter-gather support
> > around v4.20.
> >
> > Credit also to Anurag Kumar Vulisha <anurag.kumar.vulisha@xilinx.com>
> > who implemented a very similar fix to this issue.
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
> > Signed-off-by: Pratham Pratap <prathampratap@codeaurora.org>
> > [jstultz: Slight tweak to remove sg_is_last() usage, reworked
> >           commit message, minor comment tweak]
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
> > ---
> >  drivers/usb/dwc3/gadget.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
> > index 1b8014ab0b25..10aa511051e8 100644
> > --- a/drivers/usb/dwc3/gadget.c
> > +++ b/drivers/usb/dwc3/gadget.c
> > @@ -1071,7 +1071,14 @@ static void dwc3_prepare_one_trb_sg(struct dwc3_ep *dep,
> >               unsigned int rem = length % maxp;
> >               unsigned chain = true;
> >
> > -             if (sg_is_last(s))
> > +             /*
> > +              * IOMMU driver is coalescing the list of sgs which shares a
> > +              * page boundary into one and giving it to USB driver. With
> > +              * this the number of sgs mapped it not equal to the the number
>                                                  ^^ s/it/is/     ^^^ /d
>
> Or could we more specifically say "number of sgs mapped could be less
> than number passed"?
>
> > +              * of sgs passed. Mark the chain bit to false if it is the last
> > +              * mapped sg.
> > +              */
> > +             if ((i == remaining - 1))
>
> These outer parens are superfluous.

Thanks for catching these. I'll respin here shortly.

> Also wondering if it would be more or less clear to just set the
> variable once (and awkwardly move the comment to appear above the
> local var declaration):
>
>                 unsigned chain = (i < remaining - 1);
>

Personally, I think doing it via the conditional makes the logic a bit
less taxing to read/skim. So I might keep that bit as is.

thanks
-john
