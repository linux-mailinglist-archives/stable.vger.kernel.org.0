Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB87D64B752
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 15:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiLMO21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 09:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbiLMO20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 09:28:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A451EAEF;
        Tue, 13 Dec 2022 06:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFB7661557;
        Tue, 13 Dec 2022 14:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8F5C433EF;
        Tue, 13 Dec 2022 14:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670941703;
        bh=rrzaJDPWmltpz/V6l3a6Gkl9FuLfJ97cFLrnX00SHfg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LNENHUPhAT8Ebw6l5tkFIzGYdcaEZijTDBiQnLEAvwbdxNmGGQPxzp25kl2SH3ZHK
         F3FtyStongOr3rgWMLRImm2NUtrsQEY3O8jmFFJTRZ3dqO3dhN0vB0xE1TkETSt9gg
         Gaxp5+NPXEBhXMmg1zbpLP4S2KL3qykFVNP/3q9U=
Date:   Tue, 13 Dec 2022 15:28:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hugh Dickins <hughd@google.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        "Chen, Rong A" <rong.a.chen@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "Huang, Ying" <ying.huang@intel.com>, Jann Horn <jannh@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>,
        Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, Gavin Shan <gshan@redhat.com>,
        Zhenyu Zhang <zhenyzha@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5.10 001/106] mm/mlock: remove lru_lock on
 TestClearPageMlocked
Message-ID: <Y5iMA7ErVU3QGGC5@kroah.com>
References: <20221212130924.863767275@linuxfoundation.org>
 <20221212130924.929782499@linuxfoundation.org>
 <8ad6ed6-5f7c-f1cd-8693-caf88bfca73a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8ad6ed6-5f7c-f1cd-8693-caf88bfca73a@google.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 12:35:57PM -0800, Hugh Dickins wrote:
> On Mon, 12 Dec 2022, Greg Kroah-Hartman wrote:
> 
> > From: Alex Shi <alex.shi@linux.alibaba.com>
> > 
> > [ Upstream commit 3db19aa39bac33f2e850fa1ddd67be29b192e51f ]
> > 
> > In the func munlock_vma_page, comments mentained lru_lock needed for
> > serialization with split_huge_pages.  But the page must be PageLocked as
> > well as pages in split_huge_page series funcs.  Thus the PageLocked is
> > enough to serialize both funcs.
> > 
> > Further more, Hugh Dickins pointed: before splitting in
> > split_huge_page_to_list, the page was unmap_page() to remove pmd/ptes
> > which protect the page from munlock.  Thus, no needs to guard
> > __split_huge_page_tail for mlock clean, just keep the lru_lock there for
> > isolation purpose.
> > 
> > LKP found a preempt issue on __mod_zone_page_state which need change to
> > mod_zone_page_state.  Thanks!
> > 
> > Link: https://lkml.kernel.org/r/1604566549-62481-13-git-send-email-alex.shi@linux.alibaba.com
> > Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> > Acked-by: Hugh Dickins <hughd@google.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Acked-by: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Cc: Alexander Duyck <alexander.duyck@gmail.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
> > Cc: "Chen, Rong A" <rong.a.chen@intel.com>
> > Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
> > Cc: "Huang, Ying" <ying.huang@intel.com>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Cc: Kirill A. Shutemov <kirill@shutemov.name>
> > Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> > Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: Mel Gorman <mgorman@techsingularity.net>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Mika Penttilä <mika.penttila@nextfour.com>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Shakeel Butt <shakeelb@google.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: Wei Yang <richard.weiyang@gmail.com>
> > Cc: Yang Shi <yang.shi@linux.alibaba.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Stable-dep-of: 829ae0f81ce0 ("mm: migrate: fix THP's mapcount on isolation")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> NAK from me to patches 001 through 007 here: 001 through 006 are a
> risky subset of patches and followups to a per-memcg per-node lru_lock
> series from Alex Shi, which made subtle changes to locking, memcg
> charging, lru management, page migration etc.
> 
> The whole series could be backported to 5.10 (I did so myself for
> internal usage), but cherry-picking parts of it into 5.10-stable is
> misguided and contrary to stable principles.
> 
> Maybe there is in fact nothing wrong with the selection made:
> but then give linux-mm guys two or three weeks to review and
> test and give the thumbs up to that selection.
> 
> Much easier, quicker and safer would be to adjust 007 (I presume
> the reason behind 001 through 006) to fit the 5.10-stable tree:
> I can do that myself if you ask, but not until later this week.

All now dropped, thanks.

greg k-h
