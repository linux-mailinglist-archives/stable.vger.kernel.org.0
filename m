Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FFD5AE7B0
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbiIFMTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240081AbiIFMS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:18:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23C47D7A8;
        Tue,  6 Sep 2022 05:16:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 938B0614E1;
        Tue,  6 Sep 2022 12:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7940C433C1;
        Tue,  6 Sep 2022 12:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662466587;
        bh=xHc94Rc0HMe+8iekdjHOaPqGhryHGchHu4jOG+Pxxz0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mdb4fCh5EaY1pRPyoc5cihtxJ3lK7vG/a4usrsPskGMdZLGYN2XB7sdyShrF45mfi
         qLlHYcnrT55oWCvhRX5RPvkJG9pjZhl4OtcKz7WOED20RLDGCZrKAssGUvHkJSpLNg
         KGSrvpxUiOhmi5uioYnWvn0OXXZV65x0jAFLVOLY=
Date:   Tue, 6 Sep 2022 14:16:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH stable-5.15 1/3] usb: dwc3: fix PHY disable sequence
Message-ID: <Yxc6GMzOrz1k1c2D@kroah.com>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-2-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906120702.19219-2-johan@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 02:07:00PM +0200, Johan Hovold wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> commit d2ac7bef95c9ead307801ccb6cb6dfbeb14247bf upstream.
> 
> Generic PHYs must be powered-off before they can be tore down.
> 
> Similarly, suspending legacy PHYs after having powered them off makes no
> sense.
> 
> Fix the dwc3_core_exit() (e.g. called during suspend) and open-coded
> dwc3_probe() error-path sequences that got this wrong.
> 
> Note that this makes dwc3_core_exit() match the dwc3_core_init() error
> path with respect to powering off the PHYs.
> 
> Fixes: 03c1fd622f72 ("usb: dwc3: core: add phy cleanup for probe error handling")
> Fixes: c499ff71ff2a ("usb: dwc3: core: re-factor init and exit paths")
> Cc: stable@vger.kernel.org      # 4.8
> Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
> Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220804151001.23612-2-johan+linaro@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> [ johan: adjust context to 5.15 ]
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/usb/dwc3/core.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)

This one did not apply to 4.9.y, 4.14.y, or 4.19.y :(
