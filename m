Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAA076DEBFA
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 08:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjDLGlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 02:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjDLGlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 02:41:07 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0202683
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 23:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681281661; x=1712817661;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=EyjdiORsXnz6Jlhf4Kyhzq2qWgleSEOT1rKCs0gI7EQ=;
  b=ZowtNW0a5ObkSV4EmBZq5lwEQ1td7EX8CCJA0XG+NsJwXe5ptAmk3YYZ
   GJHAxuHwg+3YYbj1WdjKL7NWzlMaipe0zGsphHW+nk1DXXLS2mbgmx9tS
   iB2aFuQXZq9A4ZL4St+5KwJFI4XhE6qTRlObNhtrXvhl+Wo9/CDX7z3uj
   mGO/NdQmMG0E/iS3SKYET+iQWnOKUVeHDWnlIhZ1Uv4HB56l08C9a+skw
   5JoP+vRwXF9MSOxyk+bXv7nLCpzkOQfdyChCbjHkRSbFMEpeDGC9k0lER
   6b03gWuVCFX4d5Pah8AlHXp1NsnIrMm66U48MpAMpTFSKpe5JIv8qIOsU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="346492540"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="346492540"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 23:41:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="753419429"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="753419429"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by fmsmga008.fm.intel.com with SMTP; 11 Apr 2023 23:40:58 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 12 Apr 2023 09:40:57 +0300
Date:   Wed, 12 Apr 2023 09:40:57 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>
Subject: Re: [PATCH 6.1.y 1/3] drm/i915: Split icl_color_commit_noarm() from
 skl_color_commit_noarm()
Message-ID: <ZDZSeepv2HG8DztE@intel.com>
References: <2023040313-periscope-celery-403f@gregkh>
 <20230403162618.18469-1-ville.syrjala@linux.intel.com>
 <2023041117-cannot-sensuous-6f62@gregkh>
 <ZDWCGGgxGvcsFXhi@intel.com>
 <2023041226-zoology-smoking-5d9c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2023041226-zoology-smoking-5d9c@gregkh>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 08:17:57AM +0200, Greg KH wrote:
> On Tue, Apr 11, 2023 at 06:51:52PM +0300, Ville Syrjälä wrote:
> > On Tue, Apr 11, 2023 at 03:58:49PM +0200, Greg KH wrote:
> > > On Mon, Apr 03, 2023 at 07:26:16PM +0300, Ville Syrjala wrote:
> > > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > 
> > > > We're going to want different behavior for skl/glk vs. icl
> > > > in .color_commit_noarm(), so split the hook into two. Arguably
> > > > we already had slightly different behaviour since
> > > > csc_enable/gamma_enable are never set on icl+, so the old
> > > > code was perhaps a bit confusing as well.
> > > > 
> > > > Cc: <stable@vger.kernel.org> #v5.19+
> > > > Cc: <stable@vger.kernel.org> # 05ca98523481: drm/i915: Use _MMIO_PIPE() for SKL_BOTTOM_COLOR
> > > > Cc: Manasi Navare <navaremanasi@google.com>
> > > > Cc: Drew Davenport <ddavenport@chromium.org>
> > > > Cc: Imre Deak <imre.deak@intel.com>
> > > > Cc: Jouni Högander <jouni.hogander@intel.com>
> > > > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-2-ville.syrjala@linux.intel.com
> > > > Reviewed-by: Imre Deak <imre.deak@intel.com>
> > > > (cherry picked from commit f161eb01f50ab31f2084975b43bce54b7b671e17)
> > > > Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > > > (cherry picked from commit 76b767d4d1cd052e455cf18e06929e8b2b70101d)
> > > > ---
> > > >  drivers/gpu/drm/i915/display/intel_color.c | 21 ++++++++++++++++++++-
> > > >  1 file changed, 20 insertions(+), 1 deletion(-)
> > > 
> > > This commit breaks the build.
> > 
> > You did cherry pick all the dependencies I listed?
> 
> Nope!  When you send a patch series, I had assumed that it was
> self-contained :(

I can do that in the future if it's preferred. But that does
seem to imply that there's no point in even listing the
dependencies.

Hmm, I suppose it can still be useful if one manages to list
the dependencies in the original commit. But generating such
a list upfront (accounting each relevant stable branch) doesn't
seem particularly appetizing for a fast moving target like i915.

-- 
Ville Syrjälä
Intel
