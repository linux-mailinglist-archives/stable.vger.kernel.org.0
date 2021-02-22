Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A17C321DC2
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 18:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhBVRLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 12:11:12 -0500
Received: from mga07.intel.com ([134.134.136.100]:56929 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230379AbhBVRLK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 12:11:10 -0500
IronPort-SDR: 9pR3esMLp2LlqjdIqeJEwp4d+xTwirV3gfxwZkCiEwoXTJO7fE6efGWMiaX64wavi6Lxw1rMYL
 P0MYw/55pWfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="248571524"
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="248571524"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 09:09:23 -0800
IronPort-SDR: UYI7pOe9Ti6xsV+k3UgqhFluHEF2aBqgzG3+W/lVv8zdILt6R50KGVyaxpY835NCtl1WQHDFg+
 Ps+75/XmkjGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,197,1610438400"; 
   d="scan'208";a="402689444"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga008.jf.intel.com with SMTP; 22 Feb 2021 09:09:18 -0800
Received: by stinkbox (sSMTP sendmail emulation); Mon, 22 Feb 2021 19:09:17 +0200
Date:   Mon, 22 Feb 2021 19:09:17 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Wayne Lin <Wayne.Lin@amd.com>
Cc:     eryk.brol@amd.com, qingqing.zhuo@amd.com, stable@vger.kernel.org,
        jerry.zuo@amd.com, dri-devel@lists.freedesktop.org,
        Nicholas.Kazlauskas@amd.com
Subject: Re: [PATCH 1/2] drm/dp_mst: Revise broadcast msg lct & lcr
Message-ID: <YDPlPRJXVYfPZenQ@intel.com>
References: <20210222040027.23505-1-Wayne.Lin@amd.com>
 <20210222040027.23505-2-Wayne.Lin@amd.com>
 <YDPjiz4tiMRo320Q@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YDPjiz4tiMRo320Q@intel.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 07:02:03PM +0200, Ville Syrjälä wrote:
> On Mon, Feb 22, 2021 at 12:00:26PM +0800, Wayne Lin wrote:
> > [Why & How]
> > According to DP spec, broadcast message LCT equals to 1 and LCR equals
> > to 6. Current implementation is incorrect. Fix it.
> > 
> > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  drivers/gpu/drm/drm_dp_mst_topology.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
> > index 17dbed0a9800..713ef3b42054 100644
> > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > @@ -2727,8 +2727,14 @@ static int set_hdr_from_dst_qlock(struct drm_dp_sideband_msg_hdr *hdr,
> >  	else
> >  		hdr->broadcast = 0;
> >  	hdr->path_msg = txmsg->path_msg;
> > -	hdr->lct = mstb->lct;
> > -	hdr->lcr = mstb->lct - 1;
> > +	if (hdr->broadcast) {
> > +		hdr->lct = 1;
> > +		hdr->lcr = 6;
> > +	} else {
> > +		hdr->lct = mstb->lct;
> > +		hdr->lcr = mstb->lct - 1;
> > +	}
> > +
> >  	if (mstb->lct > 1)
> >  		memcpy(hdr->rad, mstb->rad, mstb->lct / 2);
> 
> We should also do something about RAD no?

Just skip the RAD stuff by s/mstb->lct/hdr->lct/ here I guess?

-- 
Ville Syrjälä
Intel
