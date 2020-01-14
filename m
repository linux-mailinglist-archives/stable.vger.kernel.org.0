Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46ACE13AF5B
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 17:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgANQ3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 11:29:08 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35639 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728761AbgANQ3F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 11:29:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579019345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IPYT5vQh2Yd4w7szH352o1kr3SakRWqAyBbk7sSmaIs=;
        b=M01RA58QXAh3hhGOOJVnHxgZHTr/rbnKEsm8GsVwe4taIB6jz5ZtO0l9hO14182lihYbrP
        a3w05c5LdrlaAHS9rzpmiXhhVWXesjpmA20flY0DAxCuiEnkV1FewkCBBNS+a7ZOwYAeFk
        gLFnfMsgM/xtRK7Ny2dFFgZ7gTmoiM4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-jZQy2EB5PPidwbylHzvu8Q-1; Tue, 14 Jan 2020 11:29:02 -0500
X-MC-Unique: jZQy2EB5PPidwbylHzvu8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63A771143798;
        Tue, 14 Jan 2020 16:29:00 +0000 (UTC)
Received: from sandy.ghostprotocols.net (ovpn-112-20.phx2.redhat.com [10.3.112.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C395550A8F;
        Tue, 14 Jan 2020 16:28:59 +0000 (UTC)
Received: by sandy.ghostprotocols.net (Postfix, from userid 1000)
        id 78A26119; Tue, 14 Jan 2020 13:28:55 -0300 (BRT)
Date:   Tue, 14 Jan 2020 13:28:55 -0300
From:   Arnaldo Carvalho de Melo <acme@redhat.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andres Freund <andres@anarazel.de>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH] perf c2c: Fix sorting.
Message-ID: <20200114162855.GD3115@redhat.com>
References: <20200109043030.233746-1-andres@anarazel.de>
 <20200109084822.GD52936@krava>
 <20200109170041.wgvxcci3mkjh4uee@alap3.anarazel.de>
 <20200109214611.GC82989@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109214611.GC82989@krava>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Em Thu, Jan 09, 2020 at 10:46:11PM +0100, Jiri Olsa escreveu:
> On Thu, Jan 09, 2020 at 09:00:41AM -0800, Andres Freund wrote:
> 
> SNIP
> 
> > > >  tools/perf/builtin-c2c.c | 10 ++++++----
> > > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
> > > > index e69f44941aad..f2e9d2b1b913 100644
> > > > --- a/tools/perf/builtin-c2c.c
> > > > +++ b/tools/perf/builtin-c2c.c
> > > > @@ -595,8 +595,8 @@ tot_hitm_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
> > > >  {
> > > >  	struct c2c_hist_entry *c2c_left;
> > > >  	struct c2c_hist_entry *c2c_right;
> > > > -	unsigned int tot_hitm_left;
> > > > -	unsigned int tot_hitm_right;
> > > > +	uint64_t tot_hitm_left;
> > > > +	uint64_t tot_hitm_right;
> > > 
> > > that change looks right, but I can't see how that could
> > > happened because of change in Fixes: tag
> > > 
> > > was the return statement of this function:
> > > 
> > >         return tot_hitm_left - tot_hitm_right;
> > > 
> > > considered to be 'unsigned int' and then converted to int64_t,
> > > which would treat negative 'unsigned int' as big positive 'int64_t'?
> > 
> > Correct. So e.g. when comparing 1 and 2 tot_hitm, we'd get (int64_t)
> > UINT_MAX as a result, which is obviously wrong. However, due to
> > hist_entry__sort() returning int at the time, this was masked, as the
> > int64_t was cast to int. Thereby again yielding a negative number for
> > the comparisons of hist_entry__sort()'s result.  After
> > hist_entry__sort() was fixed however, there never could be negative
> > return values (but 0's are possible) of hist_entry__sort() for c2c.
> 
> I see.. ok
> 
> Acked-by: Jiri Olsa <jolsa@redhat.com>

Thanks, applied.

- Arnaldo

