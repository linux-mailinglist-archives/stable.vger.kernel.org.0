Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5CB4875FA
	for <lists+stable@lfdr.de>; Fri,  7 Jan 2022 11:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346728AbiAGK5q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 05:57:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:55224 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237991AbiAGK5o (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 05:57:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7F6B2CE29BE;
        Fri,  7 Jan 2022 10:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68250C36AE9;
        Fri,  7 Jan 2022 10:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641553060;
        bh=Zx/AXWLVluUT54cAqQJ0SxAQoNbFfocAhgDAYiIwEqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iynpA4ecmQlJKnuCXtmTCewwhRuYTkO+xGMDA6shpvAU1g/BMgheKruQ6239iylZS
         LyJZVGyvDp4+8OyDQYdWICOslNfB8ldCebQOBDfnA4lACgjlVrkgWQ5eCsfAwbwIJN
         y0D5gMOJJfZKf2k8O3nQlrTRs40E+6mi4sLjSxB4=
Date:   Fri, 7 Jan 2022 11:57:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alaa Hleihel <alaa@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 04/42] RDMA/mlx5: Fix releasing unallocated memory
 in dereg MR flow
Message-ID: <YdgcogmDQcZwLxxe@kroah.com>
References: <20211215172026.641863587@linuxfoundation.org>
 <20211215172026.789963312@linuxfoundation.org>
 <bbb587b1-4555-ba8d-fe43-d56d41a3c652@leemhuis.info>
 <3802192c-d9ce-8f4a-88c5-a87f58eaf37b@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3802192c-d9ce-8f4a-88c5-a87f58eaf37b@leemhuis.info>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 07, 2022 at 06:57:51AM +0100, Thorsten Leemhuis wrote:
> Hi Greg!
> 
> On 01.01.22 11:56, Thorsten Leemhuis wrote:
> > Hi, this is your Linux kernel regression tracker speaking.
> > 
> > On 15.12.21 18:20, Greg Kroah-Hartman wrote:
> >> From: Alaa Hleihel <alaa@nvidia.com>
> >>
> >> [ Upstream commit f0ae4afe3d35e67db042c58a52909e06262b740f ]
> >>
> >> For the case of IB_MR_TYPE_DM the mr does doesn't have a umem, even though
> >> it is a user MR. This causes function mlx5_free_priv_descs() to think that
> >> it is a kernel MR, leading to wrongly accessing mr->descs that will get
> >> wrong values in the union which leads to attempt to release resources that
> >> were not allocated in the first place.
> > 
> > TWIMC, that commit made it into 5.15.y, but is known to cause a
> > regression in v5.16-rc:
> > 
> > https://lore.kernel.org/lkml/f298db4ec5fdf7a2d1d166ca2f66020fd9397e5c.1640079962.git.leonro@nvidia.com/
> > https://lore.kernel.org/all/EEBA2D1C-F29C-4237-901C-587B60CEE113@oracle.com/
> > 
> > A fix for mainline was posted, but got stuck afaics:
> > https://lore.kernel.org/lkml/f298db4ec5fdf7a2d1d166ca2f66020fd9397e5c.1640079962.git.leonro@nvidia.com/
> > 
> > A revert was also discussed, but not performed:
> > https://lore.kernel.org/all/20211222101312.1358616-1-maorg@nvidia.com/
> 
> I assume your scripts will catch this, nevertheless FYI:
> 
> Below patch was reverted in mainline, as it "is not the full fix and
> still causes to call traces". You likely want to revert it from v5.15.y
> as well. For details see
> 
> 4163cb3d1980 ("Revert "RDMA/mlx5: Fix releasing unallocated memory in
> dereg MR flow"")
> 
> https://git.kernel.org/torvalds/c/4163cb3d1980383220ad7043002b930995dcba33

Thanks for the heads-up, I have now queued this patch up for 5.15.y.

greg k-h
