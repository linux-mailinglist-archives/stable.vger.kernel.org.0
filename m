Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A340135651
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 10:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgAIJ51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 04:57:27 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729750AbgAIJ50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 04:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578563844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WPUHKFNriVZaSgcFsWO+0YW2UjIuQDtKhvlVOvL8HYY=;
        b=T11ncRY5Qctm3JYdiO6CF9BcH1Ru8RLj1ZDkxlBgacRfgkeQ5kcCv9jzzoT4Ou0Aup/+Lz
        4pKHabtoIVi0vc/S9aP0RiOiBuWE96eddJLZOGtvpIQGADBtmUKO3aeL758tcwsspofmTq
        3FobXXTEj0TdcD/RjgnmQnwHUWiP5k0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-RBM2kmkuPzS-yLGBf_qwVA-1; Thu, 09 Jan 2020 04:57:21 -0500
X-MC-Unique: RBM2kmkuPzS-yLGBf_qwVA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 499A4107ACC5;
        Thu,  9 Jan 2020 09:57:20 +0000 (UTC)
Received: from ovpn-200-26.brq.redhat.com (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C03A160BE0;
        Thu,  9 Jan 2020 09:57:17 +0000 (UTC)
Date:   Thu, 9 Jan 2020 10:58:43 +0100 (CET)
From:   Michael Petlan <mpetlan@redhat.com>
X-X-Sender: Michael@Diego
To:     Andres Freund <andres@anarazel.de>
cc:     Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] perf c2c: Fix sorting.
In-Reply-To: <20200109043030.233746-1-andres@anarazel.de>
Message-ID: <alpine.LRH.2.20.2001091055430.4075@Diego>
References: <20200109043030.233746-1-andres@anarazel.de>
User-Agent: Alpine 2.20 (LRH 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 Jan 2020, Andres Freund wrote:
> Commit 722ddfde366f ("perf tools: Fix time sorting") changed -
> correctly so - hist_entry__sort to return int64. Unfortunately several
> of the builtin-c2c.c comparison routines only happened to work due the
> cast caused by the wrong return type.
> 
> This causes meaningless ordering of both the cacheline list, and the
> cacheline details page. E.g a simple
>   perf c2c record -a sleep 3
>   perf c2c report
> will result in cacheline table like
>   =================================================
>              Shared Data Cache Line Table
>   =================================================
>   #
>   #        ----------- Cacheline ----------    Total      Tot  ----- LLC Load Hitm -----  ---- Store Reference ----  --- Load Dram ----      LLC    Total  ----- Core Load Hit -----  -- LLC Load Hit --
>   # Index             Address  Node  PA cnt  records     Hitm    Total      Lcl      Rmt    Total    L1Hit   L1Miss       Lcl       Rmt  Ld Miss    Loads       FB       L1       L2       Llc       Rmt
>   # .....  ..................  ....  ......  .......  .......  .......  .......  .......  .......  .......  .......  ........  ........  .......  .......  .......  .......  .......  ........  ........
>   #
>         0      0x7f0d27ffba00   N/A       0       52    0.12%       13        6        7       12       12        0         0         7       14       40        4       16        0         0         0
>         1      0x7f0d27ff61c0   N/A       0     6353   14.04%     1475      801      674      779      779        0         0       718     1392     5574     1299     1967        0       115         0
>         2      0x7f0d26d3ec80   N/A       0       71    0.15%       16        4       12       13       13        0         0        12       24       58        1       20        0         9         0
>         3      0x7f0d26d3ec00   N/A       0       98    0.22%       23       17        6       19       19        0         0         6       12       79        0       40        0        10         0
> i.e. with the list not being ordered by Total Hitm.
> 
> Fixes: 722ddfde366f ("perf tools: Fix time sorting")
> Signed-off-by: Andres Freund <andres@anarazel.de>

Tested on top of Arnaldo's perf/core branch. After the patch, the rows
are ordered by Tot Hitm.

Tested-by: Michael Petlan <mpetlan@redhat.com>

> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Michael Petlan <mpetlan@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: stable@vger.kernel.org # v3.16+
> ---
>  tools/perf/builtin-c2c.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
> index e69f44941aad..f2e9d2b1b913 100644
> --- a/tools/perf/builtin-c2c.c
> +++ b/tools/perf/builtin-c2c.c
> @@ -595,8 +595,8 @@ tot_hitm_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
>  {
>  	struct c2c_hist_entry *c2c_left;
>  	struct c2c_hist_entry *c2c_right;
> -	unsigned int tot_hitm_left;
> -	unsigned int tot_hitm_right;
> +	uint64_t tot_hitm_left;
> +	uint64_t tot_hitm_right;
>  
>  	c2c_left  = container_of(left, struct c2c_hist_entry, he);
>  	c2c_right = container_of(right, struct c2c_hist_entry, he);
> @@ -629,7 +629,8 @@ __f ## _cmp(struct perf_hpp_fmt *fmt __maybe_unused,			\
>  									\
>  	c2c_left  = container_of(left, struct c2c_hist_entry, he);	\
>  	c2c_right = container_of(right, struct c2c_hist_entry, he);	\
> -	return c2c_left->stats.__f - c2c_right->stats.__f;		\
> +	return (uint64_t) c2c_left->stats.__f -				\
> +	       (uint64_t) c2c_right->stats.__f;				\
>  }
>  
>  #define STAT_FN(__f)		\
> @@ -682,7 +683,8 @@ ld_llcmiss_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
>  	c2c_left  = container_of(left, struct c2c_hist_entry, he);
>  	c2c_right = container_of(right, struct c2c_hist_entry, he);
>  
> -	return llc_miss(&c2c_left->stats) - llc_miss(&c2c_right->stats);
> +	return (uint64_t) llc_miss(&c2c_left->stats) -
> +	       (uint64_t) llc_miss(&c2c_right->stats);
>  }
>  
>  static uint64_t total_records(struct c2c_stats *stats)
> -- 
> 2.25.0.rc1
> 
> 

