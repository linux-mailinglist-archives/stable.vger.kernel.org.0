Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA5E457D40
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 12:25:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237361AbhKTL2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 06:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237360AbhKTL2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 06:28:18 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F265C06173E
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 03:25:15 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso11021334pjb.0
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 03:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wRdqI9P/ZA4FAdOPAFHiaGAbLP6EbRI81jlcZ8n6AlM=;
        b=VDahbPtw3zrIuXH3ob6VB1NhbjU5KCQTq41MW6miokqZDhlgHwRSzhsYifahrs6SUV
         /fnmP9hBrxF9GZbi3ssf9h5Tn7oN3v0VyTWHTZYXf/YnmPQTQCOgVVQzVyg7NXSVlVzT
         RzgGxNF4g49xlRkW+okOaNU8CbUXx9ByyMz4bYnfm6RTAp7MviTKxPIGojAUbfV8UCA/
         jgLiNMOhtgmj49SqBb/IsFKL6w0q/8jDz3cColJv4f1x/dSfGfGP+wPFbOHlB4MaQldi
         QaWBnmYIScl5FPx6JX7WPPtIuaklPVPmo1WAxgytPye0EZRieBA/M7AVC7B7/5i5er0Z
         SYTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wRdqI9P/ZA4FAdOPAFHiaGAbLP6EbRI81jlcZ8n6AlM=;
        b=loXd0CPsJiFvi3aJ673hcfuuKeJD/TnYj5SZWbcSHrEkr0nXB7fes54eQuY1zYymGG
         a6USXqwKPDLY3SWbzBI9TdBsY30zoQOGma1J0UuS/cejOnZocgSwWzmTfjjAFRon/JI5
         xdYYgRAh3sRVxpxzoo8Kp/0+mpN0s76u4tEhAKbgddwOiI47k1fSdb+U93pqBVqpd3lK
         tmCWEjL3Fi8lD+lL/8LlSYh8G+Nfd6JcN+Bgpj93kXWSHCoMk6vgJ907SC416Ddlcu6c
         6sUaXoFAjq6NwTO4d23EMlqQ0BoG6EmyeLTvQKyA+F82HcGs9a9fO8yFo9iTssWqK7Wk
         yuJQ==
X-Gm-Message-State: AOAM532CiBZuUQOC+UXVSA64IL+Pgj2XueFsiwo7Exon/EOhEV1E32cd
        yvK7Z97nQLcPavqavENuLKvv8G1f2aLB
X-Google-Smtp-Source: ABdhPJxiuRsG2CUI/n3KqqDU1qfm/WCfrSA1RQ1DNQeAMiDsqM56N/1upDkUVsD6BxgFi0aVVKQxKQ==
X-Received: by 2002:a17:90b:3e81:: with SMTP id rj1mr9490947pjb.111.1637407514803;
        Sat, 20 Nov 2021 03:25:14 -0800 (PST)
Received: from thinkpad ([117.202.188.63])
        by smtp.gmail.com with ESMTPSA id bf13sm2060709pjb.47.2021.11.20.03.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:25:13 -0800 (PST)
Date:   Sat, 20 Nov 2021 16:55:08 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     mhi@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Thomas Perrot <thomas.perrot@bootlin.com>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>, quic_jhugo@quicinc.com,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] bus: mhi: Fix race while handling SYS_ERR at power up
Message-ID: <20211120112508.GA100286@thinkpad>
References: <20211118055726.13107-1-manivannan.sadhasivam@linaro.org>
 <CAAP7ucJoOTOqFnNpJcQmxF=A0TOB8TtCCng-2q9pNkddRTbpuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAP7ucJoOTOqFnNpJcQmxF=A0TOB8TtCCng-2q9pNkddRTbpuw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey,

On Thu, Nov 18, 2021 at 10:55:51AM +0100, Aleksander Morgado wrote:
> Hey Mani,
> 
> On Thu, Nov 18, 2021 at 6:57 AM Manivannan Sadhasivam
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
> >
> > Changes in v3:
> >
> > * Moved BHI_INTVEC setup after irq setup
> > * Used interval_us as the delay for the polling API
> >
> > Changes in v2:
> >
> > * Switched to "mhi_poll_reg_field" for detecting MHI reset in device.
> >
> 
> I tried this v3 patch and I'm not sure if it's working properly in my
> setup; not all boots are successfully bringing the modem up.
> 

Ouch!

> Once I installed it, I kept having this kind of logs on every boot:
> [    7.030407] mhi-pci-generic 0000:01:00.0: BAR 0: assigned [mem
> 0x600000000-0x600000fff 64bit]
> [    7.038984] mhi-pci-generic 0000:01:00.0: enabling device (0000 -> 0002)
> [    7.045814] mhi-pci-generic 0000:01:00.0: using shared MSI
> [    7.052191] mhi mhi0: Requested to power ON
> [    7.168042] mhi mhi0: Power on setup success
> [    7.168141] mhi mhi0: Wait for device to enter SBL or Mission mode
> [   15.687938] mhi-pci-generic 0000:01:00.0: failed to suspend device: -16

[...]

> I didn't try the v1 or v2 patches (sorry!), so not sure if the issues
> come in this last iteration or in an earlier one. Do you want me to
> try with v1 and v2 as well?
> 

Yes, please. Nothing changed other than moving the BHI_INTVEC programming.

Thanks,
Mani

> The patch that was working very reliably (100%) for me was the "bus:
> mhi: Register IRQ handler after SYS_ERR check during power up" one,
> which you attached here:
> https://www.spinics.net/lists/linux-arm-msm/msg97646.html
> 
> -- 
> Aleksander
> https://aleksander.es
