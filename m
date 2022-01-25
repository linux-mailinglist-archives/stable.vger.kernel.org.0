Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EA149B7FF
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 16:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1582564AbiAYPwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 10:52:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35442 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1582571AbiAYPuH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 10:50:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32FA2B8189C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 15:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D794C340E0;
        Tue, 25 Jan 2022 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643125804;
        bh=wOGMXtMSDKMnsN1Pj97pWM+3VCDB2N623Qeax7GBtzo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PA+XQGUcfEhniFs1dyQrsuODZyxOxLkBBgzwM5Y14ghOLnvjmlbBLRlpS/WQljP8n
         VGut63upiYioSVlNW5NtURBHF+j0/Uk/mTR7Z+WNMJGjXH9qYPB77BqC0BMhp6uHiy
         5ByG/JlNGV3wcMRtBfdXt1q6I9k48vXbRNj8UbCw=
Date:   Tue, 25 Jan 2022 16:50:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org, Alexander.Deucher@amd.com,
        harry.wentland@amd.com
Subject: Re: [PATCH] drm/amdgpu: Use correct VIEWPORT_DIMENSION for DCN2
Message-ID: <YfAcKZALAKAMXs/O@kroah.com>
References: <20220125152111.22515-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125152111.22515-1-mario.limonciello@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 09:21:11AM -0600, Mario Limonciello wrote:
> For some reason this file isn't using the appropriate register
> headers for DCN headers, which means that on DCN2 we're getting
> the VIEWPORT_DIMENSION offset wrong.
> 
> This means that we're not correctly carving out the framebuffer
> memory correctly for a framebuffer allocated by EFI and
> therefore see corruption when loading amdgpu before the display
> driver takes over control of the framebuffer scanout.
> 
> Fix this by checking the DCE_HWIP and picking the correct offset
> accordingly.
> 
> Long-term we should expose this info from DC as GMC shouldn't
> need to know about DCN registers.
> 
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> (cherry picked from commit dc5d4aff2e99c312df8abbe1ee9a731d2913bc1b)
> ---
> This is backported from 5.17-rc1, but doesn't backport cleanly because
> v5.16 changed to IP version harvesting for ASIC detection.  5.15.y doesn't
> have this.
>  drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)

What stable tree(s) do you want this applied to?

And what happened to the original signed-off-by's on the original
commit?

thanks,

greg k-h
