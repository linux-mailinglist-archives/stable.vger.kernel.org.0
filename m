Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC34195357
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 09:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgC0Ixp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 04:53:45 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:38718 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726215AbgC0Ixo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 04:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585299224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0q7+oK+xU3Z8kXzQCu6KZqoOG1NNGcrqKhoyLJsys48=;
        b=B107O3wthHxj9MtreE3E+W0idsXaEytYKcG58FrqdW1D2gMpNc4uG/PEGhDtm3aNUKdTth
        aRaAo7bGlFbQOlMVB9T8GKTH4RMdkDqbevLWVSpG4ufkXgM9wNYyQenKZBnG1nYOGNLKXH
        5c2yaSe199Hf8Cy+2+ghF9vJxT+KX0E=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-OyZj5TBgP8iabzFqb61zNQ-1; Fri, 27 Mar 2020 04:53:42 -0400
X-MC-Unique: OyZj5TBgP8iabzFqb61zNQ-1
Received: by mail-wr1-f71.google.com with SMTP id u18so4181336wrn.11
        for <stable@vger.kernel.org>; Fri, 27 Mar 2020 01:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=0q7+oK+xU3Z8kXzQCu6KZqoOG1NNGcrqKhoyLJsys48=;
        b=nyuuPLZSRfevGNtlOpj7GsyjNARNhtAHJM2nRiRDqqXj+hM9kbgNxB504Oldr/f9RT
         ASeWUHdrqc+ToI7YBgS0EcBmG1mPrq/nHkCyqMZSmwVd+zMW87+1YeoHkPR/OPkm68ku
         mL5hyqfD8yXFXNMVbRSfY/lXi6sJ3YuAq2d9s2taoJxvp1a5HDFDY3tjDJ/pcHWFpEcs
         LnqRq8zVzpdwZHhy0hRUWThANUhgmzxCXzJcKZ4LzNQ1h40qcXurUIonCzmShdomm119
         H3RNDRmIez6UALna5FFl26VdoCIOHrK4xOeYsSZVDoanyl0YYS/8bxy48Ovza4k5Kl/U
         jCPA==
X-Gm-Message-State: ANhLgQ1kp9kCVPvWgXtiiIn6L9pREBHsGJGraSzaE1amKxt7Vh8uUIAy
        +X+C6gvtIsd3lN1OF43zm6LZr8Ss5ZzUDuJqwTl8mhe1D9QbGYUNOQinCQQqYkmeRSqb+raQiIe
        Gx//Q+IEb/5oeLtLP
X-Received: by 2002:a1c:b789:: with SMTP id h131mr4015735wmf.141.1585299221189;
        Fri, 27 Mar 2020 01:53:41 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvc0WHbcYocOiWt9cgoCAX+Uwqe6OC53OE8hVNqrC4SkjsDw268gg9CvPXU5dV7SBm//7wNEQ==
X-Received: by 2002:a1c:b789:: with SMTP id h131mr4015719wmf.141.1585299220950;
        Fri, 27 Mar 2020 01:53:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u8sm7088146wrn.69.2020.03.27.01.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 01:53:40 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Yubo Xie <yuboxie@microsoft.com>,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        liuwe@microsoft.com, daniel.lezcano@linaro.org, tglx@linutronix.de,
        michael.h.kelley@microsoft.com
Subject: Re: [PATCH V2] x86/Hyper-V: Fix hv sched clock function return wrong time unit
In-Reply-To: <20200327021159.31429-1-Tianyu.Lan@microsoft.com>
References: <20200327021159.31429-1-Tianyu.Lan@microsoft.com>
Date:   Fri, 27 Mar 2020 09:53:39 +0100
Message-ID: <87k13641rg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tianyu Lan <ltykernel@gmail.com> writes:

> From: Yubo Xie <yuboxie@microsoft.com>
>
> sched clock callback should return time with nano second as unit
> but current hv callback returns time with 100ns. Fix it.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Yubo Xie <yuboxie@microsoft.com>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Fixes: bd00cd52d5be ("clocksource/drivers/hyperv: Add Hyper-V specific sched clock function")
> ---
> Change since v1:
> 	Update fix commit number in change log. 
> ---
>  drivers/clocksource/hyperv_timer.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clocksource/hyperv_timer.c b/drivers/clocksource/hyperv_timer.c
> index 9d808d595ca8..662ed978fa24 100644
> --- a/drivers/clocksource/hyperv_timer.c
> +++ b/drivers/clocksource/hyperv_timer.c
> @@ -343,7 +343,8 @@ static u64 notrace read_hv_clock_tsc_cs(struct clocksource *arg)
>  
>  static u64 read_hv_sched_clock_tsc(void)
>  {
> -	return read_hv_clock_tsc() - hv_sched_clock_offset;
> +	return (read_hv_clock_tsc() - hv_sched_clock_offset)
> +		* (NSEC_PER_SEC / HV_CLOCK_HZ);
>  }
>  
>  static void suspend_hv_clock_tsc(struct clocksource *arg)
> @@ -398,7 +399,8 @@ static u64 notrace read_hv_clock_msr_cs(struct clocksource *arg)
>  
>  static u64 read_hv_sched_clock_msr(void)
>  {
> -	return read_hv_clock_msr() - hv_sched_clock_offset;
> +	return (read_hv_clock_msr() - hv_sched_clock_offset)
> +		* (NSEC_PER_SEC / HV_CLOCK_HZ);
>  }
>  
>  static struct clocksource hyperv_cs_msr = {

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

