Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9F6060D58D
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 22:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiJYUc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 16:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbiJYUc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 16:32:27 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81016ABD61
        for <stable@vger.kernel.org>; Tue, 25 Oct 2022 13:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666729946; x=1698265946;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=GVo3VBqPRovcZf5EP7+TCdOX+BecorKE93akHNypg2U=;
  b=FK7LisxKk/gelIL1ifi3OeGvtlNyyFbtB3261O3Zo1hpYskRmJLowqxw
   wrixikr3Df+ki+HCZU7rJvvXmtwyOjGhJlIcpW5JN8ttrx+JtlN9gBw95
   71rS3BWYrwq7PVB18exWIpO9JFhyp7P2hzdR1kUpvu2jtFpaMigSta05z
   SUDkZQhQTN4206apKh7E6J5xiAzl/kmePD+SyyMaKOX2+K9yo9A6MZr7e
   mThErKJ3oB9O7Mbo4OVcXz6ib9HumDuZ6lfgKy6w+Om5kVzLaEMbWDl41
   aFY4fLLo5Fb2Ghi6iqT2fgwt9S3t65LfFB+jN0WS8XtKHUju7WSEh/PDp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="306515263"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="306515263"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2022 13:32:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10511"; a="774335851"
X-IronPort-AV: E=Sophos;i="5.95,212,1661842800"; 
   d="scan'208";a="774335851"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by fmsmga001.fm.intel.com with SMTP; 25 Oct 2022 13:32:24 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 25 Oct 2022 23:32:23 +0300
Date:   Tue, 25 Oct 2022 23:32:23 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/sdvo: Fallback to current output
 timings for LVDS fixed mode
Message-ID: <Y1hH10dyV0bCCSSr@intel.com>
References: <20221025165938.17264-1-ville.syrjala@linux.intel.com>
 <878rl3eqx7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878rl3eqx7.fsf@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 25, 2022 at 08:47:32PM +0300, Jani Nikula wrote:
> On Tue, 25 Oct 2022, Ville Syrjala <ville.syrjala@linux.intel.com> wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >
> > If we can't dig out a fixed mode for LVDS from the VBT or EDID
> > let's fall back to using the current output timings. This should
> > work as long as the BIOS has (somehow) enabled the output.
> >
> > In this case we are dealing with the some kind of BLB based POS
> > machine (Toshiba SurePOS 500) where neither the OpRegion mailbox
> > nor the vbios ROM contain a valid VBT. And no EDID anywhere we
> > could find either.
> >
> > Cc: <stable@vger.kernel.org> # v5.19+
> > Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7301
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> 
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
> 
> But they're saying it's a regression between 4.19 and 5.10...

Yeah. I can't actually figure out how it could have worked even
with 4.19.

Hmm. Actually now that I look at some of the hints in the logs it
does look like it maybe did find an EDID after all. What confused
me was that all the modes very much like the _noedid stuff.

Ah, it looks like we fail to fully initialize the DDC stuff
before setting up the outputs, which I guess explains why the
EDID read fails there. Previously there was this funky feedback
loop in that .get_modes() actually filled in the fixed_mode,
so until you called that (after everything else was fully set
up) you didn't have a fixed mode.

And while looking at this stuff more I can see that the whole
multi output support is still very much snafu :/

I'll see if I can make a fairly minimal fix for now...

-- 
Ville Syrjälä
Intel
