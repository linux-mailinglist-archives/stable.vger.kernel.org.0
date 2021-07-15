Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779433C9D29
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 12:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241662AbhGOKtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 06:49:00 -0400
Received: from outbound-smtp61.blacknight.com ([46.22.136.249]:56355 "EHLO
        outbound-smtp61.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241665AbhGOKtA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 06:49:00 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2021 06:49:00 EDT
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp61.blacknight.com (Postfix) with ESMTPS id 1D114FAAA4
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 11:39:46 +0100 (IST)
Received: (qmail 15713 invoked from network); 15 Jul 2021 10:39:45 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.17.255])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 15 Jul 2021 10:39:45 -0000
Date:   Thu, 15 Jul 2021 11:39:44 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-ID: <20210715103944.GQ3809@techsingularity.net>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
 <YO0zXVX9Bx9QZCTs@kroah.com>
 <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
 <YO6r1k7CIl16o61z@kroah.com>
 <YO7lZpqC4xrMPXQg@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <YO7lZpqC4xrMPXQg@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 14, 2021 at 03:23:50PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 14, 2021 at 11:18:14AM +0200, Greg Kroah-Hartman wrote:
> > On Tue, Jul 13, 2021 at 06:28:13PM -0700, Andrew Morton wrote:
> > > On Tue, 13 Jul 2021 08:31:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > >  So far, all automated testing seems to
> > > > show that there are no regressions in these releases with these commits
> > > > in them.  If there was a problem, how would it show up?
> > > > 
> > > > And as far as I know, mm/ stuff is still not triggered by the AUTOSEL
> > > > bot, but that is not what caused this commit to be added to a stable
> > > > release.
> > > > 
> > > > Trying to keep a "do not apply" list for Fixes: tags only is much harder
> > > > for both of us as we do these semi-manually and review them
> > > > individually.  Trying to remember what subsystem only does Fixes tags
> > > > yet really doesn't mean it is an impossible task.
> > > 
> > > Well, it shouldn't be super hard to skip all patches which have Fixes:,
> > > Signed-off-by:akpm and no cc:stable?
> > 
> > Ok, I will do this now (goes and writes this down...)
> > 
> > But it really feels odd that you all take the time to add a "Hey, this
> > fixes this specific commit!" tag in the changelog, yet you do not
> > actually want to go and fix the kernels that have that commit in it.
> > This is an odd signal to others that watch the changelogs for context
> > clues.  Perhaps you might not want to do that anymore.
> 
> I looked at some of these patches and it seems really odd to me that you
> all are marking them with Fixes: tags, but do not want them backported.
> 
> First example is babbbdd08af9 ("mm/huge_memory.c: don't discard hugepage
> if other processes are mapping it")
> 
> Why is this not ok to backport?
> 
> Also what about e6be37b2e7bd ("mm/huge_memory.c: add missing read-only
> THP checking in transparent_hugepage_enabled()")?
> 
> And 41eb5df1cbc9 ("mm: memcg/slab: properly set up gfp flags for objcg
> pointer array")?
> 
> And 6acfb5ba150c ("mm: migrate: fix missing update page_private to
> hugetlb_page_subpool")?
> 
> And 832b50725373 ("mm: mmap_lock: use local locks instead of disabling
> preemption")? (the RT people want that...)
> 

This one at least is theoritical in nature for a backport because
PREEMPT_RT cannot be selected as no arch defines ARCH_SUPPORTS_RT
yet. If is was heading to any stable branch, it would be under
https://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git/.
The latest kernel there is v5.10-rt and the Fixes tag is for 5.11 so that
fix would be ignored.

-- 
Mel Gorman
SUSE Labs
