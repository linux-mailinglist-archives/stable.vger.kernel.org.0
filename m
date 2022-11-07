Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6091561F207
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 12:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiKGLkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 06:40:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231948AbiKGLkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 06:40:16 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B691A066;
        Mon,  7 Nov 2022 03:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667821216; x=1699357216;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ijeOQILcLOYvtKJX2vEEcmM2t1oCmfcaSdZjYFJInjY=;
  b=JgZ5jbCwhzxb5avLBcIA9U3AZtpq3eevvGSU78lc6m+r5DvsYn/V+3DH
   YDWtB+LyIOgYOGCsiJSQeR4WE6XUG1iCp3TVCt9z/wYIRPvLbH3/d5qgt
   5QCrM5pQem78oPBRNW1SFhm7TTa+FL2APVDAQ20fk/0m/pPRSzfqbLcBJ
   HYpa6hzgaDoqWqfJy5VW40NsT3GDWwzFBVs0vNPpap5bsNbWzsnhAa0jw
   ZDx7fhGFSjtdrS/l8NpAfd/8VORIC2BziLUwR3EgA/6bZtbB57wH5x0Sd
   pm4nw8Y6KwID2lnVhCz8bTe7tsIYrB/q8qzFpBMlwPvOlS7H9fUWmUD+v
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="311524138"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="311524138"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 03:40:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="965122294"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="965122294"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga005.fm.intel.com with ESMTP; 07 Nov 2022 03:40:13 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1os0U7-008bxb-26;
        Mon, 07 Nov 2022 13:40:11 +0200
Date:   Mon, 7 Nov 2022 13:40:11 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        stable@vger.kernel.org, Gilles BULOZ <gilles.buloz@kontron.com>
Subject: Re: [PATCH 4/4] serial: 8250: Flush DMA Rx on RLSI
Message-ID: <Y2jumyyQKOsPhfcw@smile.fi.intel.com>
References: <20221107110708.58223-1-ilpo.jarvinen@linux.intel.com>
 <20221107110708.58223-5-ilpo.jarvinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221107110708.58223-5-ilpo.jarvinen@linux.intel.com>
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

On Mon, Nov 07, 2022 at 01:07:08PM +0200, Ilpo Järvinen wrote:
> Returning true from handle_rx_dma() without flushing DMA first creates
> a data ordering hazard. If DMA Rx has handled any character at the
> point when RLSI occurs, the non-DMA path handles any pending characters
> jumping them ahead of those characters that are pending under DMA.
> 
> Fixes: 75df022b5f89 ("serial: 8250_dma: Fix RX handling")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> ---
> Cc: Gilles BULOZ <gilles.buloz@kontron.com>

Maybe instead you can do --cc Guilles ... for entire series (and drop from
other commit messages)?

-- 
With Best Regards,
Andy Shevchenko


