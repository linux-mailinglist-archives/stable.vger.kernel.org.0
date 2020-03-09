Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B32C317E18C
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 14:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgCINn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 09:43:27 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:35531 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgCINn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 09:43:27 -0400
Received: by mail-qv1-f68.google.com with SMTP id u10so4360127qvi.2;
        Mon, 09 Mar 2020 06:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tD+3aLmpuKugr7D1U6Ul4mtBXGeYELcsGZqijeWjbw4=;
        b=dviCAozL0GbrixkSV0iv0PBU/nc7WSJPAEmJFMkHyN0DqaIzxdKUeWc2SMo2qnMOKn
         jc+hVkUtMijgCFejkfEHRX0vlaHKUIHdp2WHYBFhRYiuVlghfYPOr5kD10dBcOm4LG49
         XbJctoDpXp7gBkErqx68HuZ44ZrsKa+R7V6efUP/V3EN045IOcOVFhffviUrSpqv/EKo
         3kiI+tJqhmcyd4QDGBL3uqcU1vcj7uNk+58BbdWAZeDZrOSolgiMBHLrfkUJayftdOn5
         ycW2ge8hNE1zBMkwMxvpqGi3V/2nr6pq+d/Obysu095suuwkHEVyEbKZA4JzMMYjg6VQ
         DLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tD+3aLmpuKugr7D1U6Ul4mtBXGeYELcsGZqijeWjbw4=;
        b=NVl7BSrUB1nNqRDfULUcA47VpGpeYeRRwoj9pFVM1avOTTszRvYZvaNNvsxmIddNQw
         RwOi1qNd6amy5nZcmAhw6E9f8AkNY0pNu7j+aLPMZ9RwabmDboi3QgedF4MTyFJ/HzMt
         /tfkSa1XG1mvMoyZv3tlItOzsPjXkRGNXh5raeewrJt4554234BwJjqCvejHsAqcv2cc
         kNUK1Eln/K6v88uk0X4F6KGcQ6wP0MP/qqqQ36qBgazdXBSrAeSJYBPEENYbyvrC9BpP
         F6HbWMWfSdrdwSQOh+TY93mBXu/JOkpVtPTFoBq+CmUulWLv3z2mff743OEgLHZE/C0m
         9dyg==
X-Gm-Message-State: ANhLgQ0GE9+DITIkS9CipZSRIV7/iptsy+5FWKOy6bHYx22F5/822Ch4
        lQb8KZnUkUYMqdh1ng0i03M=
X-Google-Smtp-Source: ADFU+vvNyjFdDvSIHgzjDRbVuld9Pd9x2EmV9w3X/BQOQOTUj2ZiIw69Td2qllggEDV9zATKlDHIvA==
X-Received: by 2002:a0c:e891:: with SMTP id b17mr9166682qvo.235.1583761405878;
        Mon, 09 Mar 2020 06:43:25 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id f3sm5714248qkk.48.2020.03.09.06.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 06:43:24 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C28C740009; Mon,  9 Mar 2020 10:43:22 -0300 (-03)
Date:   Mon, 9 Mar 2020 10:43:22 -0300
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        He Zhe <zhe.he@windriver.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] perf probe: Fix to delete multiple probe event
Message-ID: <20200309134322.GD477@kernel.org>
References: <158287666197.16697.7514373548551863562.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158287666197.16697.7514373548551863562.stgit@devnote2>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Fri, Feb 28, 2020 at 04:57:42PM +0900, Masami Hiramatsu escreveu:
> Fix to delete multiple probe event with filter correctly.
> 
> When we put an event with multiple probes, perf-probe fails
> to delete with filters. This comes from a failure to list
> up the event name because of overwrapping its name.
> 
> To fix this issue, skip to list up the event which has
> same name.
> 
> Without this patch:
>   # perf probe -l \*
>     probe_perf:map__map_ip (on perf_sample__fprintf_brstackoff:21@
>     probe_perf:map__map_ip (on perf_sample__fprintf_brstackoff:25@
>     probe_perf:map__map_ip (on append_inlines:12@util/machine.c in
>     probe_perf:map__map_ip (on unwind_entry:19@util/machine.c in /
>     probe_perf:map__map_ip (on map__map_ip@util/map.h in /home/mhi
>     probe_perf:map__map_ip (on map__map_ip@util/map.h in /home/mhi
>   # perf probe -d \*
>   "*" does not hit any event.
>     Error: Failed to delete events. Reason: No such file or directory (Code: -2)
> 
> With this:
>   # perf probe -d \*
>   Removed event: probe_perf:map__map_ip

Thanks, tested and applied to perf/urgent.

- Arnaldo
 
> Fixes: 72363540c009 ("perf probe: Support multiprobe event")
> Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
> Reported-by: He Zhe <zhe.he@windriver.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> ---
>  v2:
>   - Forward port on the latest perf/urgent tree.
>   - Add Fixes and Reporters.
> ---
>  tools/perf/util/probe-file.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/util/probe-file.c b/tools/perf/util/probe-file.c
> index 0f5fda11675f..8c852948513e 100644
> --- a/tools/perf/util/probe-file.c
> +++ b/tools/perf/util/probe-file.c
> @@ -206,6 +206,9 @@ static struct strlist *__probe_file__get_namelist(int fd, bool include_group)
>  		} else
>  			ret = strlist__add(sl, tev.event);
>  		clear_probe_trace_event(&tev);
> +		/* Skip if there is same name multi-probe event in the list */
> +		if (ret == -EEXIST)
> +			ret = 0;
>  		if (ret < 0)
>  			break;
>  	}
> 

-- 

- Arnaldo
