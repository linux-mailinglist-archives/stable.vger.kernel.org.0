Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A81399116
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 19:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFBRIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 13:08:34 -0400
Received: from mail1.perex.cz ([77.48.224.245]:40284 "EHLO mail1.perex.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229625AbhFBRIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 13:08:34 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2021 13:08:34 EDT
Received: from mail1.perex.cz (localhost [127.0.0.1])
        by smtp1.perex.cz (Perex's E-mail Delivery System) with ESMTP id A8577A0042;
        Wed,  2 Jun 2021 18:58:15 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp1.perex.cz A8577A0042
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=perex.cz; s=default;
        t=1622653095; bh=sT4RPi+meQb9+r/aEG+lNDSsof33NXU66YQc/AJrJuc=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=EDxP/DFGEm8Ectgw2QDYhfIdSOOTmXVLGT3qWdbYXVIG7Xkc7jhLQwKPGAWO/zQ3k
         zoWdiu+zvtIZ4/pDzh2+60fleVHOsfySK3ebUv+5TnqdTXUhVniCe1fSXTU4H6ZO/I
         hgm3G4KtQ3ruYhj08hu4yVN0A3NQGfkH/VI/crVg=
Received: from p1gen2.localdomain (unknown [192.168.100.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: perex)
        by mail1.perex.cz (Perex's E-mail Delivery System) with ESMTPSA;
        Wed,  2 Jun 2021 18:58:11 +0200 (CEST)
Subject: Re: [PATCH] ALSA: timer: Fix master timer notification
To:     Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
References: <20210602113823.23777-1-tiwai@suse.de>
Cc:     stable@vger.kernel.org
From:   Jaroslav Kysela <perex@perex.cz>
Message-ID: <179e8e18-006d-f32b-ace9-3dd60ab7332b@perex.cz>
Date:   Wed, 2 Jun 2021 18:58:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210602113823.23777-1-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02. 06. 21 13:38, Takashi Iwai wrote:
> snd_timer_notify1() calls the notification to each slave for a master
> event, but it passes a wrong event number.  It should be +10 offset,
> corresponding to SNDRV_TIMER_EVENT_MXXX, but it's incorrectly with
> +100 offset.  Casually this was spotted by UBSAN check via syzkaller.
> 
> Reported-by: syzbot+d102fa5b35335a7e544e@syzkaller.appspotmail.com
> Cc: <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/000000000000e5560e05c3bd1d63@google.com
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Reviewed-by: Jaroslav Kysela <perex@perex.cz>

> ---
>  sound/core/timer.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/sound/core/timer.c b/sound/core/timer.c
> index 6898b1ac0d7f..92b7008fcdb8 100644
> --- a/sound/core/timer.c
> +++ b/sound/core/timer.c
> @@ -520,9 +520,10 @@ static void snd_timer_notify1(struct snd_timer_instance *ti, int event)
>  		return;
>  	if (timer->hw.flags & SNDRV_TIMER_HW_SLAVE)
>  		return;
> +	event += 10; /* convert to SNDRV_TIMER_EVENT_MXXX */
>  	list_for_each_entry(ts, &ti->slave_active_head, active_list)
>  		if (ts->ccallback)
> -			ts->ccallback(ts, event + 100, &tstamp, resolution);
> +			ts->ccallback(ts, event, &tstamp, resolution);
>  }
>  
>  /* start/continue a master timer */
> 


-- 
Jaroslav Kysela <perex@perex.cz>
Linux Sound Maintainer; ALSA Project; Red Hat, Inc.
