Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258A64D398C
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237293AbiCITJV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:09:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237292AbiCITJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:09:15 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA1F131949
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 11:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646852896; x=1678388896;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=B3Xdf38SaE8QjFdfNQGsY41Wo0+1F2fOs0UwsP9G5mU=;
  b=hIOUI683pDDRuUmO1ok9NuIHpEFYoFquMARKBFZNm7sSTsiwKYQi3J5B
   Y4yCbuy4VnefseDKdwIQkHD4NnMobRPC/AOYKv4POvNBy9b3rFFjAz9O2
   Er19bdcmrhx4WgkC6hKrEiCHlb39b3/YBfbgl+5Pq4CpS2TueXzbQuw2F
   eecsnTffHn4phG7K2Nm9IViRAQMfcG0yhQTAWE7VaJIA+lMWb4GoN7p0/
   oA9gbFVMyIwZwkwi5I4JsQ68pmUZor1HUC7eutlr/S2L9ZX1H2GahXw0p
   Bl0yZjyE88SYzNzd24yS98unqyrXfth80fWYO8Q/CeCmPE2XzWxoOQv95
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="253897152"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="253897152"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:08:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="642266570"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.151])
  by fmsmga002.fm.intel.com with SMTP; 09 Mar 2022 11:08:13 -0800
Received: by stinkbox (sSMTP sendmail emulation); Wed, 09 Mar 2022 21:08:12 +0200
Date:   Wed, 9 Mar 2022 21:08:12 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     "Lisovskiy, Stanislav" <stanislav.lisovskiy@intel.com>
Cc:     intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 6/8] drm/i915: Fix PSF GV point mask when SAGV is not
 possible
Message-ID: <Yij7HFOvBiVg+kqD@intel.com>
References: <20220309164948.10671-1-ville.syrjala@linux.intel.com>
 <20220309164948.10671-7-ville.syrjala@linux.intel.com>
 <20220309185959.GA9439@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220309185959.GA9439@intel.com>
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

On Wed, Mar 09, 2022 at 08:59:59PM +0200, Lisovskiy, Stanislav wrote:
> On Wed, Mar 09, 2022 at 06:49:46PM +0200, Ville Syrjala wrote:
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > 
> > Don't just mask off all the PSF GV points when SAGV gets disabled.
> > This should in fact cause the Pcode to reject the request since
> > at least one PSF point must remain enabled at all times.
> 
> Good point, however I think this is not the full fix:
> 
> BSpec says:
> 
> "At least one GV point of each type must always remain unmasked."
> 
> and
> 
> "The GV point of each type providing the highest bandwidth 
>  for display must always remain unmasked."
> 
> So I guess we should then also choose thr PSF GV point with
> the highest bandwidth as well.

The spec says PSF GV is fast enough to now stall the display data
fetch so we don't need to restrict the PSF points here.

-- 
Ville Syrjälä
Intel
