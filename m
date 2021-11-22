Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC41459164
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 16:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbhKVPay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 10:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239824AbhKVPay (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 10:30:54 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF80AC061714
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 07:27:47 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id iq11so14115191pjb.3
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 07:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FWFwUQiNQcPmdLWpd4EdufDmfHkR01oMllZ2TVyM5h4=;
        b=RdqohAcqy6NHhBvlbYxKLEw3Kj8ldpe/vCPMziaU0/z4T/SkAp/6t2n1lPDpt5YMt5
         BrkmXkFkkjzTx/OFCnSKRGMrXapnmNgPMPjrvjmpMLYrTwMt8YgcL3AeayWOmMfd3qo/
         iI+XC2i/0Q0Kx09S+dNp+tUpQwpiLTswJz5TVYcLJXbV/uWkHuhvjAJocukbOX4Oy/V9
         5oqcgp067t0L+ZvDaVtS7AM1asICdpQJmYHiTz+I6b8vxw/RYWhoz9q+tcRrSBalVlM7
         W4Ceux4kp/5nHIPq58maNI2n/W9OUqZBao3gKEltEBM3JnPFIsC6CHdUN9x5Va6p87jU
         rT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FWFwUQiNQcPmdLWpd4EdufDmfHkR01oMllZ2TVyM5h4=;
        b=GBbHEbN/bSJ1Ronh27TcfjoICcuyYOtULVDkjdQeFjERnU+dti5kxbNUj4TOzWqGaM
         tUM1bt6oxlswxpqPny4PYqEe33SSS4hkuh9Wx0Rv5/uhK4Woxyh9JQfbtqC/+PWywIer
         KQ8Dt/i8iXUkh4jZxJ11+rqwF25O+f1CXWzy1qaKMpZp+GhGbcoVVg4W4OgEjP9OFoO5
         QxG1WhMVWcjT0ByZQOeD9o3g4Cot4JAbYRxkFcFKCbbNcuVWBHBdil1xG1Bxf47+nXug
         jSRNSTk+oLxiYwskL4qP64Ep6cFy6oyHINkcQy07UebMCv0ppdilAgxYbMf3Ox/d+/qD
         KjFw==
X-Gm-Message-State: AOAM533YskUvY9mOuntOEni8Odnh3z5huaaW3EMgqgPzMNO+Se5L4kRp
        1jf0gdGgnMvnoRPmi4WyynJKhPYOnta6
X-Google-Smtp-Source: ABdhPJxlpS3VhiGIwfzqcOqSG0xq8GMqo57/UK4XVjG7EqB8Kn3/RisEsTh+r8TvOJqrd8VHqn3Z3g==
X-Received: by 2002:a17:903:32c2:b0:141:eed4:ec0a with SMTP id i2-20020a17090332c200b00141eed4ec0amr108770519plr.74.1637594867106;
        Mon, 22 Nov 2021 07:27:47 -0800 (PST)
Received: from thinkpad ([202.21.42.242])
        by smtp.gmail.com with ESMTPSA id g20sm10430677pfj.12.2021.11.22.07.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:27:46 -0800 (PST)
Date:   Mon, 22 Nov 2021 20:57:42 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     mhi@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Thomas Perrot <thomas.perrot@bootlin.com>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>, quic_jhugo@quicinc.com,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] bus: mhi: Fix race while handling SYS_ERR at power up
Message-ID: <20211122152742.GA83834@thinkpad>
References: <20211118055726.13107-1-manivannan.sadhasivam@linaro.org>
 <CAAP7ucJoOTOqFnNpJcQmxF=A0TOB8TtCCng-2q9pNkddRTbpuw@mail.gmail.com>
 <20211120112508.GA100286@thinkpad>
 <20211120113626.GB100286@thinkpad>
 <CAAP7ucJ8LyYXWRLGAhYfCV7nYL+6tSHCLrOJ_hZ+swqRfv7QfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAP7ucJ8LyYXWRLGAhYfCV7nYL+6tSHCLrOJ_hZ+swqRfv7QfQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hey,

On Mon, Nov 22, 2021 at 02:13:08PM +0100, Aleksander Morgado wrote:
> Hey Mani,
> 
> > > > >
> > > > > Some devices tend to trigger SYS_ERR interrupt while the host handling
> > > > > SYS_ERR state of the device during power up. This creates a race
> > > > > condition and causes a failure in booting up the device.
> > > > >
> > > > > The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
> > > > > handling in mhi_async_power_up(). Once the host detects that the device
> > > > > is in SYS_ERR state, it issues MHI_RESET and waits for the device to
> > > > > process the reset request. During this time, the device triggers SYS_ERR
> > > > > interrupt to the host and host starts handling SYS_ERR execution.
> > > > >
> > > > > So by the time the device has completed reset, host starts SYS_ERR
> > > > > handling. This causes the race condition and the modem fails to boot.
> > > > >
> > > > > Hence, register the IRQ handler only after handling the SYS_ERR check
> > > > > to avoid getting spurious IRQs from the device.
> > > > >
> > > > > Cc: stable@vger.kernel.org
> > > > > Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
> > > > > Reported-by: Aleksander Morgado <aleksander@aleksander.es>
> > > > > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > > > ---
> > > > >
> > > > > Changes in v3:
> > > > >
> > > > > * Moved BHI_INTVEC setup after irq setup
> > > > > * Used interval_us as the delay for the polling API
> > > > >
> > > > > Changes in v2:
> > > > >
> > > > > * Switched to "mhi_poll_reg_field" for detecting MHI reset in device.
> > > > >
> > > >
> > > > I tried this v3 patch and I'm not sure if it's working properly in my
> > > > setup; not all boots are successfully bringing the modem up.
> > > >
> > >
> > > Ouch!
> > >
> > > > Once I installed it, I kept having this kind of logs on every boot:
> > > > [    7.030407] mhi-pci-generic 0000:01:00.0: BAR 0: assigned [mem
> > > > 0x600000000-0x600000fff 64bit]
> > > > [    7.038984] mhi-pci-generic 0000:01:00.0: enabling device (0000 -> 0002)
> > > > [    7.045814] mhi-pci-generic 0000:01:00.0: using shared MSI
> > > > [    7.052191] mhi mhi0: Requested to power ON
> > > > [    7.168042] mhi mhi0: Power on setup success
> > > > [    7.168141] mhi mhi0: Wait for device to enter SBL or Mission mode
> > > > [   15.687938] mhi-pci-generic 0000:01:00.0: failed to suspend device: -16
> > >
> > > [...]
> > >
> > > > I didn't try the v1 or v2 patches (sorry!), so not sure if the issues
> > > > come in this last iteration or in an earlier one. Do you want me to
> > > > try with v1 and v2 as well?
> > > >
> > >
> > > Yes, please. Nothing changed other than moving the BHI_INTVEC programming.
> > >
> >
> > Or if you want to do it quickly, please test the diff below:
> >
> > diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
> > index ee0515a25e46..21484a61bbed 100644
> > --- a/drivers/bus/mhi/core/pm.c
> > +++ b/drivers/bus/mhi/core/pm.c
> > @@ -1055,7 +1055,9 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
> >         mutex_lock(&mhi_cntrl->pm_mutex);
> >         mhi_cntrl->pm_state = MHI_PM_DISABLE;
> >
> > +       /* Setup BHI INTVEC */
> >         write_lock_irq(&mhi_cntrl->pm_lock);
> > +       mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
> >         mhi_cntrl->pm_state = MHI_PM_POR;
> >         mhi_cntrl->ee = MHI_EE_MAX;
> >         current_ee = mhi_get_exec_env(mhi_cntrl);
> > @@ -1094,9 +1096,6 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
> >         if (ret)
> >                 goto error_setup_irq;
> >
> > -       /* Setup BHI INTVEC */
> > -       mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
> > -
> >         /* Transition to next state */
> >         next_state = MHI_IN_PBL(current_ee) ?
> >                 DEV_ST_TRANSITION_PBL : DEV_ST_TRANSITION_READY;
> >
> 
> I tested that additional diff on top of v3, and so far so good; I did
> 5 soft reboots and 5 hard boots and they were all successful.
>

Great! Thanks for the testing. I'll post v4 with this change.
Please spare some time in testing that also :)

Thanks,
Mani
 
> -- 
> Aleksander
> https://aleksander.es
