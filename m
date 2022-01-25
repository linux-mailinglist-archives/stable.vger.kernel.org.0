Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D4049AE2A
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 09:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451268AbiAYIgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 03:36:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51162 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450739AbiAYIdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 03:33:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5AAD6136A;
        Tue, 25 Jan 2022 08:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9417BC340E0;
        Tue, 25 Jan 2022 08:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643099603;
        bh=TB4aeFeA8ZJrU/9fg/+mfxiQAUKRnEctOkasXiFgvHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xLXipTOfbUhH4pKbgT33u/cyq34ki+KcuA/Kl8Q5g1ygeMbrdmItJSg3r30OTrzMQ
         6N2VPog9rIIrsX5wCspJS7xKAiFurmlMi3zLENd3NBYdnEO8iaPC9qe0gxU81NJ3KR
         X+U4AiDR4UXkoCKD2C6CsLAfxf38XdEYkndHQkhY=
Date:   Tue, 25 Jan 2022 09:33:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        David Yat Sin <david.yatsin@amd.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.16 0702/1039] drm/amdgpu: Dont inherit GEM object VMAs
 in child process
Message-ID: <Ye+10FecW3Su+9nu@kroah.com>
References: <20220124184125.121143506@linuxfoundation.org>
 <20220124184148.931014095@linuxfoundation.org>
 <e37beeb2-1ec0-9f7f-06f6-ee4df975a956@amd.com>
 <Ye+x0UwhhHWkgsr2@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ye+x0UwhhHWkgsr2@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 09:16:17AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 25, 2022 at 08:26:20AM +0100, Christian König wrote:
> > Hi Greg,
> > 
> > Am 24.01.22 um 19:41 schrieb Greg Kroah-Hartman:
> > > From: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
> > > 
> > > [ Upstream commit fbcdbfde87509d523132b59f661a355c731139d0 ]
> > > 
> > > When an application having open file access to a node forks, its shared
> > > mappings also get reflected in the address space of child process even
> > > though it cannot access them with the object permissions applied. With the
> > > existing permission checks on the gem objects, it might be reasonable to
> > > also create the VMAs with VM_DONTCOPY flag so a user space application
> > > doesn't need to explicitly call the madvise(addr, len, MADV_DONTFORK)
> > > system call to prevent the pages in the mapped range to appear in the
> > > address space of the child process. It also prevents the memory leaks
> > > due to additional reference counts on the mapped BOs in the child
> > > process that prevented freeing the memory in the parent for which we had
> > > worked around earlier in the user space inside the thunk library.
> > > 
> > > Additionally, we faced this issue when using CRIU to checkpoint restore
> > > an application that had such inherited mappings in the child which
> > > confuse CRIU when it mmaps on restore. Having this flag set for the
> > > render node VMAs helps. VMAs mapped via KFD already take care of this so
> > > this is needed only for the render nodes.
> > > 
> > > To limit the impact of the change to user space consumers such as OpenGL
> > > etc, limit it to KFD BOs only.
> > > 
> > > Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> > > Reviewed-by: Christian König <christian.koenig@amd.com>
> > > Signed-off-by: David Yat Sin <david.yatsin@amd.com>
> > > Signed-off-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
> > > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > 
> > Please drop this patch from all stable versions since it was reverted from
> > upstream later on.
> 
> The revert comes later in the patch series, so all should be ok :)

Looks like Sasha dropped this, so I'll go drop the revert as well.

thanks,

greg k-h
