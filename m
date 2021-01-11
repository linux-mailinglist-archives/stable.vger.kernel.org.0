Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833282F205D
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 21:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbhAKUFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 15:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390281AbhAKUFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 15:05:36 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6C7C061786
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:04:56 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id s15so68835plr.9
        for <stable@vger.kernel.org>; Mon, 11 Jan 2021 12:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oLv8ltJc+IKNPAGm6ahyMW/yLOMacKsqoYC06b+teng=;
        b=cKBL/Vh7MLBDXUYpfhodlVYJNxKKtScaEztGi444N+ypaojwzakC7y8zYtZOeDR834
         f19+MmHhDnwLjPNVWy0QqWQXkIyc8YZ2hdWEu7SjwiHuKHqhFs2srkXtW226sPg5RB2o
         onSrLPG7NODZ7FB2Ycxvad0BNpEhJ+p8DvqVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oLv8ltJc+IKNPAGm6ahyMW/yLOMacKsqoYC06b+teng=;
        b=cvPeosNLEQKAD/LKcNJO37fqH8MB18//w8N7+AnheH3SL+BACTy34X/GRIhM0gjnKk
         gzv2OOeubhzu5SE1Lwv+4pGpBr+IE+TnUskxO3m4nJORAe/5PospwAgCGvpHnhgu276e
         e132zPImZxkfLChB15CNJSaW9O79OcQsyTJR6kAgOEnWJcTdJ3sREP9UiIyD0T77JN4c
         eUkQZc09hiJau9cGa4sRC6nov2NChB2RQa26fQxPKSW8jJAfyK5SgnFwVLDAU5/eLVwe
         uO3IyXmiVrwgo67bErl0ZVcWLSUV5Y0WKR0425kUjzvmxKCZLrSRv+VSvCHGwZSTgJve
         gPAw==
X-Gm-Message-State: AOAM532EROc/nClK18QYygO6pMu3BszWM1g2lQjUgub5tfGttdhOhvWL
        qEdd8xbtrgPKxG1V3twzc+IZaQ==
X-Google-Smtp-Source: ABdhPJyt2NwCXxzPBC4xpRrmKZB0Rz0N1E4iBg2ZSnIKGeLeNCTefSsoBd0RsPN8blvfJe4sMATzqA==
X-Received: by 2002:a17:902:b116:b029:dc:c93:1d6b with SMTP id q22-20020a170902b116b02900dc0c931d6bmr1404786plr.22.1610395496389;
        Mon, 11 Jan 2021 12:04:56 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t1sm225433pju.43.2021.01.11.12.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 12:04:55 -0800 (PST)
Date:   Mon, 11 Jan 2021 12:04:54 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] seccomp: Add missing return in non-void function
Message-ID: <202101111204.971BDEC@keescook>
References: <20210111172839.640914-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111172839.640914-1-paul@crapouillou.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 05:28:39PM +0000, Paul Cercueil wrote:
> We don't actually care about the value, since the kernel will panic
> before that; but a value should nonetheless be returned, otherwise the
> compiler will complain.
> 
> Fixes: 8112c4f140fa ("seccomp: remove 2-phase API")
> Cc: stable@vger.kernel.org # 4.7+
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

Ah, yes, thanks. What was the build config where this actually got
exposed?

> ---
>  kernel/seccomp.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 952dc1c90229..63b40d12896b 100644
> --- a/kernel/seccomp.c
> +++ b/kernel/seccomp.c
> @@ -1284,6 +1284,8 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
>  			    const bool recheck_after_trace)
>  {
>  	BUG();
> +
> +	return -1;
>  }
>  #endif
>  
> -- 
> 2.29.2
> 

-- 
Kees Cook
