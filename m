Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91656180EEF
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 05:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgCKEcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 00:32:25 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:53581 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgCKEcZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 00:32:25 -0400
Received: by mail-pj1-f68.google.com with SMTP id l36so306775pjb.3;
        Tue, 10 Mar 2020 21:32:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y9CqbWhfL4v92L67bT4ytPNxC+GiQd5penxrum1IdpY=;
        b=N1Fy5y+D5FEggQp2glrbO3Rvu3KhR+BVyRTZAH+CKis/923M0wvRcDrHY47rzK567e
         GImXA0l0SSKPZCYuiwrjl3EHb+W2EwkBO7YUIPRI/wEqGhBVxgrZKvPGvTXWABTRuXYr
         af30ap3ZY8lYbU8AG6FAMpIbcBj4+KasRFh8B3wnV/FZD440ODdGPmPQHEYvQ1+SfAsJ
         DsLZYzVgXQDfWsWIkcVkDeeUtf81NedOLO8hm0hYy4eUZbiOgJQ59Cw3F120fwiZpMcO
         m9oq4BZau66fGcWBjIE2En/EfFRuv7paKzMKByQS2um2sH/d884WkJfUR0jRQuxbvB/X
         Y49w==
X-Gm-Message-State: ANhLgQ0Kt//oPP34Vj4sfqJ+h+o+yokhszqTH9fQmBKpCTQwBXl1fBfS
        3PrL+g7b8PjwWtxgHEEBmsc=
X-Google-Smtp-Source: ADFU+vv/Bu1s/jQ9NTGwcpCjIK6EDBpnZRP/AXC+VdHskcPECDxP/kpl/aj6kWv4dY5WgXspkPnFgg==
X-Received: by 2002:a17:90a:da01:: with SMTP id e1mr1489918pjv.100.1583901143645;
        Tue, 10 Mar 2020 21:32:23 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id b10sm3845793pjo.32.2020.03.10.21.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 21:32:22 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id C909C4028E; Wed, 11 Mar 2020 04:32:21 +0000 (UTC)
Date:   Wed, 11 Mar 2020 04:32:21 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>, NeilBrown <neilb@suse.com>,
        Josh Triplett <josh@joshtriplett.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200311043221.GK11244@42.do-not-panic.com>
References: <20200310223731.126894-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310223731.126894-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> It's long been possible to disable kernel module autoloading completely
> by setting /proc/sys/kernel/modprobe to the empty string.  This can be
> preferable

preferable but ... not documented. Or was this documented or recommended
somewhere?

> to setting it to a nonexistent file since it avoids the
> overhead of an attempted execve(), avoids potential deadlocks, and
> avoids the call to security_kernel_module_request() and thus on
> SELinux-based systems eliminates the need to write SELinux rules to
> dontaudit module_request.
> 
> However, when module autoloading is disabled in this way,
> request_module() returns 0.  This is broken because callers expect 0 to
> mean that the module was successfully loaded.

However this is implicitly not true. For instance, as Neil recently
chased down -- blacklisting a module today returns 0 as well, and so
this corner case is implicitly set to return 0.

> Apparently this was never noticed because this method of disabling
> module autoloading isn't used much, and also most callers don't use the
> return value of request_module() since it's always necessary to check
> whether the module registered its functionality or not anyway.

Right, the de-facto practice of verification of a module to be loaded is
for each caller to ensure with whatever heuristic it needs to ensure the
module is loaded.

> But
> improperly returning 0 can indeed confuse a few callers, for example
> get_fs_type() in fs/filesystems.c where it causes a WARNING to be hit:
> 
> 	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
> 		fs = __get_fs_type(name, len);
> 		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
> 	}
> 
> This is easily reproduced with:
> 
> 	echo > /proc/sys/kernel/modprobe
> 	mount -t NONEXISTENT none /
> 
> It causes:
> 
> 	request_module fs-NONEXISTENT succeeded, but still no fs?
> 	WARNING: CPU: 1 PID: 1106 at fs/filesystems.c:275 get_fs_type+0xd6/0xf0
> 	[...]

Thanks for reporting this.

> Arguably this warning is broken and should be removed, since the module
> could have been unloaded already.

No, the warning is present *because* debuggins issues for when the
module which did not load is a rootfs is *really* hard to debug. Then,
if the culprit of the issue is a userspace modprobe bug (it happens)
this makes debugging *very* difficult as you won't know what failed at
all, you just get a silent failed boot.

> However, request_module() should also
> correctly return an error when it fails.  So let's make it return
> -ENOENT, which matches the error when the modprobe binary doesn't exist.

This is a user experience change though, and I wouldn't have on my radar
who would use this, and expects the old behaviour. Josh, would you by
chance?

I'd like this to be more an RFC first so we get vetted parties to
review. I take it this and Neil's case are cases we should revisit now,
properly document as we didn't before, ensure we don't break anything,
and also extend the respective kmod selftests to ensure we don't break
these corner cases in the future.

> Cc: stable@vger.kernel.org
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jeff Vander Stoep <jeffv@google.com>
> Cc: Jessica Yu <jeyu@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  kernel/kmod.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index bc6addd9152b..a2de58de6ab6 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -120,7 +120,7 @@ static int call_modprobe(char *module_name, int wait)
>   * invoke it.
>   *
>   * If module auto-loading support is disabled then this function
> - * becomes a no-operation.
> + * simply returns -ENOENT.
>   */
>  int __request_module(bool wait, const char *fmt, ...)
>  {
> @@ -137,7 +137,7 @@ int __request_module(bool wait, const char *fmt, ...)
>  	WARN_ON_ONCE(wait && current_is_async());
>  
>  	if (!modprobe_path[0])
> -		return 0;
> +		return -ENOENT;
>  
>  	va_start(args, fmt);
>  	ret = vsnprintf(module_name, MODULE_NAME_LEN, fmt, args);
> -- 
> 2.25.1.481.gfbce0eb801-goog
> 
