Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A0B322B74
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 14:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhBWN2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 08:28:22 -0500
Received: from mga17.intel.com ([192.55.52.151]:7192 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232714AbhBWN2V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 08:28:21 -0500
IronPort-SDR: lfpc9WcPPZHoqs/8gXsN+Lvo0xljhYL1+S71k5iXdNneUg/vIMPN2XtJzG6TGzOyVNjz0+7/uj
 hhs40GgFtlMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="164647235"
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="164647235"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 05:26:32 -0800
IronPort-SDR: o8aNEzCrGEAvWA55tIZ7/mnHRPMZg8IUZiFShEGBvBpxXH8i1sezxHMN9HVN+VdJ3lG0YGrp2e
 Ae90pd/EKPiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="403517029"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga007.jf.intel.com with SMTP; 23 Feb 2021 05:26:29 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 23 Feb 2021 15:26:28 +0200
Date:   Tue, 23 Feb 2021 15:26:28 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     "Lin, Wayne" <Wayne.Lin@amd.com>
Cc:     "Brol, Eryk" <Eryk.Brol@amd.com>,
        "Zhuo, Qingqing" <Qingqing.Zhuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>
Subject: Re: [PATCH 1/2] drm/dp_mst: Revise broadcast msg lct & lcr
Message-ID: <YDUChEqKeqw1znMc@intel.com>
References: <20210222040027.23505-1-Wayne.Lin@amd.com>
 <20210222040027.23505-2-Wayne.Lin@amd.com>
 <YDPjiz4tiMRo320Q@intel.com>
 <YDPlPRJXVYfPZenQ@intel.com>
 <BN8PR12MB47700C725A9D4411BDBABE1BFC809@BN8PR12MB4770.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN8PR12MB47700C725A9D4411BDBABE1BFC809@BN8PR12MB4770.namprd12.prod.outlook.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 05:32:32AM +0000, Lin, Wayne wrote:
> [AMD Public Use]
> 
> > -----Original Message-----
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > Sent: Tuesday, February 23, 2021 1:09 AM
> > To: Lin, Wayne <Wayne.Lin@amd.com>
> > Cc: Brol, Eryk <Eryk.Brol@amd.com>; Zhuo, Qingqing <Qingqing.Zhuo@amd.com>; stable@vger.kernel.org; Zuo, Jerry
> > <Jerry.Zuo@amd.com>; dri-devel@lists.freedesktop.org; Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>
> > Subject: Re: [PATCH 1/2] drm/dp_mst: Revise broadcast msg lct & lcr
> >
> > On Mon, Feb 22, 2021 at 07:02:03PM +0200, Ville Syrjälä wrote:
> > > On Mon, Feb 22, 2021 at 12:00:26PM +0800, Wayne Lin wrote:
> > > > [Why & How]
> > > > According to DP spec, broadcast message LCT equals to 1 and LCR
> > > > equals to 6. Current implementation is incorrect. Fix it.
> > > >
> > > > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > > > Cc: stable@vger.kernel.org
> > > > ---
> > > >  drivers/gpu/drm/drm_dp_mst_topology.c | 10 ++++++++--
> > > >  1 file changed, 8 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > index 17dbed0a9800..713ef3b42054 100644
> > > > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > > @@ -2727,8 +2727,14 @@ static int set_hdr_from_dst_qlock(struct drm_dp_sideband_msg_hdr *hdr,
> > > >  else
> > > >  hdr->broadcast = 0;
> > > >  hdr->path_msg = txmsg->path_msg;
> > > > -hdr->lct = mstb->lct;
> > > > -hdr->lcr = mstb->lct - 1;
> > > > +if (hdr->broadcast) {
> > > > +hdr->lct = 1;
> > > > +hdr->lcr = 6;
> > > > +} else {
> > > > +hdr->lct = mstb->lct;
> > > > +hdr->lcr = mstb->lct - 1;
> > > > +}
> > > > +
> > > >  if (mstb->lct > 1)
> > > >  memcpy(hdr->rad, mstb->rad, mstb->lct / 2);
> > >
> > > We should also do something about RAD no?
> >
> > Just skip the RAD stuff by s/mstb->lct/hdr->lct/ here I guess?
> Thanks Ville!
> Since LCT=1, broadcast message doesn't have a RAD and this is taken
> care while we're constructing the header in drm_dp_encode_sideband_msg_hdr().
> In drm_dp_encode_sideband_msg_hdr(), we skip stuffing RAD if LCT=1.

Ugh. How many levels of these do we really need...
Either way I'd prefer the code be consistent so you don't
have to sacrifice so many brain cells to understand what
should be trivial details.

-- 
Ville Syrjälä
Intel
