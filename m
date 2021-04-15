Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B9736132D
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 21:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbhDOTzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 15:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235015AbhDOTzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 15:55:15 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EDBC061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 12:54:51 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id n138so41177263lfa.3
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 12:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rLBf1OqvMPpoDamrGAI8iET9lQw9NeqxQyOJy7dbwE8=;
        b=JUCX2DMaUPuoPhiBgfRwZsBR7haqz/HPPduE4RP3SZtVW+f9YijK6eb30EdH0YHWUj
         twdR1ifjdAvYz78JNBHEOmhv6uxXilt59U7IeIzKcsC1mDSwCvn6+BkZU2eeR4nXkGwG
         Nc8XLiqh+BK0Q5VA1g1s9h7kGkT5Hy+TDKEim8EPaZV3Ij64icgl3r29cmb5K6kiY3Xr
         nAgosJRfO10Ae04XWxZwIlYgX1kKQLNkiu5xjfxNVJt9Us8Xv+RWb6+Gr0wLWmRjQy6d
         Hl32eY5YIYUmo5AKlET0v5DnI7Yuc2iOiAMmweDS6XpgizB/ltqUqhWkb2d2Wk0voVVv
         o3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rLBf1OqvMPpoDamrGAI8iET9lQw9NeqxQyOJy7dbwE8=;
        b=kd3tFzdK8QAo3MS9W2V6ZcOa+Ak4erU37WMYfVHitM6rp5UEyk2i1a3CCVl+qOEJ0R
         erVm+h/Nox6QsT7y4k0bEdcpFwn4Nid8AbZWVbY0AHl6YozOAQrH3DQ44ON9P5877/ga
         Q/g6fvdzzj9BKdi0mpyiB/QFkZaYNgPxhzzhwUeNWu7aTASh+S6myJ1//erUoyuh542Z
         8FSWh+UJO0MAIAPAD+KTGzB1ffDxYWaRsYVtBbfmfCdJsg9XuJgMd+73rQ12qV5ZIvtN
         A6qiJRJmzAY0S08eZBIHyWu2lBHoXdtsXAk+aFdBlCADfQNETAhwuZ3iXoPvo6nlBDg8
         mK1A==
X-Gm-Message-State: AOAM531OXv9X+ZOnFxWDT/bXbxSaP4d/ODEGPOm6qLZNX/06+qdsqhCt
        EfC3A47izjD9J80MKh/INbe3C1oh/oRQ//Kx6gCw2w==
X-Google-Smtp-Source: ABdhPJygJT8vUoN3dvWj1P4WiMydNIWWRRIbnKyErKIdqNsqu6i36jtMiD92MDO2hQTZL8shmsagICoKuy5fMjXG7Bg=
X-Received: by 2002:a05:6512:3d18:: with SMTP id d24mr507681lfv.204.1618516490281;
 Thu, 15 Apr 2021 12:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
 <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Thu, 15 Apr 2021 12:54:37 -0700
Message-ID: <CALAqxLWkumSzfq1uOTbHdpiYfKOyJoyOosChBb25iyS4RYWP3w@mail.gmail.com>
Subject: Re: [PATCH v2] usb: dwc3: core: Do core softreset when switch mode
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>,
        John Youn <John.Youn@synopsys.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 9:29 AM Thinh Nguyen <Thinh.Nguyen@synopsys.com> wrote:
>
> From: Yu Chen <chenyu56@huawei.com>
> From: John Stultz <john.stultz@linaro.org>
>
> According to the programming guide, to switch mode for DRD controller,
> the driver needs to do the following.
>
> To switch from device to host:
> 1. Reset controller with GCTL.CoreSoftReset
> 2. Set GCTL.PrtCapDir(host mode)
> 3. Reset the host with USBCMD.HCRESET
> 4. Then follow up with the initializing host registers sequence
>
> To switch from host to device:
> 1. Reset controller with GCTL.CoreSoftReset
> 2. Set GCTL.PrtCapDir(device mode)
> 3. Reset the device with DCTL.CSftRst
> 4. Then follow up with the initializing registers sequence
>
> Currently we're missing step 1) to do GCTL.CoreSoftReset and step 3) of
> switching from host to device. John Stult reported a lockup issue seen
> with HiKey960 platform without these steps[1]. Similar issue is observed
> with Ferry's testing platform[2].
>
> So, apply the required steps along with some fixes to Yu Chen's and John
> Stultz's version. The main fixes to their versions are the missing wait
> for clocks synchronization before clearing GCTL.CoreSoftReset and only
> apply DCTL.CSftRst when switching from host to device.
>
> [1] https://lore.kernel.org/linux-usb/20210108015115.27920-1-john.stultz@linaro.org/
> [2] https://lore.kernel.org/linux-usb/0ba7a6ba-e6a7-9cd4-0695-64fc927e01f1@gmail.com/
>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Ferry Toth <fntoth@gmail.com>
> Cc: Wesley Cheng <wcheng@codeaurora.org>
> Cc: <stable@vger.kernel.org>
> Fixes: 41ce1456e1db ("usb: dwc3: core: make dwc3_set_mode() work properly")
> Signed-off-by: Yu Chen <chenyu56@huawei.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
> ---
> Changes in v2:
> - Initialize mutex per device and not as global mutex.
> - Add additional checks for DRD only mode


Hey Thinh!

  Thanks so much for your persisting effort on this issue! Its
something I'd love to see finally resolved!

 >  static void __dwc3_set_mode(struct work_struct *work)
>  {
>         struct dwc3 *dwc = work_to_dwc(work);
>         unsigned long flags;
> +       unsigned int hw_mode;
> +       bool otg_enabled = false;
>         int ret;
>         u32 reg;
>
> +       mutex_lock(&dwc->mutex);
> +
> +       hw_mode = DWC3_GHWPARAMS0_MODE(dwc->hwparams.hwparams0);
> +       if (DWC3_VER_IS_PRIOR(DWC3, 330A) &&
> +           (dwc->hwparams.hwparams6 & DWC3_GHWPARAMS6_SRPSUPPORT))
> +               otg_enabled = true;

Unfortunately on HiKey960, this check ends up being true, and that
basically disables the needed (on HiKey960 at least) soft reset logic
below, so we still end up hitting the issue.

The revision/hwparams6 values on the board are:
  revision: 0x5533300a hwparams6: 0xfeaec20

Just to make sure, I did test disabling the check here, and it does
seem to avoid the !COREIDLE stuck problem seen frequently on the
board.

thanks
-john
