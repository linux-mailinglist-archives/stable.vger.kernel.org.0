Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE8985F3E52
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 10:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbiJDI2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 04:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiJDI2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 04:28:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE05D2F655;
        Tue,  4 Oct 2022 01:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664872116; x=1696408116;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e06fu2wt8FsRGyJcqdo5ka5DwLg0aWID/9wQROSahiM=;
  b=O7UNtkIgH+w7VLIOluC8yrLX7LuDYy7bTfQn6hbVhbgNno0E88tCWSvx
   XypXu4/SksobRO9QYFkOyCXQYdi5ELJDUX6Z+xniiw/JEiZfxf3tyj1JP
   /6XkKyUvQmvXISs2h5gEiytbr7vRe4gda3qjjUvbCQnJH60aHAreqh7Xm
   oRxYp7nzFx7CaZavYS/dtyO1N9fJXOPkqRHEcvGsKaxjDuymJt10hYwDZ
   9JgB5ffB8zVKjPtPOKV8Ex7YnPWT5nzpzsj4HqAeYkWfCrQ7JFJrft9AZ
   GX1pkrHaThwsFQc1JV8dmNtkZdYINy0L/q5dfxrAOnIQmBW8/YBmo1637
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="364755539"
X-IronPort-AV: E=Sophos;i="5.93,367,1654585200"; 
   d="scan'208";a="364755539"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2022 01:28:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="657051981"
X-IronPort-AV: E=Sophos;i="5.93,367,1654585200"; 
   d="scan'208";a="657051981"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 04 Oct 2022 01:28:34 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ofdI0-001yGM-2i;
        Tue, 04 Oct 2022 11:28:32 +0300
Date:   Tue, 4 Oct 2022 11:28:32 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>, Ferry Toth <fntoth@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Message-ID: <YzvusOI89ju9e5+0@smile.fi.intel.com>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 09:57:35PM +0000, Thinh Nguyen wrote:
> On Tue, Sep 27, 2022, Andy Shevchenko wrote:
> > This reverts commit 0f01017191384e3962fa31520a9fd9846c3d352f.
> > 
> > As pointed out by Ferry this breaks Dual Role support on
> > Intel Merrifield platforms.
> 
> Can you provide more info than this (any debug info/description)? It
> will be difficult to come back to fix with just this to go on. The
> reverted patch was needed to fix a different issue.

It's already applied, but Ferry probably can provide more info if you describe
step-by-step instructions. (I'm still unable to test this particular type of
features since remove access is always in host mode.)

-- 
With Best Regards,
Andy Shevchenko


