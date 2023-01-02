Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD44F65AF5A
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 11:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjABKKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 05:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjABKKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 05:10:39 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0BCC23;
        Mon,  2 Jan 2023 02:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672654238; x=1704190238;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=miKRm7wTnvdcHLX6wbAeKyrfPnTS+EOoh2y6ahxXPkg=;
  b=mYzaQf1jpmgUCkjKtUA/llQ83kqhhAvA2jNXl3J4DuqHoaBEv5hrBpR8
   35eUnWxq+LpYvlg42zu//3sP4d1/uMzLNAWeOG5hFzpU41MbpnqnJN+cI
   Zv6YTiGSufR5UsH9V1KCnIKpC0AhZi56p/7Aj+DtonYE6+DFEepvhwGVX
   PZQie4q3i5NFtRpdnyZXIMajRdBK5eSc3liokPHxUVTdv6wP4Ff2B7uq2
   m9oyfNByVnJq6QnJIGlmEoqXn6oRMLq6MaiTySt9F1/cPLI7UxSqPQbeS
   oSMoN6F/PGD9OraeQyUMVWVeCYEGB4hdfJVf0Q6UUCmRWg+HXCeBDTP5p
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="319161651"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="319161651"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2023 02:10:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10577"; a="796832274"
X-IronPort-AV: E=Sophos;i="5.96,293,1665471600"; 
   d="scan'208";a="796832274"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 02 Jan 2023 02:10:34 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Mon, 02 Jan 2023 12:10:33 +0200
Date:   Mon, 2 Jan 2023 12:10:33 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Ferry Toth <ftoth@exalondelft.nl>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] Revert "usb: ulpi: defer ulpi_register on
 ulpi_read_id timeout"
Message-ID: <Y7KtmUfLcOloZDPH@kuha.fi.intel.com>
References: <20221222205302.45761-1-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221222205302.45761-1-ftoth@exalondelft.nl>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 09:53:02PM +0100, Ferry Toth wrote:
> This reverts commit 8a7b31d545d3a15f0e6f5984ae16f0ca4fd76aac.
> 
> This patch results in some qemu test failures, specifically xilinx-zynq-a9
> machine and zynq-zc702 as well as zynq-zed devicetree files, when trying
> to boot from USB drive.
> 
> Fixes: 8a7b31d545d3 ("usb: ulpi: defer ulpi_register on ulpi_read_id timeout")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/lkml/20221220194334.GA942039@roeck-us.net/
> Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/common/ulpi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
> index 60e8174686a1..d7c8461976ce 100644
> --- a/drivers/usb/common/ulpi.c
> +++ b/drivers/usb/common/ulpi.c
> @@ -207,7 +207,7 @@ static int ulpi_read_id(struct ulpi *ulpi)
>  	/* Test the interface */
>  	ret = ulpi_write(ulpi, ULPI_SCRATCH, 0xaa);
>  	if (ret < 0)
> -		return ret;
> +		goto err;
>  
>  	ret = ulpi_read(ulpi, ULPI_SCRATCH);
>  	if (ret < 0)
> -- 
> 2.37.2

-- 
heikki
