Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E20F3B799
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390889AbfFJOlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389520AbfFJOlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 10:41:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6229E2085A;
        Mon, 10 Jun 2019 14:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560177703;
        bh=FokFmznO3hyjBT8LK5KtRnNef6UscRIFRtkTmxIJrmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g8Qo5WmIqFD1faasY7A/hAKgeI9tnxPlxIqa55wfHQgTNzcnno5Uzs3xN04BF50UU
         hgUc6Ae/i+nO6c2JYCqoZ7cZdW7FG+s9+/GTqa+MWggonJAmLP/4kvodu9ayALzsS7
         sSdAE8wS4jybXI5y/423thBYHffoH/EBF93kVJrY=
Date:   Mon, 10 Jun 2019 16:41:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Amber Lin <Amber.Lin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 4.19 46/51] drm/amdgpu/soc15: skip reset on init
Message-ID: <20190610144141.GB31086@kroah.com>
References: <20190609164127.123076536@linuxfoundation.org>
 <20190609164130.489004849@linuxfoundation.org>
 <20190610143146.GA19565@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610143146.GA19565@amd>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 04:31:46PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Alex Deucher <alexander.deucher@amd.com>
> > 
> > commit 5887a59961e2295c5b02f39dbc0ecf9212709b7b upstream.
> > 
> > Not necessary on soc15 and breaks driver reload on server cards.
> 
> > --- a/drivers/gpu/drm/amd/amdgpu/soc15.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
> > @@ -495,6 +495,11 @@ int soc15_set_ip_blocks(struct amdgpu_de
> >  		return -EINVAL;
> >  	}
> >  
> > +	/* Just return false for soc15 GPUs.  Reset does not seem to
> > +	 * be necessary.
> > +	 */
> > +	return false;
> > +
> >  	if (adev->flags & AMD_IS_APU)
> >  		adev->nbio_funcs = &nbio_v7_0_funcs;
> >  	else if (adev->asic_type == CHIP_VEGA20)
> 
> Something is seriously wrong here.
> 
> Upstream commit goes to soc15_need_reset_on_init() and creates dead
> variable and quite a bit of dead code. Is that intended?
> 
> But this stable version... goes to different function, and returns
> false in function returning 0/-EINVAL, simulating success. New place
> does not seem right; it seems like patch misplaced it.

Ah, good catch!  This happened in the 4.14.y tree, so I had to drop the
patch from there, for some reason I missed checking the 4.19.y backport
(I had validated that 5.1.y got it right.)

Now dropped from the queue, thanks!

greg k-h
