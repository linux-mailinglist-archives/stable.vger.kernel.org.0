Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0DA6DDFF7
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjDKPwX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKPwW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:52:22 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42E32723
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681228341; x=1712764341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Ri6BdLcbofHzHWjjX8OZ2Xio0NKVZwWQQFOvtQQoVC4=;
  b=PL6sULII823aTq4mIm2QJVw+bSABFnK579vkmV2srDFOGA0E7VY1LNBf
   06qIoZhOs+2YZXQuNjdaJGm8dNqjfTHPSjaBhIlSC/1al3kqXeMTdeOTo
   eQJiorovGoNa9eKCWAgvm6OO01SsUFKmUV7QSaO2edEcvMmo9LoHHHsDE
   M4RlrRPoWPfRUtFfLw/Bp19Yw/QEkSsJDlud9haLIIScT0ZhKcdXUsd4X
   8Apj9qdlZBrvx+If9EjKXKYW7E5zfbaAeHcw3r/ydToDR9tit2Wtht0RY
   LHucDasx3Tik5Y7m8Q7PHsAUGh6O5IlT/Q0VWLR1dL50QfFhzdFWfCXYe
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="429945077"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="429945077"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:51:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="753187790"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="753187790"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.70])
  by fmsmga008.fm.intel.com with SMTP; 11 Apr 2023 08:51:53 -0700
Received: by stinkbox (sSMTP sendmail emulation); Tue, 11 Apr 2023 18:51:52 +0300
Date:   Tue, 11 Apr 2023 18:51:52 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>
Subject: Re: [PATCH 6.1.y 1/3] drm/i915: Split icl_color_commit_noarm() from
 skl_color_commit_noarm()
Message-ID: <ZDWCGGgxGvcsFXhi@intel.com>
References: <2023040313-periscope-celery-403f@gregkh>
 <20230403162618.18469-1-ville.syrjala@linux.intel.com>
 <2023041117-cannot-sensuous-6f62@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2023041117-cannot-sensuous-6f62@gregkh>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 03:58:49PM +0200, Greg KH wrote:
> On Mon, Apr 03, 2023 at 07:26:16PM +0300, Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > We're going to want different behavior for skl/glk vs. icl
> > in .color_commit_noarm(), so split the hook into two. Arguably
> > we already had slightly different behaviour since
> > csc_enable/gamma_enable are never set on icl+, so the old
> > code was perhaps a bit confusing as well.
> > 
> > Cc: <stable@vger.kernel.org> #v5.19+
> > Cc: <stable@vger.kernel.org> # 05ca98523481: drm/i915: Use _MMIO_PIPE() for SKL_BOTTOM_COLOR
> > Cc: Manasi Navare <navaremanasi@google.com>
> > Cc: Drew Davenport <ddavenport@chromium.org>
> > Cc: Imre Deak <imre.deak@intel.com>
> > Cc: Jouni Högander <jouni.hogander@intel.com>
> > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-2-ville.syrjala@linux.intel.com
> > Reviewed-by: Imre Deak <imre.deak@intel.com>
> > (cherry picked from commit f161eb01f50ab31f2084975b43bce54b7b671e17)
> > Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > (cherry picked from commit 76b767d4d1cd052e455cf18e06929e8b2b70101d)
> > ---
> >  drivers/gpu/drm/i915/display/intel_color.c | 21 ++++++++++++++++++++-
> >  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> This commit breaks the build.

You did cherry pick all the dependencies I listed?

> 
> Always test-build the stuff you send out.  please.

I did.

> 
> Whole series dropped from my review queue.
> 
> greg k-h

-- 
Ville Syrjälä
Intel
