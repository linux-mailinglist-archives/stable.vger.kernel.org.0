Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71F628F482
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 16:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728823AbgJOONp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 10:13:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38156 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgJOONp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 10:13:45 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602771223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0MblahxxdvFHgwDWUgjvtntdmd40tCKymEtQpaSbYxg=;
        b=jku5709TczLf/IEI2LWL7lRlM4HazOcKaKE/facN7uxF1Dg6zReTeGFprxqQ0iTsX4cAom
        3AivoOnyREXNkdWa2sakgTW9dpOR+auuxkVdy+KzccrRRBLzt/cZCVdkINU30H/xsLS1/2
        81GP0SnvVQKOjXtxrwBHtUvtRpD6dsQj7n/X0INvqs70AOb3fRrizaXRPKtYnP86RjxjZJ
        6tKiqHGbDW0u2BmxgfKivtF7n8mnQbx9aFVLacR529sBgdGth0OO8ZxpIMA1Ow0IWBEzat
        VAqITw2dUgye77g9rbEw2vm14cvAipoMVb6h1TjB+aB+e1DTO3eR8dCmc52grw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602771223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0MblahxxdvFHgwDWUgjvtntdmd40tCKymEtQpaSbYxg=;
        b=xpRQxwWgOnSeDGPmR/KGoRxc3RSrHOIwZfp8nG7SiLAjvfQQGXlg5ypeFiyZa2A23KMu3d
        X8OyefJWOlRCb7Aw==
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Andrei Vagin <avagin@gmail.com>, linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] futex: adjust a futex timeout with a per-timens offset
In-Reply-To: <fc50656f-2df8-06c9-653a-8d2910949401@gmail.com>
References: <20201015072909.271426-1-avagin@gmail.com> <fc50656f-2df8-06c9-653a-8d2910949401@gmail.com>
Date:   Thu, 15 Oct 2020 16:13:42 +0200
Message-ID: <87lfg7a86h.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15 2020 at 14:26, Dmitry Safonov wrote:

> On 10/15/20 8:29 AM, Andrei Vagin wrote:
>> For all commands except FUTEX_WAIT, timeout is interpreted as an
>> absolute value. This absolute value is inside the task's time namespace
>> and has to be converted to the host's time.
>> 
>> Cc: <stable@vger.kernel.org>
>> Fixes: 5a590f35add9 ("posix-clocks: Wire up clock_gettime() with timens offsets")
>> Reported-by: Hans van der Laan <j.h.vanderlaan@student.utwente.nl>
>> Signed-off-by: Andrei Vagin <avagin@gmail.com>[..]
>> @@ -3797,6 +3798,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
>>  		t = timespec64_to_ktime(ts);
>>  		if (cmd == FUTEX_WAIT)
>>  			t = ktime_add_safe(ktime_get(), t);
>> +		else if (!(cmd & FUTEX_CLOCK_REALTIME))
>> +			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);
>
> Err, it probably should be
> : else if (!(op & FUTEX_CLOCK_REALTIME))

Duh, you are right. I stared at it for a while and did not spot it.

> And there's also
> : SYSCALL_DEFINE6(futex_time32, ...)
> which wants to be patched.

Indeed. I zapped the commits.

Thanks,

        tglx
