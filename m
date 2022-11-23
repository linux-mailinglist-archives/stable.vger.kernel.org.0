Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3ED63508E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 07:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235951AbiKWGh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 01:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236080AbiKWGhx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 01:37:53 -0500
X-Greylist: delayed 171 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Nov 2022 22:37:49 PST
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:400:200::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BC4F00C
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 22:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1669185279;
    s=strato-dkim-0002; d=fpond.eu;
    h=Subject:References:In-Reply-To:Message-ID:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=Q2ku8PZxGwxrMfipwnTd7Em+iNYROIWJ2cEv4fZ1s8g=;
    b=QrFR/6+6tniaHA3MPzgHTK9czHuTUdINwEBlEXd5MpEeI4Pvthhz3NiMiBdMQpei5E
    S7zsEAPs1UahH8XEFnxBOwiXEAwuZaXghAyu1s0lrUZit9/dvYK+fO+RSLx7FL/VRO5x
    sx3NYu5fELVUAZgcrGRTIE2rxPUWRjGsISR4ZI+N/uD+Q4hXttfDMCUJ0pb5yxboy2fD
    5y85dlIdA4K/ZwnA7AX6oPBwQzspqLwmHhP4quI5I/gVMKIEmirPfrp1cs8cIqc0TX91
    Y/7NpOmqlQmXw33IhjTVEly2QU1qtZ/7qRYBAFMlgBPRbPxJdIlU8sx/6kTXAD2601ln
    Ue4Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OWANVUa4dPFUgKR/3dpvnYP0Np73amq+g13rqGzvv3qxio1R8fCv/x64jlM="
X-RZG-CLASS-ID: mo00
Received: from oxapp06-05.back.ox.d0m.de
    by smtp-ox.front (RZmta 48.2.1 AUTH)
    with ESMTPSA id y28384yAN6Yd1A0
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
    Wed, 23 Nov 2022 07:34:39 +0100 (CET)
Date:   Wed, 23 Nov 2022 07:34:39 +0100 (CET)
From:   Ulrich Hecht <uli@fpond.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Letu Ren <fantasquex@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>,
        "pavel@denx.de" <pavel@denx.de>
Message-ID: <970394644.1257305.1669185279738@webmail.strato.com>
In-Reply-To: <20220913140342.308723271@linuxfoundation.org>
References: <20220913140342.228397194@linuxfoundation.org>
 <20220913140342.308723271@linuxfoundation.org>
Subject: Re: [PATCH 4.9 01/42] fbdev: fb_pm2fb: Avoid potential divide by
 zero error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev30
X-Originating-Client: open-xchange-appsuite
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


> On 09/13/2022 4:07 PM CEST Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
>  
> From: Letu Ren <fantasquex@gmail.com>
> 
> commit 19f953e7435644b81332dd632ba1b2d80b1e37af upstream.
> 
> In `do_fb_ioctl()` of fbmem.c, if cmd is FBIOPUT_VSCREENINFO, var will be
> copied from user, then go through `fb_set_var()` and
> `info->fbops->fb_check_var()` which could may be `pm2fb_check_var()`.
> Along the path, `var->pixclock` won't be modified. This function checks
> whether reciprocal of `var->pixclock` is too high. If `var->pixclock` is
> zero, there will be a divide by zero error. So, it is necessary to check
> whether denominator is zero to avoid crash. As this bug is found by
> Syzkaller, logs are listed below.
> 
> divide error in pm2fb_check_var
> Call Trace:
>  <TASK>
>  fb_set_var+0x367/0xeb0 drivers/video/fbdev/core/fbmem.c:1015
>  do_fb_ioctl+0x234/0x670 drivers/video/fbdev/core/fbmem.c:1110
>  fb_ioctl+0xdd/0x130 drivers/video/fbdev/core/fbmem.c:1189
> 
> Reported-by: Zheyu Ma <zheyuma97@gmail.com>
> Signed-off-by: Letu Ren <fantasquex@gmail.com>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/video/fbdev/pm2fb.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/video/fbdev/pm2fb.c b/drivers/video/fbdev/pm2fb.c
> index 9b32b9fc44a5c..50b569d047b10 100644
> --- a/drivers/video/fbdev/pm2fb.c
> +++ b/drivers/video/fbdev/pm2fb.c
> @@ -619,6 +619,11 @@ static int pm2fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
>  		return -EINVAL;
>  	}
>  
> +	if (!var->pixclock) {
> +		DPRINTK("pixclock is zero\n");
> +		return -EINVAL;
> +	}
> +
>  	if (PICOS2KHZ(var->pixclock) > PM2_MAX_PIXCLOCK) {
>  		DPRINTK("pixclock too high (%ldKHz)\n",
>  			PICOS2KHZ(var->pixclock));
> -- 
> 2.35.1

This is a duplicate, the same patch has already been applied in 4.9.327 (0f1174f4972ea9fad6becf8881d71adca8e9ca91), so the above snippet of code is now in there twice.

Doesn't make a difference in functionality in this case, I just happened to notice it when reviewing backports from 4.9 for the CIP 4.4-stable tree.

CU
Uli
