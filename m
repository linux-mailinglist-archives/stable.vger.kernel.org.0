Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9563441F75B
	for <lists+stable@lfdr.de>; Sat,  2 Oct 2021 00:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355158AbhJAWSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 18:18:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:18794 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230292AbhJAWSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Oct 2021 18:18:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="311146993"
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="311146993"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 15:17:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="619441943"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga001.fm.intel.com with SMTP; 01 Oct 2021 15:17:06 -0700
Received: by stinkbox (sSMTP sendmail emulation); Sat, 02 Oct 2021 01:17:05 +0300
Date:   Sat, 2 Oct 2021 01:17:05 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Matt Roper <matthew.d.roper@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Karthik B S <karthik.b.s@intel.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Extend the async flip VT-d w/a
 to skl/bxt
Message-ID: <YVeI4b7EzRcwrvLi@intel.com>
References: <20210930190943.17547-1-ville.syrjala@linux.intel.com>
 <20211001210815.GG3389343@mdroper-desk1.amr.corp.intel.com>
 <YVeFOzabpcWAbVFQ@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVeFOzabpcWAbVFQ@intel.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 02, 2021 at 01:01:31AM +0300, Ville Syrjälä wrote:
> On Fri, Oct 01, 2021 at 02:08:15PM -0700, Matt Roper wrote:
> > On Thu, Sep 30, 2021 at 10:09:42PM +0300, Ville Syrjala wrote:
> > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > 
> > > Looks like skl/bxt/derivatives also need the plane stride
> > > stretch w/a when using async flips and VT-d is enabled, or
> > > else we get corruption on screen. To my surprise this was
> > > even documented in bspec, but only as a note on the
> > > CHICHKEN_PIPESL register description rather than on the
> > > w/a list.
> > > 
> > > So very much the same thing as on HSW/BDW, except the bits
> > > moved yet again.
> > 
> > Bspec 7522 doesn't say anything about this requirement being tied to
> > VT-d on these platforms.  Should we drop the intel_vtd_active()
> > condition to be safe?
> 
> I think it's just an oversight in bspec. I read through the hsd and
> IIRC it did specify that it's VT-d only. Also real life confirms
> it. No problems whatsoever when VT-d is disabled.

BTW I was hopeful this would fix shard-skl but no such luck.
Well, in fact it does fix the crc error, indicating the patch
does work. Unfortunately those systems have yet another
undiagnosed async flip problem. From the ci report on this
series I can see that the machine was only capable of ~1.2
async flips per frame during the crc test. I guess technically
anything >1 counts as "some async flips did happen" but it really
should not be that low (I put the arbitrary limit in the test at
two flips per frame). My cfl can do IIRC 50-150 per frame,
depending on the phase of the moon and whatnot.

-- 
Ville Syrjälä
Intel
