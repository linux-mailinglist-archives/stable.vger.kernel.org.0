Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CA842170D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 21:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238934AbhJDTN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 15:13:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:61381 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238562AbhJDTLs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 15:11:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10127"; a="225464580"
X-IronPort-AV: E=Sophos;i="5.85,346,1624345200"; 
   d="scan'208";a="225464580"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 12:09:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,346,1624345200"; 
   d="scan'208";a="567358907"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by fmsmga002.fm.intel.com with SMTP; 04 Oct 2021 12:09:39 -0700
Received: by stinkbox (sSMTP sendmail emulation); Mon, 04 Oct 2021 22:09:38 +0300
Date:   Mon, 4 Oct 2021 22:09:38 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Matt Roper <matthew.d.roper@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org,
        Karthik B S <karthik.b.s@intel.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Extend the async flip VT-d w/a
 to skl/bxt
Message-ID: <YVtRciGIj5WHoM5k@intel.com>
References: <20210930190943.17547-1-ville.syrjala@linux.intel.com>
 <20211001210815.GG3389343@mdroper-desk1.amr.corp.intel.com>
 <YVeFOzabpcWAbVFQ@intel.com>
 <20211004175000.GA366973@mdroper-desk1.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211004175000.GA366973@mdroper-desk1.amr.corp.intel.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 10:50:00AM -0700, Matt Roper wrote:
> On Sat, Oct 02, 2021 at 01:01:31AM +0300, Ville Syrjälä wrote:
> > On Fri, Oct 01, 2021 at 02:08:15PM -0700, Matt Roper wrote:
> > > On Thu, Sep 30, 2021 at 10:09:42PM +0300, Ville Syrjala wrote:
> > > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > 
> > > > Looks like skl/bxt/derivatives also need the plane stride
> > > > stretch w/a when using async flips and VT-d is enabled, or
> > > > else we get corruption on screen. To my surprise this was
> > > > even documented in bspec, but only as a note on the
> > > > CHICHKEN_PIPESL register description rather than on the
> > > > w/a list.
> > > > 
> > > > So very much the same thing as on HSW/BDW, except the bits
> > > > moved yet again.
> > > 
> > > Bspec 7522 doesn't say anything about this requirement being tied to
> > > VT-d on these platforms.  Should we drop the intel_vtd_active()
> > > condition to be safe?
> > 
> > I think it's just an oversight in bspec. I read through the hsd and
> > IIRC it did specify that it's VT-d only. Also real life confirms
> > it. No problems whatsoever when VT-d is disabled.
> 
> I notice there are additional bits that we should set to apply this
> workaround to planes 2, 3, and 4, but since i915 still artificially
> limits async flips to just the primary plane, only programming bits 1:0
> should be fine for now; we'll just need to remember to extend this
> workaround if we do start allowing async flips on other planes in the
> future.

Aye. gen8_de_pipe_flip_done_mask() is the other place where we
still hardcode this for plane 1 only. I think the rest of the code
I did end up making more or less plane agnostic already.

I was considering at least parametrizing the register defines but
then I got a nagging feeling that I once ran into some issues while
trying to stick non-constant numbers into REG_BIT & co. So I
decided to hardcode plane 1 for the moment.

> 
> Reviewed-by: Matt Roper <matthew.d.roper@intel.com>

Thanks. Pushed.

-- 
Ville Syrjälä
Intel
