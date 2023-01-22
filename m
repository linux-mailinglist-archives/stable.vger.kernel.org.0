Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7EF676DB4
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 15:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjAVOeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 09:34:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjAVOeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 09:34:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77C918B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 06:34:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F9B560C3B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 14:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E6DC433D2;
        Sun, 22 Jan 2023 14:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674398050;
        bh=MVTamkUMJoketFbv2TGbZ5mIJSt4d+YVkRAO4aDYmEY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZOxgA7dp28W4152XMVWcouKhGLJuHyKdZpWTPVwoQSKAoQ3Rp7YTXe0fdvWzGKrq8
         u6Zik9JJvetKI/l5KzseAUWDRCBdYc0Q9F5k6zeri+s1oZqdLWhA3gjVHjme+43ygs
         T+SJ1PjHkVlb7+mCUGFaZ7WOFApGn8yT3xemjzfE=
Date:   Sun, 22 Jan 2023 15:34:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: Re: Minor changes for supporting products with GC 11.0.4
Message-ID: <Y81JYFvtYMLtOcYR@kroah.com>
References: <MN0PR12MB61011CBAC4D256484D291A8BE2C19@MN0PR12MB6101.namprd12.prod.outlook.com>
 <MN0PR12MB610117420F72DB3E08FD0C57E2C79@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB610117420F72DB3E08FD0C57E2C79@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 08:14:17PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> These merged into 6.1.7 from Sasha:
> drm/amdgpu: add soc21 common ip block support for GC 11.0.4	
> drm/amdgpu: Enable pg/cg flags on GC11_0_4 for VCN
> 
> So here is an updated series of what's left:
> 
> 69dc98bbd441 ("drm/amdgpu/discovery: enable soc21 common for GC 11.0.4")
> d5fd8c89ed20 ("drm/amdgpu/discovery: enable gmc v11 for GC 11.0.4")
> b952d6b3d3ff ("drm/amdgpu/discovery: enable gfx v11 for GC 11.0.4")
> 6a6af77570ad ("drm/amdgpu/discovery: enable mes support for GC v11.0.4")
> 94ab70685844 ("drm/amdgpu: set GC 11.0.4 family")
> dd2d9c7fd771 ("drm/amdgpu/discovery: set the APU flag for GC 11.0.4")
> 1763cb65e870 ("drm/amdgpu: add gfx support for GC 11.0.4")
> d0ca8248999e ("drm/amdgpu: add gmc v11 support for GC 11.0.4")
> 7c1389f1b122 ("drm/amdgpu/discovery: add PSP IP v13.0.11 support")
> 16412a94364d ("drm/amdgpu/pm: enable swsmu for SMU IP v13.0.11")
> 51e7a2168769 ("drm/amdgpu: add smu 13 support for smu 13.0.11")
> 9f83e61201bb ("drm/amdgpu/pm: add GFXOFF control IP version check for SMU IP v13.0.11")
> 18ad18853cf2 ("drm/amdgpu/soc21: add mode2 asic reset for SMU IP v13.0.11")
> 069a5af97ce3 ("drm/amdgpu/pm: use the specific mailbox registers only for SMU IP v13.0.4")
> 7308ceb44663 ("drm/amdgpu/discovery: enable nbio support for NBIO v7.7.1")
> 2c83e3fd928b ("drm/amdgpu: enable PSP IP v13.0.11 support")
> f2b91e5a7cc0 ("drm/amdgpu: enable GFX IP v11.0.4 CG support")
> a89e2965da6e ("drm/amdgpu: enable GFX Power Gating for GC IP v11.0.4")
> f9caa237372b ("drm/amdgpu: enable GFX Clock Gating control for GC IP v11.0.4")
> 97074216917b ("drm/amdgpu: add tmz support for GC 11.0.1")
> 2aecbe492a3c ("drm/amdgpu: add tmz support for GC IP v11.0.4")

All now queued up, thanks.

greg k-h
