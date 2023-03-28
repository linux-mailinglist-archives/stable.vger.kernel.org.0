Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F5C6CBB36
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 11:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjC1JjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 05:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjC1JjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 05:39:05 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FFA92
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 02:39:03 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id z11so7552049pfh.4
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 02:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679996343;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9xwdE2IE7PNZO4yNNxVXzXNCrW6RVKY2tviFY/6w78Q=;
        b=TSY/B0ZRhgYwqc6csVXym8zms317WIvtdacvoLJ8+7m5Myi18vu+5cFWBAzYGX2Hin
         DB5g33pihRKOQxoLUPq/PLYkPtcQPsbF9Csl5saA1w/pta117XswrEgrFN3gfp2J2kEF
         oR5OKwS4va6jvBx1tfc67nm9h0ckluQGl2yyyTVogDhvXnoq6NM1OZ+ckJ2V42aYqCfG
         0FLpwnDGE6blXnGA8AXBjFVMMuQ+OAg4LL/QwFlQfQ6pSG8jbbwx6SzhvM+Q1sTxVgIM
         8TD1ME8AvReeFWufxfqydo8AWwMOl7T5umd7VYT/e65/abw7ELV0FtJQ/rjqzxyLkwN/
         ciDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679996343;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9xwdE2IE7PNZO4yNNxVXzXNCrW6RVKY2tviFY/6w78Q=;
        b=CDY66/mbHYuhZahF5HOhnt1ySK2MZoHNud5xPksr+KFBFmi3zEsknNwEXjbQPhkq1N
         z0wDOpl40gWxcbDlnyr5d5LEZIZekeNpopSCnexRqb4G6ku/zHvZyDyAOKU1TpH8linE
         Bq/ZxsdrIaYztb3k6nlmycLC7oJf1Jg+PiRVx1a8DdIZkeTTI7YrFhA8NrdjxRx2jm/H
         R77cbIk6o0tFettkvWddXh9aA297r1zK6lOhp5SRm72RVp7LVbOG2Y4HyUraSRND9i0f
         yxd24WZwiyMCSndaSYalNMFQu3qedHEq5N18FfW1SKibTjJJbtZZfZFVtD8HGHgGVZFa
         f5mQ==
X-Gm-Message-State: AAQBX9dlvOkq1Xnm6iXOec0nIncN3VSMZT7i+8Mf7/Lv03tBtwUtfrol
        UiyPPyoErRbccyFxFG2p+InS
X-Google-Smtp-Source: AKy350bHDX3Rrj57zUrO/5RLT7vUI0eFxDpGfCXLQUU0RNc8bm08CmNKN9NMIR+qBrhCc73UDpa1EQ==
X-Received: by 2002:a62:1c57:0:b0:624:f46:7256 with SMTP id c84-20020a621c57000000b006240f467256mr15126001pfc.21.1679996343067;
        Tue, 28 Mar 2023 02:39:03 -0700 (PDT)
Received: from thinkpad ([117.193.212.166])
        by smtp.gmail.com with ESMTPSA id a23-20020a62bd17000000b005a91d570972sm18330448pff.41.2023.03.28.02.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 02:39:02 -0700 (PDT)
Date:   Tue, 28 Mar 2023 15:08:53 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     andersson@kernel.org, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, mathias.nyman@intel.com,
        konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] arm64: dts: qcom: sc8280xp: Add missing dwc3 quirks
Message-ID: <20230328093853.GA5695@thinkpad>
References: <20230325165217.31069-1-manivannan.sadhasivam@linaro.org>
 <20230325165217.31069-2-manivannan.sadhasivam@linaro.org>
 <ZCKrXZn7Eu/jvdpG@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZCKrXZn7Eu/jvdpG@hovoldconsulting.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 10:54:53AM +0200, Johan Hovold wrote:
> On Sat, Mar 25, 2023 at 10:22:13PM +0530, Manivannan Sadhasivam wrote:
> > Add missing quirks for the USB DWC3 IP.
> 
> This is not an acceptable commit message generally and certainly not for
> something that you have tagged for stable.
> 
> At a minimum, you need to describe why these are needed and what the
> impact is.
> 

I can certainly improve the commit message. But usually the quirks are copied
from the downstream devicetree where qualcomm engineers would've added them
based on the platform requirements.

> Also, why are you sending as part of a series purporting to enable
> runtime PM when it appears to be all about optimising specific gadget
> applications?
> 

It's not related to this series I agree but just wanted to group it with a
series touching usb so that it won't get lost.

I could respin it separately though in v2.

> Did you confirm that the below makes any sense or has this just been
> copied verbatim from the vendor devicetree (it looks like that)?
> 

As you've mentioned, most of the quirks are for gadget mode which is not
supported by the upstream supported boards. So I haven't really tested them but
for I assumed that Qcom engineers did.

> The fact that almost none of the qcom SoCs sets these also indicates
> that something is not right here.
> 
> > Cc: stable@vger.kernel.org # 5.20
> > Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
> > Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > ---
> >  arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> > index 0d02599d8867..266a94c712aa 100644
> > --- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> > +++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
> > @@ -3040,6 +3040,13 @@ usb_0_dwc3: usb@a600000 {
> >  				iommus = <&apps_smmu 0x820 0x0>;
> >  				phys = <&usb_0_hsphy>, <&usb_0_qmpphy QMP_USB43DP_USB3_PHY>;
> >  				phy-names = "usb2-phy", "usb3-phy";
> > +				snps,hird-threshold = /bits/ 8 <0x0>;
> > +				snps,usb2-gadget-lpm-disable;
> 
> Here you are disabling LPM for gadget mode, which makes most of the
> other properties entirely pointless.
> 
> > +				snps,is-utmi-l1-suspend;
> > +				snps,dis-u1-entry-quirk;
> > +				snps,dis-u2-entry-quirk;
> 
> These appear to be used to optimise certain gadget application and
> likely not something that should be set in a dtsi.
> 

I will cross check these with Qcom and respin accordingly.

- Mani

> > +				snps,has-lpm-erratum;
> > +				tx-fifo-resize;
> 
> Same here.
> 
> >  				port {
> >  					usb_0_role_switch: endpoint {
> 
> Johan

-- 
மணிவண்ணன் சதாசிவம்
