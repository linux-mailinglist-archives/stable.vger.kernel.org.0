Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276182C9790
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 07:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgLAGcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 01:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgLAGcl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 01:32:41 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BFEC0613CF;
        Mon, 30 Nov 2020 22:31:54 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id t21so613599pjw.2;
        Mon, 30 Nov 2020 22:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m2pZsTgUAk2eiL9JbFy5xQbTHSAbDOFsgJwFdHL44a4=;
        b=Q8DVY6bh285AO9ROnyNWIJHE1VeHGskJWwiTdg76nKeSudcdYVWd8xT2JDLWrq1AHu
         Rj837ZC2BowdPlQnAKI7sf+/ZE6OOe8t7bto/1qAxIoMJI1uGyXCPHVaHtOH+lkIB+3F
         uVzQUN0HgdCvfNTooXvQHAljM297miBP6b/ho75hIa1ylc/DSHiPugWTsUq1nnuM29O9
         vCB3yAi3a5JpfTH+euaa08ztZL4QydYo7gvbCRR4tkpCSGbwEPGSJ9DwT+XgPAqnXZTJ
         fJQHGrNlK8hisnf82YcfBUedoFwq1jxkDcV4HljhazbvWj/zat2j23OfN4S0sRnq3k6F
         6xVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m2pZsTgUAk2eiL9JbFy5xQbTHSAbDOFsgJwFdHL44a4=;
        b=HGoKA5koRJFX5lS6XEPJmBRczKMe7xYkacoooJReKLXrxy6RrxCnDFk1jlzOQ+QXtl
         tAKM4hVUbZFaFxFJ70wH/KxSgR87xLaMwDzcAiva7ToHaZW/dTePTUBRFx/NvW/E1h5L
         ddzn3NMbGeqaszucVas0yJVbmQBcrlVhMVRS2TuSBbkI0b/zodrtdaEuD8iS3UuzozYt
         a9aB6oQINpF9bjdlvtVpO0ZhQLiyDBYA2zehK91YotRQHPrflTrZ9ab/8RFPofunzb5h
         s60UfBDdxuC3Ixqbpi/HrltxYFRc3PmyCepzFsx1RgFI027B6HWp58UyAAjb9zeota7l
         SljQ==
X-Gm-Message-State: AOAM530pp9+oYKCyoMxCN3+hddtdNnfr8UrRL0mOrFdLZ9Wpc/4YJnJL
        5Ul2xuexX9xlUsRMGsYwt+g=
X-Google-Smtp-Source: ABdhPJwMiXc2Mk4tMxhhEt2g0wcXxbNynfieB6XO7tdu8ZXZtJvfh0P+oBzWih0DIzzbYWBmYZ+nVQ==
X-Received: by 2002:a17:902:b28b:b029:da:357b:22b1 with SMTP id u11-20020a170902b28bb02900da357b22b1mr1460183plr.84.1606804313993;
        Mon, 30 Nov 2020 22:31:53 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id f17sm1219332pfk.70.2020.11.30.22.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 22:31:53 -0800 (PST)
Date:   Mon, 30 Nov 2020 22:31:50 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Andre Muller <andre.muller@web.de>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>,
        Jiada Wang <jiada_wang@mentor.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Input: atmel_mxt_ts - Fix lost interrupts
Message-ID: <20201201063150.GP2034289@dtor-ws>
References: <20201128123720.929948-1-linus.walleij@linaro.org>
 <20201129025328.GH2034289@dtor-ws>
 <CACRpkdY8r5_EYAtWLL2vZQ8ULf6rG-VfgDe=7oveJQwiRXxTNg@mail.gmail.com>
 <20201130080108.GN2034289@dtor-ws>
 <49253725-7c3d-fce9-7000-6061ebe736bc@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49253725-7c3d-fce9-7000-6061ebe736bc@web.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 30, 2020 at 09:18:45PM +0100, Andre Muller wrote:
> On 30/11/2020 09.01, Dmitry Torokhov wrote:
> > On Sun, Nov 29, 2020 at 10:13:06PM +0100, Linus Walleij wrote:
> > > On Sun, Nov 29, 2020 at 3:53 AM Dmitry Torokhov
> > > <dmitry.torokhov@gmail.com> wrote:
> > > > On Sat, Nov 28, 2020 at 01:37:20PM +0100, Linus Walleij wrote:
> > > 
> > > > > @@ -1297,8 +1297,6 @@ static int mxt_check_retrigen(struct mxt_data *data)
> > > > >        int val;is
> > > > >        struct irq_data *irqd;
> > > > > 
> > > > > -     data->use_retrigen_workaround = false;
> > > > > -
> > > > 
> > > > So this will result in data->use_retrigen_workaround staying "true" for
> > > > level interrupts, which is not needed, as with those we will never lose
> > > > an edge. So I think your patch can be reduced to simply setting
> > > > data->use_retrigen_workaround to true in mxt_probe() and leaving
> > > > mxt_check_retrigen() without any changes.
> > > 
> > > I did that first but then I realized that since there is an
> > > errorpath in mxt_check_retrigen() and it starts by disabling
> > > the workaround so in an error occurs in
> > > __mxt_read_reg() it will be left disabled.
> > 
> > If __mxt_read_reg() fails then we will bail out and leave the device not
> > operable, so leaving the workaround disabled does not change anything.
> > 
> > > 
> > > But I see that I fail to account for the level-trigging
> > > case where it should disable the workaround and
> > > bail out so I anyway need to revise the patch.
> > > 
> > > > However I wonder if it would not be better to simply call
> > > > mxt_check_retrigen() before calling mxt_acquire_irq() in mxt_probe()
> > > > instead of after.
> > > 
> > > I don't fully understand this driver, but it seems the information
> > > whether retrigen is available only appears after talking to the
> > > device a bit, checking firmware and "objects" available on the
> > > device and then it may already be too late.
> > 
> > No, because the workaround is checked only in mxt_acquire_irq() which is
> > called immediately preceding the check for RETRIGEN. And since
> > __mxt_read_reg() is a wrapper around i2c_transfer() and does not need
> > IRQs to be enalbed, we can move stuff around. Could you please check if
> > the following works for you:
> > 
> > diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> > index dde364dfb79d..2b3fff0822fe 100644
> > --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> > +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> > @@ -2185,11 +2185,11 @@ static int mxt_initialize(struct mxt_data *data)
> >   		msleep(MXT_FW_RESET_TIME);
> >   	}
> > 
> > -	error = mxt_acquire_irq(data);
> > +	error = mxt_check_retrigen(data);
> >   	if (error)
> >   		return error;
> > 
> > -	error = mxt_check_retrigen(data);
> > +	error = mxt_acquire_irq(data);
> >   	if (error)
> >   		return error;
> 
> This swap also fixes the driver for me. So both Linus' and your approach work here.
> 
> The log says
> [    0.212647] atmel_mxt_ts i2c-ATML0000:01: Family: 164 Variant: 17 Firmware V1.0.AA Objects: 32
> [    0.212804] atmel_mxt_ts i2c-ATML0000:01: Enabling RETRIGEN workaround
> [    0.228469] atmel_mxt_ts i2c-ATML0000:01: Direct firmware load for maxtouch.cfg failed with error -2
> [    0.229979] atmel_mxt_ts i2c-ATML0000:01: Touchscreen size X960Y540
> [    0.230023] input: Atmel maXTouch Touchpad as /devices/pci0000:00/INT3432:00/i2c-0/i2c-ATML0000:01/input/input4
> [    0.236080] atmel_mxt_ts i2c-ATML0001:01: Family: 164 Variant: 13 Firmware V1.0.AA Objects: 41
> [    0.236478] atmel_mxt_ts i2c-ATML0001:01: Enabling RETRIGEN workaround
> [    0.256034] atmel_mxt_ts i2c-ATML0001:01: Direct firmware load for maxtouch.cfg failed with error -2
> [    0.257608] atmel_mxt_ts i2c-ATML0001:01: Touchscreen size X2559Y1699
> [    0.257642] input: Atmel maXTouch Touchscreen as /devices/pci0000:00/INT3433:00/i2c-1/i2c-ATML0001:01/input/input5

Thank you for testing Andre!

Linus, I think I prefer swapping around calls as that makes the logic on
mxt_check_retrigen() simpler. Could you please update your patch to swap
the calls as I would like to credit you for the fix.

Thanks.

-- 
Dmitry
