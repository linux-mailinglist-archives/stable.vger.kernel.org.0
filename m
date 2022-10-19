Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25776040FF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiJSKcc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbiJSKbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:31:47 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C32A2558B
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 03:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666174246; x=1697710246;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=wiZ5crfTcZrwyuGOzfa2NfIPfMuYS82ul2fFji+Qrl8=;
  b=c5/oN/D7I3Ayhk6aEJta5viK2oSGHi/MSaV0PYIKcbsSqJUZXByiIzUN
   ZLijgFDW3OEZyREgxFRsut9h0Zcf5LIa2XibDKnZETcxJf/TfVtPj2xa+
   6hulYQOJijQ5NY3pjIp8oovNIjQ9adr7SLQzkaksDyv/GKnc2aq4ITmy9
   rLbS8zSs4mFrBrUS/99rSb4hx8I9QtPTmzZroobQXbH2JBZP5Z7CF+c4V
   Q4AZf0cHfpe6+SVwWrgHLqvAvOsYnZ0AJ5iFnU0lwhkpLLU7kBSatf3hO
   tQsJDxsQ6+PQ/iRDj7By7RgwXkPz5scOXASpLwexs96YreVeV8PSyUyC4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="368408583"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="368408583"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 02:19:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10504"; a="624045181"
X-IronPort-AV: E=Sophos;i="5.95,195,1661842800"; 
   d="scan'208";a="624045181"
Received: from stinkpipe.fi.intel.com (HELO stinkbox) ([10.237.72.191])
  by orsmga007.jf.intel.com with SMTP; 19 Oct 2022 02:19:50 -0700
Received: by stinkbox (sSMTP sendmail emulation); Wed, 19 Oct 2022 12:19:49 +0300
Date:   Wed, 19 Oct 2022 12:19:49 +0300
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>
Cc:     Imre Deak <imre.deak@intel.com>, intel-gfx@lists.freedesktop.org,
        stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH 1/3] drm/i915/tgl+: Add locking around DKL
 PHY register accesses
Message-ID: <Y0/BNSKHS+GYkLCw@intel.com>
References: <20221018172042.1449885-1-imre.deak@intel.com>
 <87bkq8i3xp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bkq8i3xp.fsf@intel.com>
X-Patchwork-Hint: comment
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 12:00:02PM +0300, Jani Nikula wrote:
> On Tue, 18 Oct 2022, Imre Deak <imre.deak@intel.com> wrote:
> > Accessing the TypeC DKL PHY registers during modeset-commit,
> > -verification, DP link-retraining and AUX power well toggling is racy
> > due to these code paths being concurrent and the PHY register bank
> > selection register (HIP_INDEX_REG) being shared between PHY instances
> > (aka TC ports) and the bank selection being not atomic wrt. the actual
> > PHY register access.
> >
> > Add the required locking around each PHY register bank selection->
> > register access sequence.
> 
> I honestly think the abstraction here is at a too low level.
> 
> Too many places are doing DKL PHY register access to begin with. IMO the
> solution should be to abstract DKL PHY better, not to provide low level
> DKL PHY register accessors.
> 
> Indeed, this level of granularity leads to a lot of unnecessary
> lock/unlock that could have a longer span otherwise, and the interface
> does not lend itself for that.

It's no worse than uncore.lock. No one cares about that in
these codepaths either.

> Also requires separate bank selection for
> every write, nearly doubling the MMIO writes.

Drop in the ocean. This is all slow modeset stuff anyway.

IMO separate reg accessors is the correct way to handle indexed
registers unless you have some very specific performance concerns
to deal with.

> I think the choice of intel_tc.c is indicative of the problems in
> abstraction. That file has zero DKL PHY register access currently, but
> becomes the focal point of DKL PHY.
> 
> I'd aim at adding intel_dkl_phy.c which is the only place that includes
> intel_dkl_phy_regs.h and only place that directly uses the DKL PHY
> registers. And with that, maybe you don't need to add any DKL PHY
> specific register accessors.

Ripping out the PHY specific junk from eg. intel_ddi.c I
think would be a good goal. But that should also be done
for the mg phy.

-- 
Ville Syrjälä
Intel
