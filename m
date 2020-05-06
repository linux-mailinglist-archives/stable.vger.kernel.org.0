Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DADD1C76CB
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 18:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgEFQoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 12:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727984AbgEFQoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 12:44:12 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B11C061A0F;
        Wed,  6 May 2020 09:44:12 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id o16so1542270qtb.13;
        Wed, 06 May 2020 09:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t7CgGDakZ6HBwLoyEuXzHSsFPvnCyBpRS/YoqjnzK6M=;
        b=N5lLph8jiTGnSBatLuURZEb4yy06JEJ+bZRmXyC1PWnHC8sDPqjgr3/SqpyoJZA1DC
         oV9HWnMj/XijqO2WVyWHSfC72ZE3oPq2liwvU6O39+3dbXsr/JLoSGjs9t5KtgrlUi+a
         iPqZtalYYRB58LucAh7ylY2zUFmfXyAtWTi+8Tr9RwLiO8ZkXzqwXmv9t2NA1xdqQLR9
         h5pd0V50OWPI4ALsdQJFxYQ1uiqLAbRnHTCIv6FtAHsewcu7DjA1HNpPDiNsRI0GbKOL
         ox4FgFawO0NA0InSmxWKyAoSWFW02HC5ivRfLwXYYOjSL4CkC4oKilvcQReqotv0gNCo
         tn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t7CgGDakZ6HBwLoyEuXzHSsFPvnCyBpRS/YoqjnzK6M=;
        b=TOXu13XYGRhWBKMSf6l4pexBZ0UbgXRJTm6+N6Y15d7nyJmbYPmbBjQJErUR/Jc6as
         anVJ7RqEB4FROLIhgU9FCuGUHrldwwrPRXIWJDradlj16pZKTecNITZ3/eX6GZ+mjEPN
         Dikz8SDOk/rg61ltsVp/X5xF43zo5AkWBSIQwujYXdamKV3ANPSMy9/Bu7A7xzDVcC5A
         2NNHXAGwgPIApqqw6yWyQHAjAsd3FYZF9GulYhWO5GUzImCuK5teu5zchnv8lATn0Wbc
         XS3mHpWDa48+Lwr05QYNAawNqirJxIkqQ8DOf72+NB6zB0vrqH4oewKpJrJgmtFia9nL
         nnXA==
X-Gm-Message-State: AGi0PuZHb6r510KrrnQfrn6SrbR1ZDOSsgf40JQiOQbI0rhF/xO1GOyA
        0399zB/isACZ5luB+NegEBFHxW2TCbA=
X-Google-Smtp-Source: APiQypLpWj1Wxz1UeUcc7dMbxUPCp3rCGxhahy7fC/kMvfQlUpBR02ObZReFLwHMP51ydu8/wM5n2g==
X-Received: by 2002:ac8:2783:: with SMTP id w3mr8989034qtw.265.1588783451454;
        Wed, 06 May 2020 09:44:11 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id c7sm2031704qko.55.2020.05.06.09.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 09:44:10 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id CBE2A409A3; Wed,  6 May 2020 13:44:08 -0300 (-03)
Date:   Wed, 6 May 2020 13:44:08 -0300
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/3] perf-probe: Fix to check blacklist address correctly
Message-ID: <20200506164408.GA4323@kernel.org>
References: <158763965400.30755.14484569071233923742.stgit@devnote2>
 <158763966411.30755.5882376357738273695.stgit@devnote2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158763966411.30755.5882376357738273695.stgit@devnote2>
X-Url:  http://acmel.wordpress.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Thu, Apr 23, 2020 at 08:01:04PM +0900, Masami Hiramatsu escreveu:
> Fix to check kprobe blacklist address correctly with
> relocated address by adjusting debuginfo address.
> 
> Since the address in the debuginfo is same as objdump,
> it is different from relocated kernel address with KASLR.
> Thus, the perf-probe always misses to catch the
> blacklisted addresses.

Thanks, applied, sorry for the delay,

- Arnaldo
 
> Without this patch, perf probe can not detect the blacklist
> addresses on KASLR enabled kernel.
> 
> =========
>   # perf probe kprobe_dispatcher
>   Failed to write event: Invalid argument
>     Error: Failed to add events.
> =========
> 
> With this patch, it correctly shows the error message.
> 
> =========
>   # perf probe kprobe_dispatcher
>   kprobe_dispatcher is blacklisted function, skip it.
>   Probe point 'kprobe_dispatcher' not found.
>     Error: Failed to add events.
> =========
> 
> Fixes: 9aaf5a5f479b ("perf probe: Check kprobes blacklist when adding new events")
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  tools/perf/util/probe-event.c |   21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index eea132f512b0..f75df63309be 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -102,7 +102,7 @@ void exit_probe_symbol_maps(void)
>  	symbol__exit();
>  }
>  
> -static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
> +static struct ref_reloc_sym *kernel_get_ref_reloc_sym(struct map **pmap)
>  {
>  	/* kmap->ref_reloc_sym should be set if host_machine is initialized */
>  	struct kmap *kmap;
> @@ -114,6 +114,10 @@ static struct ref_reloc_sym *kernel_get_ref_reloc_sym(void)
>  	kmap = map__kmap(map);
>  	if (!kmap)
>  		return NULL;
> +
> +	if (pmap)
> +		*pmap = map;
> +
>  	return kmap->ref_reloc_sym;
>  }
>  
> @@ -125,7 +129,7 @@ static int kernel_get_symbol_address_by_name(const char *name, u64 *addr,
>  	struct map *map;
>  
>  	/* ref_reloc_sym is just a label. Need a special fix*/
> -	reloc_sym = kernel_get_ref_reloc_sym();
> +	reloc_sym = kernel_get_ref_reloc_sym(NULL);
>  	if (reloc_sym && strcmp(name, reloc_sym->name) == 0)
>  		*addr = (reloc) ? reloc_sym->addr : reloc_sym->unrelocated_addr;
>  	else {
> @@ -745,6 +749,7 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
>  				       int ntevs)
>  {
>  	struct ref_reloc_sym *reloc_sym;
> +	struct map *map;
>  	char *tmp;
>  	int i, skipped = 0;
>  
> @@ -753,7 +758,7 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
>  		return post_process_offline_probe_trace_events(tevs, ntevs,
>  						symbol_conf.vmlinux_name);
>  
> -	reloc_sym = kernel_get_ref_reloc_sym();
> +	reloc_sym = kernel_get_ref_reloc_sym(&map);
>  	if (!reloc_sym) {
>  		pr_warning("Relocated base symbol is not found!\n");
>  		return -EINVAL;
> @@ -764,9 +769,13 @@ post_process_kernel_probe_trace_events(struct probe_trace_event *tevs,
>  			continue;
>  		if (tevs[i].point.retprobe && !kretprobe_offset_is_supported())
>  			continue;
> -		/* If we found a wrong one, mark it by NULL symbol */
> +		/*
> +		 * If we found a wrong one, mark it by NULL symbol.
> +		 * Since addresses in debuginfo is same as objdump, we need
> +		 * to convert it to addresses on memory.
> +		 */
>  		if (kprobe_warn_out_range(tevs[i].point.symbol,
> -					  tevs[i].point.address)) {
> +			map__objdump_2mem(map, tevs[i].point.address))) {
>  			tmp = NULL;
>  			skipped++;
>  		} else {
> @@ -2936,7 +2945,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
>  	/* Note that the symbols in the kmodule are not relocated */
>  	if (!pev->uprobes && !pev->target &&
>  			(!pp->retprobe || kretprobe_offset_is_supported())) {
> -		reloc_sym = kernel_get_ref_reloc_sym();
> +		reloc_sym = kernel_get_ref_reloc_sym(NULL);
>  		if (!reloc_sym) {
>  			pr_warning("Relocated base symbol is not found!\n");
>  			ret = -EINVAL;
> 

-- 

- Arnaldo
