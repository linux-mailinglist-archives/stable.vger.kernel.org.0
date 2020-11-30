Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE492C7F7E
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 09:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgK3IBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 03:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgK3IBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 03:01:51 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D6DC0613CF;
        Mon, 30 Nov 2020 00:01:11 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id l11so6059115plt.1;
        Mon, 30 Nov 2020 00:01:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xWg0wxDFGMcY8UIe2/5RebvM9I9LsP6Y+5sFTmocQPE=;
        b=H7w/06l3Smy/4ntHvbEC+kWfxw7JtvF4APIsTdn2pXUnkSufHzTZm02KQEHdNtOAWJ
         +Mb5GdG2+orfZt16Lt/EgtkOO8+6tb4RpOpHKTlFhYRF400/0cV3LPvUUm+3A4rCxzRd
         WW5heuxXD9zeNNCSQTAjmpFFJq4pXDNKZGaoqV7qWDtjp7sYHPvn7gwVemK95iJ6ARDz
         yg9UOiFAMpPcL+XeWd+dub+OcSxRVSPglxm7AtrsSeHssSMd+G0SeX7gD9wCBxoP4Ig6
         iZWbXChXyuQ7XkMRWZ1PjTtw21lBhRM/Gch/8/0gp3rBp6Y14YTwaUiTaFGjC92K+Zpf
         8RcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xWg0wxDFGMcY8UIe2/5RebvM9I9LsP6Y+5sFTmocQPE=;
        b=phodhi387/7F7oPtiQtw9kIVZvlaKmHep/qlaj/hh89a2SjkN++WCTQKN428Ene+6j
         gXE50gUcF4c/zb7DD75auzsoDwLQSq64eXjNLSZbTCKOJtFca66QIRAVrlTN2wTfsnTE
         y52lG5hqE2dDr0acrk78Qlfr0d9U1E2elavMDsYEnJu1fioZCyP3cFKq8cx3pYebrpPQ
         1SESl0s82NnjUEhzyp2DN2xSOC3Mgut7woUjbzHh0Ep/EwjVJA9wqoE2a3McS1qGxvIb
         qviyAuj3zE+NrmT1kS0YYdwlSiFUO1/76gQZzTPA/LfNADxNOpSJSVvaPkhhMrAwlY+e
         l2YA==
X-Gm-Message-State: AOAM531OLYgvZo54WX62wYhp+ZzrNpYPZaq0wsMjKXig7dlU0uTBhYUP
        Mt0iBq6Jk9Oqwis3p3DUoQE=
X-Google-Smtp-Source: ABdhPJxucWHA3g3YjklN0cjfBbgSXYNxuecjN6DGXW99d+SNb2gUUNyLNZlI+7If2Y3FlW55339k9Q==
X-Received: by 2002:a17:902:bd05:b029:d6:f041:f5b with SMTP id p5-20020a170902bd05b02900d6f0410f5bmr17920428pls.9.1606723271359;
        Mon, 30 Nov 2020 00:01:11 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id e18sm15093256pgr.71.2020.11.30.00.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 00:01:10 -0800 (PST)
Date:   Mon, 30 Nov 2020 00:01:08 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Linux Input <linux-input@vger.kernel.org>,
        Andre <andre.muller@web.de>, Nick Dyer <nick.dyer@itdev.co.uk>,
        Jiada Wang <jiada_wang@mentor.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Input: atmel_mxt_ts - Fix lost interrupts
Message-ID: <20201130080108.GN2034289@dtor-ws>
References: <20201128123720.929948-1-linus.walleij@linaro.org>
 <20201129025328.GH2034289@dtor-ws>
 <CACRpkdY8r5_EYAtWLL2vZQ8ULf6rG-VfgDe=7oveJQwiRXxTNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY8r5_EYAtWLL2vZQ8ULf6rG-VfgDe=7oveJQwiRXxTNg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 29, 2020 at 10:13:06PM +0100, Linus Walleij wrote:
> On Sun, Nov 29, 2020 at 3:53 AM Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Sat, Nov 28, 2020 at 01:37:20PM +0100, Linus Walleij wrote:
> 
> > > @@ -1297,8 +1297,6 @@ static int mxt_check_retrigen(struct mxt_data *data)
> > >       int val;is
> > >       struct irq_data *irqd;
> > >
> > > -     data->use_retrigen_workaround = false;
> > > -
> >
> > So this will result in data->use_retrigen_workaround staying "true" for
> > level interrupts, which is not needed, as with those we will never lose
> > an edge. So I think your patch can be reduced to simply setting
> > data->use_retrigen_workaround to true in mxt_probe() and leaving
> > mxt_check_retrigen() without any changes.
> 
> I did that first but then I realized that since there is an
> errorpath in mxt_check_retrigen() and it starts by disabling
> the workaround so in an error occurs in
> __mxt_read_reg() it will be left disabled.

If __mxt_read_reg() fails then we will bail out and leave the device not
operable, so leaving the workaround disabled does not change anything.

> 
> But I see that I fail to account for the level-trigging
> case where it should disable the workaround and
> bail out so I anyway need to revise the patch.
> 
> > However I wonder if it would not be better to simply call
> > mxt_check_retrigen() before calling mxt_acquire_irq() in mxt_probe()
> > instead of after.
> 
> I don't fully understand this driver, but it seems the information
> whether retrigen is available only appears after talking to the
> device a bit, checking firmware and "objects" available on the
> device and then it may already be too late.

No, because the workaround is checked only in mxt_acquire_irq() which is
called immediately preceding the check for RETRIGEN. And since
__mxt_read_reg() is a wrapper around i2c_transfer() and does not need
IRQs to be enalbed, we can move stuff around. Could you please check if
the following works for you:

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index dde364dfb79d..2b3fff0822fe 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2185,11 +2185,11 @@ static int mxt_initialize(struct mxt_data *data)
 		msleep(MXT_FW_RESET_TIME);
 	}
 
-	error = mxt_acquire_irq(data);
+	error = mxt_check_retrigen(data);
 	if (error)
 		return error;
 
-	error = mxt_check_retrigen(data);
+	error = mxt_acquire_irq(data);
 	if (error)
 		return error;
 

> Someone who knows the device better might be able to
> contribute here :/
> 
> > By the way, does your touchscreen work if you change interrupt trigger
> > to level in DTS?
> 
> Nope. This happens:
> [    1.824610] atmel_mxt_ts 3-004a: Failed to register interrupt
> [    1.830583] atmel_mxt_ts: probe of 3-004a failed with error -22
> 
> And that in turn is because this connected to a Nomadik
> GPIO controller which is one of those GPIO controllers
> that only support edge triggered interrupts and does not
> support level interrupts. So it needs to be edge triggered on
> this platform.

Ah, I see. Thank you.

-- 
Dmitry
