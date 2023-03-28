Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4AD6CBA9F
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 11:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232590AbjC1J2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 05:28:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbjC1J2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 05:28:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDEB5FCD;
        Tue, 28 Mar 2023 02:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04243B81BC1;
        Tue, 28 Mar 2023 09:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BEEC433EF;
        Tue, 28 Mar 2023 09:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679995700;
        bh=G65V8ZSmWgqOfTfYMpsqw0YM7nxoxWjuZLzADzcJo/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VPUrkLqTCdFVVTpAeaasOlU4oK1zTntK6p1/CB8wgSTbpEN9dKQiSBoDwODlTt3Vu
         nYqHKWNYL0YuKokuPpEUe3rILAK3I4iiNO9HK4pxxoRmv0lbeg74UFPD5XaYwfnatg
         PA5xR00B1bkmYiUobcyB9A6SnPQh7T1vnVWNWE1wuXqHftDa6xwWot0v6ZYLKARNV2
         I4yl6cvqIapGLj5xEWhHVB4mGPKBGc3h1MD4CXIjEMsJMdCg4aEH0jMlRTNI12dJ95
         tUJA5mD0Or4s9buLcHXFtN/x5/RaNd2kMjehm/3OiSC1yuMUb0r2fqeLBSe/feNGWE
         8x0E0RGstg6IA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ph5d2-0004Hy-Ji; Tue, 28 Mar 2023 11:28:32 +0200
Date:   Tue, 28 Mar 2023 11:28:32 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     andersson@kernel.org, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, mathias.nyman@intel.com,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4/5] usb: dwc3: qcom: Clear pending interrupt before
 enabling wake interrupt
Message-ID: <ZCKzQA1YhXQ/6n3L@hovoldconsulting.com>
References: <20230325165217.31069-1-manivannan.sadhasivam@linaro.org>
 <20230325165217.31069-5-manivannan.sadhasivam@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325165217.31069-5-manivannan.sadhasivam@linaro.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 25, 2023 at 10:22:16PM +0530, Manivannan Sadhasivam wrote:
> It is possible that there may be a pending interrupt logged into the dwc IP
> while the interrupts were disabled in the driver. And when the wakeup
> interrupt is enabled, the pending interrupt might fire which is not
> required to be serviced by the driver.
> 
> So always clear the pending interrupt before enabling wake interrupt.
> 
> Cc: stable@vger.kernel.org # 5.20
> Fixes: 360e8230516d ("usb: dwc3: qcom: Add helper functions to enable,disable wake irqs")
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
>  drivers/usb/dwc3/dwc3-qcom.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
> index bbf67f705d0d..f1059dfcb0e8 100644
> --- a/drivers/usb/dwc3/dwc3-qcom.c
> +++ b/drivers/usb/dwc3/dwc3-qcom.c
> @@ -346,6 +346,8 @@ static void dwc3_qcom_enable_wakeup_irq(int irq, unsigned int polarity)
>  	if (!irq)
>  		return;
>  
> +	irq_set_irqchip_state(irq, IRQCHIP_STATE_PENDING, 0);
> +

This looks like a hack (and a layering violation). Note that there are
no other non-irqchip drivers calling this function.

>  	if (polarity)
>  		irq_set_irq_type(irq, polarity);

Johan
