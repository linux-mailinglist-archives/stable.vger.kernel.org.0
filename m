Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BFE4A31F3
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 21:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353182AbiA2Uzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 15:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353175AbiA2Uzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 15:55:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A8AEC061714;
        Sat, 29 Jan 2022 12:55:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05870B827EE;
        Sat, 29 Jan 2022 20:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70799C340E5;
        Sat, 29 Jan 2022 20:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643489747;
        bh=G7QA3HwNNoYI9kiXeIfPQ93Sb/zPUzr5kXx1E0dhgLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R9PVyqGbtp/xs8vsBE3u0q9gmCJ488CGR5zUh2kI8qdeNPDDYneJF94TUBGZGKhjO
         Cn/kEky5r6evcFCypJgBkw99FwyKJZUiP4lopntkzptCQOsknAUPbDATSGUImfkkFg
         JCPQtvXt9LOCcKe3w8kWJkQSncE6zM5MhtbE/S+Ij8yuQ37C/u/11PgC0QJ1uAwOdE
         Q7TtApBV37o57nA5QjGANyg/Sjs0qRXXJxBVDB3+BZLjC70QyEAwumkzZg558r+BkA
         0h2Pkt9faxJSTCj4rvFH4MiTQahUtx4/LC/G2oriVEF5MJu/RjNEppzoGDj2Xg5fE5
         o/uTghvVAhYHw==
Date:   Sat, 29 Jan 2022 13:55:42 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     linux-usb@vger.kernel.org, balbi@kernel.org,
        gregkh@linuxfoundation.org, michal.simek@xilinx.com,
        manish.narani@xilinx.com, sean.anderson@seco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        piyush.mehta@xilinx.com, stable@vger.kernel.org
Subject: Re: [PATCH] usb: dwc3: xilinx: fix uninitialized return value
Message-ID: <YfWpznEA95bH1Bvg@dev-arch.archlinux-ax161>
References: <20220127221500.177021-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127221500.177021-1-robert.hancock@calian.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 04:15:00PM -0600, Robert Hancock wrote:
> A previous patch to skip part of the initialization when a USB3 PHY was
> not present could result in the return value being uninitialized in that
> case, causing spurious probe failures. Initialize ret to 0 to avoid this.
> 
> Fixes: 9678f3361afc ("usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0 mode")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

This resolves a clang warning that is now in mainline:

$ make -sj"$(nproc)" ARCH=arm64 LLVM=1 allmodconfig drivers/usb/dwc3/dwc3-xilinx.o
drivers/usb/dwc3/dwc3-xilinx.c:122:6: error: variable 'ret' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
        if (!usb3_phy)
            ^~~~~~~~~
drivers/usb/dwc3/dwc3-xilinx.c:216:9: note: uninitialized use occurs here
        return ret;
               ^~~
drivers/usb/dwc3/dwc3-xilinx.c:122:2: note: remove the 'if' if its condition is always false
        if (!usb3_phy)
        ^~~~~~~~~~~~~~
drivers/usb/dwc3/dwc3-xilinx.c:102:11: note: initialize the variable 'ret' to silence this warning
        int                     ret;
                                   ^
                                    = 0
1 error generated.

It might be worth moving the initialization into the if statement

    if (!usb3_phy) {
        ret = 0;
        goto skip_usb3_phy;
    }

as that will avoid hiding warnings of this nature if someone forgets to
set ret on an error path but that is ultimately up to the maintainer.

> ---
>  drivers/usb/dwc3/dwc3-xilinx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc3/dwc3-xilinx.c b/drivers/usb/dwc3/dwc3-xilinx.c
> index e14ac15e24c3..a6f3a9b38789 100644
> --- a/drivers/usb/dwc3/dwc3-xilinx.c
> +++ b/drivers/usb/dwc3/dwc3-xilinx.c
> @@ -99,7 +99,7 @@ static int dwc3_xlnx_init_zynqmp(struct dwc3_xlnx *priv_data)
>  	struct device		*dev = priv_data->dev;
>  	struct reset_control	*crst, *hibrst, *apbrst;
>  	struct phy		*usb3_phy;
> -	int			ret;
> +	int			ret = 0;
>  	u32			reg;
>  
>  	usb3_phy = devm_phy_optional_get(dev, "usb3-phy");
> -- 
> 2.31.1
> 
> 
