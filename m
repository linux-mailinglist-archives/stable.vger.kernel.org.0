Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D06627E42
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237434AbiKNMnY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:43:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbiKNMm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:42:57 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701992529B;
        Mon, 14 Nov 2022 04:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668429748; x=1699965748;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zlCVnIAt0eSoa3vWacjfa7YOK1wBDFoeeswj2A/hKh0=;
  b=kyLfCswaSWpycqhGSUKxKc/O8eCXsHsOiySeodRW6ImT66Nz+7BXuUSP
   CMPaYsGSGuDCJh+swc6Nt/RNg3oDga513dOgidSqDmWTJvgILMCYlYjIf
   nXjEJ+IY/ZHTl0ncdL1tzsiZW7Dq0OgkbEVSv7PzIMwEXX3qZv0kkQy1i
   n47VY2MEOAoL1RrxCV9zFrve/4jTfJ0GbzRaTKJ7slmm42FVi38xITQC8
   oHIHBq71DUtLCkQ0u6dGevrElV3s1eRiQK9rUuvneCgIVX3qGOWxxjQuY
   uZ6QW5TH4HQ8ktGb62w4pD3MYo0HltuBL6h6+tgZ2pjXLEENtX0gfuDgX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="398249310"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="398249310"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 04:42:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="813244077"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="813244077"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 14 Nov 2022 04:42:24 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 4929D32E; Mon, 14 Nov 2022 14:42:49 +0200 (EET)
Date:   Mon, 14 Nov 2022 14:42:49 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Wolfram Sang <wsa@kernel.org>,
        Hidenori Kobayashi <hidenorik@chromium.org>,
        stable@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        linux-kernel@vger.kernel.org,
        Hidenori Kobayashi <hidenorik@google.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v6 1/1] i2c: Restore initial power state if probe fails
Message-ID: <Y3I3yYDjbSBHDJtY@black.fi.intel.com>
References: <20221109-i2c-waive-v6-0-bc059fb7e8fa@chromium.org>
 <20221109-i2c-waive-v6-1-bc059fb7e8fa@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109-i2c-waive-v6-1-bc059fb7e8fa@chromium.org>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 14, 2022 at 01:20:34PM +0100, Ricardo Ribalda wrote:
> A driver that supports I2C_DRV_ACPI_WAIVE_D0_PROBE is not expected to
> power off a device that it has not powered on previously.
> 
> For devices operating in "full_power" mode, the first call to
> `i2c_acpi_waive_d0_probe` will return 0, which means that the device
> will be turned on with `dev_pm_domain_attach`.
> 
> If probe fails the second call to `i2c_acpi_waive_d0_probe` will
> return 1, which means that the device will not be turned off.
> This is, it will be left in a different power state. Lets fix it.
> 
> Reviewed-by: Hidenori Kobayashi <hidenorik@chromium.org>
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
