Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3EE58C98B
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 15:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236127AbiHHNeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 09:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbiHHNeL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 09:34:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1A360D0
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 06:34:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BF6D61232
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 13:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7715DC433D6;
        Mon,  8 Aug 2022 13:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659965649;
        bh=BPMVPEddu4tKfvny8baJvpxMnIOuF/BCiVtSsA9S8D0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e+Evu1l5xEwwEUhDlNsH+Tm3DNwySeDzi/j7leeCYo+jFfCgdAmduWwgie4VPMHfj
         gFPLUnpX3XviGkrDoLw7HNY5L9u0u6UGglIfIoIeq64mZvXiZr7HXAOncCOneP1sJj
         ICiD9no/SYiJNldB7pBWVhhLI0FiqsNLlAQXsthA=
Date:   Mon, 8 Aug 2022 15:34:07 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "chenjun (AM)" <chenjun102@huawei.com>
Cc:     Cengiz Can <cengiz.can@canonical.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "xuqiang (M)" <xuqiang36@huawei.com>
Subject: Re: [PATCH stable 4.14 v3 2/3] fbcon: Prevent that screen size is
 smaller than font size
Message-ID: <YvEQz8Y1mq1UX5QB@kroah.com>
References: <20220804122734.121201-1-chenjun102@huawei.com>
 <20220804122734.121201-3-chenjun102@huawei.com>
 <602ce75b5b6dba51bc24cace86c1ada27fb6b0e9.camel@canonical.com>
 <fdef7841f9474b108ced6e26afb0f21f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fdef7841f9474b108ced6e26afb0f21f@huawei.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 05, 2022 at 06:22:03AM +0000, chenjun (AM) wrote:
> 在 2022/8/5 14:09, Cengiz Can 写道:
> > On Thu, 2022-08-04 at 12:27 +0000, Chen Jun wrote:
> >> From: Helge Deller <deller@gmx.de>
> >>
> >> commit e64242caef18b4a5840b0e7a9bff37abd4f4f933 upstream
> >>
> >> We need to prevent that users configure a screen size which is smaller than the
> >> currently selected font size. Otherwise rendering chars on the screen will
> >> access memory outside the graphics memory region.
> >>
> >> This patch adds a new function fbcon_modechange_possible() which
> >> implements this check and which later may be extended with other checks
> >> if necessary.  The new function is called from the FBIOPUT_VSCREENINFO
> >> ioctl handler in fbmem.c, which will return -EINVAL if userspace asked
> >> for a too small screen size.
> >>
> >> Signed-off-by: Helge Deller <deller@gmx.de>
> >> Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> [Chen Jun: adjust context]
> >> Signed-off-by: Chen Jun <chenjun102@huawei.com>
> >> ---
> >>   drivers/video/fbdev/core/fbcon.c | 28 ++++++++++++++++++++++++++++
> >>   drivers/video/fbdev/core/fbmem.c | 10 +++++++---
> >>   include/linux/fbcon.h            |  4 ++++
> >>   3 files changed, 39 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
> >> index a97e94b1c84f..b84264e98929 100644
> >> --- a/drivers/video/fbdev/core/fbcon.c
> >> +++ b/drivers/video/fbdev/core/fbcon.c
> >> @@ -2706,6 +2706,34 @@ static void fbcon_set_all_vcs(struct fb_info *info)
> >>   		fbcon_modechanged(info);
> >>   }
> >>   
> >> +/* let fbcon check if it supports a new screen resolution */
> >> +int fbcon_modechange_possible(struct fb_info *info, struct fb_var_screeninfo *var)
> >> +{
> >> +	struct fbcon_ops *ops = info->fbcon_par;
> >> +	struct vc_data *vc;
> >> +	unsigned int i;
> >> +
> >> +	WARN_CONSOLE_UNLOCKED();
> >> +
> >> +	if (!ops)
> >> +		return 0;
> >> +
> >> +	/* prevent setting a screen size which is smaller than font size */
> >> +	for (i = first_fb_vc; i <= last_fb_vc; i++) {
> >> +		vc = vc_cons[i].d;
> >> +		if (!vc || vc->vc_mode != KD_TEXT ||
> >> +			   registered_fb[con2fb_map[i]] != info)
> >> +			continue;
> >> +
> >> +		if (vc->vc_font.width  > FBCON_SWAP(var->rotate, var->xres, var->yres) ||
> >> +		    vc->vc_font.height > FBCON_SWAP(var->rotate, var->yres, var->xres))
> >> +			return -EINVAL;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(fbcon_modechange_possible);
> >> +
> >>   static int fbcon_mode_deleted(struct fb_info *info,
> >>   			      struct fb_videomode *mode)
> >>   {
> >> diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
> >> index 9087d467cc46..264e8ca5efa7 100644
> >> --- a/drivers/video/fbdev/core/fbmem.c
> >> +++ b/drivers/video/fbdev/core/fbmem.c
> >> @@ -1134,9 +1134,13 @@ static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
> >>   			console_unlock();
> >>   			return -ENODEV;
> >>   		}
> >> -		info->flags |= FBINFO_MISC_USEREVENT;
> >> -		ret = fb_set_var(info, &var);
> >> -		info->flags &= ~FBINFO_MISC_USEREVENT;
> >> +		ret = fbcon_modechange_possible(info, &var);
> >> +		if (!ret) {
> >> +			info->flags |= FBINFO_MISC_USEREVENT;
> >> +			ret = fb_set_var(info, &var);
> >> +			info->flags &= ~FBINFO_MISC_USEREVENT;
> >> +		}
> >> +		lock_fb_info(info);
> >>   		unlock_fb_info(info);
> > 
> > Why do we lock and unlock here consecutively?
> > 
> > Can it be a leftover?
> > 
> > Because in upstream commit, lock encapsulates `fb_set_var`,
> > `fbcon_modechange_possible` and `fbcon_update_vcs` calls, which makes
> > sense.
> > 
> > Here, it doesn't.
> > 
> 
> Thanks, lock_fb_info(info) is wrong here.

Ok, I'm totally confused now.

I'm dropping all of these series from my queue now.  Please fix them up
and resend them for all pending stable trees (4.9.y, 4.14.y, and
4.19.y).

thanks,

greg k-h
