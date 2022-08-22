Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A461959BBD3
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 10:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiHVIko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 04:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiHVIk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 04:40:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2172CE08;
        Mon, 22 Aug 2022 01:40:27 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D610F3409E;
        Mon, 22 Aug 2022 08:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661157625; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VcbvCJQ1zOc64Py1K/gbGV3Y6GJOOhSUWGI7rx6TWww=;
        b=ER9unaPf2hCEbRjHPDyTECb5vRi26FhhiGjg9bwvnzF+/0XCprkC8OBBhFJFMtwWj68Xtj
        1m/Ax427gI//N003gKJD5Ojq4PEsF/RPchJSxVxb81mm03xXrVWIiDxqVXd+dH21I31QcY
        IUdg4ZtD4i10l+Gf1w4Oj42sRq/lgiY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661157625;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VcbvCJQ1zOc64Py1K/gbGV3Y6GJOOhSUWGI7rx6TWww=;
        b=pxebau4ppmaoquiGchCiweeVSANLj6ZznuTd4F5MvyGMIFQzGy3xND1GIvbjLtLY1zbG6Y
        DceKPjfysbZd4KBw==
Received: from suse.de (mgorman.udp.ovpn2.nue.suse.de [10.163.43.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9AC6A2C142;
        Mon, 22 Aug 2022 08:40:23 +0000 (UTC)
Date:   Mon, 22 Aug 2022 09:40:19 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] sched/all: Change all BUG_ON() instances in the
 scheduler to WARN_ON_ONCE()
Message-ID: <20220822084019.wcezy5dyy5slg4k7@suse.de>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvSsKcAXISmshtHo@gmail.com>
 <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
 <YvYdbn2GtTlCaand@gmail.com>
 <20220815144143.zjsiamw5y22bvgki@suse.de>
 <YwIW+mVeZoTOxn/4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <YwIW+mVeZoTOxn/4@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 21, 2022 at 01:28:58PM +0200, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > For the rest, I didn't see obvious recovery paths that would allow the 
> > system to run predictably. Any of them firing will have unpredictable 
> > consequences (e.g. move_queued_task firing would be fun if it was a 
> > per-cpu kthread). Depending on which warning triggers, the remaining life 
> > of the system may be very short but maybe long enough to be logged even 
> > if system locks up shortly afterwards.
> 
> Correct. I'd prefer to keep all these warnings 'simple' - i.e. no attempted 
> recovery & control flow, unless we ever expect these to trigger.
> 

I generally hope we never expect a warning to trigger until of course it
does :P

> I.e. instead of adding a 'goto' I'd prefer if we removed most of the ones 
> you highlighted. But wanted to keep this first patch simple.
> 

The only one I would push back on is claming cpupri_find_fitness() so it
does not access outside the bounds of an array after a warning triggers.

For the rest, I've no strong objection to recovering given the nature of
the BUGs you are converting. If any of them *did* trigger, it would be
more important to fix the issue than recover the warning. So other than
the out-of-bounds array access which I'd like to see clamped just in case;

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
