Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3516DEBA8
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 08:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjDLGSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 02:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjDLGSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 02:18:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4D05598
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 23:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAE4D62854
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 06:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB56C433D2;
        Wed, 12 Apr 2023 06:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681280280;
        bh=Tq1thgpcrc+ctTurMAw/r3w2BlaFmRYNib1KhkPWghU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V00KV9dMwOOSWohhvHeEEQ6zsBFDQ5+NTlPCTHszwnNTQcbF4G9SOguedFzZEJ2Nb
         0kLK2iW1bt3ZEzrbUn6gg+M7ZEDN62/AdDUFzIZnPk4LAXatItut6dYb/UnpkHG9lH
         n78AvQ8d9okhVgMKqwUsZJCPGRUw/sTMr29F2hrQ=
Date:   Wed, 12 Apr 2023 08:17:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc:     stable@vger.kernel.org, Manasi Navare <navaremanasi@google.com>,
        Drew Davenport <ddavenport@chromium.org>,
        Imre Deak <imre.deak@intel.com>,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>
Subject: Re: [PATCH 6.1.y 1/3] drm/i915: Split icl_color_commit_noarm() from
 skl_color_commit_noarm()
Message-ID: <2023041226-zoology-smoking-5d9c@gregkh>
References: <2023040313-periscope-celery-403f@gregkh>
 <20230403162618.18469-1-ville.syrjala@linux.intel.com>
 <2023041117-cannot-sensuous-6f62@gregkh>
 <ZDWCGGgxGvcsFXhi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZDWCGGgxGvcsFXhi@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 11, 2023 at 06:51:52PM +0300, Ville Syrjälä wrote:
> On Tue, Apr 11, 2023 at 03:58:49PM +0200, Greg KH wrote:
> > On Mon, Apr 03, 2023 at 07:26:16PM +0300, Ville Syrjala wrote:
> > > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > 
> > > We're going to want different behavior for skl/glk vs. icl
> > > in .color_commit_noarm(), so split the hook into two. Arguably
> > > we already had slightly different behaviour since
> > > csc_enable/gamma_enable are never set on icl+, so the old
> > > code was perhaps a bit confusing as well.
> > > 
> > > Cc: <stable@vger.kernel.org> #v5.19+
> > > Cc: <stable@vger.kernel.org> # 05ca98523481: drm/i915: Use _MMIO_PIPE() for SKL_BOTTOM_COLOR
> > > Cc: Manasi Navare <navaremanasi@google.com>
> > > Cc: Drew Davenport <ddavenport@chromium.org>
> > > Cc: Imre Deak <imre.deak@intel.com>
> > > Cc: Jouni Högander <jouni.hogander@intel.com>
> > > Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > Link: https://patchwork.freedesktop.org/patch/msgid/20230320095438.17328-2-ville.syrjala@linux.intel.com
> > > Reviewed-by: Imre Deak <imre.deak@intel.com>
> > > (cherry picked from commit f161eb01f50ab31f2084975b43bce54b7b671e17)
> > > Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > > (cherry picked from commit 76b767d4d1cd052e455cf18e06929e8b2b70101d)
> > > ---
> > >  drivers/gpu/drm/i915/display/intel_color.c | 21 ++++++++++++++++++++-
> > >  1 file changed, 20 insertions(+), 1 deletion(-)
> > 
> > This commit breaks the build.
> 
> You did cherry pick all the dependencies I listed?

Nope!  When you send a patch series, I had assumed that it was
self-contained :(

I'll try that and see what happens this time...

greg k-h
