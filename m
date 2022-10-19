Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0A160406D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbiJSJzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234381AbiJSJzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:55:02 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79FB106935
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 02:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666171846; x=1697707846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dBfBKtwPMIoIidBaSHvXf7Yzdmj0u0uiQGhoY8SkPXA=;
  b=B899Vd2PxCFywvEt8wDRooce/1QEQXR5PxATYj4v37JrDwlMCzmMAu/e
   xSA9DY9p5btl5e+7OwCtiYHQ97se5HP9pDZco/iLNpGsoSLWFEcvY9F1l
   S0W+yQ2hVJ4kcaQdQcFN58UxcfyLWDJzM1Q0App1p5b43kkSyL7FsWLna
   1rjVlCuy+Ga/NW5/O9n2AIUE3UbtGXL5wPJpAoJyQ6wezrN1e9NXewSDe
   LB+Hg7H9iOqrBCEInGs/7pvOTOGpO6QJLsy/DtpjZlfsL96ZqqEOTWTbo
   QTf+Ok13MQUAef+xwTxmHnwYwAkqBickfJG8ryMUmTUNs81V3nDSXwy9U
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="305094680"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="305094680"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 02:30:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="631579524"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="631579524"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by fmsmga007.fm.intel.com with SMTP; 19 Oct 2022 02:30:43 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 19 Oct 2022 12:30:42 +0300
Date:   Wed, 19 Oct 2022 12:30:42 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/i915/tgl+: Add locking around DKL
 PHY register accesses
Message-ID: <Y0/Dwl3Bct0owF7S@intel.com>
References: <20221018172042.1449885-1-imre.deak@intel.com>
 <87bkq8i3xp.fsf@intel.com>
 <Y0/BNSKHS+GYkLCw@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y0/BNSKHS+GYkLCw@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 12:19:49PM +0300, Ville Syrjälä wrote:
> On Wed, Oct 19, 2022 at 12:00:02PM +0300, Jani Nikula wrote:
> > On Tue, 18 Oct 2022, Imre Deak <imre.deak@intel.com> wrote:
> > > Accessing the TypeC DKL PHY registers during modeset-commit,
> > > -verification, DP link-retraining and AUX power well toggling is racy
> > > due to these code paths being concurrent and the PHY register bank
> > > selection register (HIP_INDEX_REG) being shared between PHY instances
> > > (aka TC ports) and the bank selection being not atomic wrt. the actual
> > > PHY register access.
> > >
> > > Add the required locking around each PHY register bank selection->
> > > register access sequence.
> > 
> > I honestly think the abstraction here is at a too low level.
> > 
> > Too many places are doing DKL PHY register access to begin with. IMO the
> > solution should be to abstract DKL PHY better, not to provide low level
> > DKL PHY register accessors.
> > 
> > Indeed, this level of granularity leads to a lot of unnecessary
> > lock/unlock that could have a longer span otherwise, and the interface
> > does not lend itself for that.
> 
> It's no worse than uncore.lock. No one cares about that in
> these codepaths either.
> 
> > Also requires separate bank selection for
> > every write, nearly doubling the MMIO writes.
> 
> Drop in the ocean. This is all slow modeset stuff anyway.
> 
> IMO separate reg accessors is the correct way to handle indexed
> registers unless you have some very specific performance concerns
> to deal with.

Now, whether those accessors need to be visible everywere is another
matter. It should certainly be possible to suck all dkl phy stuff
into one file and keep the accessors static. But currently eveything
is grouped by function (PLLs in one file, vswing stuff in another,
etc.). We'd have to flip that around so that all the sub functions
of of each IP block is in the same file. Is that a better apporach?
Not sure.

-- 
Ville Syrjälä
Intel
