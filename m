Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD1B66E267
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 16:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjAQPi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 10:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbjAQPhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 10:37:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA7842DF1;
        Tue, 17 Jan 2023 07:37:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8364D61383;
        Tue, 17 Jan 2023 15:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90933C433D2;
        Tue, 17 Jan 2023 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673969818;
        bh=Ym8e7FIe6tH7gKvaylNN8lkU9N6amKylR3EYcDnWvGM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c5bw1jY6ZeGtsOG69qX0kcKjMJfPYRWQekDfTGbmqCKdlnBNZff3a5/h9/CKLT6kJ
         xNhpOtHoSP6nkY2d51SrHRZy0zpgSYDwwcEYfmrPIma0gjnXaYwqgcIirlX0WnaUJr
         Ad7LQwy7rdYAWcyFNnbDwggpNSaMi1LkLHUwzj8s=
Date:   Tue, 17 Jan 2023 16:36:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Juhyung Park <qkrwngud825@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu, zenghongling@kylinos.cn,
        zhongling0719@126.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb-storage: apply IGNORE_UAS only for HIKSEMI MD202
 on RTL9210
Message-ID: <Y8bAmH+zRBThjwSJ@kroah.com>
References: <20230117085154.123301-1-qkrwngud825@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117085154.123301-1-qkrwngud825@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 17, 2023 at 05:51:54PM +0900, Juhyung Park wrote:
> The commit e00b488e813f ("usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS")
> blacklists UAS for all of RTL9210 enclosures.
> 
> The RTL9210 controller was advertised with UAS since its release back in
> 2019 and was shipped with a lot of enclosure products with different
> firmware combinations.
> 
> Blacklist UAS only for HIKSEMI MD202.
> 
> This should hopefully be replaced with more robust method than just
> comparing strings.  But with limited information [1] provided thus far
> (dmesg when the device is plugged in, which includes manufacturer and
> product, but no lsusb -v to compare against), this is the best we can do
> for now.
> 
> [1] https://lore.kernel.org/all/20230109115550.71688-1-qkrwngud825@gmail.com
> 
> Fixes: e00b488e813f ("usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS")
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Hongling Zeng <zenghongling@kylinos.cn>
> Cc: stable@vger.kernel.org
> Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
> ---
>  drivers/usb/storage/uas-detect.h  | 13 +++++++++++++
>  drivers/usb/storage/unusual_uas.h |  7 -------
>  2 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
> index 3f720faa6f97..d73282c0ec50 100644
> --- a/drivers/usb/storage/uas-detect.h
> +++ b/drivers/usb/storage/uas-detect.h
> @@ -116,6 +116,19 @@ static int uas_use_uas_driver(struct usb_interface *intf,
>  	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2)
>  		flags |= US_FL_NO_ATA_1X;
>  
> +	/*
> +	 * RTL9210-based enclosure from HIKSEMI, MD202 reportedly have issues
> +	 * with UAS.  This isn't distinguishable with just idVendor and
> +	 * idProduct, use manufacturer and product too.
> +	 *
> +	 * Reported-by: Hongling Zeng <zenghongling@kylinos.cn>
> +	 */
> +	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bda &&
> +			le16_to_cpu(udev->descriptor.idProduct) == 0x9210 &&
> +			(udev->manufacturer && !strcmp(udev->manufacturer, "HIKSEMI")) &&
> +			(udev->product && !strcmp(udev->product, "MD202")))
> +		flags |= US_FL_IGNORE_UAS;
> +
>  	usb_stor_adjust_quirks(udev, &flags);
>  
>  	if (flags & US_FL_IGNORE_UAS) {
> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
> index 251778d14e2d..c7b763d6d102 100644
> --- a/drivers/usb/storage/unusual_uas.h
> +++ b/drivers/usb/storage/unusual_uas.h
> @@ -83,13 +83,6 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x9999,
>  		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
>  		US_FL_NO_REPORT_LUNS),
>  
> -/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
> -UNUSUAL_DEV(0x0bda, 0x9210, 0x0000, 0x9999,
> -		"Hiksemi",
> -		"External HDD",
> -		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> -		US_FL_IGNORE_UAS),
> -
>  /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
>  UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
>  		"Initio Corporation",
> -- 
> 2.39.0
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/process/submitting-patches.rst for what
  needs to be done here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
