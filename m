Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0DF8631B9E
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 09:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiKUIhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 03:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbiKUIhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 03:37:36 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A9B120A8;
        Mon, 21 Nov 2022 00:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669019850; x=1700555850;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ONVx5JUDDrdY/F0j8BvBpBwoBCSINvKCjtNVzmScM5k=;
  b=Bq0/coA4qOPVib4ZO7riUzYMGY/rscjOiCa4hhGN4pEq/V0irkwx7tXL
   ul5aBEd8dvYlTywtgCCWJVbq8Q2M8mvE4VDEWCUCz3NsIHpEq2FaM3uwO
   GDMR9xrH9ejlRKULMfSZnUmvakA5e4jNRypxP5/JXfjW/8EcixdPuhrIJ
   BI6BXi/1JiWxMXW7H0miaV/FbVB5lv2FMyH9VFaMlL4xGqqbDLrvrq6fh
   pOaPs4D8QH4BFDvUTZMUmzIaAWN6ZT0KuYrP4EbfubPKjporvniF4Pd6r
   DQEnpNw+jl/81Uayo4NH0vQYNN3JfICDppgds5MIWAkrTnERr5ZtPofdW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="293894511"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="293894511"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 00:37:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="643235256"
X-IronPort-AV: E=Sophos;i="5.96,180,1665471600"; 
   d="scan'208";a="643235256"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007.fm.intel.com with ESMTP; 21 Nov 2022 00:37:14 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ox2Ii-00FBOw-0B;
        Mon, 21 Nov 2022 10:37:12 +0200
Date:   Mon, 21 Nov 2022 10:37:11 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ferry Toth <ftoth@exalondelft.nl>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Ferry Toth <fntoth@gmail.com>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 2/2] usb: dwc3: core: defer probe on ulpi_read_id
 timeout
Message-ID: <Y3s4t2veOe78Emnt@smile.fi.intel.com>
References: <20221120153704.9090-1-ftoth@exalondelft.nl>
 <20221120153704.9090-3-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221120153704.9090-3-ftoth@exalondelft.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 20, 2022 at 04:37:04PM +0100, Ferry Toth wrote:
> Since commit 0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present"),
> Dual Role support on Intel Merrifield platform broke due to rearranging
> the call to dwc3_get_extcon().
> 
> It appears to be caused by ulpi_read_id() masking the timeout on the first
> test write. In the past dwc3 probe continued by calling dwc3_core_soft_reset()
> followed by dwc3_get_extcon() which happend to return -EPROBE_DEFER.
> On deferred probe ulpi_read_id() finally succeeded. Due to above mentioned
> rearranging -EPROBE_DEFER is not returned and probe completes without phy.
> 
> As we now changed ulpi_read_id() to return -ETIMEDOUT in this case, we
> need to handle the error by calling dwc3_core_soft_reset() and request
> -EPROBE_DEFER. On deferred probe ulpi_read_id() is retried and succeeds.
> 
> Fixes: ef6a7bcfb01c ("usb: ulpi: Support device discovery via DT")
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>

Same comments as per patch 1.

But before sending v5, let give a chance to others to review the code and other
aspects of the changes.

-- 
With Best Regards,
Andy Shevchenko


