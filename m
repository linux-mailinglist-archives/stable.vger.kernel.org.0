Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCC64630C5
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 11:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhK3KQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 05:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbhK3KQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 05:16:30 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84478C061574
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 02:13:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BCB1DCE17D8
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 10:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9D1C53FC7;
        Tue, 30 Nov 2021 10:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638267187;
        bh=cMcn93w4UXcvb6lZ4/Y7gyJjQpTZyEbPlzsVfTvOLS4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0dUTveCYLAoXbj7dcxNUflutrtvqib/rzZMAOpFCUq1S7vLEIWBtMJyDy7bmS6v5R
         ZhOfgQOuwnZa2JwyehmMvimuZGtJAqBfXlHeCK71Ejxv8tOZoqBAwgk+5pbL89BlsF
         6J0aIHkvAxKKMYlkB04zdaoaD85E1/tJDdJNqPh8=
Date:   Tue, 30 Nov 2021 11:13:05 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Luben Tuikov <luben.tuikov@amd.com>
Subject: Re: [PATCH] drm/amdgpu/gfx9: switch to golden tsc registers for
 renoir+
Message-ID: <YaX5MWZNRMNGY5yi@kroah.com>
References: <20211129182527.26440-1-mario.limonciello@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129182527.26440-1-mario.limonciello@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 12:25:26PM -0600, Mario Limonciello wrote:
> From: Alex Deucher <alexander.deucher@amd.com>
> 
> commit 53af98c091bc ("drm/amdgpu/gfx9: switch to golden tsc registers
> for renoir+")
> 
> Renoir and newer gfx9 APUs have new TSC register that is
> not part of the gfxoff tile, so it can be read without
> needing to disable gfx off.
> 
> Acked-by: Luben Tuikov <luben.tuikov@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 46 ++++++++++++++++++++-------
>  1 file changed, 35 insertions(+), 11 deletions(-)
> 
> This is necessary for s0i3 to work well on GNOME41 which tries to access
> timestamps during suspend process causing GFX to wake up.
> 
> Modified to take use ASIC IDs rather than IP version checking
> Please apply this to both 5.14.y and 5.15.y.

Please note that 5.14.y is end-of-life as the front page of kernel.org
should show.

thanks,

greg k-h
