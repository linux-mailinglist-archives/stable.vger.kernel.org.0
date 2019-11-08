Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B41F51CB
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 17:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfKHQ7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 11:59:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44304 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfKHQ7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 11:59:22 -0500
Received: from [179.174.16.153] (helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1iT7bU-0000Hs-DW; Fri, 08 Nov 2019 16:59:20 +0000
Date:   Fri, 8 Nov 2019 13:59:16 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH v3.16] alarmtimer: Use EOPNOTSUPP instead of ENOTSUPP
Message-ID: <20191108165916.GD3753@calabresa>
References: <20191108155411.13306-1-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108155411.13306-1-pvorel@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 04:54:11PM +0100, Petr Vorel wrote:
> From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> 
> ENOTSUPP is not supposed to be returned to userspace. This was found on an
> OpenPower machine, where the RTC does not support set_alarm.
> 
> On that system, a clock_nanosleep(CLOCK_REALTIME_ALARM, ...) results in
> "524 Unknown error 524"
> 
> Replace it with EOPNOTSUPP which results in the expected "95 Operation not
> supported" error.
> 
> Fixes: 1c6b39ad3f01 (alarmtimers: Return -ENOTSUPP if no RTC device is present)
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> [ pvorel: backport for v3.16, changes also in alarm_timer_{del,set}(), which
> were removed in f2c45807d3992fe0f173f34af9c347d907c31686 in v4.13-rc1 ]
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> Cc: stable@vger.kernel.org # v3.16
> Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

This already has my sign-off, but for the extra changes:
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

> Cc: Ben Hutchings <ben@decadent.org.uk>
> Link: https://lkml.kernel.org/r/20190903171802.28314-1-cascardo@canonical.com
> ---
>  kernel/time/alarmtimer.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index 8c65c236f26a..c3fc69986850 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -533,7 +533,7 @@ static int alarm_timer_create(struct k_itimer *new_timer)
>  	struct alarm_base *base;
>  
>  	if (!alarmtimer_get_rtcdev())
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	if (!capable(CAP_WAKE_ALARM))
>  		return -EPERM;
> @@ -576,7 +576,7 @@ static void alarm_timer_get(struct k_itimer *timr,
>  static int alarm_timer_del(struct k_itimer *timr)
>  {
>  	if (!rtcdev)
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
>  		return TIMER_RETRY;
> @@ -600,7 +600,7 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
>  	ktime_t exp;
>  
>  	if (!rtcdev)
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	if (flags & ~TIMER_ABSTIME)
>  		return -EINVAL;
> @@ -761,7 +761,7 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
>  	struct restart_block *restart;
>  
>  	if (!alarmtimer_get_rtcdev())
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	if (flags & ~TIMER_ABSTIME)
>  		return -EINVAL;
