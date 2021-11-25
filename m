Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB22E45D41F
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 06:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhKYF02 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 00:26:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbhKYFY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 00:24:28 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28EAC06175E
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 21:20:45 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y7so3705700plp.0
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 21:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V6RfWvdt16U2VWFqMEVvVlOPkJuFLI558MPr5o4RNcU=;
        b=J+fNPN/cXhJhxbhMNUJpcNGJ1PNJWEqRssvmQpYFeDpekIueCED4gFTz1Dayxsh2vb
         BDl8Crys0S1xxU2+Xw7d0MiI9lw6xcrMO1sRuocYi2ij1uXxPcdbnI/JGM33mh2foHAA
         Gmqux4E6WOJtJGNlY3eIGZzkAb4/05xdjmDuMAfAOmKJF9mMcJMJH7pVzI0EHVli9zYj
         kJeHDoVbntylmUkTNYRfy9ZQG5gIeQKlXxpV/HDh54FV5j5vIDLS4ggRIojqlv7Bugv1
         xlnhpxWRQlH4Ow6Tt+X5gj83JVaZcX9UVixWZ0fuio7hv379Y7ucvz4tLXoO9X4/LCIu
         yb4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V6RfWvdt16U2VWFqMEVvVlOPkJuFLI558MPr5o4RNcU=;
        b=BmQYVoqh8qP+UTJORvbxn/y1ggNdCKPz2GvFFsXY/BR/BWPjNJQDH8r+hxtcBZOf/g
         VL6OHRbX7BEYOSgkgE1dqXMG31C1QduWMZA7N8+wGepxEhu1OrlWDXRFcHKDs6BrmPv+
         mzgtHbuKYg7wxGoMzg5HurJXwLLk/vgLYMUFJXzb/g0kkEhTeIG+mGSffqE+fHY34s1D
         /EDU1EsuEde2Tez/6Xa1wT6Qg6Ay/uRUOL6462uX/FieW/6EB8Yovm7gpq+vNfk761ah
         luOBSY6Mx6xt3D3lQBA29N0KIATQcZiwOuQsljskUyhy8aXlQKM4jtgolBMa/YeNPbkU
         gCww==
X-Gm-Message-State: AOAM5327jz09J9mcK+iTR0IrOU9Tjd08wk44BsaQSmSxFeSX+IoGf5t5
        2JDuoztoQeryBZrxhiMR2s5Hqf13UVvk
X-Google-Smtp-Source: ABdhPJyZLdQu6IiytVeUo9CZLbw43unxno/Icd7jTSRIYnGA4c9Gl8HRTcPcrN5lWRgKlqStQD9lLg==
X-Received: by 2002:a17:903:120a:b0:143:e4e9:4cdb with SMTP id l10-20020a170903120a00b00143e4e94cdbmr26634721plh.89.1637817645184;
        Wed, 24 Nov 2021 21:20:45 -0800 (PST)
Received: from thinkpad ([117.193.208.239])
        by smtp.gmail.com with ESMTPSA id b15sm1579372pfl.118.2021.11.24.21.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 21:20:44 -0800 (PST)
Date:   Thu, 25 Nov 2021 10:50:38 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     mhi@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Thomas Perrot <thomas.perrot@bootlin.com>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>, quic_jhugo@quicinc.com,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v4] bus: mhi: Fix race while handling SYS_ERR at power up
Message-ID: <20211125052038.GA7290@thinkpad>
References: <20211124132221.44915-1-manivannan.sadhasivam@linaro.org>
 <CAAP7ucKnOEpt3_tj3+-A12+m2DPmfBO46wLs1F9gszQ95aUHdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAP7ucKnOEpt3_tj3+-A12+m2DPmfBO46wLs1F9gszQ95aUHdw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 04:17:40PM +0100, Aleksander Morgado wrote:
> Hey Mani,
> 
> On Wed, Nov 24, 2021 at 2:22 PM Manivannan Sadhasivam
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
> > Changes in v4:
> >
> > * Reverted the change that moved BHI_INTVEC as that was causing issue as
> >   reported by Aleksander.
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
> So far so good, works without issues in both reboots and cold boots.
> Thanks!
> 

Thanks a lot for testing! I'll add your tested-by tag while applying.

Regards,
Mani

> Posting here an example log for reference:
> 
> root@OpenWrt:~# dmesg | grep mhi
> [    7.022756] mhi-pci-generic 0000:01:00.0: MHI PCI device found: sierra-em919x
> [    7.029931] mhi-pci-generic 0000:01:00.0: BAR 0: assigned [mem
> 0x600000000-0x600000fff 64bit]
> [    7.038495] mhi-pci-generic 0000:01:00.0: enabling device (0000 -> 0002)
> [    7.045311] mhi-pci-generic 0000:01:00.0: using shared MSI
> [    7.051420] mhi mhi0: Requested to power ON
> [    7.055637] mhi mhi0: Attempting power on with EE: PASS THROUGH,
> state: SYS ERROR
> [    7.176024] mhi mhi0: Power on setup success
> [    7.176082] mhi mhi0: Handling state transition: PBL
> [    7.180322] mhi mhi0: local ee: INVALID_EE state: RESET device ee:
> MISSION MODE state: READY
> [    7.193852] mhi mhi0: Device in READY State
> [    7.198043] mhi mhi0: Initializing MHI registers
> [    7.202712] mhi mhi0: Wait for device to enter SBL or Mission mode
> [   15.351002] mhi mhi0: local ee: MISSION MODE state: READY device
> ee: MISSION MODE state: READY
> [   15.509984] mhi mhi0: State change event to state: M0
> [   15.510001] mhi mhi0: local ee: MISSION MODE state: READY device
> ee: MISSION MODE state: M0
> [   15.523459] mhi mhi0: Received EE event: MISSION MODE
> [   15.523463] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   15.536629] mhi mhi0: Handling state transition: MISSION MODE
> [   15.542393] mhi mhi0: Processing Mission Mode transition
> [   15.549246] mhi_net mhi0_IP_HW0: 100: Updating channel state to: START
> [   15.647776] mhi_net mhi0_IP_HW0: 100: Channel state change to START
> successful
> [   15.647795] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   15.663196] mhi_net mhi0_IP_HW0: 101: Updating channel state to: START
> [   15.719309] mhi_net mhi0_IP_HW0: 101: Channel state change to START
> successful
> [   15.719314] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   17.851014] mhi mhi0: Allowing M3 transition
> [   17.855347] mhi mhi0: Waiting for M3 completion
> [   17.987550] mhi mhi0: State change event to state: M3
> [   17.987568] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M3
> [   21.851920] mhi_wwan_ctrl mhi0_DUN: 32: Updating channel state to: START
> [   21.876065] mhi mhi0: Entered with PM state: M3, MHI state: M3
> [   21.900513] mhi mhi0: State change event to state: M0
> [   21.900538] mhi mhi0: local ee: MISSION MODE state: M3 device ee:
> MISSION MODE state: M0
> [   21.921710] mhi_wwan_ctrl mhi0_DUN: 32: Channel state change to
> START successful
> [   21.921713] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   21.937308] mhi_wwan_ctrl mhi0_DUN: 33: Updating channel state to: START
> [   21.946170] mhi_wwan_ctrl mhi0_DUN: 33: Channel state change to
> START successful
> [   21.946172] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   21.981308] mhi_wwan_ctrl mhi0_DIAG: 4: Updating channel state to: START
> [   21.990184] mhi_wwan_ctrl mhi0_DIAG: 4: Channel state change to
> START successful
> [   21.990186] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   22.005697] mhi_wwan_ctrl mhi0_DIAG: 5: Updating channel state to: START
> [   22.014547] mhi_wwan_ctrl mhi0_DIAG: 5: Channel state change to
> START successful
> [   22.014549] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   22.043376] mhi_wwan_ctrl mhi0_DIAG: mhi_ul_xfer_cb: status: 0 xfer_len: 5
> [   22.043380] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   22.050277] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   22.058371] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: 0
> receive_len: 58
> [   22.073988] mhi_wwan_ctrl mhi0_DIAG: 5: Updating channel state to: RESET
> [   22.082292] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   22.082294] mhi_wwan_ctrl mhi0_DIAG: 5: Channel state change to
> RESET successful
> [   22.097778] mhi mhi0: Marking all events for chan: 5 as stale
> [   22.103523] mhi mhi0: Finished marking events as stale events
> [   22.109271] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.116676] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.124076] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.131476] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.138874] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.146274] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.153672] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.161071] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.168470] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.175870] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.183268] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.190666] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.198065] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.205463] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.212862] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.220260] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.227660] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.235059] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.242457] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.249855] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.257253] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.264651] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.272049] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.279448] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.286846] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.294245] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.301643] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.309041] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.316440] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.323838] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.331237] mhi_wwan_ctrl mhi0_DIAG: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   22.338666] mhi_wwan_ctrl mhi0_DIAG: 5: successfully reset
> [   22.344157] mhi_wwan_ctrl mhi0_DIAG: 4: Updating channel state to: RESET
> [   22.352753] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   22.352758] mhi_wwan_ctrl mhi0_DIAG: 4: Channel state change to
> RESET successful
> [   22.368356] mhi mhi0: Marking all events for chan: 4 as stale
> [   22.374106] mhi mhi0: Finished marking events as stale events
> [   22.379910] mhi_wwan_ctrl mhi0_DIAG: 4: successfully reset
> [   22.388072] mhi_wwan_ctrl mhi0_QMI: 14: Updating channel state to: START
> [   22.397188] mhi_wwan_ctrl mhi0_QMI: 14: Channel state change to
> START successful
> [   22.397190] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   22.412690] mhi_wwan_ctrl mhi0_QMI: 15: Updating channel state to: START
> [   22.424017] mhi_wwan_ctrl mhi0_QMI: 15: Channel state change to
> START successful
> [   22.424021] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   25.917106] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: 0 xfer_len: 4
> [   25.917125] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   25.935842] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: 0 xfer_len: 4
> [   25.935852] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   25.942645] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 3
> [   25.950734] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   25.957768] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 6
> [   25.972897] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 3
> [   25.979950] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 6
> [   25.979953] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   25.995084] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: 0 xfer_len: 9
> [   25.995269] mhi_wwan_ctrl mhi0_DUN: 33: Updating channel state to: RESET
> [   26.001872] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 8
> [   26.001879] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 39
> [   26.024415] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   26.024418] mhi_wwan_ctrl mhi0_DUN: 33: Channel state change to
> RESET successful
> [   26.039893] mhi mhi0: Marking all events for chan: 33 as stale
> [   26.045723] mhi mhi0: Finished marking events as stale events
> [   26.051468] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.058780] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.066092] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.073404] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.080715] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.088027] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.095337] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.102650] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.109965] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.117279] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.124589] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.131900] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.139211] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.146521] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.153831] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.161142] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.168452] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.175763] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.183073] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.190385] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.197695] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.205006] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.212315] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.219627] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.226937] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.234248] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.241558] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.248869] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   26.256206] mhi_wwan_ctrl mhi0_DUN: 33: successfully reset
> [   26.261695] mhi_wwan_ctrl mhi0_DUN: 32: Updating channel state to: RESET
> [   26.270660] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   26.270669] mhi_wwan_ctrl mhi0_DUN: 32: Channel state change to
> RESET successful
> [   26.286159] mhi mhi0: Marking all events for chan: 32 as stale
> [   26.291992] mhi mhi0: Finished marking events as stale events
> [   26.297761] mhi_wwan_ctrl mhi0_DUN: 32: successfully reset
> [   30.355529] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 12
> [   30.355543] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   30.362450] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 12
> [   30.370546] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   30.377411] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 12
> [   30.392643] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 12
> [   30.399531] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 228
> [   30.406757] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 12
> [   30.413636] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 228
> [   30.420863] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 12
> [   30.427754] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 228
> [   30.434992] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 12
> [   30.441882] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 228
> [   30.449115] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 12
> [   30.456012] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 228
> [   30.463268] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 228
> [   30.470516] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 228
> [   30.479754] mhi_wwan_ctrl mhi0_QMI: 15: Updating channel state to: RESET
> [   30.489207] mhi_wwan_ctrl mhi0_QMI: 15: Channel state change to
> RESET successful
> [   30.489210] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   30.504704] mhi mhi0: Marking all events for chan: 15 as stale
> [   30.510536] mhi mhi0: Finished marking events as stale events
> [   30.516284] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.523598] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.530911] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.538224] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.545535] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.552847] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.560157] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.567468] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.574779] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.582091] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.589402] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.596713] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.604024] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.611335] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.618645] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.625957] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.633291] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.640618] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.647946] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.655297] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.662627] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.669949] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.677262] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.684572] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.691888] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.699199] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.706509] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.713820] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.721131] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.728441] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.735752] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: -107
> receive_len: 0
> [   30.743092] mhi_wwan_ctrl mhi0_QMI: 15: successfully reset
> [   30.748605] mhi_wwan_ctrl mhi0_QMI: 14: Updating channel state to: RESET
> [   30.761269] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   30.769375] mhi_wwan_ctrl mhi0_QMI: 14: Channel state change to
> RESET successful
> [   30.776780] mhi mhi0: Marking all events for chan: 14 as stale
> [   30.782613] mhi mhi0: Finished marking events as stale events
> [   30.788371] mhi_wwan_ctrl mhi0_QMI: 14: successfully reset
> [   30.794771] mhi_wwan_ctrl mhi0_QMI: 14: Updating channel state to: START
> [   30.803532] mhi_wwan_ctrl mhi0_QMI: 14: Channel state change to
> START successful
> [   30.803535] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   30.819038] mhi_wwan_ctrl mhi0_QMI: 15: Updating channel state to: START
> [   30.828331] mhi_wwan_ctrl mhi0_QMI: 15: Channel state change to
> START successful
> [   30.828333] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   31.925717] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 12
> [   31.925723] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   31.932639] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   31.940747] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 12
> [   31.955964] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 228
> [   31.978521] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 16
> [   31.978523] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   31.985418] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   31.993503] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.012893] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.012897] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.019777] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 77
> [   32.027861] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.054892] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 16
> [   32.054894] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.061787] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.069867] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 17
> [   32.084825] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.091966] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.123615] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 16
> [   32.123618] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.130510] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.138594] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.168928] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.168935] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 16
> [   32.183929] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.183937] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.203362] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 16
> [   32.203363] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.210246] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.218328] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.236614] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 16
> [   32.236616] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.243512] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.251618] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.269860] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 16
> [   32.269862] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.276745] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.284834] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.304246] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 16
> [   32.304247] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.311135] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.319241] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.339188] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 16
> [   32.339193] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.346078] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.354158] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.369801] mhi_wwan_ctrl mhi0_DUN: 32: Updating channel state to: START
> [   32.379359] mhi_wwan_ctrl mhi0_DUN: 32: Channel state change to
> START successful
> [   32.379361] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.394877] mhi_wwan_ctrl mhi0_DUN: 33: Updating channel state to: START
> [   32.404051] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.404052] mhi_wwan_ctrl mhi0_DUN: 33: Channel state change to
> START successful
> [   32.423401] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: 0 xfer_len: 6
> [   32.423403] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.430201] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.438282] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.453242] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 294
> [   32.460474] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 5
> [   32.467535] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 6
> [   32.467538] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.482675] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.489557] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.489560] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 26
> [   32.489567] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: 0 xfer_len: 6
> [   32.504790] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.511569] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 6
> [   32.526694] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.533572] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 197
> [   32.533574] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.548873] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: 0 xfer_len: 11
> [   32.555749] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 6
> [   32.555752] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.562793] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.577748] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.577750] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 52
> [   32.577755] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: 0 xfer_len: 6
> [   32.592974] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.599753] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 9
> [   32.614877] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.621756] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.621758] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 29
> [   32.621765] mhi_wwan_ctrl mhi0_DUN: mhi_ul_xfer_cb: status: 0 xfer_len: 7
> [   32.629862] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.636985] mhi_wwan_ctrl mhi0_DUN: mhi_dl_xfer_cb: status: 0 receive_len: 9
> [   32.643764] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.651846] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.673835] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 77
> [   32.684996] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 27
> [   32.684998] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.691894] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.699994] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 20
> [   32.715206] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 29
> [   32.726784] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.726788] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.733667] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 26
> [   32.741756] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.759982] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.759985] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.766864] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 42
> [   32.774951] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.794333] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.794337] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.801215] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 145
> [   32.809294] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.828654] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.828657] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.835554] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.843638] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 24
> [   32.862183] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 20
> [   32.862186] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.869074] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.877162] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 27
> [   32.896556] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.896558] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.903446] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.911532] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 12
> [   32.926749] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 116
> [   32.938214] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.938223] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.945134] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0
> receive_len: 116
> [   32.953218] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.972615] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   32.972619] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   32.979497] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 20
> [   32.987579] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   33.005791] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   33.005793] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   33.012673] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   33.020759] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 90
> [   35.011999] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   35.012012] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   35.018924] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 90
> [   35.027016] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   35.034131] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 12
> [   37.011548] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   37.011554] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   37.018476] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   37.026567] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 90
> [   39.012483] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   39.012497] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   39.019413] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 90
> [   39.027510] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   39.034617] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 12
> [   41.010833] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   41.010839] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   41.017760] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   41.025856] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 90
> [   43.010424] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   43.010431] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   43.017356] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   43.025455] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 90
> [   45.009911] mhi_wwan_ctrl mhi0_QMI: mhi_ul_xfer_cb: status: 0 xfer_len: 13
> [   45.009918] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   45.016839] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> [   45.024933] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 90
> [   47.523933] mhi mhi0: Allowing M3 transition
> [   47.528247] mhi mhi0: Waiting for M3 completion
> [   47.569544] mhi mhi0: State change event to state: M3
> [   47.569567] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M3
> [   48.632075] mhi mhi0: Entered with PM state: M3, MHI state: M3
> [   48.650239] mhi mhi0: State change event to state: M0
> [   48.650247] mhi mhi0: local ee: MISSION MODE state: M3 device ee:
> MISSION MODE state: M0
> [   48.667040] mhi_wwan_ctrl mhi0_QMI: mhi_dl_xfer_cb: status: 0 receive_len: 12
> [   48.667043] mhi mhi0: local ee: MISSION MODE state: M0 device ee:
> MISSION MODE state: M0
> 
> 
> 
> 
> -- 
> Aleksander
> https://aleksander.es
