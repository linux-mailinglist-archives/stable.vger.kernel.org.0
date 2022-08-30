Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CB95A5EC6
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 10:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiH3I7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 04:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiH3I7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 04:59:06 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C6A9E687
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 01:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661849945; x=1693385945;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6Caw0q5J68ww78mhEpYkFWe5tEMRQv4UXVBQSmfCFSw=;
  b=k7iPC4mYnAki6JHj4htKHl745ifd8mxeKGy6iOMSHKqJ3VTWqWeaPBYS
   XE89nRlfpLEdeEulj9hxZJnQvlNZFFsPNPrIFJbxcyy2cBjF1d54R2ZmZ
   Zc5GwsIClSMqgj0cJWg0LohJDQ2oGl23l94KlnDEy8b4q4lyIybajP/6C
   Y8I46Kh53qdUEnjV18ubXmxyiZL5mpbQA8aOdzzl5T1H+51wnffnIJedd
   fsb9qLQCdTVpnmZftP8EuUsfa4VLel9hOTV90G3KnSr+o3RuZWcXZIfHs
   +B8EWcb38HMsKBriROx/oRs71B4SseySeYcODGr2RRrQYyq8nYNliYvR9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="381420515"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="381420515"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 01:59:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="611632200"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by orsmga002.jf.intel.com with SMTP; 30 Aug 2022 01:59:02 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 30 Aug 2022 11:59:01 +0300
Date:   Tue, 30 Aug 2022 11:59:01 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/bios: Copy the whole MIPI sequence
 block
Message-ID: <Yw3RVTkIf1WVk/tb@intel.com>
References: <20220829135834.8585-1-ville.syrjala@linux.intel.com>
 <87o7w2dtlc.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o7w2dtlc.fsf@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 11:27:27AM +0300, Jani Nikula wrote:
> On Mon, 29 Aug 2022, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >
> > Turns out the MIPI sequence block version number and
> > new block size fields are considered part of the block
> > header and are not included in the reported new block size
> > field itself. Bump up the block size appropriately so that
> > we'll copy over the last five bytes of the block as well.
> >
> > For this particular machine those last five bytes included
> > parts of the GPIO op for the backlight on sequence, causing
> > the backlight no longer to turn back on:
> >
> >  		Sequence 6 - MIPI_SEQ_BACKLIGHT_ON
> >  			Delay: 20000 us
> > -			GPIO index 0, number 0, set 0 (0x00)
> > +			GPIO index 1, number 70, set 1 (0x01)
> >
> > Cc: stable@vger.kernel.org
> > Fixes: e163cfb4c96d ("drm/i915/bios: Make copies of VBT data blocks")
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6652
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > ---
> >  drivers/gpu/drm/i915/display/intel_bios.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
> > index 81d6cfbd2615..d493d04f4049 100644
> > --- a/drivers/gpu/drm/i915/display/intel_bios.c
> > +++ b/drivers/gpu/drm/i915/display/intel_bios.c
> > @@ -479,6 +479,13 @@ init_bdb_block(struct drm_i915_private *i915,
> >  
> >  	block_size = get_blocksize(block);
> >  
> > +	/*
> > +	 * Version number and new block size are considered
> > +	 * part of the header for MIPI sequenece block v3+.
> > +	 */
> 
> Quoth Bspec, "This field specifies the size of this entire data
> structure excluding this header." Okay.
> 
> > +	if (section_id == BDB_MIPI_SEQUENCE && *(const u8 *)block >= 3)
> > +		block_size += 5;
> > +
> 
> Since we need to look at the header later, we can't just use data +
> 5. Okay.
> 
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>

Thanks.

> 
> I just don't get the whole sequence block u32 size thing, because the
> vbt header and bdb header still have u16, and they're supposed to cover
> the entire vbt and all bdb data blocks. And this is what we check
> anyway.

Yeah, very much snafu.

> 
> >  	entry = kzalloc(struct_size(entry, data, max(min_size, block_size) + 3),
> >  			GFP_KERNEL);
> >  	if (!entry) {
> 
> -- 
> Jani Nikula, Intel Open Source Graphics Center

-- 
Ville Syrjälä
Intel
