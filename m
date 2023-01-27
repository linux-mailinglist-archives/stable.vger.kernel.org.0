Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FF767DE79
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 08:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbjA0HZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 02:25:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjA0HZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 02:25:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D56A518E8;
        Thu, 26 Jan 2023 23:25:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1E43B81F83;
        Fri, 27 Jan 2023 07:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A47C433D2;
        Fri, 27 Jan 2023 07:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674804319;
        bh=uiDH1wTvjIHk7fS7H/gr3ugWkoj8lJ2x2AXClUIXcVc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CFSAlYy9Dm+0rzvxNPbzD6Hoget8LchXtUZIKj1/mPZ++3Z9tihvpDIyl37ehs2FF
         my4KMLyXyzqUhN1d/9MBncXqDzA/zsX6yup9N3f1nihtrvHkHeSXaq5jj3ZZGBqW1H
         wifmRiZnQc7yJN1EedhndkIv4M8pRLDRELw5Hsmw=
Date:   Fri, 27 Jan 2023 08:25:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adrian Zaharia <adrian.zaharia@windriver.com>
Cc:     stable@vger.kernel.org, mathias.nyman@intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.10 1/1] xhci: Set HCD flag to defer primary roothub
 registration
Message-ID: <Y9N8XEh6rL/MWP77@kroah.com>
References: <20230125133359.3538078-1-adrian.zaharia@windriver.com>
 <20230125133359.3538078-2-adrian.zaharia@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125133359.3538078-2-adrian.zaharia@windriver.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 25, 2023 at 03:33:59PM +0200, Adrian Zaharia wrote:
> From: Kishon Vijay Abraham I <kishon@ti.com>
> 
> [ Upstream commit b7a4f9b5d0e4b6dd937678c546c0b322dd1a4054 ]
> 
> Set "HCD_FLAG_DEFER_RH_REGISTER" to hcd->flags in xhci_run() to defer
> registering primary roothub in usb_add_hcd() if xhci has two roothubs.
> This will make sure both primary roothub and secondary roothub will be
> registered along with the second HCD.
> This is required for cold plugged USB devices to be detected in certain
> PCIe USB cards (like Inateck USB card connected to AM64 EVM or J7200 EVM).
> 
> This patch has been added and reverted earier as it triggered a race
> in usb device enumeration.
> That race is now fixed in 5.16-rc3, and in stable back to 5.4
> commit 6cca13de26ee ("usb: hub: Fix locking issues with address0_mutex")
> commit 6ae6dc22d2d1 ("usb: hub: Fix usb enumeration issue due to address0
> race")
> 
> [minor rebase change, and commit message update -Mathias]
> 
> CC: stable@vger.kernel.org # 5.4+
> Suggested-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Tested-by: Chris Chiu <chris.chiu@canonical.com>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Link: https://lore.kernel.org/r/20220510091630.16564-3-kishon@ti.com
> Signed-off-by: Adrian Zaharia <Adrian.Zaharia@windriver.com>
> ---
>  drivers/usb/host/xhci.c | 2 ++
>  1 file changed, 2 insertions(+)

You dropped my original signed-off-by?  Odd...

Anyway, now queued up.

greg k-h
