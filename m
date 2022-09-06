Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E83CE5AE932
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240387AbiIFNOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233870AbiIFNO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:14:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF286EF2F;
        Tue,  6 Sep 2022 06:14:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3920E61525;
        Tue,  6 Sep 2022 13:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20584C433C1;
        Tue,  6 Sep 2022 13:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662470054;
        bh=a9w/Vs65i9eFdgfD56qa1Y3jWZBcc3vZheq7lUkZQ9o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K9jdrn5HcSyF5r41NkgbHhArlyluLufhOGKdZceCxn3tF9wzAbg8cslLV6yZgK5VJ
         s/GVbf2VDh43c9mPo9JicSnsCfxEkszYi6H48UlywUrkEC9nck85HHw6k03v3G8VbZ
         R/6Q5XNKASAlihSOWOGYlrpTv80K78q4j5OM4cig=
Date:   Tue, 6 Sep 2022 15:14:11 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH stable-5.15 1/3] usb: dwc3: fix PHY disable sequence
Message-ID: <YxdHo2JPYhm5GgEr@kroah.com>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-2-johan@kernel.org>
 <Yxc6GMzOrz1k1c2D@kroah.com>
 <Yxc8NclTP8hwmQG9@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxc8NclTP8hwmQG9@hovoldconsulting.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 02:25:25PM +0200, Johan Hovold wrote:
> On Tue, Sep 06, 2022 at 02:16:24PM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Sep 06, 2022 at 02:07:00PM +0200, Johan Hovold wrote:
> > > From: Johan Hovold <johan+linaro@kernel.org>
> > > 
> > > commit d2ac7bef95c9ead307801ccb6cb6dfbeb14247bf upstream.
> > > 
> > > Generic PHYs must be powered-off before they can be tore down.
> > > 
> > > Similarly, suspending legacy PHYs after having powered them off makes no
> > > sense.
> > > 
> > > Fix the dwc3_core_exit() (e.g. called during suspend) and open-coded
> > > dwc3_probe() error-path sequences that got this wrong.
> > > 
> > > Note that this makes dwc3_core_exit() match the dwc3_core_init() error
> > > path with respect to powering off the PHYs.
> > > 
> > > Fixes: 03c1fd622f72 ("usb: dwc3: core: add phy cleanup for probe error handling")
> > > Fixes: c499ff71ff2a ("usb: dwc3: core: re-factor init and exit paths")
> > > Cc: stable@vger.kernel.org      # 4.8
> > > Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
> > > Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> > > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > > Link: https://lore.kernel.org/r/20220804151001.23612-2-johan+linaro@kernel.org
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > [ johan: adjust context to 5.15 ]
> > > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > > ---
> > >  drivers/usb/dwc3/core.c | 19 ++++++++++---------
> > >  1 file changed, 10 insertions(+), 9 deletions(-)
> > 
> > This one did not apply to 4.9.y, 4.14.y, or 4.19.y :(
> 
> Perhaps someone who cares about these old trees can do the backports.
> Should be as trivial. Can't be the patch submitters responsibility to
> maintain 8 stable trees.

I agree!  :)
