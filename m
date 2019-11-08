Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280E0F51C7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 17:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfKHQ6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 11:58:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44265 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729711AbfKHQ6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 11:58:38 -0500
Received: from [179.174.16.153] (helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1iT7am-0000EH-92; Fri, 08 Nov 2019 16:58:36 +0000
Date:   Fri, 8 Nov 2019 13:58:32 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4.4-stable] alarmtimer: Change remaining ENOTSUPP to
 EOPNOTSUPP
Message-ID: <20191108165832.GC3753@calabresa>
References: <20191108155116.12896-1-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108155116.12896-1-pvorel@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 04:51:16PM +0100, Petr Vorel wrote:
> Fix backport of commit f18ddc13af981ce3c7b7f26925f099e7c6929aba upstream.
> 
> Update backport to change ENOTSUPP to EOPNOTSUPP in
> alarm_timer_{del,set}(), which were removed in
> f2c45807d3992fe0f173f34af9c347d907c31686 in v4.13-rc1.
> 
> Fixes: c22df8ea7c5831d6fdca2f6f136f0d32d7064ff9
> 
> Signed-off-by: Petr Vorel <pvorel@suse.cz>


Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

> ---
>  kernel/time/alarmtimer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index 70aef327b6e8..015d432bcb08 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -573,7 +573,7 @@ static void alarm_timer_get(struct k_itimer *timr,
>  static int alarm_timer_del(struct k_itimer *timr)
>  {
>  	if (!rtcdev)
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
>  		return TIMER_RETRY;
> @@ -597,7 +597,7 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
>  	ktime_t exp;
>  
>  	if (!rtcdev)
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	if (flags & ~TIMER_ABSTIME)
>  		return -EINVAL;
> -- 
> 2.16.4
> 
