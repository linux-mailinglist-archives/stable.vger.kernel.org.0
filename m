Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B38174AA875
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 12:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376676AbiBELxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 06:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358916AbiBELx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 06:53:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEDBC061347;
        Sat,  5 Feb 2022 03:53:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CFF460C8E;
        Sat,  5 Feb 2022 11:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDF1C340E8;
        Sat,  5 Feb 2022 11:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644062007;
        bh=lUBbvL5wH7PnC+Gd4WGcambxq9nvtgxEqvEU6mzfiRo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bhK7ZDiqSab8DUUIr/SuKZlRlf3Apz37KIjRYW5ESXygnA1T0E43ssRgZ5oS8jDVy
         fHty8+NsYap5H0Zd3LnvjrPWKJ3lzbeZGnt6gYrVB3f+QTmCnfocYQvJf6oJNCE7nB
         gHo2Js3WCg6ZXbimc4OenCAYUOfWqV9zA4w2F/7U=
Date:   Sat, 5 Feb 2022 12:53:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Stapelberg <michael+drm@stapelberg.ch>,
        Maxime Ripard <maxime@cerno.tech>
Subject: Re: [PATCH 5.10 12/25] drm/vc4: hdmi: Make sure the device is
 powered with CEC
Message-ID: <Yf5lNIJnvhP4ajam@kroah.com>
References: <20220204091914.280602669@linuxfoundation.org>
 <20220204091914.688259001@linuxfoundation.org>
 <91a59ee1-cca4-8d0c-4f86-388434eb5a39@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91a59ee1-cca4-8d0c-4f86-388434eb5a39@ispras.ru>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 05, 2022 at 02:40:37PM +0300, Alexey Khoroshilov wrote:
> On 04.02.2022 12:20, Greg Kroah-Hartman wrote:
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
> >  drivers/gpu/drm/vc4/vc4_hdmi.c |   27 ++++++++++++++-------------
> >  1 file changed, 14 insertions(+), 13 deletions(-)
> > 
> > --- a/drivers/gpu/drm/vc4/vc4_hdmi.c
> > +++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
> > @@ -1402,18 +1402,18 @@ static int vc4_hdmi_cec_adap_enable(stru
> >  	u32 val;
> >  	int ret;
> >  
> > -	ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
> > -	if (ret)
> > -		return ret;
> > -
> > -	val = HDMI_READ(HDMI_CEC_CNTRL_5);
> > -	val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
> > -		 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
> > -		 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
> > -	val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
> > -	       ((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
> > -
> >  	if (enable) {
> > +		ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
> > +		if (ret)
> > +			return ret;
> > +
> > +		val = HDMI_READ(HDMI_CEC_CNTRL_5);
> > +		val &= ~(VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET |
> > +			 VC4_HDMI_CEC_CNT_TO_4700_US_MASK |
> > +			 VC4_HDMI_CEC_CNT_TO_4500_US_MASK);
> > +		val |= ((4700 / usecs) << VC4_HDMI_CEC_CNT_TO_4700_US_SHIFT) |
> > +			((4500 / usecs) << VC4_HDMI_CEC_CNT_TO_4500_US_SHIFT);
> > +
> >  		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
> >  			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
> >  		HDMI_WRITE(HDMI_CEC_CNTRL_5, val);
> > @@ -1439,7 +1439,10 @@ static int vc4_hdmi_cec_adap_enable(stru
> >  		HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
> >  		HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
> >  			   VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
> > +
> > +		pm_runtime_put(&vc4_hdmi->pdev->dev);
> >  	}
> > +
> >  	return 0;
> >  }
> >  
> > @@ -1531,8 +1534,6 @@ static int vc4_hdmi_cec_init(struct vc4_
> >  	if (ret < 0)
> >  		goto err_delete_cec_adap;
> >  
> > -	pm_runtime_put(&vc4_hdmi->pdev->dev);
> > -
> >  	return 0;
> >  
> >  err_delete_cec_adap:
> > 
> > 
> 
> The patch has moved initialization of val local variable into if
> (enable) branch. But the variable is used in in the else branch as well.
> As a result we write of its initialized value here:
> 
>     HDMI_WRITE(HDMI_CEC_CNTRL_5, val |
>          VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> static
> int vc4_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
> {
>   struct vc4_hdmi *vc4_hdmi = cec_get_drvdata(adap);
>   /* clock period in microseconds */
>   const u32 usecs = 1000000 / CEC_CLOCK_FREQ;
>   u32 val;
>   int ret;
> 
>   if (enable) {
>     ret = pm_runtime_resume_and_get(&vc4_hdmi->pdev->dev);
>     if (ret)
>       return ret;
> 
>     val = HDMI_READ(HDMI_CEC_CNTRL_5);
>     .....
> 
>   } else {
>     HDMI_WRITE(HDMI_CEC_CPU_MASK_SET, VC4_HDMI_CPU_CEC);
>     HDMI_WRITE(HDMI_CEC_CNTRL_5, val |  <------------------ UNINIT VALUE
>          VC4_HDMI_CEC_TX_SW_RESET | VC4_HDMI_CEC_RX_SW_RESET);
> 
>     pm_runtime_put(&vc4_hdmi->pdev->dev);
>   }
> 
>   return 0;
> }

So what does this mean?  That this backport is incorrect and should be
dropped?  Or that the original commit was wrong?  Or something else?

confused,

greg k-h
