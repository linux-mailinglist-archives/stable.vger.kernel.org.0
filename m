Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E23D961F1F8
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 12:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiKGLiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 06:38:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiKGLiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 06:38:14 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1F7D40;
        Mon,  7 Nov 2022 03:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667821093; x=1699357093;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=umGzmRMwLMWQ/a5ON85PG0oqEFogrPqAnJJnkozevmM=;
  b=m+m7HEQUZli3mAxcVynO2gP33sdbLjh4AfI9MObuf9FFGo28NsjStQVh
   S8RQM7nSVL3lnShAUmzgHtUGeZESuXSZ0qT2EaCcXyVWkh3v58JkQrrdZ
   M2VqphdlwVSkw7h2b0cVCIB4z4YKi5nEa/dkf39db1xV23G+OFp4WY0u2
   LSedE+EFYr8HyW+AUTzChh8/S2BMrWIpsgreNA10tJhkJBW7QDPmnVofT
   iDk+mMI1AjkXa9aYVDKFhD5428TK5LIjvn3ljFTH1i9k/xCGZXk2t3arj
   9pvu8btoMxJJ9W2FH4GTYAfqYhjk8e9YeTFUEDAM0oXIjR71JXxnhipVj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="311523885"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="311523885"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 03:38:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="669108364"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="669108364"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001.jf.intel.com with ESMTP; 07 Nov 2022 03:38:10 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1os0S8-008bvj-29;
        Mon, 07 Nov 2022 13:38:08 +0200
Date:   Mon, 7 Nov 2022 13:38:08 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Wentong Wu <wentong.wu@intel.com>,
        Srikanth Thokala <srikanth.thokala@intel.com>,
        Aman Kumar <aman.kumar@intel.com>
Subject: Re: [PATCH 3/4] serial: 8250_lpss: Use 16B DMA burst with Elkhart
 Lake
Message-ID: <Y2juIETKUZtw9wu6@smile.fi.intel.com>
References: <20221107110708.58223-1-ilpo.jarvinen@linux.intel.com>
 <20221107110708.58223-4-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221107110708.58223-4-ilpo.jarvinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 01:07:07PM +0200, Ilpo Järvinen wrote:
> Configure DMA to use 16B burst size with Elkhart Lake. This makes the
> bus use more efficient and works around an issue which occurs with the
> previously used 1B.
> 
> Fixes: 0a9410b981e9 ("serial: 8250_lpss: Enable DMA on Intel Elkhart Lake")
> Cc: <stable@vger.kernel.org> # serial: 8250_lpss: Configure DMA also w/o DMA filter
> Reported-by: Wentong Wu <wentong.wu@intel.com>
> Co-developed-by: Srikanth Thokala <srikanth.thokala@intel.com>
> Signed-off-by: Srikanth Thokala <srikanth.thokala@intel.com>
> Co-developed-by: Aman Kumar <aman.kumar@intel.com>
> Signed-off-by: Aman Kumar <aman.kumar@intel.com>
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> 
> ---
> I know the list of Co-dev-bys & Sob seems a bit odd for a oneliner.
> The reason is that I cleaned up this from a more complex patch using
> the earlier change that I authored myself so only this oneliner
> remained in this patch.

If you changed more than 70% of the code, I would suggest to drop the rest of
(Co)authors and if you want to pay a credit, just mention them in the commit
message in a free form.

-- 
With Best Regards,
Andy Shevchenko


