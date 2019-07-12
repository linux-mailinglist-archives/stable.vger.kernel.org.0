Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F7C66787
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 09:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfGLHOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 03:14:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:49180 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726033AbfGLHOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 03:14:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 38EF9AC2D;
        Fri, 12 Jul 2019 07:14:00 +0000 (UTC)
Date:   Fri, 12 Jul 2019 09:13:59 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Kuo-Hsin Yang <vovoy@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: scan anonymous pages on file refaults
Message-ID: <20190712071359.GN29483@dhcp22.suse.cz>
References: <20190628111627.GA107040@google.com>
 <20190701081038.GA83398@google.com>
 <20190703143057.GQ978@dhcp22.suse.cz>
 <20190704094716.GA245276@google.com>
 <20190704110425.GD5620@dhcp22.suse.cz>
 <20190705124505.GA173726@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705124505.GA173726@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri 05-07-19 20:45:05, Kuo-Hsin Yang wrote:
> With 4 processes accessing non-overlapping parts of a large file, 30316
> pages swapped out with this patch, 5152 pages swapped out without this
> patch. The swapout number is small comparing to pgpgin.

which is 5 times more swapout. This may be seen to be a lot for
workloads that prefer no swapping (e.g. large in memory databases) with
an occasional heavy IO (e.g. backup). And I am worried those would
regress. I do agree that the current behavior is far from optimal
because the trashing is real. I believe that we really need a different
approach. Johannes has brought this up few years back (sorry I do not
have a link handy) but it was essentially about implementing refault
logic to anonymous memory and swap out based on the refault price. If
there is effectively no swapin then it simply makes more sense to swap
out rather than refault a page cache.

That being said, I am not nacking the patch. Let's see whether something
regresses as there is a no clear cut for the proper behavior. But I am
bringing that up because we really need a better and more robust plan
for the future.

-- 
Michal Hocko
SUSE Labs
