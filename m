Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDD81362CD
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 22:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgAIVqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 16:46:22 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58261 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727905AbgAIVqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 16:46:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578606381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZbAF9d7fjB7aZO4keNV6FYG7yhXE6/ctJ0M/uR6RLjI=;
        b=AC/NQy55Tph1GZL0hgGWTMCqWxVo1kdDpPPwf7nPaUrIUgjsCVdMSumnYDcPNY78m2tAc0
        yp1eOdO7VuEouXqxALyS2mSyxBK/fkAMil/Ajag8p7I/FsxYf2ZFSzXDqwSgsaU2wUaY8t
        W0k+OZbId2cUYtx3+4y+6Mk9QfJZKMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276--ATCng3CP3KnlYqAzwkAQA-1; Thu, 09 Jan 2020 16:46:17 -0500
X-MC-Unique: -ATCng3CP3KnlYqAzwkAQA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5709010054E3;
        Thu,  9 Jan 2020 21:46:16 +0000 (UTC)
Received: from krava (ovpn-204-81.brq.redhat.com [10.40.204.81])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2DD59620A6;
        Thu,  9 Jan 2020 21:46:13 +0000 (UTC)
Date:   Thu, 9 Jan 2020 22:46:11 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andres Freund <andres@anarazel.de>
Cc:     linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] perf c2c: Fix sorting.
Message-ID: <20200109214611.GC82989@krava>
References: <20200109043030.233746-1-andres@anarazel.de>
 <20200109084822.GD52936@krava>
 <20200109170041.wgvxcci3mkjh4uee@alap3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109170041.wgvxcci3mkjh4uee@alap3.anarazel.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 09, 2020 at 09:00:41AM -0800, Andres Freund wrote:

SNIP

> > >  tools/perf/builtin-c2c.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
> > > index e69f44941aad..f2e9d2b1b913 100644
> > > --- a/tools/perf/builtin-c2c.c
> > > +++ b/tools/perf/builtin-c2c.c
> > > @@ -595,8 +595,8 @@ tot_hitm_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
> > >  {
> > >  	struct c2c_hist_entry *c2c_left;
> > >  	struct c2c_hist_entry *c2c_right;
> > > -	unsigned int tot_hitm_left;
> > > -	unsigned int tot_hitm_right;
> > > +	uint64_t tot_hitm_left;
> > > +	uint64_t tot_hitm_right;
> > 
> > that change looks right, but I can't see how that could
> > happened because of change in Fixes: tag
> > 
> > was the return statement of this function:
> > 
> >         return tot_hitm_left - tot_hitm_right;
> > 
> > considered to be 'unsigned int' and then converted to int64_t,
> > which would treat negative 'unsigned int' as big positive 'int64_t'?
> 
> Correct. So e.g. when comparing 1 and 2 tot_hitm, we'd get (int64_t)
> UINT_MAX as a result, which is obviously wrong. However, due to
> hist_entry__sort() returning int at the time, this was masked, as the
> int64_t was cast to int. Thereby again yielding a negative number for
> the comparisons of hist_entry__sort()'s result.  After
> hist_entry__sort() was fixed however, there never could be negative
> return values (but 0's are possible) of hist_entry__sort() for c2c.

I see.. ok

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

