Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2796F50A4
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 17:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727010AbfKHQIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 11:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHQIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 11:08:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DEA321924;
        Fri,  8 Nov 2019 16:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573229294;
        bh=u+jSkjY/DIpnf1rsY130ZoCWxwRK1E3aPrxfcC/EFjI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oV8Si+VuhEdC72G39lINKrxDxxi7pBhOBkLb9WlMCz8Uk+bWdRAuKbtUA0UxKI/Ph
         F3AuK3YiS72XBv5wZLmHk50RNmF/WtXQpT00QY6r9lZtWT250TWxectGysHfG8Xmsn
         Jh8HhGvOw7A+BxojsM+HgTSEGNWKpmyRPCaE9oHw=
Date:   Fri, 8 Nov 2019 17:08:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Fix backport of f18ddc13af981ce3c7b7f26925f099e7c6929aba
Message-ID: <20191108160812.GA991932@kroah.com>
References: <20191108155316.13109-1-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108155316.13109-1-pvorel@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 04:53:16PM +0100, Petr Vorel wrote:
> for v4.4 and v4.9 stable branches
> 
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> ---
> Hi,
> 
> Patch for stable-queue.git of previously sent 2 patches, if needed.
> 
> Kind regards,
> Petr
> 
>  ...armtimer-use-eopnotsupp-instead-of-enotsupp.patch | 20 +++++++++++++++++++-
>  ...armtimer-use-eopnotsupp-instead-of-enotsupp.patch | 20 +++++++++++++++++++-
>  2 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/releases/4.4.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch b/releases/4.4.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
> index 6e1622d11..64864792b 100644
> --- a/releases/4.4.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
> +++ b/releases/4.4.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
> @@ -38,7 +38,25 @@ Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>   
>   	if (!capable(CAP_WAKE_ALARM))
>   		return -EPERM;
> -@@ -759,7 +759,7 @@ static int alarm_timer_nsleep(const cloc
> +@@ -573,7 +573,7 @@ static void alarm_timer_get(struct k_itimer *timr,
> + static int alarm_timer_del(struct k_itimer *timr)
> + {
> + 	if (!rtcdev)
> +-		return -ENOTSUPP;
> ++		return -EOPNOTSUPP;
> + 
> + 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
> + 		return TIMER_RETRY;
> +@@ -597,7 +597,7 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
> + 	ktime_t exp;
> + 
> + 	if (!rtcdev)
> +-		return -ENOTSUPP;
> ++		return -EOPNOTSUPP;
> + 
> + 	if (flags & ~TIMER_ABSTIME)
> + 		return -EINVAL;
> +@@ -759,7 +759,7 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
>   	struct restart_block *restart;
>   
>   	if (!alarmtimer_get_rtcdev())
> diff --git a/releases/4.9.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch b/releases/4.9.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
> index 1c783e622..f6af42535 100644
> --- a/releases/4.9.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
> +++ b/releases/4.9.195/alarmtimer-use-eopnotsupp-instead-of-enotsupp.patch
> @@ -38,7 +38,25 @@ Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>   
>   	if (!capable(CAP_WAKE_ALARM))
>   		return -EPERM;
> -@@ -772,7 +772,7 @@ static int alarm_timer_nsleep(const cloc
> +@@ -586,7 +586,7 @@ static void alarm_timer_get(struct k_itimer *timr,
> + static int alarm_timer_del(struct k_itimer *timr)
> + {
> + 	if (!rtcdev)
> +-		return -ENOTSUPP;
> ++		return -EOPNOTSUPP;
> + 
> + 	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
> + 		return TIMER_RETRY;
> +@@ -610,7 +610,7 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
> + 	ktime_t exp;
> + 
> + 	if (!rtcdev)
> +-		return -ENOTSUPP;
> ++		return -EOPNOTSUPP;
> + 
> + 	if (flags & ~TIMER_ABSTIME)
> + 		return -EINVAL;
> +@@ -772,7 +772,7 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
>   	struct restart_block *restart;
>   
>   	if (!alarmtimer_get_rtcdev())

It's a bit hard to go back in time and modify a patch that is already in
the main linux-stable.git tree like this :)

If we messed up the backport, great, please send a patch I can apply to
the 4.9.y kernel tree with the information in it that I can accept to
resolve this issue.

thanks,

greg k-h
