Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB62517CC
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 17:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731416AbfFXP6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 11:58:04 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45653 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731413AbfFXP6E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jun 2019 11:58:04 -0400
Received: by mail-pl1-f196.google.com with SMTP id bi6so7131453plb.12
        for <stable@vger.kernel.org>; Mon, 24 Jun 2019 08:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DJnEi1YXeUUZLNDz6H66DhAhyTf27C4w0UFUWB0nSNo=;
        b=JR+0PofkIPb42rXZ0k4D1jhgYRpVXf4D1DZj7Vzg62hYuln3n7kOpSb+72F3aHg6GJ
         l31NjIe4IHGgEOmUuZdmpt1xSJNmKAu9H1dc4Th+TRnH9TcVeIH4rpDLYAR3nnJUanzS
         u8VfIxMgsz5WT8qUOcdlnua9ePr0qN5/TEYdE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DJnEi1YXeUUZLNDz6H66DhAhyTf27C4w0UFUWB0nSNo=;
        b=XBevg4L17FemvQWZ4qlSyAIjjewBT5cLEzECOtFLPTpRGAP0tqO1/5MQ4rO0Hn0fV+
         eQiusH0h6l9mAKPB7/EDJZXvpujbi8nk5xTMeDMvxjpeszIsETl8jDWMosjbwNVBqBGx
         b/dnql/gIX0zT5C7GNfLgqRwlq69wNMOudLWw+Qan6btPYdexnvDSNma0J9Dv2ZDJFlW
         ozcrc5wOlHY7Mulw7TPbbE2auoZ5GwcATvrZlZA9eZK56FkHwNBZXPcfYjoJskY1o5vP
         5Iduy+GdQYv4sATsD0foS2uXl0NUGkFO7ICKuz1t6mirrN/hxMjIONov1JRC+yZeIEgO
         v37w==
X-Gm-Message-State: APjAAAVdclpDEgfjo07oWCF3UUCrzfk33YnmuLirCNzUitAVFT5tZ+UQ
        rja7r1+0341FOxY/psPonGNzzQ==
X-Google-Smtp-Source: APXvYqyrlPNh2D7rvrEuRlTDMSipBjo8BKKPyMY23jseHGJ/KfMrjragNNhq/D8Fgg4PJS9Ar17qjg==
X-Received: by 2002:a17:902:4e25:: with SMTP id f34mr7421058ple.305.1561391883819;
        Mon, 24 Jun 2019 08:58:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w132sm12678681pfd.78.2019.06.24.08.58.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Jun 2019 08:58:03 -0700 (PDT)
Date:   Mon, 24 Jun 2019 08:58:02 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Drew Davenport <ddavenport@chromium.org>, akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] bug: Fix "cut here" for WARN_ON for __WARN_TAINT
 architectures
Message-ID: <201906240856.0A82D562C@keescook>
References: <20190624154831.163888-1-ddavenport@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624154831.163888-1-ddavenport@chromium.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 09:48:31AM -0600, Drew Davenport wrote:
> For architectures using __WARN_TAINT, the WARN_ON macro did not
> print out the "cut here" string. The other WARN_XXX macros would
> print "cut here" inside __warn_printk, which is not called for
> WARN_ON since it doesn't have a message to print.
> 
> Fixes: a7bed27af194 ("bug: fix "cut here" location for __WARN_TAINT architectures")
> Cc: stable@vger.kernel.org
> Signed-off-by: Drew Davenport <ddavenport@chromium.org>

Whoops, yes; thanks for catching this!

Acked-and-Tested-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  include/asm-generic/bug.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index c21ff2712803..79feb1a3081b 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -94,8 +94,10 @@ extern void warn_slowpath_null(const char *file, const int line);
>  	warn_slowpath_fmt_taint(__FILE__, __LINE__, taint, arg)
>  #else
>  extern __printf(1, 2) void __warn_printk(const char *fmt, ...);
> -#define __WARN()		__WARN_TAINT(TAINT_WARN)
> -#define __WARN_printf(arg...)	do { __warn_printk(arg); __WARN(); } while (0)
> +#define __WARN() do { \
> +	printk(KERN_WARNING CUT_HERE); __WARN_TAINT(TAINT_WARN); \
> +} while (0)
> +#define __WARN_printf(arg...)	__WARN_printf_taint(TAINT_WARN, arg)
>  #define __WARN_printf_taint(taint, arg...)				\
>  	do { __warn_printk(arg); __WARN_TAINT(taint); } while (0)
>  #endif
> -- 
> 2.20.1
> 

-- 
Kees Cook
