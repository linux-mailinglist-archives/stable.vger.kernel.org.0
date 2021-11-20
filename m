Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A295457D9B
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 12:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237169AbhKTLjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 06:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbhKTLjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 06:39:36 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31FDC061748
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 03:36:33 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id n8so10147435plf.4
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 03:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mwh3yeexugaWmd2oQO5Gr/AwSPWqgPn2PcKbVI2Mkqo=;
        b=L0+luCF8AgL96JKFhudHEnxriM3tYrrS9sGOu+0LTRudaGG8Re3DHoMddTciL1mKYD
         xIIsIcOy33KyxVlwGm9DU5HTgZa7l0fCWGj9KGWZhprz5OCujqAvCUiG+wGIUtikn+jh
         05j/uKJdyFsd+/8EsOzNsde9wKoxmduFNkuKQdRQQISaj3eSSTGM3pvyiP8hB344ZqlO
         4oTZErgyaxDBHrg/p9fQCxK3SKKGZUbJeuagePsloiF92c3rbfsgV1s49qxZkUFttTkP
         EtDseuEk/fpRMDCp+2s8VOIhgiDkGqxkFM9VgkNCg3EB5Dvj8eZMTfJGc57aE7WuK96o
         UXiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mwh3yeexugaWmd2oQO5Gr/AwSPWqgPn2PcKbVI2Mkqo=;
        b=prNhmnEZ8WH3mi+TOkTaBQ6l7Zl/MpFaF83h1sygFp4L9FHJgqEHIvKvKArJc4aqLE
         ls8HLwAS0fM/ELfl10ZM33WzULwCYG/wtsn2UgBKr4i27sJpyHRPFUCqEHC+TbhXR+dv
         BXpFiZq+mEMa01UoOTyS3S5uobZFtEm5ohSIHAEy/QA/Jeg1BIcP4Sh+cHVilj7gBsm0
         DKo0Tgqg8FhTznToiby0sO8mDYPKjV/lsakWUe11b9fkHNYro7048BiufKdBFr7m4IPX
         3G5CMQVPCoJDypCyAIOx/tCvyd4E5+/60OTTltmWexTvrr9qOxKANhk9UWSNuIuhbEC+
         QFkg==
X-Gm-Message-State: AOAM5307R8Iou8/H52kpwtZ+lxTXnUbrfp/MKcEmuNrUqp2GUgNqpjyL
        K7auy4+dc4XgZS6OkK9QuAaA
X-Google-Smtp-Source: ABdhPJzBcoYmBdIzmemDnGbaHVq23U1t/6fqSzfXqYQxNsm4S+JtXz4xvcnSTuUUig7rQ+wuV3BMcw==
X-Received: by 2002:a17:90b:1892:: with SMTP id mn18mr9554871pjb.178.1637408192975;
        Sat, 20 Nov 2021 03:36:32 -0800 (PST)
Received: from thinkpad ([117.202.188.63])
        by smtp.gmail.com with ESMTPSA id f2sm2728133pfe.132.2021.11.20.03.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 03:36:32 -0800 (PST)
Date:   Sat, 20 Nov 2021 17:06:26 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Aleksander Morgado <aleksander@aleksander.es>
Cc:     mhi@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
        Thomas Perrot <thomas.perrot@bootlin.com>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>, quic_jhugo@quicinc.com,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] bus: mhi: Fix race while handling SYS_ERR at power up
Message-ID: <20211120113626.GB100286@thinkpad>
References: <20211118055726.13107-1-manivannan.sadhasivam@linaro.org>
 <CAAP7ucJoOTOqFnNpJcQmxF=A0TOB8TtCCng-2q9pNkddRTbpuw@mail.gmail.com>
 <20211120112508.GA100286@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211120112508.GA100286@thinkpad>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 20, 2021 at 04:55:15PM +0530, Manivannan Sadhasivam wrote:
> Hey,
> 
> On Thu, Nov 18, 2021 at 10:55:51AM +0100, Aleksander Morgado wrote:
> > Hey Mani,
> > 
> > On Thu, Nov 18, 2021 at 6:57 AM Manivannan Sadhasivam
> > <manivannan.sadhasivam@linaro.org> wrote:
> > >
> > > Some devices tend to trigger SYS_ERR interrupt while the host handling
> > > SYS_ERR state of the device during power up. This creates a race
> > > condition and causes a failure in booting up the device.
> > >
> > > The issue is seen on the Sierra Wireless EM9191 modem during SYS_ERR
> > > handling in mhi_async_power_up(). Once the host detects that the device
> > > is in SYS_ERR state, it issues MHI_RESET and waits for the device to
> > > process the reset request. During this time, the device triggers SYS_ERR
> > > interrupt to the host and host starts handling SYS_ERR execution.
> > >
> > > So by the time the device has completed reset, host starts SYS_ERR
> > > handling. This causes the race condition and the modem fails to boot.
> > >
> > > Hence, register the IRQ handler only after handling the SYS_ERR check
> > > to avoid getting spurious IRQs from the device.
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
> > > Reported-by: Aleksander Morgado <aleksander@aleksander.es>
> > > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > ---
> > >
> > > Changes in v3:
> > >
> > > * Moved BHI_INTVEC setup after irq setup
> > > * Used interval_us as the delay for the polling API
> > >
> > > Changes in v2:
> > >
> > > * Switched to "mhi_poll_reg_field" for detecting MHI reset in device.
> > >
> > 
> > I tried this v3 patch and I'm not sure if it's working properly in my
> > setup; not all boots are successfully bringing the modem up.
> > 
> 
> Ouch!
> 
> > Once I installed it, I kept having this kind of logs on every boot:
> > [    7.030407] mhi-pci-generic 0000:01:00.0: BAR 0: assigned [mem
> > 0x600000000-0x600000fff 64bit]
> > [    7.038984] mhi-pci-generic 0000:01:00.0: enabling device (0000 -> 0002)
> > [    7.045814] mhi-pci-generic 0000:01:00.0: using shared MSI
> > [    7.052191] mhi mhi0: Requested to power ON
> > [    7.168042] mhi mhi0: Power on setup success
> > [    7.168141] mhi mhi0: Wait for device to enter SBL or Mission mode
> > [   15.687938] mhi-pci-generic 0000:01:00.0: failed to suspend device: -16
> 
> [...]
> 
> > I didn't try the v1 or v2 patches (sorry!), so not sure if the issues
> > come in this last iteration or in an earlier one. Do you want me to
> > try with v1 and v2 as well?
> > 
> 
> Yes, please. Nothing changed other than moving the BHI_INTVEC programming.
> 

Or if you want to do it quickly, please test the diff below:

diff --git a/drivers/bus/mhi/core/pm.c b/drivers/bus/mhi/core/pm.c
index ee0515a25e46..21484a61bbed 100644
--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -1055,7 +1055,9 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
        mutex_lock(&mhi_cntrl->pm_mutex);
        mhi_cntrl->pm_state = MHI_PM_DISABLE;
 
+       /* Setup BHI INTVEC */
        write_lock_irq(&mhi_cntrl->pm_lock);
+       mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
        mhi_cntrl->pm_state = MHI_PM_POR;
        mhi_cntrl->ee = MHI_EE_MAX;
        current_ee = mhi_get_exec_env(mhi_cntrl);
@@ -1094,9 +1096,6 @@ int mhi_async_power_up(struct mhi_controller *mhi_cntrl)
        if (ret)
                goto error_setup_irq;
 
-       /* Setup BHI INTVEC */
-       mhi_write_reg(mhi_cntrl, mhi_cntrl->bhi, BHI_INTVEC, 0);
-
        /* Transition to next state */
        next_state = MHI_IN_PBL(current_ee) ?
                DEV_ST_TRANSITION_PBL : DEV_ST_TRANSITION_READY;

Thanks,
Mani

> Thanks,
> Mani
> 
> > The patch that was working very reliably (100%) for me was the "bus:
> > mhi: Register IRQ handler after SYS_ERR check during power up" one,
> > which you attached here:
> > https://www.spinics.net/lists/linux-arm-msm/msg97646.html
> > 
> > -- 
> > Aleksander
> > https://aleksander.es
