Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB913CBB90
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 20:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhGPSE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:04:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231397AbhGPSE3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 14:04:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9049E613D3;
        Fri, 16 Jul 2021 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626458493;
        bh=E1EKMQQeWc+/Gvs/ODJCXt2BVLvvvGKp3Nl3lGt6ksA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pdBu7gov+7E0hdd9FChutuB1lRmeDNPYmM9h9iGmlfJAM6P+hkOGj05e6UIpCw0ow
         Sirtni1i+BPzljAftTjELxHiZMKuFZZzzjuLh0xhn3sB3QsxybDRzsE4wcpQl7tRUy
         CaRGEiPB9dcpfJfkomce7iE441Mct44A6zAF9zSQ=
Date:   Fri, 16 Jul 2021 20:01:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/266] 5.13.3-rc1 review
Message-ID: <YPHJcsohJ/yklDhj@kroah.com>
References: <20210715182613.933608881@linuxfoundation.org>
 <2eeb4711-8ad3-9d87-23b9-ba298cd462dc@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2eeb4711-8ad3-9d87-23b9-ba298cd462dc@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 08:26:32AM -0700, Guenter Roeck wrote:
> On 7/15/21 11:35 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.13.3 release.
> > There are 266 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> > Anything received after that time might be too late.
> > 
> 
> This one is a bit surprising.
> 
> Build reference: v5.13.2-267-g7e5885d
> Compiler version: x86_64-linux-gcc (GCC) 11.1.0
> 
> Building i386:allyesconfig ... failed
> --------------
> Error log:
> drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c: In function 'dcn20_update_clocks_update_dentist':
> drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:154:47: error: 'const struct stream_encoder_funcs' has no member named 'get_fifo_cal_average_level'
> 
> Turns out that CONFIG_DRM_AMD_DC_DCN is only enabled with allyesconfig
> for ARCH=i386 but not for ARCH=x86_64, and get_fifo_cal_average_level
> is indeed not a member of struct stream_encoder_funcs in v5.13.y-queue.
> This strongly suggests that commit a39c5ab96adc ("drm/amd/display: Cover
> edge-case when changing DISPCLK WDIVIDER") either needs to be dropped
> from v5.13.y, or it needs to be backported (and tested) properly.

I've now dropped this, thanks.

greg k-h
