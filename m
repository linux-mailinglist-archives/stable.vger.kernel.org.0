Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A344E28FFDE
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 10:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405088AbgJPITR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 04:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404947AbgJPITQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 04:19:16 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F40AC061755;
        Fri, 16 Oct 2020 01:19:15 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id p3so831572pjd.0;
        Fri, 16 Oct 2020 01:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X40dr3V1XCCeP0vnBtdWuUDrwr7eHWN1XaOMTZrojXE=;
        b=o5u3DKRXovogGUm88Cw9Jdx2kRHBYvD+cYYfHTdYl9nFhCZwhBrtxCHJnt/TEiIKxg
         yzaCVwGWIMaLOATND0Ari1MyeI+fkKH2I+1AnsrkGUR9OvV9sjcINImAUtEpeBaFXLZ4
         SUFLeaqhL/oAvOVhmffaLYOSSmKazntl8Yc4zdkHIW1nRej+SV8hmVQrbQBNEL7JWhMm
         lrwdjBxpNgEuz2f2AwNvVSvLvxN1Uz+nnSLkRpRViBbI4rir4Xrl+y1aF1dHES1jiB0s
         WIA53S7eLSdvYSvtmvQrWqEYI6ri+JiQ8H4kXMzatS97DUQniNw3zFubbzdg3ftw2d1c
         8dTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X40dr3V1XCCeP0vnBtdWuUDrwr7eHWN1XaOMTZrojXE=;
        b=rfG8X94jzFP2thdSzNAa4Bn3YuOVxHnDTp+uRhFHAm8NljiWzSA8+7XvRJ5xIKMPfr
         DSfqus+i8rVRJEIzxNBcR3JlOrJYi776Rzy25SwIaJ0/grK8Sm8uQT2Er24YGc4sbnwy
         KTrSFB3vZ4SkJSHOVy2k/sp0SZ42K4/NYpTK7xfrafWdRAHHCFVFzY+CjzopZbZlcDOa
         yZgda7edHg1mmID6f47GFbWCgKI3ytQaOO1gqcidateDQHpsyCxXiOsYCPRod2haQHkm
         mSLiT2zRfR292NliX2KiJO89Qv9fiXZcwqyADE/pJUHnAeMOO8H4IzwOT/kedYcvjqiT
         W6FA==
X-Gm-Message-State: AOAM532MwVTOCrl2b6hA17QQYp2UOIl8/IEfn106t3hkwfX4VSDe0JN7
        sEs1/2MswWVq5G8ESJkzFt0O8i4tcBRa9A==
X-Google-Smtp-Source: ABdhPJwgLUXnkfBHdoCASdi+cNCaDMxxA0Y1Z14dVUw3nwDOHHjY6tUOIj0tov732d9Dj4/s8ODhwg==
X-Received: by 2002:a17:902:b497:b029:d5:c01a:f06b with SMTP id y23-20020a170902b497b02900d5c01af06bmr2902352plr.13.1602836354526;
        Fri, 16 Oct 2020 01:19:14 -0700 (PDT)
Received: from gmail.com ([2601:600:9b7f:872e:a655:30fb:7373:c762])
        by smtp.gmail.com with ESMTPSA id lx5sm1796993pjb.33.2020.10.16.01.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 01:19:13 -0700 (PDT)
Date:   Fri, 16 Oct 2020 01:18:53 -0700
From:   Andrei Vagin <avagin@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] futex: adjust a futex timeout with a per-timens
 offset
Message-ID: <20201016081853.GA298408@gmail.com>
References: <20201015072909.271426-1-avagin@gmail.com>
 <fc50656f-2df8-06c9-653a-8d2910949401@gmail.com>
 <87lfg7a86h.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <87lfg7a86h.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15, 2020 at 04:13:42PM +0200, Thomas Gleixner wrote:
> On Thu, Oct 15 2020 at 14:26, Dmitry Safonov wrote:
> 
> > On 10/15/20 8:29 AM, Andrei Vagin wrote:
> >> For all commands except FUTEX_WAIT, timeout is interpreted as an
> >> absolute value. This absolute value is inside the task's time namespace
> >> and has to be converted to the host's time.
> >> 
> >> Cc: <stable@vger.kernel.org>
> >> Fixes: 5a590f35add9 ("posix-clocks: Wire up clock_gettime() with timens offsets")
> >> Reported-by: Hans van der Laan <j.h.vanderlaan@student.utwente.nl>
> >> Signed-off-by: Andrei Vagin <avagin@gmail.com>[..]
> >> @@ -3797,6 +3798,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
> >>  		t = timespec64_to_ktime(ts);
> >>  		if (cmd == FUTEX_WAIT)
> >>  			t = ktime_add_safe(ktime_get(), t);
> >> +		else if (!(cmd & FUTEX_CLOCK_REALTIME))
> >> +			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
> >
> > Err, it probably should be
> > : else if (!(op & FUTEX_CLOCK_REALTIME))

Dmitry, thank you for catching this.

> 
> Duh, you are right. I stared at it for a while and did not spot it.
> 
> > And there's also
> > : SYSCALL_DEFINE6(futex_time32, ...)
> > which wants to be patched.
> 
> Indeed. I zapped the commits.

I sent a new version. This time, I extended the test to check
FUTEX_CLOCK_REALTIME and I compiled and run the compat version.
Everything works as it should be.

Thanks,
Andrei
