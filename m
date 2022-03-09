Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 283D64D3AF4
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 21:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235137AbiCIUWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 15:22:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235113AbiCIUWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 15:22:51 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AB3366BC
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 12:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646857311; x=1678393311;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=eh6zljM6wl5zcQMcr53FpmShLHX8Lr9dendslzhPvOw=;
  b=TB5Q351zw1uLxqX4DRv39E/zYTCOk2lM8f/c1UWcgY79oE/IJnKnmKkz
   cL5KGyKHjyhp5k/5X971U1wYTyPDM1qM+I1G9BVJeuarenu3YW2a4qSGu
   6vN3+U5rYwIw9ZoSILdZUz3NzKNrMU2D7Tek0KxKHESyktfQz1x2pm/j6
   JqofLcH8+FBPTx2RC8aEp7PAB6McCE025Z8IBVWIyhcrR/wrx9In1FVr7
   OrR9Brj3UjhjYBPWrs+joaFPoGDvEJ3EpNzGgTX2lqul0EwPPB2eCCaE6
   5/AfJjAf62ih60wGF1qPCYcopyjGEJEqyDD/N80VtODAwGgObgCyxHlYs
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="318307454"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="318307454"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 12:21:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="642289394"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by fmsmga002.fm.intel.com with SMTP; 09 Mar 2022 12:21:48 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 09 Mar 2022 22:21:47 +0200
Date:   Wed, 9 Mar 2022 22:21:47 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 6/8] drm/i915: Fix PSF GV point mask when SAGV is not
 possible
Message-ID: <YikMW6lE4QwKAHOU@intel.com>
References: <20220309164948.10671-1-ville.syrjala@linux.intel.com>
 <20220309164948.10671-7-ville.syrjala@linux.intel.com>
 <20220309185959.GA9439@intel.com>
 <Yij7HFOvBiVg+kqD@intel.com>
 <20220309193458.GA9556@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220309193458.GA9556@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 09:34:58PM +0200, Lisovskiy, Stanislav wrote:
> On Wed, Mar 09, 2022 at 09:08:12PM +0200, Ville Syrjälä wrote:
> > On Wed, Mar 09, 2022 at 08:59:59PM +0200, Lisovskiy, Stanislav wrote:
> > > On Wed, Mar 09, 2022 at 06:49:46PM +0200, Ville Syrjala wrote:
> > > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > 
> > > > Don't just mask off all the PSF GV points when SAGV gets disabled.
> > > > This should in fact cause the Pcode to reject the request since
> > > > at least one PSF point must remain enabled at all times.
> > > 
> > > Good point, however I think this is not the full fix:
> > > 
> > > BSpec says:
> > > 
> > > "At least one GV point of each type must always remain unmasked."
> > > 
> > > and
> > > 
> > > "The GV point of each type providing the highest bandwidth 
> > >  for display must always remain unmasked."
> > > 
> > > So I guess we should then also choose thr PSF GV point with
> > > the highest bandwidth as well.
> > 
> > The spec says PSF GV is fast enough to now stall the display data
> > fetch so we don't need to restrict the PSF points here.
> 
> But why it asks to ensure that we have the PSF GV of highest bandwidth to
> stay always unmasked then?

I presume so you don't lock the memory bandwdith to some lower
performance point and hurt all the other things that need
memory bandwidth. Either that or there is some internal
implementation detail that simply doesn't work if you try to
permanently run at a lower performance point.

-- 
Ville Syrjälä
Intel
