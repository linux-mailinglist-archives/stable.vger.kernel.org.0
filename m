Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05FE2931F4
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 01:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389009AbgJSX2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 19:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389006AbgJSX2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 19:28:21 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D4D6C0613CE
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 16:28:21 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j18so26646pfa.0
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 16:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/2F8q6Ukhni9uIK/7GtOstYyNtNLGPo5bALoF91J4xY=;
        b=R3k6TWNErlaI10tN9HGH4Tbg59oBLJ8hJE8RRjdE+SEilovgl5SywBUKkv0V33Gvbm
         TLmC+YS1yHgTnS7XZiAVAO0RJreM9B0VLzGkNx16nl4KOvHWojBgOWIzqnFONLkGSKRz
         ENztsbkxXoiM1mO7iwaN35ejSyYCXnupEvxyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/2F8q6Ukhni9uIK/7GtOstYyNtNLGPo5bALoF91J4xY=;
        b=cTsv1id0OB8gMbKI8XxE2lc2FEix94sNsKaNBeRDN8LYZb9PRe8H0z5KaxErrufBDz
         QkkmOvwVIUIL1ZzJXrn2DGTTv5/ApiydCRHcY5Yia+P9gpGvnwjm1akNpyMnKFBVxwun
         b9NzKE8qJrSfx+2amFlHNfcxxp+GjL5FTZNIj+DvvpJxTms8Vb/OYy5JIs3qbkYGGJbr
         HXcpBXOqleGF9b7MM9pjefREndF3uSrzGi+Yo+C6y+RUYLiGN36iJDeUA2ZtDxyxgn9x
         DCXilTWfVxLwH32ClCHAj5CKuJ1gia2HmcFpWshGni00zrYaVelJVOBbMKbMAZFNVcAR
         J9jQ==
X-Gm-Message-State: AOAM530JZERJ40sMnF2b8oDxG/eLvzzTUhSTDezcgU1jHMjarnM8j06U
        XXAHJgfmUrImZkW465JjvSG2c9rbEYSnnw==
X-Google-Smtp-Source: ABdhPJwECESC+w8dkkuXxPwLKBef0/S2i4jE4Sg+BjJz3NDNLHjqciKGsvjvXXOtTi4UIeYHDBdfZA==
X-Received: by 2002:a63:f815:: with SMTP id n21mr214858pgh.410.1603150100682;
        Mon, 19 Oct 2020 16:28:20 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w6sm590961pgw.28.2020.10.19.16.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 16:28:19 -0700 (PDT)
Date:   Mon, 19 Oct 2020 16:28:19 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rich Felker <dalias@libc.org>
Subject: Re: [PATCH AUTOSEL 5.9 026/111] seccomp: kill process instead of
 thread for unknown actions
Message-ID: <202010191627.EAD97F5E@keescook>
References: <20201018191807.4052726-1-sashal@kernel.org>
 <20201018191807.4052726-26-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018191807.4052726-26-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

I'd prefer this was not backported -- it's not a bug fix, and if the
behavioral change is actually disruptive, I'd like to keep the fall-out
contained. :)

Thanks!

-Kees

On Sun, Oct 18, 2020 at 03:16:42PM -0400, Sasha Levin wrote:
> From: Rich Felker <dalias@libc.org>
> 
> [ Upstream commit 4d671d922d51907bc41f1f7f2dc737c928ae78fd ]
> 
> Asynchronous termination of a thread outside of the userspace thread
> library's knowledge is an unsafe operation that leaves the process in
> an inconsistent, corrupt, and possibly unrecoverable state. In order
> to make new actions that may be added in the future safe on kernels
> not aware of them, change the default action from
> SECCOMP_RET_KILL_THREAD to SECCOMP_RET_KILL_PROCESS.
> 
> Signed-off-by: Rich Felker <dalias@libc.org>
> Link: https://lore.kernel.org/r/20200829015609.GA32566@brightrain.aerifal.cx
> [kees: Fixed up coredump selection logic to match]
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  kernel/seccomp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 676d4af621038..f754c1087e413 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1020,7 +1020,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>  	default:
>  		seccomp_log(this_syscall, SIGSYS, action, true);
>  		/* Dump core only if this is the last remaining thread. */
> -		if (action == SECCOMP_RET_KILL_PROCESS ||
> +		if (action != SECCOMP_RET_KILL_THREAD ||
>  		    get_nr_threads(current) == 1) {
>  			kernel_siginfo_t info;
>  
> @@ -1030,10 +1030,10 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>  			seccomp_init_siginfo(&info, this_syscall, data);
>  			do_coredump(&info);
>  		}
> -		if (action == SECCOMP_RET_KILL_PROCESS)
> -			do_group_exit(SIGSYS);
> -		else
> +		if (action == SECCOMP_RET_KILL_THREAD)
>  			do_exit(SIGSYS);
> +		else
> +			do_group_exit(SIGSYS);
>  	}
>  
>  	unreachable();
> -- 
> 2.25.1
> 

-- 
Kees Cook
