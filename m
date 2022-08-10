Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFA6758EF80
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 17:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiHJPi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 11:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbiHJPiX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 11:38:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD93B2AC71
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 08:38:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A8788CE1CB2
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 15:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796BFC433C1;
        Wed, 10 Aug 2022 15:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660145898;
        bh=kR+fXsKAxABIT1HKS0zsO7tkAj9hgofrEX2EKzA30wM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PmfyGLY/LThm40Coer3DBqadas4GrDRpac7YJaLg2NiMC2TxHYXEBYIR4y97OdBdG
         +EpeeZfEdCIv6kt6C529IJfPQN4yumY/bCsmHy0mAatM/9YVUulkmmsPOCTuWD3y5H
         hOiOgZutafM6u4JwqxiL581dOXEdJfhhnYAr97tk=
Date:   Wed, 10 Aug 2022 17:38:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alex Deucher <alexdeucher@gmail.com>
Cc:     Alex Deucher <alexander.deucher@amd.com>, stable@vger.kernel.org,
        hgoffin@amazon.com, amd-gfx@lists.freedesktop.org
Subject: Re: [PATCH] drm/amdgpu: fix check in fbdev init
Message-ID: <YvPQ6MBF6V5FUEHF@kroah.com>
References: <20220719185659.2068735-1-alexander.deucher@amd.com>
 <CADnq5_MkB8xKHZxVsiXfWPA-QuVrrNCNXF=ScrYAPjNbAH36LA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADnq5_MkB8xKHZxVsiXfWPA-QuVrrNCNXF=ScrYAPjNbAH36LA@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 10, 2022 at 11:28:18AM -0400, Alex Deucher wrote:
> On Tue, Jul 19, 2022 at 2:57 PM Alex Deucher <alexander.deucher@amd.com> wrote:
> >
> > The new vkms virtual display code is atomic so there is
> > no need to call drm_helper_disable_unused_functions()
> > when it is enabled.  Doing so can result in a segfault.
> > When the driver switched from the old virtual display code
> > to the new atomic virtual display code, it was missed that
> > we enable virtual display unconditionally under SR-IOV
> > so the checks here missed that case.  Add the missing
> > check for SR-IOV.
> >
> > There is no equivalent of this patch for Linus' tree
> > because the relevant code no longer exists.  This patch
> > is only relevant to kernels 5.15 and 5.16.
> >
> > Fixes: 84ec374bd580 ("drm/amdgpu: create amdgpu_vkms (v4)")
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Cc: stable@vger.kernel.org # 5.15.x
> > Cc: hgoffin@amazon.com
> 
> Hi Greg,
> 
> Is there any chance this can get applied?  It fixes a regression on
> 5.15 and 5.16.

Ah, missed this as it was not obvious that this was a not-upstream
commit at all, sorry.

I'll dig it out of lore.kernel.org and queue it up for the next round of
releases, but note, this is our "busy time" with many patches marked for
stable.

Oh and 5.16 is long end-of-life, nothing anyone can do there, and no one
should be using that kernel version anymore, so no issues there.

thanks,

greg k-h
