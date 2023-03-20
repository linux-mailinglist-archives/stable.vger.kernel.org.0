Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42906C1363
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjCTN3A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjCTN24 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:28:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B932596D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35C8BB80DD4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EF4C4339C;
        Mon, 20 Mar 2023 13:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679318889;
        bh=+4hfR7FRnWoFkcY5muup1dYEccZSPx9x35eXcItS+kE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K8FaPs4wClF5CAKIi8KriQHi/KRlajW//XNMPdJivW+sdFbkXB3/z2TwPiMJPIvQs
         7en4PpSO9XF8TsZ40GGzEkvO6b+Mmm51t8+1Yzv8DC2JU5ad4bZdhLr1mlAID45h6d
         4Q6cA5o1SdALaYV6boD82uEYsmQW0ztyIECKBsbs=
Date:   Mon, 20 Mar 2023 14:28:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     John Harrison <john.c.harrison@intel.com>
Cc:     stable@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 5.4.y] drm/i915: Don't use BAR mappings for ring buffers
 with LLC
Message-ID: <ZBhfYUnt2gPxEOam@kroah.com>
References: <167820543971229@kroah.com>
 <20230314022211.1393031-1-John.C.Harrison@Intel.com>
 <ZBF48kVhFmXIsR+K@kroah.com>
 <a5cf5572-4160-3efb-4f80-aaf53aa06efe@intel.com>
 <ZBIHJD5FkxiammjB@kroah.com>
 <5ed286b7-c2df-9e63-d85a-be9994f93eec@intel.com>
 <ZBRkAZwItdidH32z@kroah.com>
 <17301b8c-19e0-4364-3e4c-c1c3d8cc45aa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17301b8c-19e0-4364-3e4c-c1c3d8cc45aa@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 17, 2023 at 09:07:50PM -0700, John Harrison wrote:
> On 3/17/2023 05:58, Greg KH wrote:
> > On Thu, Mar 16, 2023 at 01:58:35PM -0700, John Harrison wrote:
> > > On 3/15/2023 10:57, Greg KH wrote:
> > > > On Wed, Mar 15, 2023 at 10:07:53AM -0700, John Harrison wrote:
> > > > > On 3/15/2023 00:51, Greg KH wrote:
> > > > > > On Mon, Mar 13, 2023 at 07:22:11PM -0700, John.C.Harrison@Intel.com wrote:
> > > > > > > From: John Harrison <John.C.Harrison@Intel.com>
> > > > > > > 
> > > > > > > Direction from hardware is that ring buffers should never be mapped
> > > > > > > via the BAR on systems with LLC. There are too many caching pitfalls
> > > > > > > due to the way BAR accesses are routed. So it is safest to just not
> > > > > > > use it.
> > > > > > > 
> > > > > > > Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
> > > > > > > Fixes: 9d80841ea4c9 ("drm/i915: Allow ringbuffers to be bound anywhere")
> > > > > > > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > > > > > > Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> > > > > > > Cc: Jani Nikula <jani.nikula@linux.intel.com>
> > > > > > > Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > > > > > > Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
> > > > > > > Cc: intel-gfx@lists.freedesktop.org
> > > > > > > Cc: <stable@vger.kernel.org> # v4.9+
> > > > > > > Tested-by: Jouni Högander <jouni.hogander@intel.com>
> > > > > > > Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
> > > > > > > Link: https://patchwork.freedesktop.org/patch/msgid/20230216011101.1909009-3-John.C.Harrison@Intel.com
> > > > > > > (cherry picked from commit 65c08339db1ada87afd6cfe7db8e60bb4851d919)
> > > > > > > Signed-off-by: Jani Nikula <jani.nikula@intel.com>
> > > > > > > (cherry picked from commit 85636167e3206c3fbd52254fc432991cc4e90194)
> > > > > > > Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
> > > > > > > ---
> > > > > > >     drivers/gpu/drm/i915/gt/intel_ringbuffer.c | 4 ++--
> > > > > > >     1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > > Also queued up for 5.10.y, you forgot that one :)
> > > > > I'm still working through the backlog of them.
> > > > > 
> > > > > Note that these patches must all be applied as a pair. The 'don't use
> > > > > stolen' can be applied in isolation but won't totally fix the problem.
> > > > > However, applying 'don't use BAR mappings' without applying the stolen patch
> > > > > first will results in problems such as the failure to boot that was recently
> > > > > reported and resulted in a revert in one of the trees.
> > > > I do not understand, you only submitted 1 patch here, what is the
> > > > "pair"?
> > > The original patch series was two patches -
> > > https://patchwork.freedesktop.org/series/114080/. One to not use stolen
> > > memory and the other to not use BAR mappings. If the anti-BAR patch is
> > > applied without the anti-stolen patch then the i915 driver will attempt to
> > > access stolen memory directly which will fail. So both patches must be
> > > applied and in the correct order to fix the problem of cache aliasing when
> > > using BAR accesses on LLC systems.
> > > 
> > > As above, I am working my way through the bunch of 'FAILED patch' emails.
> > > The what-to-do instructions in those emails explicitly say to send the patch
> > > individually in reply to the 'FAILED' message rather than as part of any
> > > original series.
> > So what commits exactly in Linus's tree should be in these stable
> > branches?  Sorry, I still do not understand if we are missing one or if
> > we need to revert something.
> > 
> > confused,
> > 
> > greg k-h
> As far as I can tell, I have replied to all the "FAILED: patch" emails now.
> There should be a versions of these two patches available for all trees
> (being 4.14, 4.19, 5.4, 5.10 and 5.15):
>     690e0ec8e63d drm/i915: Don't use stolen memory for ring buffers with LLC

Your backports of this are all now queued up, thanks.

greg k-h
