Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2980F449B44
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 18:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbhKHSCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 13:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234180AbhKHSCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 13:02:37 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E1A2C061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 09:59:53 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id o6-20020a17090a0a0600b001a64b9a11aeso502483pjo.3
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 09:59:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eOkbF6RJbzSR2y0WRZFBRW2VzAisHKRZH6leo4LT6IE=;
        b=oJ9kRijyNmsV+pXg1hPvk7qdWqqLSa+3U7A9IfagZTjm3B1yAkE5WJF69BzePmB84s
         rcLtcLuVoU4ICH+gA/2LOmmVB9Xkz43ZZOGZfymuO5MxfmX1uC2y30oSqqzIxCPyRDFC
         uWLlz2tlF494XKeJ/2tFSd+o5S+qIAfo/M761cUQs0Fqv7NaCiXFFfHxJLS9zpmgr094
         7GvC6w0MS9A1qpQ4bvvYwqDdxGEnd2EjMSZND6E3lgT+3E9pUkBxdAu+ahk87xjLZ3+n
         u+tUwHwRBe1mXe/43KrSrF+f//drIOR8Wtd9fLC56nozqj+QzlmT5NfwL+0keaJ3SDME
         XXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eOkbF6RJbzSR2y0WRZFBRW2VzAisHKRZH6leo4LT6IE=;
        b=j26qsuUVQe5VhQrz30N7SU8YGNc5rVjfhjdSHKH/lGkfWWRqrpWpjmPdwZ6DpWmIM8
         YmjZ3LwQw5QpEYx59LfqavdYfZHfEJHAMrXW+ayFXXFiMu+Fc7vareIsIcMAIlnahKBM
         TyAcRxbw8+H6zDFp5RLZR23LMplLCX8SbAwaTLB9WWNsCNKXQJtpEqGeNszknS3TTC8M
         8DirpLCQYyVMYWP5H2xTHgSu3VgaaIXQszKvbSEApAyQLi8hyYSD3NuM27/zmEWKGecd
         68dF2ETF3ZvNKrE+mzfeoI/4nvDzADeTSq0wG7EoMAKaPRFPAicjGjkG/WSqVllGR7y0
         aUdw==
X-Gm-Message-State: AOAM531b4Wiw+vSojPk55DVV8Z5bRNxs0f4qatcJg6EhMa5vr88yW3Pb
        Jvk7Ff/Lpwg6gzjPlKXWccUc
X-Google-Smtp-Source: ABdhPJztcQIXQeSv3Rgmd7OwSDGQEoSdSu/O+GMYlD7iWuo5jN4wmbjzYzcKicKg9HCGAy+lXU1+Vg==
X-Received: by 2002:a17:902:9a91:b0:138:efd5:7302 with SMTP id w17-20020a1709029a9100b00138efd57302mr1025994plp.35.1636394392587;
        Mon, 08 Nov 2021 09:59:52 -0800 (PST)
Received: from thinkpad ([117.202.191.159])
        by smtp.gmail.com with ESMTPSA id t4sm16653626pfj.166.2021.11.08.09.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 09:59:51 -0800 (PST)
Date:   Mon, 8 Nov 2021 23:29:47 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     mhi@lists.linux.dev, aleksander@aleksander.es,
        thomas.perrot@bootlin.com, hemantk@codeaurora.org,
        bbhatt@codeaurora.org, quic_jhugo@quicinc.com,
        linux-arm-msm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] bus: mhi: Fix race while handling SYS_ERR at power up
Message-ID: <20211108175947.GB6161@thinkpad>
References: <20211108174142.52835-1-manivannan.sadhasivam@linaro.org>
 <CAMZdPi-U=nDsGn41tr7NEWAJ3dwYK70fDEkfOO914Q-a1tyfSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi-U=nDsGn41tr7NEWAJ3dwYK70fDEkfOO914Q-a1tyfSQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Loic,

On Mon, Nov 08, 2021 at 07:04:56PM +0100, Loic Poulain wrote:
> Hi Mani,
> 
> On Mon, 8 Nov 2021 at 18:42, Manivannan Sadhasivam
> <manivannan.sadhasivam@linaro.org> wrote:
> >
> > Some devices tend to trigger SYS_ERR interrupt while the host handling
> > SYS_ERR state of the device during power up. This creates a race
> > condition and causes a failure in booting up the device.
> >
> > The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
> > handling in mhi_async_power_up(). Once the host detects that the device
> > is in SYS_ERR state, it issues MHI_RESET and waits for the device to
> > process the reset request. During this time, the device triggers SYS_ERR
> > interrupt to the host and host starts handling SYS_ERR execution.
> >
> > So by the time the device has completed reset, host starts SYS_ERR
> > handling. This causes the race condition and the modem fails to boot.
> >
> > Hence, register the IRQ handler only after handling the SYS_ERR check
> > to avoid getting spurious IRQs from the device.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
> > Reported-by: Aleksander Morgado <aleksander@aleksander.es>
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  drivers/bus/mhi/core/pm.c | 26 +++++++++++---------------
> >  1 file changed, 11 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
> > index fb99e3727155..ec5f11166820 100644
> > --- a/drivers/bus/mhi/core/pm.c
> > +++ b/drivers/bus/mhi/core/pm.c
> > @@ -1055,10 +1055,6 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
> >         mutex_lock(&mhi_cntrl->pm_mutex);
> >         mhi_cntrl->pm_state = MHI_PM_DISABLE;
> >
> > -       ret = mhi_init_irq_setup(mhi_cntrl);
> > -       if (ret)
> > -               goto error_setup_irq;
> > -
> >         /* Setup BHI INTVEC */
> >         write_lock_irq(&mhi_cntrl->pm_lock);
> >         mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
> > @@ -1072,7 +1068,7 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
> >                 dev_err(dev, "%s is not a valid EE for power on\n",
> >                         TO_MHI_EXEC_STR(current_ee));
> >                 ret = -EIO;
> > -               goto error_async_power_up;
> > +               goto error_setup_irq;
> >         }
> >
> >         state = mhi_get_mhi_state(mhi_cntrl);
> > @@ -1082,19 +1078,18 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
> >         if (state == MHI_STATE_SYS_ERR) {
> >                 mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
> >                 ret = wait_event_timeout(mhi_cntrl->state_event,
> 
> Shouldn't we use a polling variant such as mhi_poll_reg_field() given
> the interrupts are not yet enabled?
> 

Realised _just_ after sending the patch and already submitted v2. Please take a
look.

Thanks,
Mani

> > -                               MHI_PM_IN_FATAL_STATE(mhi_cntrl->pm_state) ||
> > -                                       mhi_read_reg_field(mhi_cntrl,
> > -                                                          mhi_cntrl->regs,
> > -                                                          MHICTRL,
> > -                                                          MHICTRL_RESET_MASK,
> > -                                                          MHICTRL_RESET_SHIFT,
> > +                                        mhi_read_reg_field(mhi_cntrl,
> > +                                                           mhi_cntrl->regs,
> > +                                                           MHICTRL,
> > +                                                           MHICTRL_RESET_MASK,
> > +                                                           MHICTRL_RESET_SHIFT,
> >                                                            &val) ||
> >                                         !val,
> >                                 msecs_to_jiffies(mhi_cntrl->timeout_ms));
> >                 if (!ret) {
> >                         ret = -EIO;
> >                         dev_info(dev, "Failed to reset MHI due to syserr state\n");
> > -                       goto error_async_power_up;
> > +                       goto error_setup_irq;
> >                 }
> 
> Regards,
> Loic
