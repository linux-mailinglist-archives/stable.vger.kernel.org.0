Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5D628F328
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 15:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgJON0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Oct 2020 09:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728216AbgJON0V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Oct 2020 09:26:21 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE5CC061755;
        Thu, 15 Oct 2020 06:26:20 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e18so3456867wrw.9;
        Thu, 15 Oct 2020 06:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vbVg16QrGKyvlMckDNn7Gc3nciHNv5GDTwM3pbpTXY0=;
        b=sxyRa8oiLkOGh5khW9uyt4C/N1rfSh5E5GnzgOtuPTlJF9vh+poDXThSHdRMZgmNca
         M7Momf8eX1CN0ezKJ4p7KIMfevKqKcG5zw/bhPZqHGf62PrAqxDkzIuHBoL3EaUqmLZM
         3ryp28PiXOe8ApVwwawYhM3pEa/K8s9hYdXjOd5BSIlWPL8gTTL9m8CZQyTjz0j61YbP
         Ac3oqCo0urF5XfrtJJqdhXLZat8966EmUzPp/oKQeI8C6XxOpeLO27+XDAGpfo751a29
         cDMWcyzWFFqFV7a9jke1xUN3LT6FA6ZdX1Il8cqKkz1lvhrqSGQ9Nd/ZPQis73qBz5HH
         tIyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vbVg16QrGKyvlMckDNn7Gc3nciHNv5GDTwM3pbpTXY0=;
        b=fPw5O3H8JQ/F8WU5aj3JlMBCJpgfKwzy84ibsuoSeVRLySs7/eFfPwCsNV4AOLEOKU
         JpdJsdZwhmXBMP1vJnM/855nwEFjTWWXj9QxMeatj3dtbbWzQWltv7PdkUIxVXjfhkoc
         VEeJ2kUP+EDbMC3v+lOkEuwkKsXkZ5/ZvWsiefPiLi6iT6Hx2PksA4FVIZ++qroc0ivL
         gGzc1dzDUtW01PGYOImRPbKeMGV/K2K5IfsmcOq+NvYSkfaXSWVQHr13y+OIA1zNUoA9
         tfoA7gve7jNbEsxVyb1HQg0nucSrwUFYZsLydUt+IXhAs2lNCY9CI8pyPfOxP87iU1jh
         P2jw==
X-Gm-Message-State: AOAM533X4pNi0O+Y3qWwHQH8j6a4FEAfWEmxuP6IA+T+92fXVj86rxY7
        tuIl+cOZGlIwV/M85osA8MM=
X-Google-Smtp-Source: ABdhPJzkVhQlHr4psjqGHvJgXaBFBjQpUe8HpzLEiIam3P0cz3ZzpqDT4ckaobCUecVdBb41Fj4W1w==
X-Received: by 2002:adf:dd50:: with SMTP id u16mr4575900wrm.419.1602768379590;
        Thu, 15 Oct 2020 06:26:19 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id e25sm2431731wra.71.2020.10.15.06.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 06:26:18 -0700 (PDT)
Subject: Re: [PATCH 1/2] futex: adjust a futex timeout with a per-timens
 offset
To:     Andrei Vagin <avagin@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Shuah Khan <shuah@kernel.org>, stable@vger.kernel.org
References: <20201015072909.271426-1-avagin@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <fc50656f-2df8-06c9-653a-8d2910949401@gmail.com>
Date:   Thu, 15 Oct 2020 14:26:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201015072909.271426-1-avagin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/15/20 8:29 AM, Andrei Vagin wrote:
> For all commands except FUTEX_WAIT, timeout is interpreted as an
> absolute value. This absolute value is inside the task's time namespace
> and has to be converted to the host's time.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 5a590f35add9 ("posix-clocks: Wire up clock_gettime() with timens offsets")
> Reported-by: Hans van der Laan <j.h.vanderlaan@student.utwente.nl>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>[..]
> @@ -3797,6 +3798,8 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
>  		t = timespec64_to_ktime(ts);
>  		if (cmd == FUTEX_WAIT)
>  			t = ktime_add_safe(ktime_get(), t);
> +		else if (!(cmd & FUTEX_CLOCK_REALTIME))
> +			t = timens_ktime_to_host(CLOCK_MONOTONIC, t);

Err, it probably should be
: else if (!(op & FUTEX_CLOCK_REALTIME))

And there's also
: SYSCALL_DEFINE6(futex_time32, ...)
which wants to be patched.

Thanks,
          Dmitry
