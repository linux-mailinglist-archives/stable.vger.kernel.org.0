Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32690645916
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 12:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiLGLeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 06:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLGLeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 06:34:02 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1174FBF59;
        Wed,  7 Dec 2022 03:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670412842; x=1701948842;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=C1dF2Zq2kxySe5YwoU7Zscer4blAdIuOMHgGu059vG4=;
  b=Q0wFlbPOr9i+uJn3AeH41LJ+KmpV2MKBiX4b6s+ajXNRSAed79N80RRC
   DiNRQMaCGuPG19p3Agg2Lo59pEHavQgqvxCobK2R6qFzDr4QGkpI0Erz5
   G1ld8kxH76nO86BlzGF9veqHdxovLHmn1R6QmSEWurBecHT/WGeLx5lkO
   AmNSS2TZyJP/MpQHkpwLTyjXeKmEmuFotNpEfYkVMNi+xVwh6szpeVrta
   xMBdArySoT/n9SJMiq0bXbEr5BGjN7g5g6mfR7oYEEOfxYo3tnCiGYcsZ
   RIOg/PhJx8P726XeeW0IIxcJZah4Yd3glfUFfpcjjGBEmbUJ/xUf3/u23
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="379036530"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="379036530"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 03:34:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="788862106"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="788862106"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 07 Dec 2022 03:33:57 -0800
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Wed, 07 Dec 2022 13:33:56 +0200
Date:   Wed, 7 Dec 2022 13:33:56 +0200
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Ferry Toth <ftoth@exalondelft.nl>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id
 timeout
Message-ID: <Y5B6JB6C+K1FdLk9@kuha.fi.intel.com>
References: <20221205201527.13525-1-ftoth@exalondelft.nl>
 <20221205201527.13525-2-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205201527.13525-2-ftoth@exalondelft.nl>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 05, 2022 at 09:15:26PM +0100, Ferry Toth wrote:
> Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral
> if extcon is present") Dual Role support on Intel Merrifield platform
> broke due to rearranging the call to dwc3_get_extcon().
> 
> It appears to be caused by ulpi_read_id() on the first test write failing
> with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
> DT when the test write fails and returns 0 in that case, even if DT does not
> provide the phy. As a result usb probe completes without phy.
> 
> Make ulpi_read_id() return -ETIMEDOUT to its user if the first test write
> fails. The user should then handle it appropriately. A follow up patch
> will make dwc3_core_init() set -EPROBE_DEFER in this case and bail out.
> 
> Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>

Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

> ---
>  drivers/usb/common/ulpi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
> index d7c8461976ce..60e8174686a1 100644
> --- a/drivers/usb/common/ulpi.c
> +++ b/drivers/usb/common/ulpi.c
> @@ -207,7 +207,7 @@ static int ulpi_read_id(struct ulpi *ulpi)
>  	/* Test the interface */
>  	ret = ulpi_write(ulpi, ULPI_SCRATCH, 0xaa);
>  	if (ret < 0)
> -		goto err;
> +		return ret;
>  
>  	ret = ulpi_read(ulpi, ULPI_SCRATCH);
>  	if (ret < 0)

thanks,

-- 
heikki
