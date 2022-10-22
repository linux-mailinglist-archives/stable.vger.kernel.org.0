Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E624B608CCF
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJVLkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiJVLjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:39:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558A22D6550;
        Sat, 22 Oct 2022 04:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C13AB82E91;
        Sat, 22 Oct 2022 11:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F102C433C1;
        Sat, 22 Oct 2022 11:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666438287;
        bh=gJM4FsXoaL46Ah5Eq5TPpdg9dGEJvgLo7J84Ore65Vc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hMW8cZlGE2SdAA98MWMuLTxzvSbxWpx/2Qc+FsbJzfw9r3FmMTN5jwkXEEYSrPpj7
         wGa7FpTen6dJTInpw4MZOY2EBMyXpS3c+926WZ/NUpoReqdxVHMI0xnBmEV+3J+dvg
         Z7op0fvELJERW29oKSNyIv2Rf8WCKzX95TY721PI=
Date:   Sat, 22 Oct 2022 13:31:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Dan Vacura <w36195@motorola.com>
Cc:     linux-usb@vger.kernel.org,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>, stable@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Message-ID: <Y1PUjO99fcgaN0tc@kroah.com>
References: <20221018215044.765044-1-w36195@motorola.com>
 <20221018215044.765044-3-w36195@motorola.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018215044.765044-3-w36195@motorola.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 18, 2022 at 04:50:38PM -0500, Dan Vacura wrote:
> From: Jeff Vanhoof <qjv001@motorola.com>
> 
> arm-smmu related crashes seen after a Missed ISOC interrupt when
> no_interrupt=1 is used. This can happen if the hardware is still using
> the data associated with a TRB after the usb_request's ->complete call
> has been made.  Instead of immediately releasing a request when a Missed
> ISOC interrupt has occurred, this change will add logic to cancel the
> request instead where it will eventually be released when the
> END_TRANSFER command has completed. This logic is similar to some of the
> cleanup done in dwc3_gadget_ep_dequeue.
> 
> Fixes: 6d8a019614f3 ("usb: dwc3: gadget: check for Missed Isoc from event status")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jeff Vanhoof <qjv001@motorola.com>
> Co-developed-by: Dan Vacura <w36195@motorola.com>
> Signed-off-by: Dan Vacura <w36195@motorola.com>
> ---
> V1 -> V3:
> - no change, new patch in series
> V3 -> V4:
> - no change

I need an ack from the dwc3 maintainer before I can take this one.

thanks,

greg k-h
