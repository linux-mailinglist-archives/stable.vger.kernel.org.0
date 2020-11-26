Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CA32C51A5
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 10:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbgKZJxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 04:53:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:14179 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733102AbgKZJxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Nov 2020 04:53:39 -0500
IronPort-SDR: kG0NBu6QDKxFtQ2Cviv8KzPeQVoI/ZZ7QVjeu3GeIyIBKPJchYo10cKza7jX2ZVju2To+sfg5x
 EPPJF4RV9hZg==
X-IronPort-AV: E=McAfee;i="6000,8403,9816"; a="190416160"
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="190416160"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 01:53:37 -0800
IronPort-SDR: JGHQn+QD7xbDF8ab9HvcWO+SAq2dMi4pdmH+vTRc4Wz9wXCYi/wqh9mUbTT4c0Dme2OEFgETaY
 Eigx0q6TfgYA==
X-IronPort-AV: E=Sophos;i="5.78,371,1599548400"; 
   d="scan'208";a="371086581"
Received: from genxfsim-desktop.iind.intel.com (HELO intel.com) ([10.223.74.178])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2020 01:53:34 -0800
Date:   Thu, 26 Nov 2020 15:09:50 +0530
From:   Anshuman Gupta <anshuman.gupta@intel.com>
To:     Imre Deak <ville.syrjala@linux.intel.com>
Cc:     Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
Subject: Re: [RFC] drm/i915/dp: PPS registers doesn't require AUX power
Message-ID: <20201126093947.GM13853@intel.com>
References: <20201124095847.14098-1-anshuman.gupta@intel.com>
 <20201124164406.GG1750458@ideak-desk.fi.intel.com>
 <20201125074624.GJ13853@intel.com>
 <20201125162444.GC1968234@ideak-desk.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201125162444.GC1968234@ideak-desk.fi.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-11-25 at 18:24:44 +0200, Imre Deak wrote:
> +Ville.
Hi Ville ,
Let me provide you some context over the issue which requires your input.
TGL on chorome OS has observed some display glitches when brightness is being updated
at very fast rate. This has surfaced out two issue.
1. Getting the AUX power when accessing the PPS registers on platform with split PCH.
2. The race between DC3CO disabling delay and flips. (B.Spec says 200us dc3co exit delay)
   I will send a separate RFC patch to fix this issue.

Current patch is addressing issue1, 
IMHO it is unnecessary to take AUX power for pps register read for checking
whether backlight was enabled. This is causing flip to race with
DC3CO exit delay.
Could you please provide your input to this . 

Thanks,
Anshuman Gupta.   
> 
> On Wed, Nov 25, 2020 at 01:16:27PM +0530, Anshuman Gupta wrote:
> > On 2020-11-24 at 18:44:06 +0200, Imre Deak wrote:
> > > On Tue, Nov 24, 2020 at 03:28:47PM +0530, Anshuman Gupta wrote:
> > > > Platforms with South Display Engine on PCH, doesn't
> > > > require to get/put the AUX power domain in order to
> > > > access PPS register because PPS registers are always on
> > > > with South display on PCH.
> > > > 
> > > > Cc: Imre Deak <imre.deak@intel.com>
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Anshuman Gupta <anshuman.gupta@intel.com>
> > > 
> > > Could you describe the issue the patch is fixing?
> >
> > This fixes the display glitches causes by race between brightness
> > update thread and flip thread.
> 
> Flips should work even with asynchronous DC3co (or any DC state)
> disabling, at least according to the spec the HW handles this. Only
> modesetting and AUX transfers have restriction wrt. DC state handling
> (where DC states need to get disabled).
> 
> I think the exact restriction needs to be clarified with HW people: Is
> only the DC3co disable -> flip or also the opposite sequence
> problematic? Is it only DC3co or also DC5/6 affected?
> 
> > While brightness is being updated it reads pp_ctrl reg to check
> > whether backlight is enabled and get/put the AUX power domain, this
> > enables and disable DC Off power well(DC3CO) back and forth.
> >
> > IMO there are two work item for above race needed to be addressed.
> > 1. Don't get AUX power for PPS register access (this patch addressed this).
> > 2. skl_program_plane() should wait for DC3CO exit delay to avoid any race with
> >    DC3CO disable sequence. (WIP)      
> 
> DC states can be disabled asynchronously with a flip modeset, not only
> for panel brightness setting, but also AUX transfers for instance. So I
> think we'd need to add locking against DC state changes to
> intel_pipe_update_start()/end(). Probably the easiest would be to use
> the power_domains->lock for this.
> 
> --Imre
