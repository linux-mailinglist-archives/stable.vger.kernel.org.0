Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAFB63DAE5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 17:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiK3Ql3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 11:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiK3Ql2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 11:41:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B80880F6;
        Wed, 30 Nov 2022 08:41:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19735B81BC6;
        Wed, 30 Nov 2022 16:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CD6C433D6;
        Wed, 30 Nov 2022 16:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669826483;
        bh=yQuWI4MA6bwmVUUGK3RMPsD7clpwM/nL4h1BMZ9rZP8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gyJLWfaKHPO/6CjmBIWsojaCjIog/l9SJT+5V9J1BUGCuIfKGtxXtCH16FSeNhdf/
         pZZGyjKy5FrsyflRUO3W/ZaEkHZ0js4EK7MlyAEmyG8fBoxAPEFLUmR3l6RGilwub0
         e8yUT/1kYxIlGKis4pNXzdQvVwoRoTH73sGPcaXg=
Date:   Wed, 30 Nov 2022 17:41:21 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ulrich Hecht <uli@fpond.eu>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>,
        Letu Ren <fantasquex@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>,
        "pavel@denx.de" <pavel@denx.de>
Subject: Re: [PATCH 4.9 01/42] fbdev: fb_pm2fb: Avoid potential divide by
 zero error
Message-ID: <Y4eHsZ+/68RH8hFe@kroah.com>
References: <20220913140342.228397194@linuxfoundation.org>
 <20220913140342.308723271@linuxfoundation.org>
 <970394644.1257305.1669185279738@webmail.strato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <970394644.1257305.1669185279738@webmail.strato.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 07:34:39AM +0100, Ulrich Hecht wrote:
> 
> > On 09/13/2022 4:07 PM CEST Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> >  
> > From: Letu Ren <fantasquex@gmail.com>
> > 
> > commit 19f953e7435644b81332dd632ba1b2d80b1e37af upstream.
> > 
> > In `do_fb_ioctl()` of fbmem.c, if cmd is FBIOPUT_VSCREENINFO, var will be
> > copied from user, then go through `fb_set_var()` and
> > `info->fbops->fb_check_var()` which could may be `pm2fb_check_var()`.
> > Along the path, `var->pixclock` won't be modified. This function checks
> > whether reciprocal of `var->pixclock` is too high. If `var->pixclock` is
> > zero, there will be a divide by zero error. So, it is necessary to check
> > whether denominator is zero to avoid crash. As this bug is found by
> > Syzkaller, logs are listed below.
> > 
> > divide error in pm2fb_check_var
> > Call Trace:
> >  <TASK>
> >  fb_set_var+0x367/0xeb0 drivers/video/fbdev/core/fbmem.c:1015
> >  do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1110
> >  fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1189
> > 
> > Reported-by: Zheyu Ma <zheyuma97@gmail.com>
> > Signed-off-by: Letu Ren <fantasquex@gmail.com>
> > Signed-off-by: Helge Deller <deller@gmx.de>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/video/fbdev/pm2fb.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
> > index 9b32b9fc44a5c..50b569d047b10 100644
> > --- a/drivers/video/fbdev/pm2fb.c
> > +++ b/drivers/video/fbdev/pm2fb.c
> > @@ -619,6 +619,11 @@ static int pm2fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
> >  		return -EINVAL;
> >  	}
> >  
> > +	if (!var->pixclock) {
> > +		DPRINTK("pixclock is zero\n");
> > +		return -EINVAL;
> > +	}
> > +
> >  	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
> >  		DPRINTK("pixclock too high (%ldKHz)\n",
> >  			PICOS2KHZ(var->pixclock));
> > -- 
> > 2.35.1
> 
> This is a duplicate, the same patch has already been applied in 4.9.327 (0f1174f4972ea9fad6becf8881d71adca8e9ca91), so the above snippet of code is now in there twice.
> 
> Doesn't make a difference in functionality in this case, I just happened to notice it when reviewing backports from 4.9 for the CIP 4.4-stable tree.

Good catch, want to send a revert for this to fix it up?

thanks,

greg k-h
