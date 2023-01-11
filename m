Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBF0665EBA
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 16:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbjAKPFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 10:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238833AbjAKPEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 10:04:55 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5B210FE;
        Wed, 11 Jan 2023 07:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673449495; x=1704985495;
  h=date:from:to:subject:message-id:references:mime-version:
   content-transfer-encoding:in-reply-to;
  bh=jxDJ3ooBqVnTaczv1GXFLe+oPshX0iJRCjOYwPWvPAA=;
  b=b+wYNn8bm9dndm/k3rnX4nARLMBPPUC+Dj3nzq4ku88Afs44J7oJW+DP
   EsuKTC5ryH3UI3PPKlVZDPHUA6Z6LnUDNX+ORZM9q+98up+mmpqrFjqy3
   gUyyg+Nn9uTpaYlpXLTAMIAUkYEywMmMcYSJk159qWeqj5Rohd89iSWVt
   zgegjLtIMxLvT86BLvg1x229YKuHC5iwekIrhIdhn7tzzniX+lmoZTWDZ
   o9S86wU6eR+ArwoldLzPGegrNJJB4i/1KYS5Gf+BSB+19IcVP5AE/fZHu
   18gABjUIyJg1lUWeoQlCj7jphouklLtmZBw2/7Aw4jsfptn2Qw2+XJg6l
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="350662836"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="350662836"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 07:03:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="687955288"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="687955288"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.55])
  by orsmga008.jf.intel.com with SMTP; 11 Jan 2023 07:03:31 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 11 Jan 2023 17:03:30 +0200
Date:   Wed, 11 Jan 2023 17:03:30 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Brian Norris <briannorris@chromium.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] drm/atomic: Allow vblank-enabled + self-refresh
 "disable"
Message-ID: <Y77PwoqlfUS5JK7q@intel.com>
References: <20230105174001.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
 <Y7hgLUXOrD7QwKs1@phenom.ffwll.local>
 <Y7hl0Z9PZhFk8On9@phenom.ffwll.local>
 <Y7h3cuAVE2fdS9K3@google.com>
 <Y7iFAJqGNXA7wHoK@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y7iFAJqGNXA7wHoK@phenom.ffwll.local>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 09:30:56PM +0100, Daniel Vetter wrote:
> On Fri, Jan 06, 2023 at 11:33:06AM -0800, Brian Norris wrote:
> > On Fri, Jan 06, 2023 at 07:17:53PM +0100, Daniel Vetter wrote:
> > > - fake vblanks with hrtimer, because on most hw when you turn off the crtc
> > >   the vblanks are also turned off, and so your compositor would still
> > >   hang. The vblank machinery already has all the code to make this happen
> > >   (and if it's not all, then i915 psr code should have it).
> > 
> > Is a timer better than an interrupt? I'm pretty sure the vblank
> > interrupts still can fire on Rockchip CRTC (VOP) (see also the other
> > branch of this thread), so this isn't really necessary. (IGT vblank
> > tests pass without hanging.) Unless you simply prefer a fake timer for
> > some reason.
> > 
> > Also, I still haven't found that fake timer machinery, but maybe I just
> > don't know what I'm looking for.
> 
> I ... didn't find it either. I'm honestly not sure whether this works for
> intel, or whether we do something silly like disable self-refresh when a
> vblank interrupt is pending :-/

Intel hardware doesn't enter PSR while the vblank interrupt is enabled.

-- 
Ville Syrjälä
Intel
