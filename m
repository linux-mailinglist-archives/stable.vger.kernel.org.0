Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9019F59B3E2
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 15:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbiHUNW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 09:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHUNW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 09:22:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16961D0C6;
        Sun, 21 Aug 2022 06:22:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D418B80D55;
        Sun, 21 Aug 2022 13:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B3CC433D6;
        Sun, 21 Aug 2022 13:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661088175;
        bh=uY1Bc6u8IJRS5yHXdFsUKDWlNwYjZsaz1+eyGUsklY8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gCLDcUMef1cPpYwTQGiowCEsA0MBZNL5iQHJPHDUrjRKjtgWnRWM6FmHKH+iZ7IgP
         RW0kKyoqZR8ZGSUf5Fdf7UGCe78hXHH3o9PWvU027w/cQvFAbwYDIk+AIjo0IP7PaS
         lbkdXwJ7gudfKN+T4goIVgw7iwJBWpoQdRcWkZjY=
Date:   Sun, 21 Aug 2022 15:22:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Doug Anderson <dianders@chromium.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>,
        Gao Chao <gaochao49@huawei.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: Re: [PATCH 5.18 0309/1095] drm/panel: Fix build error when
 CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=y && CONFIG_DRM_DISPLAY_HELPER=m
Message-ID: <YwIxrK8cK31SU2+t@kroah.com>
References: <20220815180429.240518113@linuxfoundation.org>
 <20220815180442.585574345@linuxfoundation.org>
 <CAD=FV=UK3Oyb9N9TpDqa55VEukhkjL1+GRO8+yLVxdFMuE=Mrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=FV=UK3Oyb9N9TpDqa55VEukhkjL1+GRO8+yLVxdFMuE=Mrw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 02:33:32PM -0700, Doug Anderson wrote:
> Hi,
> 
> On Mon, Aug 15, 2022 at 12:09 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > From: Gao Chao <gaochao49@huawei.com>
> >
> > [ Upstream commit a67664860f7833015a683ea295f7c79ac2901332 ]
> >
> > If CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20=y && CONFIG_DRM_DISPLAY_HELPER=m,
> > bulding fails:
> >
> > drivers/gpu/drm/panel/panel-samsung-atna33xc20.o: In function `atana33xc20_probe':
> > panel-samsung-atna33xc20.c:(.text+0x744): undefined reference to
> >  `drm_panel_dp_aux_backlight'
> > make: *** [vmlinux] Error 1
> >
> > Let CONFIG_DRM_PANEL_SAMSUNG_ATNA33XC20 select DRM_DISPLAY_DP_HELPER and
> > CONFIG_DRM_DISPLAY_HELPER to fix this error.
> >
> > Fixes: 32ce3b320343 ("drm/panel: atna33xc20: Introduce the Samsung ATNA33XC20 panel")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Gao Chao <gaochao49@huawei.com>
> > Reviewed-by: Douglas Anderson <dianders@chromium.org>
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Link: https://patchwork.freedesktop.org/patch/msgid/20220524024551.539-1-gaochao49@huawei.com
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/gpu/drm/panel/Kconfig | 2 ++
> >  1 file changed, 2 insertions(+)
> 
> While it doesn't hurt to land this patch as-is on 5.18 and older
> kernels, it's not quite right. The symbols that this patch 'select'
> don't actually exist on 5.18. ;-) Doing a `git grep` of
> `DRM_DISPLAY_DP_HELPER` shows no hits except the one introduced in
> this patch...
> 
> If you want the equivalent fix for v5.18 and older, I believe you'd want:
> 
> select DRM_DP_HELPER
> select DRM_KMS_HELPER
> 
> See commit 3755d35ee1d2 ("drm/panel: Select DRM_DP_HELPER for
> DRM_PANEL_EDP") and commit 3c3384050d68 ("drm: Don't make
> DRM_PANEL_BRIDGE dependent on DRM_KMS_HELPERS") which added those for
> the (very similar) panel-edp.
> 
> The first of those is what got changed in v5.19 in commit 1e0f66420b13
> ("drm/display: Introduce a DRM display-helper module")
> 
> So I guess the tl;dr:
> 
> * If you leave this patch in 5.18 (and 5.15), nothing bad will happen
> but the broken "randconfig" won't be fixed.
> 
> * If you revert this patch in 5.18 (and 5.15) also nothing bad will
> happen but also the broken "randconfig" won't be fixed.
> 
> * If someone cares about the randconfig on 5.15 / 5.18, we need a
> backport that adapts what's selected to the old symbol names.

Thanks for letting us know, I'll leave it alone for now and see if
anyone has problems.

greg k-h
