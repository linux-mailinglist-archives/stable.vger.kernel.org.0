Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F0463B1F2
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 20:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbiK1TMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 14:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiK1TMm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 14:12:42 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE5A6164;
        Mon, 28 Nov 2022 11:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669662761; x=1701198761;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tpKVBl91w441Ol1xAG26hVyxvG2xyFS2cEqH3COpaGE=;
  b=Or/KfyYaTyLuxpjaLJ1ySe73510+ZI+D6lmObpH/OqFmQP+DMCY+KfYC
   B7TiZ7HBdb1C+u3d+VgODnVFLq5UgIsFMGzICVJ7cTC3QxUBW2CwiqJYy
   xdJzAyY7ich0R7LdBYcUp4Ii/C6aGED2Pj3NI3QH4U5BEOvk8GC3F5Bsd
   45PNHMJEMB6s3kH/t8bZnVfkNlGUlJ2u//c6owQihJhA76QosKoDK4fou
   wiIOJyq2rBxuTRPyJjFfwtu9epmiQTquzlCbJSVrd2jAD9TAlUPtjbdTC
   RTkfXNd+GZpwk+jdgSteJjeUfubr2udt6c5DPcLHLTnb8aayyfcgUs4QE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="379186455"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="379186455"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 11:12:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="732260822"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="732260822"
Received: from smile.fi.intel.com ([10.237.72.54])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Nov 2022 11:12:19 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ozjYA-001MTs-11;
        Mon, 28 Nov 2022 21:12:18 +0200
Date:   Mon, 28 Nov 2022 21:12:18 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Dale Smith <dalepsmith@gmail.com>,
        John Harris <jmharris@gmail.com>
Subject: Re: [PATCH v1 1/1] pinctrl: intel: Save and restore pins in "direct
 IRQ" mode
Message-ID: <Y4UIEpICwI9NdoL+@smile.fi.intel.com>
References: <20221124222926.72326-1-andriy.shevchenko@linux.intel.com>
 <Y4BcguSaNlh7VbLQ@black.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4BcguSaNlh7VbLQ@black.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 25, 2022 at 08:11:14AM +0200, Mika Westerberg wrote:
> On Fri, Nov 25, 2022 at 12:29:26AM +0200, Andy Shevchenko wrote:
> > The firmware on some systems may configure GPIO pins to be
> > an interrupt source in so called "direct IRQ" mode. In such
> > cases the GPIO controller driver has no idea if those pins
> > are being used or not. At the same time, there is a known bug
> > in the firmwares that don't restore the pin settings correctly
> > after suspend, i.e. by an unknown reason the Rx value becomes
> > inverted.
> > 
> > Hence, let's save and restore the pins that are configured
> > as GPIOs in the input mode with GPIROUTIOXAPIC bit set.
> > 
> > Cc: stable@vger.kernel.org
> > Reported-and-tested-by: Dale Smith <dalepsmith@gmail.com>
> > Reported-and-tested-by: John Harris <jmharris@gmail.com>
> > BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214749
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Thanks Andy!
> 
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Thank you!

Linus, this would be nice to have in v6.1 release, if possible.

-- 
With Best Regards,
Andy Shevchenko


