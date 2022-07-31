Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBB3585EE4
	for <lists+stable@lfdr.de>; Sun, 31 Jul 2022 14:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbiGaMgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jul 2022 08:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiGaMgp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jul 2022 08:36:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F610DF19
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 05:36:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C132D60CFB
        for <stable@vger.kernel.org>; Sun, 31 Jul 2022 12:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A2CC433C1;
        Sun, 31 Jul 2022 12:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659271003;
        bh=ZZma4irnOIli1uXJFi0hEYdNYk+XQR/whoVC8kkSMzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lu+aV7QFYE44KfrYuo3gzcb6hDcYJUpYJI0OG0vGEmxmrqMvYIB4PrfUlbt5yX3OI
         CrCT8CqA4K+SY0Gk6LVcKfg0sxAg/7Cu6z6Tz8J7Vnk/MbrbbWctFcdjnAl6nOtSD1
         YeNR+wOzYuYMbouwoeiSzifpqn9gBkIcoWWlR9a8=
Date:   Sun, 31 Jul 2022 14:36:40 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chen Jun <chenjun102@huawei.com>
Cc:     stable@vger.kernel.org, deller@gmx.de, geert@linux-m68k.org,
        b.zolnierkie@samsung.com, xuqiang36@huawei.com,
        xiujianfeng@huawei.com
Subject: Re: [PATCH stable 4.19 4.14 0/2] add fix patch for CVE-2021-3365
Message-ID: <YuZ3WAOVRqmcyvHQ@kroah.com>
References: <20220729031140.21806-1-chenjun102@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729031140.21806-1-chenjun102@huawei.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 29, 2022 at 03:11:38AM +0000, Chen Jun wrote:
> refer to https://lore.kernel.org/all/20220706150253.2186-1-deller@gmx.de/
> 3 patches are provided to fix CVE-2021-3365 (When sending malicous data
> to kernel by ioctl cmd FBIOPUT_VSCREENINFO,kernel will write memory out
> of bounds. https://nvd.nist.gov/vuln/detail/CVE-2021-33655) in mainline.
> 
> But only
> commit 65a01e601dbb ("fbcon: Disallow setting font bigger than screen size")
> was backported to stable (4.19,4.14).
> 
> without other two commit
> commit e64242caef18 ("fbcon: Prevent that screen size is smaller than font size")
> commit 6c11df58fd1a ("fbmem: Check virtual screen sizes in fb_set_var()")
> The problem still exists.
> 
> static long do_fb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
> 	fb_set_var(info, &var);
> 		fb_notifier_call_chain(evnt, &event); // evnt = FB_EVENT_MODE_CHANGE
> 
> static int fbcon_event_notify(struct notifier_block *self,
> 			      unsigned long action, void *data)
> 	fbcon_modechanged(info);
> 		updatescrollmode(p, info, vc);
> 			...
> 			p->vrows = vyres/fh;
> 			if (yres > (fh * (vc->vc_rows + 1)))
> 				p->vrows -= (yres - (fh * vc->vc_rows)) / fh;
> 			if ((yres % fh) && (vyres % fh < yres % fh))
> 				p->vrows--;	[1]
> [1]: p->vrows could be -1, like what CVE-2021-3365 described.
> 
> I think, the two commits should be backported to 4.19 and 4.14.
> 
> Helge Deller (2):
>   fbcon: Prevent that screen size is smaller than font size
>   fbmem: Check virtual screen sizes in fb_set_var()
> 
>  drivers/video/fbdev/core/fbcon.c | 28 ++++++++++++++++++++++++++++
>  drivers/video/fbdev/core/fbmem.c | 20 +++++++++++++++++---
>  include/linux/fbcon.h            |  4 ++++
>  3 files changed, 49 insertions(+), 3 deletions(-)
> 
> -- 
> 2.17.1
> 

This breaks the build on 4.14.y, did you test it there?

The error is:
	ERROR: "is_console_locked" [drivers/video/fbdev/core/fb.ko] undefined!

Can you please fix this up and also do a 4.9.y version?

thanks,

greg k-h
