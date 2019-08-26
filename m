Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087919CC37
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 11:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730482AbfHZJIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 05:08:36 -0400
Received: from cloudserver094114.home.pl ([79.96.170.134]:51672 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730398AbfHZJIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 05:08:36 -0400
Received: from 79.184.255.249.ipv4.supernova.orange.pl (79.184.255.249) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.275)
 id 553e23666d31bd2e; Mon, 26 Aug 2019 11:08:33 +0200
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Curtis Malainey <cujomalainey@chromium.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] ACPI / LPSS: Save/restore LPSS private registers also on Lynxpoint
Date:   Mon, 26 Aug 2019 11:08:33 +0200
Message-ID: <2273274.i4Yan65riR@kreacher>
In-Reply-To: <20190822083200.18150-1-jarkko.nikula@linux.intel.com>
References: <20190822083200.18150-1-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thursday, August 22, 2019 10:32:00 AM CEST Jarkko Nikula wrote:
> My assumption in the commit b53548f9d9e4 ("spi: pxa2xx: Remove LPSS private
> register restoring during resume") that Intel Lynxpoint and compatible
> based chipsets may not need LPSS private registers saving and restoring
> over suspend/resume cycle turned out to be false on Intel Broadwell.
> 
> Curtis Malainey sent a patch bringing above change back and reported the
> LPSS SPI Chip Select control was lost over suspend/resume cycle on
> Broadwell machine.
> 
> Instead of reverting above commit lets add LPSS private register
> saving/restoring also for all LPSS SPI, I2C and UART controllers on
> Lynxpoint and compatible chipset to make sure context is not lost in
> case nothing else preserves it like firmware or if LPSS is always on.
> 
> Fixes: b53548f9d9e4 ("spi: pxa2xx: Remove LPSS private register restoring during resume")
> Reported-by: Curtis Malainey <cujomalainey@chromium.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> ---
>  drivers/acpi/acpi_lpss.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index d696f165a50e..60bbc5090abe 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -219,12 +219,13 @@ static void bsw_pwm_setup(struct lpss_private_data *pdata)
>  }
>  
>  static const struct lpss_device_desc lpt_dev_desc = {
> -	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR,
> +	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR
> +			| LPSS_SAVE_CTX,
>  	.prv_offset = 0x800,
>  };
>  
>  static const struct lpss_device_desc lpt_i2c_dev_desc = {
> -	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_LTR,
> +	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_LTR | LPSS_SAVE_CTX,
>  	.prv_offset = 0x800,
>  };
>  
> @@ -236,7 +237,8 @@ static struct property_entry uart_properties[] = {
>  };
>  
>  static const struct lpss_device_desc lpt_uart_dev_desc = {
> -	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR,
> +	.flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR
> +			| LPSS_SAVE_CTX,
>  	.clk_con_id = "baudclk",
>  	.prv_offset = 0x800,
>  	.setup = lpss_uart_setup,
> 

Applied, thanks!




