Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877453CBB92
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 20:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhGPSEn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229937AbhGPSEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 14:04:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A8FC60FE7;
        Fri, 16 Jul 2021 18:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626458503;
        bh=s7Fd477VakCUQjlVc/6FDwPgTBCmpR8IO7i1M1IhGIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D7DYXEpBO2oR63kbWefC3IFT6JbYuKPv+jf9seJzHWId9w4hL0cGMkcIroESVy0wT
         Kqky9ii1RylYsE5DRWTohfxfkbvqtqIO7wNQxWVtovmYH5gcc+SKhMvv3kv8WSq6HI
         7r5lXVqdXTKrGKp5d1a2BzX7NrFb7hPkTJyB8OQ4=
Date:   Fri, 16 Jul 2021 20:01:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.13 106/266] drm/amd/display: Cover edge-case when
 changing DISPCLK WDIVIDER
Message-ID: <YPHJfNE2M+2OU3Wi@kroah.com>
References: <20210715182613.933608881@linuxfoundation.org>
 <20210715182632.619513356@linuxfoundation.org>
 <20210715231255.38f8442b@mir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715231255.38f8442b@mir>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 11:12:55PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On 2021-07-15, Greg Kroah-Hartman wrote:
> > From: Wesley Chalmers <Wesley.Chalmers@amd.com>
> > 
> > [ Upstream commit 78ebca321999699f30ea19029726d1a3908b395f ]
> > 
> > [WHY]
> > When changing the DISPCLK_WDIVIDER value from 126 to 127, the change in
> > clock rate is too great for the FIFOs to handle. This can cause visible
> > corruption during clock change.
> > 
> > HW has handed down this register sequence to fix the issue.
> > 
> > [HOW]
> > The sequence, from HW:
> > a.	127 -> 126
> > Read  DIG_FIFO_CAL_AVERAGE_LEVEL
> > FIFO level N = DIG_FIFO_CAL_AVERAGE_LEVEL / 4
> > Set DCCG_FIFO_ERRDET_OVR_EN = 1
> > Write 1 to OTGx_DROP_PIXEL for (N-4) times
> > Set DCCG_FIFO_ERRDET_OVR_EN = 0
> > Write DENTIST_DISPCLK_RDIVIDER = 126
> > 
> > Because of frequency stepping, sequence a can be executed to change the
> > divider from 127 to any other divider value.
> > 
> > b.	126 -> 127
> > Read  DIG_FIFO_CAL_AVERAGE_LEVEL
> > FIFO level N = DIG_FIFO_CAL_AVERAGE_LEVEL / 4
> > Set DCCG_FIFO_ERRDET_OVR_EN = 1
> > Write 1 to OTGx_ADD_PIXEL for (12-N) times
> > Set DCCG_FIFO_ERRDET_OVR_EN = 0
> > Write DENTIST_DISPCLK_RDIVIDER = 127
> > 
> > Because of frequency stepping, divider must first be set from any other
> > divider value to 126 before executing sequence b.
> [...]
> 
> This patch seem to introduce a build regression for x86_64:
> 
>   CC [M]  drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.o
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c: In function 'dcn20_update_clocks_update_dentist':
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:154:26: error: 'const struct stream_encoder_funcs' has no member named 'get_fifo_cal_average_level'
>   154 |    if (!stream_enc->funcs->get_fifo_cal_average_level)
>       |                          ^~
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:156:34: error: 'const struct stream_encoder_funcs' has no member named 'get_fifo_cal_average_level'
>   156 |    fifo_level = stream_enc->funcs->get_fifo_cal_average_level(
>       |                                  ^~
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:159:15: error: 'const struct dccg_funcs' has no member named 'set_fifo_errdet_ovr_en'
>   159 |    dccg->funcs->set_fifo_errdet_ovr_en(
>       |               ^~
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:163:16: error: 'const struct dccg_funcs' has no member named 'otg_drop_pixel'
>   163 |     dccg->funcs->otg_drop_pixel(
>       |                ^~
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:166:15: error: 'const struct dccg_funcs' has no member named 'set_fifo_errdet_ovr_en'
>   166 |    dccg->funcs->set_fifo_errdet_ovr_en(
>       |               ^~
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:185:26: error: 'const struct stream_encoder_funcs' has no member named 'get_fifo_cal_average_level'
>   185 |    if (!stream_enc->funcs->get_fifo_cal_average_level)
>       |                          ^~
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:187:34: error: 'const struct stream_encoder_funcs' has no member named 'get_fifo_cal_average_level'
>   187 |    fifo_level = stream_enc->funcs->get_fifo_cal_average_level(
>       |                                  ^~
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:190:15: error: 'const struct dccg_funcs' has no member named 'set_fifo_errdet_ovr_en'
>   190 |    dccg->funcs->set_fifo_errdet_ovr_en(dccg, true);
>       |               ^~
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:192:16: error: 'const struct dccg_funcs' has no member named 'otg_add_pixel'
>   192 |     dccg->funcs->otg_add_pixel(dccg,
>       |                ^~
> /build/linux-5.13/drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:194:15: error: 'const struct dccg_funcs' has no member named 'set_fifo_errdet_ovr_en'
>   194 |    dccg->funcs->set_fifo_errdet_ovr_en(dccg, false);
>       |               ^~
> make[5]: *** [/build/linux-aptosid-5.13/scripts/Makefile.build:273: drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.o] Error 1
> make[4]: *** [/build/linux-aptosid-5.13/scripts/Makefile.build:516: drivers/gpu/drm/amd/amdgpu] Error 2
> make[3]: *** [/build/linux-aptosid-5.13/scripts/Makefile.build:516: drivers/gpu/drm] Error 2
> make[2]: *** [/build/linux-aptosid-5.13/scripts/Makefile.build:516: drivers/gpu] Error 2
> make[1]: *** [/build/linux-aptosid-5.13/Makefile:1864: drivers] Error 2
> make: *** [/build/linux-aptosid-5.13/Makefile:215: __sub-make] Error 2
> 
> Regards
> 	Stefan Lippers-Hollmann

Now dropped, thanks!

greg k-h
