Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1E7191559
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 16:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgCXPtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 11:49:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:32881 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728368AbgCXPtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 11:49:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585064979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gDeYcAUSbBq7ywkS5vACQpnT9b7hAluwSzLUAQ2Mkuo=;
        b=UWyq109aARiETWzOJF2nSEcrF78b/fpxAMDOEblWVBaKVZRkAvuh9FgICyU5P3OL/PIKGY
        d2aZaLMp4lkQ5L64NdKbuj0fWXA6ZBciuJaAV+xpFr2fcWLCSghBhfH7GDI19QyqB3ykfW
        1mu6ajt+nzYY4jbimbsOy67zr+Yg5gg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-YqnaOaKMMVGlfjWc0yTrhw-1; Tue, 24 Mar 2020 11:49:35 -0400
X-MC-Unique: YqnaOaKMMVGlfjWc0yTrhw-1
Received: by mail-wm1-f72.google.com with SMTP id f8so1351321wmh.4
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 08:49:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gDeYcAUSbBq7ywkS5vACQpnT9b7hAluwSzLUAQ2Mkuo=;
        b=A0O2ujKewJiN5JQIb+R/Dqnx+eT1+xqDsI0MkkeVCCojPk0Lo1beWyPsIQQaJOhKSO
         6GFqHDSEqzzFRKgOdKEefVGcUpkcm+V1qmmnwp33eUEHK0yZ7hTtMHb/knkEJPNPf0HS
         068hH5vksGytDe6aLtRex5c20rhZKmAau0AtsUo7nMgpTRJ/qK93aWy0CXeEMYu+Mov7
         rmRm4jo9BGFZkCjrfoUI6LLp8G5v07M2mf80dIHIk9FzTeuUwPV799GyQQ1nUqXW6kuR
         dFwF1eJsf5Nne1JIv+NP7MQ6BPgL80Puh6N9MVdoKMESTOW/u6diFADM/twkSUkQzecu
         hAnQ==
X-Gm-Message-State: ANhLgQ2id6wbyAWIrNngYofPeM/fnnd7IEl36r9WQDdU2lm2x2kWYW/p
        3hJV2VjRbPgix+xX0JIxo7O7MpuwP6AqlzmAfPaR9/CtoUVLt0rWfqh0mntwZZkvev6tqw6OlJ7
        fD/EqN5WgTX4cqC+h
X-Received: by 2002:adf:ce8d:: with SMTP id r13mr21284982wrn.253.1585064974716;
        Tue, 24 Mar 2020 08:49:34 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvieeuVU2W0zTxEOUqjpUVow4Ua37PmuvDaQdo6jPYZN+iJoR9w2Z7lCsv/HlVC3WP9EqY7jg==
X-Received: by 2002:adf:ce8d:: with SMTP id r13mr21284953wrn.253.1585064974406;
        Tue, 24 Mar 2020 08:49:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id y7sm6862882wrq.54.2020.03.24.08.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 08:49:33 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Yubo Xie <ltykernel@gmail.com>
Cc:     Yubo Xie <yuboxie@microsoft.com>, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tianyu Lan <Tianyu.Lan@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        liuwe@microsoft.com, daniel.lezcano@linaro.org, tglx@linutronix.de,
        michael.h.kelley@microsoft.com
Subject: Re: [PATCH] x86/Hyper-V: Fix hv sched clock function return wrong time unit
In-Reply-To: <20200324151935.15814-1-yuboxie@microsoft.com>
References: <20200324151935.15814-1-yuboxie@microsoft.com>
Date:   Tue, 24 Mar 2020 16:49:32 +0100
Message-ID: <87ftdx7nxv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Yubo Xie <ltykernel@gmail.com> writes:

> sched clock callback should return time with nano second as unit
> but current hv callback returns time with 100ns. Fix it.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Yubo Xie <yuboxie@microsoft.com>
> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
> Fixes: adb87ff4f96c ("clocksource/drivers/hyperv: Allocate Hyper-V TSC page statically")

I don't think this is the right commit to reference, 

commit bd00cd52d5be655a2f217e2ed74b91a71cb2b14f
Author: Tianyu Lan <Tianyu.Lan@microsoft.com>
Date:   Wed Aug 14 20:32:16 2019 +0800

    clocksource/drivers/hyperv: Add Hyper-V specific sched clock function

looks like the one.

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

kvmclock seems to have the same (pre-patch) code ...

>  
>  static struct clocksource hyperv_cs_msr = {

-- 
Vitaly

