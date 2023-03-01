Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7143C6A7063
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 17:01:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjCAQBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 11:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCAQBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 11:01:00 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 187D34391B
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 08:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677686459; x=1709222459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dOfIHw0XcWmKTeBOyGTcZzKkaoYuxdWm3iXIh5Y6IZY=;
  b=RlXgTztabIFbZLqistfTL9EsAG9JtEMUe6MBVwWRmzrIE2deVjS8rKr8
   tBPISt/w/6bH41E2WjqnGhB2Cf6rfbP7eXIt87OT/FM5Vt5c4UbwmVU8j
   j1/jKVDCUTpVnN/4x6og4YZvfkX1Z1HPqf20GcwqswXyMyAUmuXjVC4jE
   1rCeNfXKzyT7G+F3Dj0GHuk/id2usXR2wGTJysa47xfinxKm0CRJb7Key
   sa6wXuCiGeCdGSM3OE+eEByqpSPe3HRicYrUvY4+FZp+s+2iHUILiWWB5
   G+PN9wwFn+lWKcOSnBzWV80VmVTIwjM10ioCemJejM7P32T7gO2DOFDWE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="331923309"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="331923309"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 08:00:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="674613265"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="674613265"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by orsmga002.jf.intel.com with SMTP; 01 Mar 2023 08:00:52 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 01 Mar 2023 18:00:51 +0200
Date:   Wed, 1 Mar 2023 18:00:51 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/dsi: fix DSS CTL register offsets
 for TGL+
Message-ID: <Y/92swZjW47GuN2c@intel.com>
References: <20230301151409.1581574-1-jani.nikula@intel.com>
 <Y/9xf6SkV1fG4JSA@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y/9xf6SkV1fG4JSA@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 05:38:39PM +0200, Ville Syrjälä wrote:
> On Wed, Mar 01, 2023 at 05:14:09PM +0200, Jani Nikula wrote:
> > On TGL+ the DSS control registers are at different offsets, and there's
> > one per pipe. Fix the offsets to fix dual link DSI for TGL+.
> > 
> > There would be helpers for this in the DSC code, but just do the quick
> > fix now for DSI. Long term, we should probably move all the DSS handling
> > into intel_vdsc.c, so exporting the helpers seems counter-productive.
> 
> I'm not entirely happy with intel_vdsc.c since it handles
> both the hardware VDSC block (which includes DSS, and so
> also uncompressed joiner and MSO), and also some actual
> DSC calculations/etc. Might be nice to have a cleaner
> split of some sort.
> 
> That also reminds me that MSO+dsc/joiner is probably going
> to fail miserably given that neither side knows about the
> other and both poke the DSS registers.

I suppose MSO+joiner should just be rejected outright since 
the splitter seems to sit before the joiner in the path.
We'd need them to be the other way around.

But MSO+DSC does look plausible.

-- 
Ville Syrjälä
Intel
