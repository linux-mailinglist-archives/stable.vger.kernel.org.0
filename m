Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78EFD5FD7D1
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 12:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiJMKgf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 06:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJMKge (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 06:36:34 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3928E52CC
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 03:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665657393; x=1697193393;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=84cm2nDkKB3FojEUx+eiD5IfKY7NpFQn3U+ONC/nHWs=;
  b=liCNlSJYDFjtDJG/QLl641ERRjE2fACjYyUUocGgb9+Z55OElA3LUDP2
   JG5QLSUh7vXKleQDTVzECTSZ8dPrn4pgm3+B0JjkCqjWjgalDPuUi7e47
   bmi4VbVfV+YEaJG6p8wC93NS8rloF1v2bUtTTk/y1lyeHnwZs7G+TeI73
   4aSQusX+O8ZRfnXMDK+BPpFLUeLWLJnGKcocDf6Z61QuTZapaeVzob/Ec
   /HPfURJSG/goD09FCAdYIm7g7s3Ei8OUGH8TDflw4ROI+Xj9lswt3JgCa
   bj8cqDk3gFkdj8F685YQ8kQHU/cHjXsxAsDTGtPb8/ImykO3QLFDfk9eE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="305034182"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="305034182"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2022 03:36:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10498"; a="872275679"
X-IronPort-AV: E=Sophos;i="5.95,180,1661842800"; 
   d="scan'208";a="872275679"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by fmsmga006.fm.intel.com with SMTP; 13 Oct 2022 03:36:30 -0700
Received: by stinkbox (sSMTP sendmail emulation); Thu, 13 Oct 2022 13:36:30 +0300
Date:   Thu, 13 Oct 2022 13:36:30 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Jocelyn Falempe <jfalempe@redhat.com>,
        dri-devel@lists.freedesktop.org, airlied@redhat.com,
        michel@daenzer.net, stable@vger.kernel.org
Subject: Re: [PATCH] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
Message-ID: <Y0fqLofkA7O4IEbQ@intel.com>
References: <20221013082901.471417-1-jfalempe@redhat.com>
 <db634341-da68-e8a6-1143-445f17262c63@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db634341-da68-e8a6-1143-445f17262c63@suse.de>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 11:05:19AM +0200, Thomas Zimmermann wrote:
> Hi
> 
> Am 13.10.22 um 10:29 schrieb Jocelyn Falempe:
> > For G200_SE_A, PLL M setting is wrong, which leads to blank screen,
> > or "signal out of range" on VGA display.
> > previous code had "m |= 0x80" which was changed to
> > m |= ((pixpllcn & BIT(8)) >> 1);
> > 
> > Tested on G200_SE_A rev 42
> > 
> > This line of code was moved to another file with
> > commit 85397f6bc4ff ("drm/mgag200: Initialize each model in separate
> > function") but can be easily backported before this commit.
> > 
> > Fixes: 2dd040946ecf ("drm/mgag200: Store values (not bits) in struct mgag200_pll_values")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
> > ---
> >   drivers/gpu/drm/mgag200/mgag200_g200se.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/mgag200/mgag200_g200se.c b/drivers/gpu/drm/mgag200/mgag200_g200se.c
> > index be389ed91cbd..4ec035029b8b 100644
> > --- a/drivers/gpu/drm/mgag200/mgag200_g200se.c
> > +++ b/drivers/gpu/drm/mgag200/mgag200_g200se.c
> > @@ -284,7 +284,7 @@ static void mgag200_g200se_04_pixpllc_atomic_update(struct drm_crtc *crtc,
> >   	pixpllcp = pixpllc->p - 1;
> >   	pixpllcs = pixpllc->s;
> >   
> > -	xpixpllcm = pixpllcm | ((pixpllcn & BIT(8)) >> 1);
> > +	xpixpllcm = pixpllcm | BIT(7);
> 
> Thanks for figuring this out. G200SE apparently is special compared to 
> the other models. The old MGA docs only list this bit as <reserved>. 
> Really makes me wonder why this is different.

Could measure eg. the vblank interval with and without that bit set
and see what effect it has. Assuming the PLL locks without the bit
of course.

-- 
Ville Syrjälä
Intel
