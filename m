Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A96104456
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 20:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfKTT3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 14:29:36 -0500
Received: from imap1.codethink.co.uk ([176.9.8.82]:34311 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbfKTT3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 14:29:36 -0500
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1iXVfQ-0002UZ-9S; Wed, 20 Nov 2019 19:29:32 +0000
Message-ID: <a79f4e894bf05816d2b279c2706a0108f130d75b.camel@codethink.co.uk>
Subject: Re: [Y2038] [PATCH 7/8] ppdev: fix PPGETTIME/PPSETTIME ioctls
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Arnd Bergmann <arnd@arndb.de>, y2038@lists.linaro.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Bamvor Jian Zhang <bamvor.zhangjian@linaro.org>
Date:   Wed, 20 Nov 2019 19:29:31 +0000
In-Reply-To: <20191108203435.112759-8-arnd@arndb.de>
References: <20191108203435.112759-1-arnd@arndb.de>
         <20191108203435.112759-8-arnd@arndb.de>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-11-08 at 21:34 +0100, Arnd Bergmann wrote:
> Going through the uses of timeval in the user space API,
> I noticed two bugs in ppdev that were introduced in the y2038
> conversion:
> 
> * The range check was accidentally moved from ppsettime to
>   ppgettime
> 
> * On sparc64, the microseconds are in the other half of the
>   64-bit word.
> 
> Fix both, and mark the fix for stable backports.

Like the patch for lpdev, this also doesn't completely fix sparc64.

Ben.

> Cc: stable@vger.kernel.org
> Fixes: 3b9ab374a1e6 ("ppdev: convert to y2038 safe")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/char/ppdev.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
> index c86f18aa8985..34bb88fe0b0a 100644
> --- a/drivers/char/ppdev.c
> +++ b/drivers/char/ppdev.c
> @@ -619,20 +619,27 @@ static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		if (copy_from_user(time32, argp, sizeof(time32)))
>  			return -EFAULT;
>  
> +		if ((time32[0] < 0) || (time32[1] < 0))
> +			return -EINVAL;
> +
>  		return pp_set_timeout(pp->pdev, time32[0], time32[1]);
>  
>  	case PPSETTIME64:
>  		if (copy_from_user(time64, argp, sizeof(time64)))
>  			return -EFAULT;
>  
> +		if ((time64[0] < 0) || (time64[1] < 0))
> +			return -EINVAL;
> +
> +		if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
> +			time64[1] >>= 32;
> +
>  		return pp_set_timeout(pp->pdev, time64[0], time64[1]);
>  
>  	case PPGETTIME32:
>  		jiffies_to_timespec64(pp->pdev->timeout, &ts);
>  		time32[0] = ts.tv_sec;
>  		time32[1] = ts.tv_nsec / NSEC_PER_USEC;
> -		if ((time32[0] < 0) || (time32[1] < 0))
> -			return -EINVAL;
>  
>  		if (copy_to_user(argp, time32, sizeof(time32)))
>  			return -EFAULT;
> @@ -643,8 +650,9 @@ static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		jiffies_to_timespec64(pp->pdev->timeout, &ts);
>  		time64[0] = ts.tv_sec;
>  		time64[1] = ts.tv_nsec / NSEC_PER_USEC;
> -		if ((time64[0] < 0) || (time64[1] < 0))
> -			return -EINVAL;
> +
> +		if (IS_ENABLED(CONFIG_SPARC64) && !in_compat_syscall())
> +			time64[1] <<= 32;
>  
>  		if (copy_to_user(argp, time64, sizeof(time64)))
>  			return -EFAULT;
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

