Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE7A591A6D
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 14:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239304AbiHMM4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 08:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiHMMz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 08:55:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54BA17075
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 05:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EE9460B89
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 12:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7B4C433D6;
        Sat, 13 Aug 2022 12:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660395357;
        bh=jvqn0fx244qzYOS4iDFSsnziEQCpWTTwSxEuG/P5ctA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rlmehEoE9xF7f8y+2RsnNaDFwIWvIF362w4qz3z+r1Rb5nPZKewRSkBm6puW+F5NU
         6pdVYBV9+7RdMoSBcn0MOwNFotreYGu7vo+wjPXcVITsX9Mc33RmgcIZ44hNZuO6n0
         yWW2AjkfPzO9lYAfVVChIAG+1nU2R+utcqqMwkWw=
Date:   Sat, 13 Aug 2022 14:55:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     Alex Deucher <alexander.deucher@amd.com>, stable@vger.kernel.org,
        hgoffin@amazon.com, amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH] drm/amdgpu: fix check in fbdev init
Message-ID: <YvefW7SSPvTVr07y@kroah.com>
References: <20220719185659.2068735-1-alexander.deucher@amd.com>
 <CADnq5_MkB8xKHZxVsiXfWPA-QuVrrNCNXF=ScrYAPjNbAH36LA@mail.gmail.com>
 <YvPQ6MBF6V5FUEHF@kroah.com>
 <CADnq5_OtXNALuQwsp-yShKxsyZTnfhheSuf9UqfRkbtm9GddiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_OtXNALuQwsp-yShKxsyZTnfhheSuf9UqfRkbtm9GddiA@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 10, 2022 at 11:39:39AM -0400, Alex Deucher wrote:
> On Wed, Aug 10, 2022 at 11:38 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Aug 10, 2022 at 11:28:18AM -0400, Alex Deucher wrote:
> > > On Tue, Jul 19, 2022 at 2:57 PM Alex Deucher <alexander.deucher@amd.com> wrote:
> > > >
> > > > The new vkms virtual display code is atomic so there is
> > > > no need to call drm_helper_disable_unused_functions()
> > > > when it is enabled.  Doing so can result in a segfault.
> > > > When the driver switched from the old virtual display code
> > > > to the new atomic virtual display code, it was missed that
> > > > we enable virtual display unconditionally under SR-IOV
> > > > so the checks here missed that case.  Add the missing
> > > > check for SR-IOV.
> > > >
> > > > There is no equivalent of this patch for Linus' tree
> > > > because the relevant code no longer exists.  This patch
> > > > is only relevant to kernels 5.15 and 5.16.
> > > >
> > > > Fixes: 84ec374bd580 ("drm/amdgpu: create amdgpu_vkms (v4)")
> > > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > > Cc: stable@vger.kernel.org # 5.15.x
> > > > Cc: hgoffin@amazon.com
> > >
> > > Hi Greg,
> > >
> > > Is there any chance this can get applied?  It fixes a regression on
> > > 5.15 and 5.16.
> >
> > Ah, missed this as it was not obvious that this was a not-upstream
> > commit at all, sorry.
> >
> > I'll dig it out of lore.kernel.org and queue it up for the next round of
> > releases, but note, this is our "busy time" with many patches marked for
> > stable.
> >
> > Oh and 5.16 is long end-of-life, nothing anyone can do there, and no one
> > should be using that kernel version anymore, so no issues there.
> 
> Thanks Greg.  Much appreciated.

Sorry for the delay, now queued up.

greg k-h
