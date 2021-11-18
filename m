Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AF2455865
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 10:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245313AbhKRJ75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 04:59:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245322AbhKRJ7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 04:59:04 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DBDC061764
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 01:56:03 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z5so24483978edd.3
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 01:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aleksander-es.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xu5C790ZoAg97VGCg1XhQWVDBmDf+6a36FlNr4a3o/M=;
        b=ynBCFY5uD4ULQ9b/5BK8N5p8NyESaZmBpT5PNxk9FhOvrN3r77IYXiXYuYim4xVME1
         t+k0rV7mkqae5K8ojii4uRFtclgDlvxj2m/q6OQtwh9V7kLhaQeNRR/mKHZMEI3yHjpq
         Qui0gTFLBC2a4WbUyVM/Ynu/v/Rdy1S6fQfBiTQH1i1Zq3kXiLfWK0yVDUvJMQAGR6yC
         WM3MiQelyyFak9ymmcYM7VmH7UUFjmZcU6tVzLsjRuVrDFkqDFNE5aV2TmNPAW9gaRzx
         aWrehN6NKuXCR46SvqdaWBpVox7ECBeKRLfU1yT2EpNiO4FX6//lYQMq64iKutnhWqvN
         Yo4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xu5C790ZoAg97VGCg1XhQWVDBmDf+6a36FlNr4a3o/M=;
        b=tJ5OEJDkoSWx/1GETrs8sGcncSWY4xN7FkOnYc9EaeVyvbIwv64Kedg5RGI0v9zbaJ
         H/nQAdwqC3O9+UfcLilX8p+XNQDkjq0e4DkTiFSnCi56qUWu5K8m2J8pQAHpFsoKeZVl
         sCAuZGYlhMBLQ4UsW5fDqCJ8csl4jWdsGoKG9nM/GZ9lHYfg27Bwor29fG4SZNdIZxIu
         UN0SUpcJwewDtxaiBAngxnonqdguSX0coxXfdEg0+du7mFfxpEHErpYm2jn5KG6yOSKK
         +KLoqBr+pyNSZBttyhkp6GYs/2CbjbW7/BjxLEfHoI3NxG5d5cDGgUxU6dfatf/NczV1
         qocQ==
X-Gm-Message-State: AOAM5305bV05oOqVdfuAQYUJQ7VR9yrbmvKraEuSQzdLe99zi3ZBuSlU
        u8uXGJ1wRp8gAjIenofiDLrekqqYYylvLhLXgwNJCg==
X-Google-Smtp-Source: ABdhPJytdcmXOpm+1R0BZ5kIZ7mJHWmMMAKGNTUwWOBwbaIAUJQfq3/Rmp56rV4+ydwCFBd0unEvoNAfl2QvdEnvDrw=
X-Received: by 2002:a17:907:720d:: with SMTP id dr13mr32411152ejc.153.1637229362213;
 Thu, 18 Nov 2021 01:56:02 -0800 (PST)
MIME-Version: 1.0
References: <20211118055726.13107-1-manivannan.sadhasivam@linaro.org>
In-Reply-To: <20211118055726.13107-1-manivannan.sadhasivam@linaro.org>
From:   Aleksander Morgado <aleksander@aleksander.es>
Date:   Thu, 18 Nov 2021 10:55:51 +0100
Message-ID: <CAAP7ucJoOTOqFnNpJcQmxF=A0TOB8TtCCng-2q9pNkddRTbpuw@mail.gmail.com>
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

On Thu, Nov 18, 2021 at 6:57 AM Manivannan Sadhasivam
<manivannan.sadhasivam@linaro.org> wrote:
>
> Some devices tend to trigger SYS_ERR interrupt while the host handling
> SYS_ERR state of the device during power up. This creates a race
> condition and causes a failure in booting up the device.
>
> The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
> handling in mhi_async_power_up(). Once the host detects that the device
> is in SYS_ERR state, it issues MHI_RESET and waits for the device to
> process the reset request. During this time, the device triggers SYS_ERR
> interrupt to the host and host starts handling SYS_ERR execution.
>
> So by the time the device has completed reset, host starts SYS_ERR
> handling. This causes the race condition and the modem fails to boot.
>
> Hence, register the IRQ handler only after handling the SYS_ERR check
> to avoid getting spurious IRQs from the device.
>
> Cc: stable@vger.kernel.org
> Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
> Reported-by: Aleksander Morgado <aleksander@aleksander.es>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>
> Changes in v3:
>
> * Moved BHI_INTVEC setup after irq setup
> * Used interval_us as the delay for the polling API
>
> Changes in v2:
>
> * Switched to "mhi_poll_reg_field" for detecting MHI reset in device.
>

I tried this v3 patch and I'm not sure if it's working properly in my
setup; not all boots are successfully bringing the modem up.

Once I installed it, I kept having this kind of logs on every boot:
[    7.030407] mhi-pci-generic 0000:01:00.0: BAR 0: assigned [mem
0x600000000-0x600000fff 64bit]
[    7.038984] mhi-pci-generic 0000:01:00.0: enabling device (0000 -> 0002)
[    7.045814] mhi-pci-generic 0000:01:00.0: using shared MSI
[    7.052191] mhi mhi0: Requested to power ON
[    7.168042] mhi mhi0: Power on setup success
[    7.168141] mhi mhi0: Wait for device to enter SBL or Mission mode
[   15.687938] mhi-pci-generic 0000:01:00.0: failed to suspend device: -16

I didn't have debug logs enabled in that build, so I created a new one
with them enabled, and... these are the logs I'm getting now (not the
same ones as above, not sure why):

// Cold boots fail (tried several times)
[    7.033370] mhi-pci-generic 0000:01:00.0: MHI PCI device found: sierra-em919x
[    7.040558] mhi-pci-generic 0000:01:00.0: BAR 0: assigned [mem
0x600000000-0x600000fff 64bit]
[    7.049105] mhi-pci-generic 0000:01:00.0: enabling device (0000 -> 0002)
[    7.055923] mhi-pci-generic 0000:01:00.0: using shared MSI
[    7.062130] mhi mhi0: Requested to power ON
[    7.066351] mhi mhi0: Attempting power on with EE: PASS THROUGH,
state: SYS ERROR
[   20.572010] mhi mhi0: Power on setup success
[   20.576412] mhi mhi0: Handling state transition: PBL
[   55.139820] mhi mhi0: Device failed to enter MHI Ready
[   55.144978] mhi mhi0: MHI did not enter READY state
[   55.149876] mhi mhi0: Handling state transition: DISABLE
[   55.155203] mhi mhi0: Processing disable transition with PM state:
Firmware Download Error
[   55.163482] mhi mhi0: Triggering MHI Reset in device
[   89.727820] mhi mhi0: Device failed to clear MHI Reset
[   89.732975] mhi mhi0: Waiting for all pending event ring processing
to complete
[   89.740316] mhi mhi0: Waiting for all pending threads to complete
[   89.746422] mhi mhi0: Reset all active channels and remove MHI devices
[   89.752963] mhi mhi0: Resetting EV CTXT and CMD CTXT
[   89.757940] mhi mhi0: Error moving from PM state: Firmware Download
Error to: DISABLE
[   89.765785] mhi mhi0: Exiting with PM state: Firmware Download
Error, MHI state: RESET
[   89.773793] mhi-pci-generic 0000:01:00.0: failed to power up MHI controller
[   89.781067] mhi-pci-generic: probe of 0000:01:00.0 failed with error -110

// Warm reboots afterwards seem to go ok (tried several times)
[    7.072762] mhi-pci-generic 0000:01:00.0: MHI PCI device found: sierra-em919x
[    7.079942] mhi-pci-generic 0000:01:00.0: BAR 0: assigned [mem
0x600000000-0x600000fff 64bit]
[    7.088505] mhi-pci-generic 0000:01:00.0: enabling device (0000 -> 0002)
[    7.095331] mhi-pci-generic 0000:01:00.0: using shared MSI
[    7.101628] mhi mhi0: Requested to power ON
[    7.105859] mhi mhi0: Attempting power on with EE: PASS THROUGH,
state: SYS ERROR
[    7.224053] mhi mhi0: Power on setup success
[    7.228373] mhi mhi0: local ee: INVALID_EE state: RESET device ee:
MISSION MODE state: READY
[    7.236878] mhi mhi0: Handling state transition: PBL
[    7.241871] mhi mhi0: Device in READY State
[    7.246118] mhi mhi0: Initializing MHI registers
[    7.250775] mhi mhi0: Wait for device to enter SBL or Mission mode
[   15.418147] mhi mhi0: local ee: MISSION MODE state: READY device
ee: MISSION MODE state: READY
[   16.025027] mhi mhi0: State change event to state: M0
[   16.025041] mhi mhi0: local ee: MISSION MODE state: READY device
ee: MISSION MODE state: M0
[   16.038500] mhi mhi0: Received EE event: MISSION MODE
[   16.038505] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
MISSION MODE state: M0
[   16.051671] mhi mhi0: Handling state transition: MISSION MODE
[   16.057434] mhi mhi0: Processing Mission Mode transition
[   16.063780] mhi_net mhi0_IP_HW0: 100: Updating channel state to: START
[   16.197073] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
MISSION MODE state: M0
[   16.201196] mhi_net mhi0_IP_HW0: 100: Channel state change to START
successful
[   16.212565] mhi_net mhi0_IP_HW0: 101: Updating channel state to: START
[   16.362262] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
MISSION MODE state: M0
[   16.362268] mhi_net mhi0_IP_HW0: 101: Channel state change to START
successful
[   18.860081] mhi mhi0: Allowing M3 transition
[   18.864380] mhi mhi0: Waiting for M3 completion
[   19.080218] mhi mhi0: State change event to state: M3
[   19.080228] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
MISSION MODE state: M3
[   21.899049] mhi_wwan_ctrl mhi0_DUN: 32: Updating channel state to: START
[   21.924031] mhi mhi0: Entered with PM state: M3, MHI state: M3
[   21.952174] mhi mhi0: State change event to state: M0
[   21.952193] mhi mhi0: local ee: MISSION MODE state: M3 device ee:
MISSION MODE state: M0
[   21.967549] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
MISSION MODE state: M0
[   21.967553] mhi_wwan_ctrl mhi0_DUN: 32: Channel state change to
START successful

I didn't try the v1 or v2 patches (sorry!), so not sure if the issues
come in this last iteration or in an earlier one. Do you want me to
try with v1 and v2 as well?

The patch that was working very reliably (100%) for me was the "bus:
mhi: Register IRQ handler after SYS_ERR check during power up" one,
which you attached here:
https://www.spinics.net/lists/linux-arm-msm/msg97646.html

-- 
Aleksander
https://aleksander.es
