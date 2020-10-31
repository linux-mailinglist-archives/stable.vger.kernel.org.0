Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422E92A1A89
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 21:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbgJaU32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 16:29:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59512 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbgJaU31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Oct 2020 16:29:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604176166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OR4KMfMPbpKQLMp2weJp3GsaUhJnnbli7sqAKhs6M+M=;
        b=c6Ny/e/itTX+8nLU31qAQDPGuRGRdX6+bo+4DxBC+ouY9DTe98stCI0tgSVfhLBXXv/Gsv
        WucE1T1pf0YGl+GplxoQz1u3SZDyJ7QsSHfvzMRtqVwLLGpbx5Sq5RJD4QscbdGY5cGkgP
        RSQFDOsjcalqbzYOlIQA5DKU7ytu46w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-1yANeTggOiun0nXsG2-6og-1; Sat, 31 Oct 2020 16:29:24 -0400
X-MC-Unique: 1yANeTggOiun0nXsG2-6og-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDE14802B7D;
        Sat, 31 Oct 2020 20:29:22 +0000 (UTC)
Received: from krava (unknown [10.40.192.83])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5050260BF3;
        Sat, 31 Oct 2020 20:29:21 +0000 (UTC)
Date:   Sat, 31 Oct 2020 21:29:20 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH] perf: increase size of buf in perf_evsel__hists_browse()
Message-ID: <20201031202920.GC3380099@krava>
References: <20201030235431.534417-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030235431.534417-1-songliubraving@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 04:54:31PM -0700, Song Liu wrote:
> Making perf with gcc-9.1.1 generates the following warning:
> 
>   CC       ui/browsers/hists.o
> ui/browsers/hists.c: In function 'perf_evsel__hists_browse':
> ui/browsers/hists.c:3078:61: error: '%d' directive output may be \
> truncated writing between 1 and 11 bytes into a region of size \
> between 2 and 12 [-Werror=format-truncation=]
> 
>  3078 |       "Max event group index to sort is %d (index from 0 to %d)",
>       |                                                             ^~
> ui/browsers/hists.c:3078:7: note: directive argument in the range [-2147483648, 8]
>  3078 |       "Max event group index to sort is %d (index from 0 to %d)",
>       |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from /usr/include/stdio.h:937,
>                  from ui/browsers/hists.c:5:
> 
> IOW, the string in line 3078 might be too long for buf[] of 64 bytes.
> 
> Fix this by increasing the size of buf[] to 128.
> 
> Fixes: dbddf1747441  ("perf report/top TUI: Support hotkeys to let user select any event for sorting")
> Cc: stable <stable@vger.kernel.org> # v5.7+
> Cc: Jin Yao <yao.jin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Signed-off-by: Song Liu <songliubraving@fb.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

jirka

> ---
>  tools/perf/ui/browsers/hists.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
> index a07626f072087..b0e1880cf992b 100644
> --- a/tools/perf/ui/browsers/hists.c
> +++ b/tools/perf/ui/browsers/hists.c
> @@ -2963,7 +2963,7 @@ static int perf_evsel__hists_browse(struct evsel *evsel, int nr_events,
>  	struct popup_action actions[MAX_OPTIONS];
>  	int nr_options = 0;
>  	int key = -1;
> -	char buf[64];
> +	char buf[128];
>  	int delay_secs = hbt ? hbt->refresh : 0;
>  
>  #define HIST_BROWSER_HELP_COMMON					\
> -- 
> 2.24.1
> 

