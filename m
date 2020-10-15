Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE7C28F650
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 18:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389388AbgJOQC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 12:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389309AbgJOQC6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 12:02:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C6FC061755;
        Thu, 15 Oct 2020 09:02:57 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t9so4119967wrq.11;
        Thu, 15 Oct 2020 09:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WIcgB2Q0alW1rOnfm0FtiewwKipdqqH1aK9iaZJcVD4=;
        b=PdfR45tIpIvve2r0bJRwAXu1/0iFdUr+p+cTd2oeF6uc4KOEGgmp+MpYI4mHfunBPd
         VI+iB1haADNtaSwFIgoTv11ypFVTM8Zrzyy3PASbr2antcndZ2S/OZoLgzR6rLRG7xwz
         yiefSR6Y/v/z8DTxGueTU6Pt9slMmS11M2QV6z5dLfE12pb3EK+C69I/R66bAcjQshPd
         X8hr8gwsDjfvxIgptcr73xHo0Wx2W5Nc0iBlj2yh9w/nGUKxUeTB0DEUSLiQb7U1ipW9
         1+1slgczgvuSc17eltkn9hgD8N0tY6aQmXhL9HxRs3b/svFeS/Dw1QqsLB/o5puLNykm
         umBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WIcgB2Q0alW1rOnfm0FtiewwKipdqqH1aK9iaZJcVD4=;
        b=NfVXftbsNMgz1bFtnkRX3k2hR5XO2RDjwM2aRwlVyWXegH5rFqmhyYsQdpfSEK2Pdb
         AN2PpcSFLOGJ8gxMuZ1IK+mQJdxm8U+5KqFYHe4Dp1p0vDkPIB7xVYx78EmCM0M6b4/t
         iSNM9lkxBfiMtuk+OsNwYkt9/dqdjzQbAGtYCxfVbc+3TRqcEr7kOlLzpRtiw5cWqlKz
         XdjW3DYdk3/PIUFovvTNPinH547Q28QaRNC8RTHduzSkvNklyEeHV54/rHf5I8i90uwa
         Tk4iHAicG2rD4e9FGKyp/WKizjmAC1rZWhYJWcpF3cjzY4M95W5StDhHGE4ajv4Rjg5z
         q02g==
X-Gm-Message-State: AOAM532KI2Lj3wtl5bKdCXGt9LOrH6r+36sl2LH3Ew6A/UmZnsCd1I5O
        U8bktlMGQZDLAf1BWLN3CEE=
X-Google-Smtp-Source: ABdhPJz/JhmTtLPzilSQJXA+JlY9/cN09wf8jefA0o7qrygdRiK/qqvDVd50fdm2KZ8e8BQDLzGalg==
X-Received: by 2002:a5d:6a0a:: with SMTP id m10mr5286266wru.189.1602777776579;
        Thu, 15 Oct 2020 09:02:56 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id l26sm4943211wmi.39.2020.10.15.09.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 09:02:55 -0700 (PDT)
Subject: Re: [PATCH 1/2 v2] futex: adjust a futex timeout with a per-timens
 offset
To:     Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org
References: <20201015160020.293748-1-avagin@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <1594cb72-3755-86be-9916-6dafd658993d@gmail.com>
Date:   Thu, 15 Oct 2020 17:02:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201015160020.293748-1-avagin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/15/20 5:00 PM, Andrei Vagin wrote:
> For all commands except FUTEX_WAIT, timeout is interpreted as an
> absolute value. This absolute value is inside the task's time namespace
> and has to be converted to the host's time.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 5a590f35add9 ("posix-clocks: Wire up clock_gettime() with timens offsets")
> Reported-by: Hans van der Laan <j.h.vanderlaan@student.utwente.nl>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>

Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>

> ---
> 
> v2:
> * check FUTEX_CLOCK_REALTIME properly
> * fix futex_time32 too
> 
>  kernel/futex.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index a5876694a60e..32056d2d4171 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -39,6 +39,7 @@
>  #include <linux/freezer.h>
>  #include <linux/memblock.h>
>  #include <linux/fault-inject.h>
> +#include <linux/time_namespace.h>
>  
>  #include <asm/futex.h>
>  
> @@ -3797,6 +3798,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
>  		t = timespec64_to_ktime(ts);
>  		if (cmd == FUTEX_WAIT)
>  			t = ktime_add_safe(ktime_get(), t);
> +		else if (!(op & FUTEX_CLOCK_REALTIME))
> +			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
>  		tp = &t;
>  	}
>  	/*
> @@ -3989,6 +3992,8 @@ SYSCALL_DEFINE6(futex_time32, u32 __user *, uaddr, int, op, u32, val,
>  		t = timespec64_to_ktime(ts);
>  		if (cmd == FUTEX_WAIT)
>  			t = ktime_add_safe(ktime_get(), t);
> +		else if (!(op & FUTEX_CLOCK_REALTIME))
> +			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
>  		tp = &t;
>  	}
>  	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
>

Thanks,
         Dmitry
