Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3C55EC6A4
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 16:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiI0Ojb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 10:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbiI0OjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 10:39:00 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B7E57BD2;
        Tue, 27 Sep 2022 07:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664289315; x=1695825315;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=y/fuRhFA5D0txA6uWzJgnt/GJDNmbJfp6bnUuv5kLDA=;
  b=P2CzxDdu7cvHfAsDivZiCJHR99VCAwRM/8DbK5oTwxrYh7QxLKmTQ9Bp
   /sMBSYPCLmHoHkRwWDb1QHSTLek7PoLRFN+EWNhHhCkdFnRtgvu2kW8AN
   b8KyLxeAwmUenX24ZNfUKY30ffk3D8CPg1OmOvZNCfkzmbj1JMQWDHqDD
   06e7d9fWrQLli2z9r7JLiUhjvNifMS9mCHb/gEOD5Xj8lUE+HeIK01j0Z
   DaSOY1PDOK33SnhZCRvNoNBsOT5U70n8GVweGadyClnQbscBLdHnS5ql7
   LB12ecDwjG/cijfb44XOIp2oJ3pf1FRwqMrmp/RTHPnprQW7LYTfdBRXD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="363169234"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="363169234"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 07:35:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="950307697"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="950307697"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga005.fm.intel.com with ESMTP; 27 Sep 2022 07:35:10 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1odBfx-008UCo-1H;
        Tue, 27 Sep 2022 17:35:09 +0300
Date:   Tue, 27 Sep 2022 17:35:09 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jarkko Nikula <jarkko.nikula@linux.intel.com>
Cc:     linux-i2c@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jan Dabros <jsd@semihalf.com>,
        Samuel Clark <slc2015@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] i2c: designware: Fix handling of real but unexpected
 device interrupts
Message-ID: <YzMKHf+aNKiGVkyn@smile.fi.intel.com>
References: <20220927135644.1656369-1-jarkko.nikula@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927135644.1656369-1-jarkko.nikula@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 27, 2022 at 04:56:44PM +0300, Jarkko Nikula wrote:
> Commit c7b79a752871 ("mfd: intel-lpss: Add Intel Alder Lake PCH-S PCI
> IDs") caused a regression on certain Gigabyte motherboards for Intel
> Alder Lake-S where system crashes to NULL pointer dereference in
> i2c_dw_xfer_msg() when system resumes from S3 sleep state ("deep").
> 
> I was able to debug the issue on Gigabyte Z690 AORUS ELITE and made
> following notes:
> 
> - Issue happens when resuming from S3 but not when resuming from
>   "s2idle"
> - PCI device 00:15.0 == i2c_designware.0 is already in D0 state when
>   system enters into pci_pm_resume_noirq() while all other i2c_designware
>   PCI devices are in D3. Devices were runtime suspended and in D3 prior
>   entering into suspend
> - Interrupt comes after pci_pm_resume_noirq() when device interrupts are
>   re-enabled
> - According to register dump the interrupt really comes from the
>   i2c_designware.0. Controller is enabled, I2C target address register
>   points to a one detectable I2C device address 0x60 and the
>   DW_IC_RAW_INTR_STAT register START_DET, STOP_DET, ACTIVITY and
>   TX_EMPTY bits are set indicating completed I2C transaction.
> 
> My guess is that the firmware uses this controller to communicate with
> an on-board I2C device during resume but does not disable the controller
> before giving control to an operating system.
> 
> I was told the UEFI update fixes this but never the less it revealed the
> driver is not ready to handle TX_EMPTY (or RX_FULL) interrupt when device
> is supposed to be idle and state variables are not set (especially the
> dev->msgs pointer which may point to NULL or stale old data).
> 
> Introduce a new software status flag STATUS_ACTIVE indicating when the
> controller is active in driver point of view. Now treat all interrupts
> that occur when is not set as unexpected and mask all interrupts from
> the controller.

...

>  #define STATUS_IDLE			0x0

A side note: I think the clearer is to use STATUS_MASK and use
'&= ~STATUS_MASK' instead of '= STATUS_IDLE' in the affected pieces
of the code.

> -#define STATUS_WRITE_IN_PROGRESS	0x1
> -#define STATUS_READ_IN_PROGRESS		0x2
> +#define STATUS_ACTIVE			0x1
> +#define STATUS_WRITE_IN_PROGRESS	0x2
> +#define STATUS_READ_IN_PROGRESS		0x4

Can we at the same time replace them with BIT()?

...

Otherwise looks good to me,
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


