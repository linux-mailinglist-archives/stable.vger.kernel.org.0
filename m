Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3717C4AAABA
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 18:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379959AbiBER5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 12:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbiBER5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 12:57:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B37EC061348;
        Sat,  5 Feb 2022 09:57:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 066716117C;
        Sat,  5 Feb 2022 17:57:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D06C340E8;
        Sat,  5 Feb 2022 17:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644083819;
        bh=XHleCc2I9PXzpTLVZkgLBwyHF5HnJy1sWBCqxttPtTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZQerPsPpBByi/VM0X95evgE/7JsHe6Pgd68mkYdc10eqCBg+Bz5rV63RCkcUa8y9n
         XRGFfIni8cK94asKO0SNMEGPvsULdqBhV87Ej8KoqV1x4UBWXlhPD8l2MSRKSp2wq7
         h/08CeqzQyHiiHjCnLOzMEctYbiXzJttQuOF7BgM=
Date:   Sat, 5 Feb 2022 18:56:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Stapelberg <michael+drm@stapelberg.ch>,
        Maxime Ripard <maxime@cerno.tech>
Subject: Re: [PATCH 5.15 05/32] drm/vc4: hdmi: Make sure the device is
 powered with CEC
Message-ID: <Yf66Y2/N0nh9tMxT@kroah.com>
References: <20220204091915.247906930@linuxfoundation.org>
 <20220204091915.421812582@linuxfoundation.org>
 <20220205171238.GA3073350@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220205171238.GA3073350@roeck-us.net>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 05, 2022 at 09:12:38AM -0800, Guenter Roeck wrote:
> On Fri, Feb 04, 2022 at 10:22:15AM +0100, Greg Kroah-Hartman wrote:
> > From: Maxime Ripard <maxime@cerno.tech>
> > 
> > Commit 20b0dfa86bef0e80b41b0e5ac38b92f23b6f27f9 upstream.
> > 
> > The original commit depended on a rework commit (724fc856c09e ("drm/vc4:
> > hdmi: Split the CEC disable / enable functions in two")) that
> > (rightfully) didn't reach stable.
> > 
> > However, probably because the context changed, when the patch was
> > applied to stable the pm_runtime_put called got moved to the end of the
> > vc4_hdmi_cec_adap_enable function (that would have become
> > vc4_hdmi_cec_disable with the rework) to vc4_hdmi_cec_init.
> > 
> > This means that at probe time, we now drop our reference to the clocks
> > and power domains and thus end up with a CPU hang when the CPU tries to
> > access registers.
> > 
> > The call to pm_runtime_resume_and_get() is also problematic since the
> > .adap_enable CEC hook is called both to enable and to disable the
> > controller. That means that we'll now call pm_runtime_resume_and_get()
> > at disable time as well, messing with the reference counting.
> > 
> > The behaviour we should have though would be to have
> > pm_runtime_resume_and_get() called when the CEC controller is enabled,
> > and pm_runtime_put when it's disabled.
> > 
> > We need to move things around a bit to behave that way, but it aligns
> > stable with upstream.
> > 
> > Cc: <stable@vger.kernel.org> # 5.10.x
> > Cc: <stable@vger.kernel.org> # 5.15.x
> > Cc: <stable@vger.kernel.org> # 5.16.x
> > Reported-by: Michael Stapelberg <michael+drm@stapelberg.ch>
> > Signed-off-by: Maxime Ripard <maxime@cerno.tech>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/gpu/drm/vc4/vc4_hdmi.c |   25 +++++++++++++------------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> > 
> > --- a/drivers/gpu/drm/vc4/vc4_hdmi.c
> > +++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
> > @@ -1738,18 +1738,18 @@ static int vc4_hdmi_cec_adap_enable(stru
> >  	u32 val;
> >  	int ret;
> >  
> > -	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
> > -	if (ret)
> > -		return ret;
> > +	if (enable) {
> > +		ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
> > +		if (ret)
> > +			return ret;
> >  
> > -	val = HDMI_READ(HDMI_CEC_CNTRL_5);
> > -	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
> > -		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
> > -		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
> > -	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
> > -	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
> > +		val = HDMI_READ(HDMI_CEC_CNTRL_5);
> > +		val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
> > +			 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
> > +			 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
> > +		val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
> > +			((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
> 
> Unfortunately this is broken because it leaves the still existing
> else path with
> 
>                if (!vc4_hdmi->variant->external_irq_controller)
>                         HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
>                 HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
>                            VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
> 
> where 'val' is now uninitialized. I don't know how to fix this up properly,
> so I won't even try.

Yeah, something is really wrong here.  I'm going to go revert this for
now and push out a new set of releases with that fixed.

thanks for the review.

greg k-h
