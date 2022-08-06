Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2328358B6B4
	for <lists+stable@lfdr.de>; Sat,  6 Aug 2022 18:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiHFQIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Aug 2022 12:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiHFQI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Aug 2022 12:08:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46691FD23;
        Sat,  6 Aug 2022 09:08:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3A7DB806A1;
        Sat,  6 Aug 2022 16:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB0FC433D6;
        Sat,  6 Aug 2022 16:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659802104;
        bh=VvHM1tnPn2qiG36ep1sfWTKbgrKDTPXMkEamR180VL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JqlPvJl+g1rBeO/2KYfyawbbS9B0GTjUk7QBl61IbOesLVetQm6AeXynn3EbIzb0Y
         eRbUSW+ybG6Vc696Mwt+MlGbRNkBSla2AWr4EdR/k15Bh1hZaQbUHJLugzyt6mU/WH
         1//geFEI1Gmm0uPFiCfmNU2hZbmqHCrlEevMxHftngPVnDhsjttlhY37sG0KhT6pZY
         gBdeWV90U8e4D60kW0pjCJRxbRTaphGRSoO+9fm2Vgmi7FI4bKjnGYi3AiFba89iEx
         VT5ulyp+YffanF0hH70vXpy5/4JVdkcJ1y2o//D0kM5I4HEdEcYSeXhxFyw64Dr/ca
         O9WGi83BOHNTg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oKMM7-0003If-Op; Sat, 06 Aug 2022 18:08:51 +0200
Date:   Sat, 6 Aug 2022 18:08:51 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krishna Kurapati <quic_kriskura@quicinc.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>,
        quic_ppratap@quicinc.com, quic_vpulyala@quicinc.com,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 4/9] usb: dwc3: qcom: fix use-after-free on runtime-PM
 wakeup
Message-ID: <Yu6SE1wKXk6/qT9Z@hovoldconsulting.com>
References: <20220804151001.23612-1-johan+linaro@kernel.org>
 <20220804151001.23612-5-johan+linaro@kernel.org>
 <20220806143311.GE14384@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806143311.GE14384@thinkpad>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 06, 2022 at 08:03:11PM +0530, Manivannan Sadhasivam wrote:
> On Thu, Aug 04, 2022 at 05:09:56PM +0200, Johan Hovold wrote:
> > The Qualcomm dwc3 runtime-PM implementation checks the xhci
> > platform-device pointer in the wakeup-interrupt handler to determine
> > whether the controller is in host mode and if so triggers a resume.
> > 
> > After a role switch in OTG mode the xhci platform-device would have been
> > freed and the next wakeup from runtime suspend would access the freed
> > memory.
> > 
> > Note that role switching is executed from a freezable workqueue, which
> > guarantees that the pointer is stable during suspend.
> > 
> > Also note that runtime PM has been broken since commit 2664deb09306
> > ("usb: dwc3: qcom: Honor wakeup enabled/disabled state"), which
> > incidentally also prevents this issue from being triggered.
> > 
> > Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
> > Cc: stable@vger.kernel.org      # 4.18
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> 
> It'd be good to mention the introduction of dwc3_qcom_is_host() function.
> Initially I thought it is used in a single place, but going through the rest of
> the patches reveals that it is used later on.

I think the helper is warranted on its own as it serves as documentation
of the underlying assumptions that this code relies on.

> > +/* Only usable in contexts where the role can not change. */
> > +static bool dwc3_qcom_is_host(struct dwc3_qcom *qcom)
> > +{
> > +	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
> > +
> > +	return dwc->xhci;
> > +}
> > +
> >  static enum usb_device_speed dwc3_qcom_read_usb2_speed(struct dwc3_qcom *qcom)
> >  {
> >  	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
> > @@ -460,7 +468,11 @@ static irqreturn_t qcom_dwc3_resume_irq(int irq, void *data)
> >  	if (qcom->pm_suspended)
> >  		return IRQ_HANDLED;
> >  
> > -	if (dwc->xhci)
> > +	/*
> > +	 * This is safe as role switching is done from a freezable workqueue
> > +	 * and the wakeup interrupts are disabled as part of resume.
> > +	 */
> > +	if (dwc3_qcom_is_host(qcom))
> >  		pm_runtime_resume(&dwc->xhci->dev);
> >  
> >  	return IRQ_HANDLED;
> > diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
> > index f56c30cf151e..f6f13e7f1ba1 100644
> > --- a/drivers/usb/dwc3/host.c
> > +++ b/drivers/usb/dwc3/host.c
> > @@ -135,4 +135,5 @@ int dwc3_host_init(struct dwc3 *dwc)
> >  void dwc3_host_exit(struct dwc3 *dwc)
> >  {
> >  	platform_device_unregister(dwc->xhci);
> > +	dwc->xhci = NULL;
> >  }
> > -- 
> > 2.35.1

Johan
