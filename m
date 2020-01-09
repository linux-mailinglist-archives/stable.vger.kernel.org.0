Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6E81359F0
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 14:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgAINSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 08:18:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730917AbgAINSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 08:18:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578575924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Oi6sxXgGF2oGh7wW3x+9RBwUATb9piupredDv1qF/4U=;
        b=GSDfuUo4Leos2mFpr8Az+wMEzweAgWrBHxdIhHmPOYFCO23ghjmpdkN6LAq2zFBVDMf+0W
        d+iJqA4dWb4fmYjaCH55+KdLky3W6l58PCyYxBlsQZCnYyXvuRoXPt1Y3B7EX05zRyltWq
        Yxz4acFDXvwNsP7WbeFXfFugf9djkZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-6dDQdXgXMJ6FTr0dfRjlyw-1; Thu, 09 Jan 2020 08:18:41 -0500
X-MC-Unique: 6dDQdXgXMJ6FTr0dfRjlyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 31E8210054E3;
        Thu,  9 Jan 2020 13:18:40 +0000 (UTC)
Received: from sandy.ghostprotocols.net (ovpn-112-40.phx2.redhat.com [10.3.112.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0E08C5C54A;
        Thu,  9 Jan 2020 13:18:39 +0000 (UTC)
Received: by sandy.ghostprotocols.net (Postfix, from userid 1000)
        id 9311B127E; Thu,  9 Jan 2020 10:18:34 -0300 (BRT)
Date:   Thu, 9 Jan 2020 10:18:34 -0300
From:   Arnaldo Carvalho de Melo <acme@redhat.com>
To:     Michael Petlan <mpetlan@redhat.com>
Cc:     Andres Freund <andres@anarazel.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] perf c2c: Fix sorting.
Message-ID: <20200109131834.GA4404@redhat.com>
References: <20200109043030.233746-1-andres@anarazel.de>
 <alpine.LRH.2.20.2001091055430.4075@Diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.20.2001091055430.4075@Diego>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Thu, Jan 09, 2020 at 10:58:43AM +0100, Michael Petlan escreveu:
> On Wed, 8 Jan 2020, Andres Freund wrote:
> > Commit 722ddfde366f ("perf tools: Fix time sorting") changed -
> > correctly so - hist_entry__sort to return int64. Unfortunately several
> > of the builtin-c2c.c comparison routines only happened to work due the
> > cast caused by the wrong return type.
> > 
> > This causes meaningless ordering of both the cacheline list, and the
> > cacheline details page. E.g a simple
> >   perf c2c record -a sleep 3
> >   perf c2c report
> > will result in cacheline table like
> >   =================================================
> >              Shared Data Cache Line Table
> >   =================================================
> >   #
> >   #        ----------- Cacheline ----------    Total      Tot  ----- LLC Load Hitm -----  ---- Store Reference ----  --- Load Dram ----      LLC    Total  ----- Core Load Hit -----  -- LLC Load Hit --
> >   # Index             Address  Node  PA cnt  records     Hitm    Total      Lcl      Rmt    Total    L1Hit   L1Miss       Lcl       Rmt  Ld Miss    Loads       FB       L1       L2       Llc       Rmt
> >   # .....  ..................  ....  ......  .......  .......  .......  .......  .......  .......  .......  .......  ........  ........  .......  .......  .......  .......  .......  ........  ........
> >   #
> >         0      0x7f0d27ffba00   N/A       0       52    0.12%       13        6        7       12       12        0         0         7       14       40        4       16        0         0         0
> >         1      0x7f0d27ff61c0   N/A       0     6353   14.04%     1475      801      674      779      779        0         0       718     1392     5574     1299     1967        0       115         0
> >         2      0x7f0d26d3ec80   N/A       0       71    0.15%       16        4       12       13       13        0         0        12       24       58        1       20        0         9         0
> >         3      0x7f0d26d3ec00   N/A       0       98    0.22%       23       17        6       19       19        0         0         6       12       79        0       40        0        10         0
> > i.e. with the list not being ordered by Total Hitm.
> > 
> > Fixes: 722ddfde366f ("perf tools: Fix time sorting")
> > Signed-off-by: Andres Freund <andres@anarazel.de>
> 
> Tested on top of Arnaldo's perf/core branch. After the patch, the rows
> are ordered by Tot Hitm.
> 
> Tested-by: Michael Petlan <mpetlan@redhat.com>

Jiri, so you think we should use a different Fixes: cset? Or plain
remove it? I haven't checked it, just trying to figure out if you guys
came up with a conclusion so that I can review/apply.

- Arnaldo
 
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> > Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> > Cc: Michael Petlan <mpetlan@redhat.com>
> > Cc: Namhyung Kim <namhyung@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: stable@vger.kernel.org # v3.16+
> > ---
> >  tools/perf/builtin-c2c.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
> > index e69f44941aad..f2e9d2b1b913 100644
> > --- a/tools/perf/builtin-c2c.c
> > +++ b/tools/perf/builtin-c2c.c
> > @@ -595,8 +595,8 @@ tot_hitm_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
> >  {
> >  	struct c2c_hist_entry *c2c_left;
> >  	struct c2c_hist_entry *c2c_right;
> > -	unsigned int tot_hitm_left;
> > -	unsigned int tot_hitm_right;
> > +	uint64_t tot_hitm_left;
> > +	uint64_t tot_hitm_right;
> >  
> >  	c2c_left  = container_of(left, struct c2c_hist_entry, he);
> >  	c2c_right = container_of(right, struct c2c_hist_entry, he);
> > @@ -629,7 +629,8 @@ __f ## _cmp(struct perf_hpp_fmt *fmt __maybe_unused,			\
> >  									\
> >  	c2c_left  = container_of(left, struct c2c_hist_entry, he);	\
> >  	c2c_right = container_of(right, struct c2c_hist_entry, he);	\
> > -	return c2c_left->stats.__f - c2c_right->stats.__f;		\
> > +	return (uint64_t) c2c_left->stats.__f -				\
> > +	       (uint64_t) c2c_right->stats.__f;				\
> >  }
> >  
> >  #define STAT_FN(__f)		\
> > @@ -682,7 +683,8 @@ ld_llcmiss_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
> >  	c2c_left  = container_of(left, struct c2c_hist_entry, he);
> >  	c2c_right = container_of(right, struct c2c_hist_entry, he);
> >  
> > -	return llc_miss(&c2c_left->stats) - llc_miss(&c2c_right->stats);
> > +	return (uint64_t) llc_miss(&c2c_left->stats) -
> > +	       (uint64_t) llc_miss(&c2c_right->stats);
> >  }
> >  
> >  static uint64_t total_records(struct c2c_stats *stats)
> > -- 
> > 2.25.0.rc1
> > 
> > 

