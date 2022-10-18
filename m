Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DDB602FED
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 17:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiJRPmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 11:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJRPms (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 11:42:48 -0400
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 18 Oct 2022 08:42:47 PDT
Received: from mail.kmu-office.ch (mail.kmu-office.ch [IPv6:2a02:418:6a02::a2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12355B56D1;
        Tue, 18 Oct 2022 08:42:47 -0700 (PDT)
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 4C1935C37FA;
        Tue, 18 Oct 2022 17:27:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1666106844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2uOD+QzykYc6f3qCbxD8fcI9NlSj4IUhhFS44dLVNg4=;
        b=NQ1uJtnKQIOXwNqU4ER7kMis+tRaERSfU2W5KTy8rRVZ/h/ofCrik4U4nbAgF2fdiaQ1M0
        jZyty46XrHiA0gBnSjqeyoj6COyuVp7bRqXzziZAUnivthYYtrHCTsowkq0NMV8iqivIkS
        lsrpGjXr/vV1ni/P2zd1EZjXRbJBDdU=
MIME-Version: 1.0
Date:   Tue, 18 Oct 2022 17:27:24 +0200
From:   Stefan Agner <stefan@agner.ch>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        stable <stable@kernel.org>, regressions@lists.linux.dev,
        m.szyprowski@samsung.com, krzk@kernel.org
Subject: Re: [PATCH stable-5.15 3/3] usb: dwc3: disable USB core PHY
 management
In-Reply-To: <20220906120702.19219-4-johan@kernel.org>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-4-johan@kernel.org>
Message-ID: <808bdba846bb60456adf10a3016911ee@agner.ch>
X-Sender: stefan@agner.ch
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Johan,

On 2022-09-06 14:07, Johan Hovold wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> commit 6000b8d900cd5f52fbcd0776d0cc396e88c8c2ea upstream.
> 
> The dwc3 driver manages its PHYs itself so the USB core PHY management
> needs to be disabled.
> 
> Use the struct xhci_plat_priv hack added by commits 46034a999c07 ("usb:
> host: xhci-plat: add platform data support") and f768e718911e ("usb:
> host: xhci-plat: add priv quirk for skip PHY initialization") to
> propagate the setting for now.

[adding also Samsung/ODROID device tree authors Krzysztof and Marek]

For some reason, this commit seems to break detection of the USB to
S-ATA controller on ODROID-HC1 devices (Exynos 5422).

We have a known to work OS release of v5.15.60, and known to not be
working of v5.15.67. By reverting suspicious commits, I was able to
pinpoint the problem to this particular commit.

From what I understand, on that particular hardware the S-ATA controller
power is controlled via the V-BUS signal VBUSCTRL_U2 (Schematic [1]).
Presumably this signal is no longer controlled with this change.

This came up in our HAOS issue #2153 [2].

--
Stefan

[1]
https://dn.odroid.com/5422/ODROID-HC1_MC1/Schematics/HC1_MAIN_REV0.1_20170630.pdf
[2] https://github.com/home-assistant/operating-system/issues/2153

> 
> Fixes: 4e88d4c08301 ("usb: add a flag to skip PHY initialization to
> struct usb_hcd")
> Fixes: 178a0bce05cb ("usb: core: hcd: integrate the PHY wrapper into
> the HCD core")
> Tested-by: Matthias Kaehlcke <mka@chromium.org>
> Cc: stable <stable@kernel.org>
> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220825131836.19769-1-johan+linaro@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [ johan: adjust context to 5.15 ]
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/usb/dwc3/host.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
> index 2078e9d70292..85165a972076 100644
> --- a/drivers/usb/dwc3/host.c
> +++ b/drivers/usb/dwc3/host.c
> @@ -10,8 +10,13 @@
>  #include <linux/acpi.h>
>  #include <linux/platform_device.h>
>  
> +#include "../host/xhci-plat.h"
>  #include "core.h"
>  
> +static const struct xhci_plat_priv dwc3_xhci_plat_priv = {
> +	.quirks = XHCI_SKIP_PHY_INIT,
> +};
> +
>  static int dwc3_host_get_irq(struct dwc3 *dwc)
>  {
>  	struct platform_device	*dwc3_pdev = to_platform_device(dwc->dev);
> @@ -87,6 +92,11 @@ int dwc3_host_init(struct dwc3 *dwc)
>  		goto err;
>  	}
>  
> +	ret = platform_device_add_data(xhci, &dwc3_xhci_plat_priv,
> +					sizeof(dwc3_xhci_plat_priv));
> +	if (ret)
> +		goto err;
> +
>  	memset(props, 0, sizeof(struct property_entry) * ARRAY_SIZE(props));
>  
>  	if (dwc->usb3_lpm_capable)
