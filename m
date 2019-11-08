Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C04F51C1
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 17:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfKHQ6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 11:58:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44257 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbfKHQ6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Nov 2019 11:58:19 -0500
Received: from [179.174.16.153] (helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1iT7aT-0000DX-R0; Fri, 08 Nov 2019 16:58:18 +0000
Date:   Fri, 8 Nov 2019 13:58:13 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4.9-stable] alarmtimer: Change remaining ENOTSUPP to
 EOPNOTSUPP
Message-ID: <20191108165813.GB3753@calabresa>
References: <20191108155050.12786-1-pvorel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191108155050.12786-1-pvorel@suse.cz>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 04:50:50PM +0100, Petr Vorel wrote:
> Fix backport of commit f18ddc13af981ce3c7b7f26925f099e7c6929aba upstream.
> 
> Update backport to change ENOTSUPP to EOPNOTSUPP in
> alarm_timer_{del,set}(), which were removed in
> f2c45807d3992fe0f173f34af9c347d907c31686 in v4.13-rc1.
> 
> Fixes: 65b7a5a36afb11a6769a70308c1ef3a2afae6bf4
> 
> Signed-off-by: Petr Vorel <pvorel@suse.cz>

Nice catch!

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

> ---
>  kernel/time/alarmtimer.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> index a519d3cab1a2..6aef4a0bed29 100644
> --- a/kernel/time/alarmtimer.c
> +++ b/kernel/time/alarmtimer.c
> @@ -586,7 +586,7 @@ static void alarm_timer_get(struct k_itimer *timr,
>  static int alarm_timer_del(struct k_itimer *timr)
>  {
>  	if (!rtcdev)
> -		return -ENOTSUPP;
> +		return -EOPNOTSUPP;
>  
>  	if (alarm_try_to_cancel(&timr->it.alarm.alarmtimer) < 0)
>  		return TIMER_RETRY;
> @@ -610,7 +610,7 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
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
