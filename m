Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C0B458F36
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 14:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhKVNQ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 08:16:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbhKVNQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 08:16:28 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC54C061714
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 05:13:21 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id r11so76648881edd.9
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 05:13:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wtYroizhHqJrGVDaksNBazUqy0tZ4NNXvcMpUiY7l1w=;
        b=EE6VFG4kLO7LPHcRNyRoT+pOd94sieaTFgr7Gs/uu6WtuIWDdMnjrBGcbINfqfndfE
         QxCp1UUozIySbMYb579T9/LLoyt4okXcnHWkdwEVQphMHiG6koalumdadTYbYukgs5G7
         PGgY5gmHKKG1zhJl2C52euWXUaUIQPAkdFd6lX+jeQHsn5ykIfm2oAi10FEHZ3JZGwXq
         JNTMIhDXwHjYbybohLD6IhWVILqu/2Ejmp/ARHuc5465xfv9h5oHJ83HHDoU3WfozdO1
         0NKR4gaD51HY8fq/mtsnMCSFnsBNwMQ/veJZfOiUmPfq3G2+FmjL334/LH9V7l/yjyTS
         A02Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wtYroizhHqJrGVDaksNBazUqy0tZ4NNXvcMpUiY7l1w=;
        b=3SPzKkoJOEVhoQ/AFkCfNQipdxDE5JyuZFOr7ggOzVOOHAEtZrRH/fVvpLvzt534Em
         9ZnrkCftMlMUd8CQoukFVuGfimFICSwW6fnGzWa9pZLKjAXC8/t5pQLwZw8lXdB6PNcL
         P0Yyz7o1fUNQ3Hu5+k/nnPM7A3LqyyC81i+fkO23RQS1J3IYqg0RFk+mxJmR9nCEocDA
         Tbls1UV13dm70O4OyCS0Bo/txOrDgUXWJNbSfZv11mFV3wI/GN/MFg8R0uurKoIbjl7r
         gzKaANKLvha7CQ3CmSsbmIFrg9x8w0t206mwSm45l/+oNRRCaI1g54bQGLIVqqQGESMg
         fyqg==
X-Gm-Message-State: AOAM531+fVmdp7ipe+SGzzBpQKkWHvU3JdgY2l6GXuYunFJHWIlPhMyv
        hh1cOvJ3KHw0+rWnZ+icO8Nvsywh5ek0L/5bKBWkCA==
X-Google-Smtp-Source: ABdhPJzVLCPziXjZsYJ6ncptCqZfDMLvYAV4ajtwLF+R5azT6DiquWrL7LZ+T0F9TROgKFUugM+N+Di2Q/8EcRUggM4=
X-Received: by 2002:a17:907:68e:: with SMTP id wn14mr41508952ejb.258.1637586800354;
 Mon, 22 Nov 2021 05:13:20 -0800 (PST)
MIME-Version: 1.0
References: <20211118055726.13107-1-manivannan.sadhasivam@linaro.org>
 <CAAP7ucJoOTOqFnNpJcQmxF=A0TOB8TtCCng-2q9pNkddRTbpuw@mail.gmail.com>
 <20211120112508.GA100286@thinkpad> <20211120113626.GB100286@thinkpad>
In-Reply-To: <20211120113626.GB100286@thinkpad>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Mon, 22 Nov 2021 14:13:08 +0100
Message-ID: <CAAP7ucJ8LyYXWRLGAhYfCV7nYL+6tSHCLrOJ_hZ+swqRfv7QfQ@mail.gmail.com>
Subject: Re: [PATCH v3] bus: mhi: Fix race while handling SYS_ERR at power up
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     mhi@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Thomas Perrot <thomas.perrot@bootlin.com>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>, quic_jhugo@quicinc.com,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Mani,

> > > >
> > > > Some devices tend to trigger SYS_ERR interrupt while the host handling
> > > > SYS_ERR state of the device during power up. This creates a race
> > > > condition and causes a failure in booting up the device.
> > > >
> > > > The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
> > > > handling in mhi_async_power_up(). Once the host detects that the device
> > > > is in SYS_ERR state, it issues MHI_RESET and waits for the device to
> > > > process the reset request. During this time, the device triggers SYS_ERR
> > > > interrupt to the host and host starts handling SYS_ERR execution.
> > > >
> > > > So by the time the device has completed reset, host starts SYS_ERR
> > > > handling. This causes the race condition and the modem fails to boot.
> > > >
> > > > Hence, register the IRQ handler only after handling the SYS_ERR check
> > > > to avoid getting spurious IRQs from the device.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
> > > > Reported-by: Aleksander Morgado <aleksander@aleksander.es>
> > > > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > > ---
> > > >
> > > > Changes in v3:
> > > >
> > > > * Moved BHI_INTVEC setup after irq setup
> > > > * Used interval_us as the delay for the polling API
> > > >
> > > > Changes in v2:
> > > >
> > > > * Switched to "mhi_poll_reg_field" for detecting MHI reset in device.
> > > >
> > >
> > > I tried this v3 patch and I'm not sure if it's working properly in my
> > > setup; not all boots are successfully bringing the modem up.
> > >
> >
> > Ouch!
> >
> > > Once I installed it, I kept having this kind of logs on every boot:
> > > [    7.030407] mhi-pci-generic 0000:01:00.0: BAR 0: assigned [mem
> > > 0x600000000-0x600000fff 64bit]
> > > [    7.038984] mhi-pci-generic 0000:01:00.0: enabling device (0000 -> 0002)
> > > [    7.045814] mhi-pci-generic 0000:01:00.0: using shared MSI
> > > [    7.052191] mhi mhi0: Requested to power ON
> > > [    7.168042] mhi mhi0: Power on setup success
> > > [    7.168141] mhi mhi0: Wait for device to enter SBL or Mission mode
> > > [   15.687938] mhi-pci-generic 0000:01:00.0: failed to suspend device: -16
> >
> > [...]
> >
> > > I didn't try the v1 or v2 patches (sorry!), so not sure if the issues
> > > come in this last iteration or in an earlier one. Do you want me to
> > > try with v1 and v2 as well?
> > >
> >
> > Yes, please. Nothing changed other than moving the BHI_INTVEC programming.
> >
>
> Or if you want to do it quickly, please test the diff below:
>
> diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
> index ee0515a25e46..21484a61bbed 100644
> --- a/drivers/bus/mhi/core/pm.c
> +++ b/drivers/bus/mhi/core/pm.c
> @@ -1055,7 +1055,9 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
>         mutex_lock(&mhi_cntrl->pm_mutex);
>         mhi_cntrl->pm_state = MHI_PM_DISABLE;
>
> +       /* Setup BHI INTVEC */
>         write_lock_irq(&mhi_cntrl->pm_lock);
> +       mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
>         mhi_cntrl->pm_state = MHI_PM_POR;
>         mhi_cntrl->ee = MHI_EE_MAX;
>         current_ee = mhi_get_exec_env(mhi_cntrl);
> @@ -1094,9 +1096,6 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
>         if (ret)
>                 goto error_setup_irq;
>
> -       /* Setup BHI INTVEC */
> -       mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
> -
>         /* Transition to next state */
>         next_state = MHI_IN_PBL(current_ee) ?
>                 DEV_ST_TRANSITION_PBL : DEV_ST_TRANSITION_READY;
>

I tested that additional diff on top of v3, and so far so good; I did
5 soft reboots and 5 hard boots and they were all successful.

-- 
Aleksander
https://aleksander.es
