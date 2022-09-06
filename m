Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51435AE7B4
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbiIFMTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240004AbiIFMSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:18:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7487D78B;
        Tue,  6 Sep 2022 05:16:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCA76614F7;
        Tue,  6 Sep 2022 12:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4934C433D6;
        Tue,  6 Sep 2022 12:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662466540;
        bh=t3ivAoYIWzwSxnOMkaBn6EDK8j50NkdJ/txRgfpguHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nFb+aEN0Gu+7/9//bc5DFbS1uBNf0pakTg1Uk5CWcmh/ZgJEQ/4zVVWeMtKBf8qck
         ivDKlSJeuIedpqKfJlET9iCtN0zUouv4tw4dyXVZqxLfrEr3D93odz7+E9iesc0pK5
         YPcTqb0dxJ7gf6pr0Bis82tX5oZGjsvUSDznWVqI=
Date:   Tue, 6 Sep 2022 14:15:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH stable-5.15 2/3] usb: dwc3: qcom: fix use-after-free on
 runtime-PM wakeup
Message-ID: <Yxc56WhsflGnwuMg@kroah.com>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-3-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906120702.19219-3-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 02:07:01PM +0200, Johan Hovold wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> commit  a872ab303d5ddd4c965f9cd868677781a33ce35a upstream.
> 
> The Qualcomm dwc3 runtime-PM implementation checks the xhci
> platform-device pointer in the wakeup-interrupt handler to determine
> whether the controller is in host mode and if so triggers a resume.
> 
> After a role switch in OTG mode the xhci platform-device would have been
> freed and the next wakeup from runtime suspend would access the freed
> memory.
> 
> Note that role switching is executed from a freezable workqueue, which
> guarantees that the pointer is stable during suspend.
> 
> Also note that runtime PM has been broken since commit 2664deb09306
> ("usb: dwc3: qcom: Honor wakeup enabled/disabled state"), which
> incidentally also prevents this issue from being triggered.
> 
> Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
> Cc: stable@vger.kernel.org      # 4.18
> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220804151001.23612-5-johan+linaro@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [ johan: adjust context for 5.15 ]
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/usb/dwc3/dwc3-qcom.c | 14 +++++++++++++-
>  drivers/usb/dwc3/host.c      |  1 +
>  2 files changed, 14 insertions(+), 1 deletion(-)

This one did not apply to 5.4.y or 4.19.y :(

