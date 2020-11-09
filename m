Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218562AB768
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 12:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgKILnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 06:43:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:34534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKILnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 06:43:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4A5A20789;
        Mon,  9 Nov 2020 11:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604922231;
        bh=PYG/t8cgnN0DROMTJhPKE5TMqpEZ4rNKTZqNwXdVvIk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yfpavlva+m5+0oZRrWiiM0V+wNBLfltuIA3gP6Yk/MCN5YZxFtdCFreUVvN5CEjzG
         kLExU5POHU5wQuVHk3hX40lG4JxWYBQYC1vTP9ioP/A+XYd0hlnGsvDSAUmc7Yfyci
         iIkKmboH9jF9+5zwy5M1gw5FNa7M2Ic3zietbIiA=
Date:   Mon, 9 Nov 2020 12:44:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v4.19] tools: perf: Fix build error in v4.19.y
Message-ID: <20201109114451.GE1769924@kroah.com>
References: <20201108003124.100732-1-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201108003124.100732-1-linux@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 07, 2020 at 04:31:24PM -0800, Guenter Roeck wrote:
> perf may fail to build in v4.19.y with the following error.
> 
> util/evsel.c: In function ‘perf_evsel__exit’:
> util/util.h:25:28: error:
> 	passing argument 1 of ‘free’ discards ‘const’ qualifier from pointer target type
> 
> This is observed (at least) with gcc v6.5.0. The underlying problem is
> the following statement.
> 	zfree(&evsel->pmu_name);
> evsel->pmu_name is decared 'const *'. zfree in turn is defined as
> 	#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
> and thus passes the const * to free(). The problem is not seen
> in the upstream kernel since zfree() has been rewritten there.
> 
> The problem has been introduced into v4.19.y with the backport of upstream
> commit d4953f7ef1a2 (perf parse-events: Fix 3 use after frees found with
> clang ASAN).
> 
> One possible fix of this problem would be to not declare pmu_name
> as const. This patch chooses to typecast the parameter of zfree()
> to void *, following the guidance from the upstream kernel which
> does the same since commit 7f7c536f23e6a ("tools lib: Adopt
> zalloc()/zfree() from tools/perf")
> 
> Fixes: a0100a363098 ("perf parse-events: Fix 3 use after frees found with clang ASAN")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> This patch only applies to v4.19.y and has no upstream equivalent.
> 
>  tools/perf/util/util.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index dc58254a2b69..8c01b2cfdb1a 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -22,7 +22,7 @@ static inline void *zalloc(size_t size)
>  	return calloc(1, size);
>  }
>  
> -#define zfree(ptr) ({ free(*ptr); *ptr = NULL; })
> +#define zfree(ptr) ({ free((void *)*ptr); *ptr = NULL; })
>  
>  struct dirent;
>  struct nsinfo;
> -- 
> 2.17.1
> 

Now queued up, thanks.

greg k-h
