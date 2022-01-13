Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A0048DA2A
	for <lists+stable@lfdr.de>; Thu, 13 Jan 2022 15:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbiAMOwC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jan 2022 09:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiAMOwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jan 2022 09:52:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7427C06161C
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 06:52:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94D19B822B9
        for <stable@vger.kernel.org>; Thu, 13 Jan 2022 14:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C12C36AEB;
        Thu, 13 Jan 2022 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642085519;
        bh=J8yN7+ok4Kw+defBQxQGi7lmR2mJFUHHb/qK0PISew0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tFzxXPZXM++PdVNoACYyTSe7N7AT2FoqGTldlsdOuUyb4LMv27njPtR8WrwLaxk1K
         2rnrhtrzl5uOV8g9amlP2ZYJ6lS+u8F/6MpQgOd7fGOraunPhoOgdCyNb4xUEv2Fhi
         +htNZ8asNfFtAdOav36RQt2NktURLCj+PcXMHhvE=
Date:   Thu, 13 Jan 2022 15:51:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: [PATCH][BACKPORT] mfd: intel-lpss-pci: Fix clock speed for 38a8
 UART
Message-ID: <YeA8jN1XMGHJHGeo@kroah.com>
References: <BCA770B8-D7E8-4810-A7CD-FE178C550209@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BCA770B8-D7E8-4810-A7CD-FE178C550209@live.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 01:37:42PM +0000, Aditya Garg wrote:
> The following patch was proposed as a fix for 5.16 when it was in beta stage but still hasn't been applied to stable 5.16 yet. Thus I am sending it to queue up
> 
> commit 9651cf2cb14726c785240e9dc01b274a68e9959e upstream
> 
> From: Orlando Chamberlain <redecorating@protonmail.com>
> 
> This device is found in the MacBookPro16,2, and as the MacBookPro16,1 is
> from the same generation of MacBooks and has a UART with bxt_uart_info,
> it was incorrectly assumed that the MacBookPro16,2's UART would have the
> same info.
> 
> This led to the wrong clock speed being used, and the Bluetooth
> controller exposed by the UART receiving and sending random data, which
> was incorrectly assumed to be an issue with the Bluetooth stuff, not an
> error with the UART side of things.
> 
> Changing the info to spt_uart_info changes the clock speed and makes it
> send and receive data correctly.
> 
> Fixes: ddb1ada ("mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N UART")
> Signed-off-by: Orlando Chamberlain <redecorating@protonmail.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Link: https://lore.kernel.org/r/20211124091846.11114-1-redecorating@protonmail.com
> ---
>  drivers/mfd/intel-lpss-pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/intel-lpss-pci.c b/drivers/mfd/intel-lpss-pci.c
> index 9700e5acd0cd2d..a59aa147959b3e 100644
> --- a/drivers/mfd/intel-lpss-pci.c
> +++ b/drivers/mfd/intel-lpss-pci.c
> @@ -254,7 +254,7 @@ static const struct pci_device_id intel_lpss_pci_ids[] = {
>  	{ PCI_VDEVICE(INTEL, 0x34eb), (kernel_ulong_t)&bxt_i2c_info },
>  	{ PCI_VDEVICE(INTEL, 0x34fb), (kernel_ulong_t)&spt_info },
>  	/* ICL-N */
> -	{ PCI_VDEVICE(INTEL, 0x38a8), (kernel_ulong_t)&bxt_uart_info },
> +	{ PCI_VDEVICE(INTEL, 0x38a8), (kernel_ulong_t)&spt_uart_info },
>  	/* TGL-H */
>  	{ PCI_VDEVICE(INTEL, 0x43a7), (kernel_ulong_t)&bxt_uart_info },
>  	{ PCI_VDEVICE(INTEL, 0x43a8), (kernel_ulong_t)&bxt_uart_info },

Now queued up, thanks.

greg k-h
