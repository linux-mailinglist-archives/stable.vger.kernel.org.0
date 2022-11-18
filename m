Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A403862F297
	for <lists+stable@lfdr.de>; Fri, 18 Nov 2022 11:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235150AbiKRKb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Nov 2022 05:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241185AbiKRKbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Nov 2022 05:31:55 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71CD922FC;
        Fri, 18 Nov 2022 02:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668767514; x=1700303514;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N8x7xImtAvyd/PeshLorVVz6Fc9g7VY+cy0Rhscb5qs=;
  b=CnyISHj3/qgpovJtxA1esLUP0wRUeHGxPqu2A25Rkp10nk3o3v9AxLVD
   WWf3No/dl5QOnisS31rFCaXr8uVN9po/+/zSYZZ5DDk2vje0GyfHleCR3
   7LWz4jdtD5fl6McHTLKJpsLPAQ5qvdg4BWw4k6/fpsWzaBX7Ufbg6BqJL
   KEMFqRGA3QS4I69vXEQVGo05Fbu4aaBd7IcqHUmLQg/B34xb/nDjvuOcx
   rzwjZ9JlkT7PWLK0kOCwfRtYBGGYG4cL9ZOqDE2HkIqVn7aRUNew1a8ED
   KMJFr99KlRHV4xOhz/5qYSZ0rYKCJ40o/JMrMfwFiEf7GdNoSYx8FW8Mx
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="314925837"
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="314925837"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 02:31:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="617968256"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="617968256"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006.jf.intel.com with ESMTP; 18 Nov 2022 02:31:51 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1ovyez-00DzqW-1I;
        Fri, 18 Nov 2022 12:31:49 +0200
Date:   Fri, 18 Nov 2022 12:31:49 +0200
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
Subject: Re: [PATCH v3 1/2] usb: ulpi: defer ulpi_register on ulpi_read_id
 timeout
Message-ID: <Y3dfFX0P9n2lndCL@smile.fi.intel.com>
References: <20221117205411.11489-1-ftoth@exalondelft.nl>
 <20221117205411.11489-2-ftoth@exalondelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117205411.11489-2-ftoth@exalondelft.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 17, 2022 at 09:54:10PM +0100, Ferry Toth wrote:
> Since commit 0f010171
> Dual Role support on Intel Merrifield platform broke due to rearranging
> the call to dwc3_get_extcon().

Not sure why format is broken, you may add into your ~/.gitconfig

	[core]
		abbrev = 12

	[alias]
		one = show -s --pretty='format:%h (\"%s\")'

and run

	git one 0f010171

with the result

	0f0101719138 ("usb: dwc3: Don't switch OTG -> peripheral if extcon is present")

> It appears to be caused by ulpi_read_id() on the first test write failing
> with -ETIMEDOUT. Currently ulpi_read_id() expects to discover the phy via
> DT when the test write fails and returns 0 in that case even if DT does not
> provide the phy. As a result usb probe completes without phy.


-- 
With Best Regards,
Andy Shevchenko


