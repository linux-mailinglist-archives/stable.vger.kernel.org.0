Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBDD3616B3
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 02:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbhDPANG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 20:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbhDPANG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 20:13:06 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636B2C061756
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 17:12:42 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id z8so29090461ljm.12
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 17:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r8GkCrbv/zYPRVaSFtl6H/BFwmBvL0ol3pcK113pi4U=;
        b=mRZhaeKKPrNjSKqWxKsNS+xCLa6R792rtfZKlDYqSBPGlgKe23wDw00iv1/lCtnxV3
         wRYCXySwOTi3vSSq0Zezz8BS7d+zcEWzsLV44l6k+JKacFZRN4PTQumOn3zuo8UdL2MA
         EBM9k31pTC/g7Y/7K0Af+ryb9nkE+yRosWPHUiDwQeHxrm9hG+HWe9MUrIGRRAtVKroB
         0O53v1GmygPxqewZJozQQRg186jYq4V0O3XlM3Pn+H1gqivzLZa5bPm+iCyVqYkQ3GOh
         Undn3Ug3hZ6eX3HmVt9gsJoQJjf8UDwNFC6I1E1z+rkYBHju+8Nf1mFUBI3dLhENvqej
         K+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r8GkCrbv/zYPRVaSFtl6H/BFwmBvL0ol3pcK113pi4U=;
        b=Sm9aUvihQLjak1W/2SAllwDkVNZ7xwXaSLxhIwd7yyIEEivb0GrahcpW23+Y2kVtam
         yq4zsoYXqMCx1HamIt/lvM1goOJ22x4tlhInOqn8osamr/C2g2KetiyjK2L8oYq7z+8i
         w8GflBI2/2brjDIbqkOEkpj/dK9uPTj1wtD2j3HRl+fIZ+dYXrXXFIJn3k5NVUY1KLi7
         O6qib1KfQknxAhqi9SssqBIKHsAUWuycWd92XCyD51kxDY7TdH+us+Cwqvl42J+iZZGS
         Jr/hSDt5k3tGYJUn73PKPZvhhxz6tvTVLTAOsbH1R+HBeboYId7zEQKnT6HTToUgXAlQ
         kLuw==
X-Gm-Message-State: AOAM532DisUWlsF23G+xplk1+ziZ+TIUgSn0GIDw7TbFKmbWeCNWGFrW
        39k7ipi3JGA0JoEOkfZifcWlzMLASO5b8jo2HMwtBA==
X-Google-Smtp-Source: ABdhPJxgTh1PQWkLqJ7g4FXETP5TGGKrGJedsy/dUmG0HnDn0PKcwTcV9ZUN1A2BuC92IvEPYlRwIcb0a0QMukiLM/c=
X-Received: by 2002:a2e:9d88:: with SMTP id c8mr1005964ljj.257.1618531960777;
 Thu, 15 Apr 2021 17:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Thu, 15 Apr 2021 17:12:28 -0700
Message-ID: <CALAqxLW9d-jWC4qyfWvTQAYT-V7W19tFY+v3pzCE_QHfNYeYTg@mail.gmail.com>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 3:20 PM Thinh Nguyen <Thinh.Nguyen@synopsys.com> wrote:
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
> Changes in v3:
> - Check if the desired mode is OTG, then keep the old flow
> - Remove condition for OTG support only since the device can still be
>   configured DRD host/device mode only
> - Remove redundant hw_mode check since __dwc3_set_mode() only applies when
>   hw_mode is DRD
> Changes in v2:
> - Initialize mutex per device and not as global mutex.
> - Add additional checks for DRD only mode
>

I've not been able to test all the different modes on HiKey960 yet,
but with this patch we avoid the !COREIDLE hangs that we see
frequently on bootup, so it looks pretty good to me.  I'll get back to
you tonight when I can put hands on the board to test the gadget to
host switching to make sure all is well (I really don't expect any
issues, but just want to be sure).

thanks
-john
