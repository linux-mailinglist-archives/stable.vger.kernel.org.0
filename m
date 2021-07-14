Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1482D3C92D4
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 23:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234891AbhGNVMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 17:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234998AbhGNVME (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 17:12:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B46BF613CC;
        Wed, 14 Jul 2021 21:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626296952;
        bh=hHlXOWAlgpR5zYXZWRZLzEhjTkhsaaifQTA1+gqRSu4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=y44sm/PmDvlcm+SYUSSbjyrMdahlB1dXzuDoxpGIElSAhhuyE/IxYd8wq7baRA0Sk
         HNL7tgdBEaKQOd/hZSXZsY9cGjpHhqQ7x9qLAjaLew4dlqO+y7G4fKolAExtHlUI3w
         R3zDLSDN9Ash9MzS9pVhT547n9ygj/6rb7PJraZg=
Date:   Wed, 14 Jul 2021 14:09:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Michal Hocko <mhocko@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: 5.13.2-rc and others have many not for stable
Message-Id: <20210714140911.6c45f8f4a9b129ed36bb9d06@linux-foundation.org>
In-Reply-To: <YO7lZpqC4xrMPXQg@kroah.com>
References: <2b1b798e-8449-11e-e2a1-daf6a341409b@google.com>
        <YO0zXVX9Bx9QZCTs@kroah.com>
        <20210713182813.2fdd57075a732c229f901140@linux-foundation.org>
        <YO6r1k7CIl16o61z@kroah.com>
        <YO7lZpqC4xrMPXQg@kroah.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 14 Jul 2021 15:23:50 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

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
> And f7ec104458e0 ("mm/page_alloc: fix counting of managed_pages")?
> 
> Do you want to rely on systems where these fixes are not applied?
> 
> I can understand if you all want to send them to us later after they
> have been "tested out" in Linus's tree, that's fine, but to just not
> want them applied at all feels odd to me.

Broadly speaking: end-user impact.  If we don't have reports of the
issue causing a user-visible problem and we don't expect such things to
occur, don't backport.  Why risk causing some regression when we cannot
identify any benefit?  (and boy do my fingers get tired asking people
to describe the user-visible effects of the bug they claim to have fixed!)

Of course, screwups can happen and user-useful patches may be passed
over.

