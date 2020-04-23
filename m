Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7F01B5D20
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 16:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgDWOBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 10:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727053AbgDWOBK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 10:01:10 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCCEC08E934;
        Thu, 23 Apr 2020 07:01:08 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id p13so2869778qvt.12;
        Thu, 23 Apr 2020 07:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jXDe/IW3FrJSTh/vYqQdoYVT3ff45aX6yw/T7/hZptk=;
        b=iu7dtUoy9t4K29l/5Fa0WXwcHbdLxNAOu6c6/jCTjdv3xq9eXlSIxixzt8w5mEFsxN
         KC0G83TpOICG32Xo63toL6NpMBDn2TuVBuLN2yii3sMwHDzya6QDByhQKjZ/muR9YpGc
         8+tfz2tvWNFIM4I9MKBmw8m2Gz/1ZrixFjpp43aTJH1kWgSYv81aJPb/lcvWTijf9lYH
         S/JoaqNYe+EMHPZMG9aM2uZn1+AQK7c/tu/ygL6q/VC0hvJ2P6rXz64N/jAXF19xWqWg
         sVOQLr2wy0Rb4C8l7fMdTv4JXjtEm/NRhgbBtNw5M2JXQYJeKabD5JOzPT0XCxF1GDOD
         4TXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jXDe/IW3FrJSTh/vYqQdoYVT3ff45aX6yw/T7/hZptk=;
        b=Dvsm0amh2EVTo2LKk3c423tA56kSwtYzasSkj87DNG/Ki5frbIsbFfUT+/xeSNQCfP
         HTx0DqG2b+EqZe4pgVn1qszyhiIBsORVdGIl1ip1LGxrc7qmrZ1blrZ9K+f0CsTcAwXh
         dHANemVfEJtOP3Xt6Yxp8PWD+y85XLDDxTpSHNCjPvnp7j7PAxaeU3P3hG1udpSK5FHW
         fxyqsJiycaJbSgWcTxyS6vOb6nUUDYLREItBg/S1kfVUPeC3N9Fy8cJTKVT96Uq6Sexs
         Mn13GGndPj+D0M6ohNwPivCo8E6+J21kPsay/s08aYO4XxX2kZqhes4q4Ic6kR30495o
         P0OA==
X-Gm-Message-State: AGi0PuayUfPH8Q7hPX7E+/0gYVH6fIsmc53gFbJU4EHzYfvw4QwSymBN
        xvo8iUB5r9blXlJaIBi1L3dugzL7rcU=
X-Google-Smtp-Source: APiQypK69MjOG3v2c5KK/21f3EG5cCkaefsv8EQvpuOcgfuWAWhlx2xjHR8F7WI/Pz/4jMDbUxuH8g==
X-Received: by 2002:a05:6214:18c9:: with SMTP id cy9mr4243800qvb.35.1587650467052;
        Thu, 23 Apr 2020 07:01:07 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id i56sm1841572qte.6.2020.04.23.07.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 07:01:06 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 7DC42409A3; Thu, 23 Apr 2020 11:01:02 -0300 (-03)
Date:   Thu, 23 Apr 2020 11:01:02 -0300
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 2/3] perf-probe: Check address correctness by map instead
 of _etext
Message-ID: <20200423140102.GF19437@kernel.org>
References: <158763965400.30755.14484569071233923742.stgit@devnote2>
 <158763967332.30755.4922496724365529088.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158763967332.30755.4922496724365529088.stgit@devnote2>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Thu, Apr 23, 2020 at 08:01:13PM +0900, Masami Hiramatsu escreveu:
> Since commit 03db8b583d1c ("perf tools: Fix maps__find_symbol_by_name()")
> introduced map address range check in maps__find_symbol_by_name(),
> we can not get "_etext" from kernel map because _etext is placed
> on the edge of the kernel .text section (= kernel map in perf.)
> 
> To fix this issue, this checks the address correctness
> by map address range information (map->start and map->end)
> instead of using _etext address.
> 
> This can cause an error if the target inlined function is
> embedded in both __init function and normal function.
> 
> For exaample, request_resource() is a normal function but also
> embedded in __init reserve_setup(). In this case, the probe point
> in reserve_setup() must be skipped. However, without this fix,
> it failes to setup all probe points.
> ================
>   # ./perf probe -v request_resource
>   probe-definition(0): request_resource
>   symbol:request_resource file:(null) line:0 offset:0 return:0 lazy:(null)
>   0 arguments
>   Looking at the vmlinux_path (8 entries long)
>   Using /usr/lib/debug/lib/modules/5.5.17-200.fc31.x86_64/vmlinux for symbols
>   Open Debuginfo file: /usr/lib/debug/lib/modules/5.5.17-200.fc31.x86_64/vmlinux
>   Try to find probe point from debuginfo.
>   Matched function: request_resource [15e29ad]
>   found inline addr: 0xffffffff82fbf892
>   Probe point found: reserve_setup+204
>   found inline addr: 0xffffffff810e9790
>   Probe point found: request_resource+0
>   Found 2 probe_trace_events.
>   Opening /sys/kernel/debug/tracing//kprobe_events write=1
>   Opening /sys/kernel/debug/tracing//README write=0
>   Writing event: p:probe/request_resource _text+33290386
>   Failed to write event: Invalid argument
>     Error: Failed to add events. Reason: Invalid argument (Code: -22)
> ================
> 
> With this fix,
> 
> ================
>   # ./perf probe request_resource
>   reserve_setup is out of .text, skip it.
>   Added new events:
>     (null):(null)        (on request_resource)

But what is this (null):(null) probe? Confusing :-)

Thanks for working on this!

- Arnaldo

>     probe:request_resource (on request_resource)
> 
>   You can now use it in all perf tools, such as:
> 
>   	perf record -e probe:request_resource -aR sleep 1
> 
> ================
> 
> Fixes: 03db8b583d1c ("perf tools: Fix maps__find_symbol_by_name()")
> Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  tools/perf/util/probe-event.c |   25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index f75df63309be..a5387e03e365 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -236,21 +236,22 @@ static void clear_probe_trace_events(struct probe_trace_event *tevs, int ntevs)
>  static bool kprobe_blacklist__listed(unsigned long address);
>  static bool kprobe_warn_out_range(const char *symbol, unsigned long address)
>  {
> -	u64 etext_addr = 0;
> -	int ret;
> -
> -	/* Get the address of _etext for checking non-probable text symbol */
> -	ret = kernel_get_symbol_address_by_name("_etext", &etext_addr,
> -						false, false);
> +	struct map *map;
> +	bool ret = false;
>  
> -	if (ret == 0 && etext_addr < address)
> -		pr_warning("%s is out of .text, skip it.\n", symbol);
> -	else if (kprobe_blacklist__listed(address))
> +	map = kernel_get_module_map(NULL);
> +	if (map) {
> +		ret = address <= map->start || map->end < address;
> +		if (ret)
> +			pr_warning("%s is out of .text, skip it.\n", symbol);
> +		map__put(map);
> +	}
> +	if (!ret && kprobe_blacklist__listed(address)) {
>  		pr_warning("%s is blacklisted function, skip it.\n", symbol);
> -	else
> -		return false;
> +		ret = true;
> +	}
>  
> -	return true;
> +	return ret;
>  }
>  
>  /*
> 

-- 

- Arnaldo
