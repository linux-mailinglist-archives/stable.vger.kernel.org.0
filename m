Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148B649E697
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 16:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243154AbiA0PsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 10:48:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56770 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243118AbiA0PsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 10:48:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D2D1617FE
        for <stable@vger.kernel.org>; Thu, 27 Jan 2022 15:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40624C340E8;
        Thu, 27 Jan 2022 15:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643298480;
        bh=RpZ6GZ5XpQD04R5Ydos1Y+RZUXyiT6UujapK2hl/BgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O/J0VJVQZG1Pwo+p+30qgAACtsMgn3Z8ki/5W42elep7YihMxpcDeLlGC2W5E7Q/g
         bxXgi8NmWAFTDXbSWZA/fZjp3S3jVtZvHOVbv6AiczuiaWqTsDBxlwaS/nr7bV2Zhb
         zcPcAvJK/2zWjLOY9IiXE7juQlpV66tpqKMqQCI0=
Date:   Thu, 27 Jan 2022 16:47:57 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Wentland, Harry" <Harry.Wentland@amd.com>
Subject: Re: [PATCH] drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2
Message-ID: <YfK+rc4mowKwp4VM@kroah.com>
References: <20220125152111.22515-1-mario.limonciello@amd.com>
 <YfAcKZALAKAMXs/O@kroah.com>
 <BL1PR12MB5157FC7109F99B0D2DB265B5E25F9@BL1PR12MB5157.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5157FC7109F99B0D2DB265B5E25F9@BL1PR12MB5157.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 03:52:47PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > Sent: Tuesday, January 25, 2022 09:50
> > To: Limonciello, Mario <Mario.Limonciello@amd.com>
> > Cc: stable@vger.kernel.org; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; Wentland, Harry
> > <Harry.Wentland@amd.com>
> > Subject: Re: [PATCH] drm/amdgpu: Use correct VIEWPORT_DIMENSION for
> > DCN2
> > 
> > On Tue, Jan 25, 2022 at 09:21:11AM -0600, Mario Limonciello wrote:
> > > For some reason this file isn't using the appropriate register
> > > headers for DCN headers, which means that on DCN2 we're getting
> > > the VIEWPORT_DIMENSION offset wrong.
> > >
> > > This means that we're not correctly carving out the framebuffer
> > > memory correctly for a framebuffer allocated by EFI and
> > > therefore see corruption when loading amdgpu before the display
> > > driver takes over control of the framebuffer scanout.
> > >
> > > Fix this by checking the DCE_HWIP and picking the correct offset
> > > accordingly.
> > >
> > > Long-term we should expose this info from DC as GMC shouldn't
> > > need to know about DCN registers.
> > >
> > > Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> > > (cherry picked from commit dc5d4aff2e99c312df8abbe1ee9a731d2913bc1b)
> > > ---
> > > This is backported from 5.17-rc1, but doesn't backport cleanly because
> > > v5.16 changed to IP version harvesting for ASIC detection.  5.15.y doesn't
> > > have this.
> > >  drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 14 +++++++++++++-
> > >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > What stable tree(s) do you want this applied to?
> > 
> 
> The original commit it was cherry-picked from was CC to @stable and it
> should have applied to 5.16 from that. 
> 
> This fixed commit should go into 5.15.y.

Thanks, now queued up.

> > And what happened to the original signed-off-by's on the original
> > commit?
> 
> I dropped them because I had to change code to do the backport, it didn't seem reasonable
> to me to keep all of their ACK's/signed-off-by's on the code still.
> 
> If that's incorrect, please let me know and I can re-send with the exact same commit message.

Please keep them.  I've fixed this up for now, so no need for a resend.

thanks,

greg k-h
