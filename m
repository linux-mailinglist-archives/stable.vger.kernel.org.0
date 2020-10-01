Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E91528023F
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 17:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732414AbgJAPMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 11:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732384AbgJAPMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 11:12:49 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26001208B6;
        Thu,  1 Oct 2020 15:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601565169;
        bh=0tp/yT04bI9YEzGZ7JU9CrvtzZ2lCVTf/YhR8YSvl1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ri2zKa4L3913Z+XrUkCW1KGdtyI7MxP7tlck2HW9hwIv0UX352si7rIbuiOS6hnLI
         fL4PO8r4qCePIcfTb3hcCvb86OHYbQ9AJGQu7kFCilpMLbmC9NCq9FN/JKtkaiDjsA
         o76d0ekIB4Wm4Bbq1dMQo5EMvZ+7+Kwup+k/tJiw=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 467E8403AC; Thu,  1 Oct 2020 12:12:47 -0300 (-03)
Date:   Thu, 1 Oct 2020 12:12:47 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     stable@vger.kernel.org, Hagen Paul Pfeifer <hagen@jauu.net>,
        lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>
Subject: Re: [PATCH] perf tools: Fix printable strings in python3 scripts
Message-ID: <20201001151247.GC18693@kernel.org>
References: <20200928201135.3633850-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928201135.3633850-1-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Mon, Sep 28, 2020 at 10:11:35PM +0200, Jiri Olsa escreveu:
> Hagen reported broken strings in python3 tracepoint scripts:
> 
>   make PYTHON=python3
>   ./perf record -e sched:sched_switch -a -- sleep 5
>   ./perf script --gen-script py
>   ./perf script -s ./perf-script.py
> 
>   [..]
>   sched__sched_switch      7 563231.759525792        0 swapper   \
>   prev_comm=bytearray(b'swapper/7\x00\x00\x00\x00\x00\x00\x00'), \
>   prev_pid=0, prev_prio=120, prev_state=, next_comm=bytearray(b'mutex-thread-co\x00'),
> 
> The problem is in is_printable_array function that does not take
> zero byte into account and claim such string as not printable,
> so the code will create byte array instead of string.

Thanks, tested and applied.

- Arnaldo
 
> Cc: stable@vger.kernel.org
> Fixes: 249de6e07458 ("perf script python: Fix string vs byte array resolving")
> Tested-by: Hagen Paul Pfeifer <hagen@jauu.net>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/print_binary.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/print_binary.c b/tools/perf/util/print_binary.c
> index 599a1543871d..13fdc51c61d9 100644
> --- a/tools/perf/util/print_binary.c
> +++ b/tools/perf/util/print_binary.c
> @@ -50,7 +50,7 @@ int is_printable_array(char *p, unsigned int len)
>  
>  	len--;
>  
> -	for (i = 0; i < len; i++) {
> +	for (i = 0; i < len && p[i]; i++) {
>  		if (!isprint(p[i]) && !isspace(p[i]))
>  			return 0;
>  	}
> -- 
> 2.26.2
> 

-- 

- Arnaldo
