Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFCB657454
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 09:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbiL1Iui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 03:50:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiL1IuX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 03:50:23 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856B9324;
        Wed, 28 Dec 2022 00:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672217422; x=1703753422;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version:content-transfer-encoding;
  bh=VQip/Z99parCgodreX+wts8zbKulSZQgR4ewC+MO0lI=;
  b=FQops5M7C/KzzCOBiFpCjxIPxOUdUi3rsBtLM1iSvnjfNCum6DXHZ6fE
   s1/HlfJwEwLnUfVvKyZ6GIPhKD0gvFCT++O48cRijt8xOp8jxDFEyWzfh
   JVAyOngA934aFpHg9ehD2bVJrn93+eRoKpW4kHLGc76CPLMn+CNc4e+9y
   uJyeI8/nwvTxVnPsI0yH4T2g0adtc4NHEvFKcHOEXuD1SCEsi82NPBnTs
   HmxAW+Gn/tNhZY0xQycGpTbikV7nJrbeJlaBytbQiqL1R5XUbKcrJBCRf
   wstbZjpR8OlT2ZsvOs6wC51ACixYc6jhZ2fhr/E/x+l3g3pjc+PnrG+a1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="322815663"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="322815663"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2022 00:50:20 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10573"; a="655251298"
X-IronPort-AV: E=Sophos;i="5.96,280,1665471600"; 
   d="scan'208";a="655251298"
Received: from kvkhairn-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.23.135])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2022 00:50:17 -0800
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Alexey Lukyachuk <skif@skif-web.ru>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     tvrtko.ursulin@linux.intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: dell wyse 3040 shutdown fix
In-Reply-To: <20221227204003.6b0abe65@alexey-Swift-SF314-42>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <20221225184413.146916-1-skif@skif-web.ru>
 <20221225185507.149677-1-skif@skif-web.ru> <Y6sfvUJmrb73AeJh@intel.com>
 <20221227204003.6b0abe65@alexey-Swift-SF314-42>
Date:   Wed, 28 Dec 2022 10:50:15 +0200
Message-ID: <875ydv29q0.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 27 Dec 2022, Alexey Lukyachuk <skif@skif-web.ru> wrote:
> On Tue, 27 Dec 2022 11:39:25 -0500
> Rodrigo Vivi <rodrigo.vivi@intel.com> wrote:
>
>> On Sun, Dec 25, 2022 at 09:55:08PM +0300, Alexey Lukyanchuk wrote:
>> > dell wyse 3040 doesn't peform poweroff properly, but instead remains i=
n=20
>> > turned power on state.
>>=20
>> okay, the motivation is explained in the commit msg..
>>=20
>> > Additional mutex_lock and=20
>> > intel_crtc_wait_for_next_vblank=20
>> > feature 6.2 kernel resolve this trouble.
>>=20
>> but this why is not very clear... seems that by magic it was found,
>> without explaining what race we are really protecting here.
>>=20
>> but even worse is:
>> what about those many random vblank waits in the code? what's the
>> reasoning?
>>=20
> I would like to say, that this solution was found in drm-tip repository:
> link: git://anongit.freedesktop.org/drm-tip
> I will quotate original commit message from Ville Syrj=C3=A4l=C3=A4=20
> <ville.syrjala@linux.intel.com>: "The spec tells us to do a bunch of=20
> vblank waits in the audio enable/disable sequences. Make it so."
> So it's just a backport of accepted patch.
> Which i wanna to propagate to stable versions

This is not how stable kernel backports work. Please read [1].

Does v6.2-rc1 work for you? It has all the relevant commits. Which
stable kernel are you trying to backport them to?

Though I must say I find it surprising that these changes would fix a
poweroff issue, and it certainly was not the goal. I'm wondering if it's
just a coincidence due to timing and/or locking changes.

Have you reported an issue at fdo gitlab [2]?


BR,
Jani.



[1] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
[2] https://gitlab.freedesktop.org/drm/intel/wikis/How-to-file-i915-bugs


--=20
Jani Nikula, Intel Open Source Graphics Center
