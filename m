Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797916276A2
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 08:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbiKNHso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 02:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235924AbiKNHsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 02:48:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989A7226;
        Sun, 13 Nov 2022 23:48:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FD71B80D38;
        Mon, 14 Nov 2022 07:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9FDC433C1;
        Mon, 14 Nov 2022 07:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668412119;
        bh=Wty1q4Vw3osxbeKih7YgwVKV3K20oBfY1RvNlNBfyTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XV2xyRy02RLWFX8vCuoAdVTHmGApf/7E3ZgGGyR0QpZUjMZ9OU5Rs/yxQku5rLCSm
         NgjR/XvqkY2RIpsV4MAw9bW/mBhN4UhQOZ4ARfwZKEeQZ9Cuf7IaGJ2ABifeAyHCvL
         XHgFXy8ZYCFk5ip148gjawUVwbBjTaVeUm+kC+i+tXo4IRTZzOUjpewr1hkkM6Tyot
         vYqPMaQ+Zz7gzDW8O/A8Sz6twLufWVt4r9st7jTyeY/qvrip+dqfggYy8+ixuLtuCe
         vVrakk4xzBEGLmmVAUyxzVaOxddw4OyggtHuEK2aoUgQDWTjhA7CRMe2ItBkSD79lH
         dvCFWzY9fCujQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ouUCN-0000oU-6n; Mon, 14 Nov 2022 08:48:07 +0100
Date:   Mon, 14 Nov 2022 08:48:07 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 4/6] phy: qcom-qmp-combo: fix broken power on
Message-ID: <Y3Hyt9xNQEjifDUY@hovoldconsulting.com>
References: <20221111084255.8963-1-johan+linaro@kernel.org>
 <20221111084255.8963-5-johan+linaro@kernel.org>
 <e4a423c6-e92d-1c40-2609-e8512bd9c03c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4a423c6-e92d-1c40-2609-e8512bd9c03c@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 12, 2022 at 09:15:43AM +0300, Dmitry Baryshkov wrote:
> On 11/11/2022 11:42, Johan Hovold wrote:
> > The PHY is powered on during phy-init by setting the SW_PRWDN bit in the
> 
> Nit: SW_PWRDN
> 
> > COM_POWER_DOWN_CTRL register and then setting the same bit in the in the
> > PCS_POWER_DOWN_CONTROL register that belongs to the USB part of the
> > PHY.
> > 
> > Currently, whether power on succeeds depends on probe order and having
> > the USB part of the PHY be initialised first. In case the DP part of the
> > PHY is instead initialised first, the intended power on of the USB block
> > results in a corrupted DP_PHY register (e.g. DP_PHY_AUX_CFG8).
> > 
> > Add a pointer to the USB part of the PHY to the driver data and use that
> > to power on the PHY also if the DP part of the PHY is initialised first.
> > 
> > Fixes: 52e013d0bffa ("phy: qcom-qmp: Add support for DP in USB3+DP combo phy")
> > Cc: stable@vger.kernel.org	# 5.10
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> 
> I can only hope that at some point in your cleanup this hack is going to 
> be removed.
> Nevertheless, I don't see a good way to do this at this moment. Thus:

Not sure why you're calling this a hack. This is how the hardware works
and pretending that this PHY is some kind of MFD with completely
independent components is partly what resulted in this mess.

Accessing the USB registers by means of a hard-coded index in the PHY
array as is done in the runtime PM callbacks is a hack (see patch 5/6),
adding a dedicated pointer is not.

> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

Johan
