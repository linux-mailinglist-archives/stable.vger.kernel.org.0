Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057344DB7B3
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 19:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243333AbiCPSCx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 14:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236096AbiCPSCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 14:02:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967B2403E9
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 11:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647453697; x=1678989697;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=46B31t1RpVn51Y+u+KVgu7k19ErzLK1oxhC+qBwnj+I=;
  b=UwnYz65cM7TVW+k8GyAJ/+P9X3zkxuKZ960z5nC5t2s/lvXUktFyIEGJ
   jU06S2fKy9sW/SaN2AMgxNZQ+HfWNIUnN2MnKc4ONZfPqzlYuaoghwlG+
   TIGPf4yHJ/Ej4XxQPgK7CpkJGytFlVE139T9G3vD/1s8siRTwFkakg3ra
   8x2dNB9XsED05NLqxkLYIKYpVvfxqZE+N33Na5NhG3HZp+z9znnb5N4/d
   Ja/rXzeR93iKlXsti/uvEJOgRUZpOTxTLiXOBQVkKTdUc92Movq5mgdfm
   lELkwVQ1RZu12cZS9hhTY4WA2EUkYqpWmic2dL3PaKS2o8Wz0FvfQSwM/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="255508597"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="255508597"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 11:01:37 -0700
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="690677697"
Received: from unknown (HELO intel.com) ([10.237.72.65])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 11:01:34 -0700
Date:   Wed, 16 Mar 2022 20:01:57 +0200
From:   "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH v2 6/8] drm/i915: Fix PSF GV point mask when
 SAGV is not possible
Message-ID: <20220316180157.GA21786@intel.com>
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
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
> 
> Stan

Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>

> 
> > 
> > -- 
> > Ville Syrjälä
> > Intel
