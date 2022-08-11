Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F61590808
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 23:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiHKV2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 17:28:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiHKV2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 17:28:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64889D8DF;
        Thu, 11 Aug 2022 14:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VU1PZeaw6I4YyL6iOFs+wCjPWpBvnmOGKLSrFWd0G/s=; b=QG7bP6FilsSAZ571eM1Q1YCap/
        VairpPnmpDhpHxSQR4JS2J4Z5dAqMi3Un8zuDp5WS0PbP1J8VXlrX7PfxIAVNcyI9XmqSCq22gPe7
        SfTw9evl2A6qLn4poujnmCxcYlJlceCXSwEzvzlV4sAT6WN3LL0gvtXjwB6aep7QK18YbwO7iwCf1
        0l9DxZcYbik86ikCHjgWVeXU/j5jyiBpdautmducKWbre7hkqkwLao4BRUawDVVXOVWOr6H+p39Y8
        hoOiHExMgtVPHTWNiPuN5DJJOwYodocQ25wXfybxbHaupoN5bL8C0m9HEn1fUnWr6K2KZZmaSBgnB
        QYLqbiuA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oMFj9-001IJD-45; Thu, 11 Aug 2022 21:28:27 +0000
Date:   Thu, 11 Aug 2022 22:28:27 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        John Hubbard <jhubbard@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] sched/all: Change BUG_ON() instances to WARN_ON()
Message-ID: <YvV0e7UY5yRbHNJQ@casper.infradead.org>
References: <20220808073232.8808-1-david@redhat.com>
 <CAHk-=wiEAH+ojSpAgx_Ep=NKPWHU8AdO3V56BXcCsU97oYJ1EA@mail.gmail.com>
 <1a48d71d-41ee-bf39-80d2-0102f4fe9ccb@redhat.com>
 <CAHk-=wg40EAZofO16Eviaj7mfqDhZ2gVEbvfsMf6gYzspRjYvw@mail.gmail.com>
 <YvSsKcAXISmshtHo@gmail.com>
 <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgqW6zQcAW4i-ARJ8KNZZjw6tP3nn0QimyTWO=j+ZKsLA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 01:43:09PM -0700, Linus Torvalds wrote:
> May I suggest going one step further, and making these WARN_ON_ONCE() instead.
> 
> >From personal experience, once some scheduler bug (or task struct
> corruption) happens, ti often *keeps* happening, and the logs just
> fill up with more and more data, to the point where you lose sight of
> the original report (and the machine can even get unusable just from
> the logging).

I've been thinking about magically turning all the WARN_ON_ONCE() into
(effectively) WARN_ON_RATELIMIT().  I had some patches in that direction
a while ago but never got round to tidying them up for submission.
