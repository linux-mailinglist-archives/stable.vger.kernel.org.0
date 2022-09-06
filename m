Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AED5AE81B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiIFM30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240251AbiIFM2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:28:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C608C77;
        Tue,  6 Sep 2022 05:25:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98F2261518;
        Tue,  6 Sep 2022 12:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F237FC433D7;
        Tue,  6 Sep 2022 12:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662467121;
        bh=FVIz9jOcYZovbef6R7ziRzkYDGIwM247D7ae6/vYWLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UVDCbT9WfXM6YFeFbxLTt7scCB/B1HbIkRDQXNdpzQas3y5MwiK5OJhKn1HhqVRij
         e7ZS/k+VZxYZl9Qb639i94Q1drkjC+E+0ozdRZRmBGBQKDrSi0dwZTTyEkUo0lUmtC
         6wby4TpKl2dXSZAB2negF5YuN4pP3bXSu8XneZME3a2Ge5gPDn4SV/nxmdBJ43tpMJ
         1yZB5CZinBgh2yVvcjcRwqxt27FUbm3oStpXkOanMYbtK6sLu00ZsPJQDO5z+lw/gn
         7pSFabp4FtcjwMyLmw5ekHEQmlaF77/ODt3YcqtULiUBcDKOUv9G3hcqbNOWKgwzTq
         jVsd0NfK96Ggw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVXdt-0008BH-3O; Tue, 06 Sep 2022 14:25:25 +0200
Date:   Tue, 6 Sep 2022 14:25:25 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Andrew Halaney <ahalaney@redhat.com>,
        Matthias Kaehlcke <mka@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH stable-5.15 1/3] usb: dwc3: fix PHY disable sequence
Message-ID: <Yxc8NclTP8hwmQG9@hovoldconsulting.com>
References: <20220906120702.19219-1-johan@kernel.org>
 <20220906120702.19219-2-johan@kernel.org>
 <Yxc6GMzOrz1k1c2D@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yxc6GMzOrz1k1c2D@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 02:16:24PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 06, 2022 at 02:07:00PM +0200, Johan Hovold wrote:
> > From: Johan Hovold <johan+linaro@kernel.org>
> > 
> > commit d2ac7bef95c9ead307801ccb6cb6dfbeb14247bf upstream.
> > 
> > Generic PHYs must be powered-off before they can be tore down.
> > 
> > Similarly, suspending legacy PHYs after having powered them off makes no
> > sense.
> > 
> > Fix the dwc3_core_exit() (e.g. called during suspend) and open-coded
> > dwc3_probe() error-path sequences that got this wrong.
> > 
> > Note that this makes dwc3_core_exit() match the dwc3_core_init() error
> > path with respect to powering off the PHYs.
> > 
> > Fixes: 03c1fd622f72 ("usb: dwc3: core: add phy cleanup for probe error handling")
> > Fixes: c499ff71ff2a ("usb: dwc3: core: re-factor init and exit paths")
> > Cc: stable@vger.kernel.org      # 4.8
> > Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
> > Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
> > Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > Link: https://lore.kernel.org/r/20220804151001.23612-2-johan+linaro@kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > [ johan: adjust context to 5.15 ]
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > ---
> >  drivers/usb/dwc3/core.c | 19 ++++++++++---------
> >  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> This one did not apply to 4.9.y, 4.14.y, or 4.19.y :(

Perhaps someone who cares about these old trees can do the backports.
Should be as trivial. Can't be the patch submitters responsibility to
maintain 8 stable trees.

Johan
