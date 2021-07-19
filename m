Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2ED3CD482
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236742AbhGSLga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 07:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbhGSLg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 07:36:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C15C061574;
        Mon, 19 Jul 2021 04:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=yk584Xxi5JgreijLkhmyuMqT8hsuugiWPk0sXg85DPc=; b=fVTrgIpdtJ9zMf/WiHGbzqdL/0
        Bjbdh5PCrSP+9Y/SwPO+aV6jq6I2rweBoW3mrLFiQkQbMYbB5LlKjJvQFox9RXXs/ASPDJF8D8XGI
        q9ORMHpta7I5TqdS0YjnA/F315lDS2K5GQsLhCdt7z7cw4H1RmOCErBJMOJzP39u7jFb2pCA4iog9
        UnhCPPKrehawCcmlnWv0NNLbIzv+f+/VdNYuKudkRQNgR282rAGFASZv2/XpnxAITFhG5bbJAL1ST
        Tv37ctw54UCI5ghCgR3to1iNYoKo8z2Cfe3nRZSCnJF2z1nI3/bjRzlAAAM4OQsxxWNc9KvsRYNgK
        PoLDfmnQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m5SBo-006pjW-Ob; Mon, 19 Jul 2021 12:16:14 +0000
Date:   Mon, 19 Jul 2021 13:16:04 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     Miaohe Lin <linmiaohe@huawei.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, paulmck@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Chris Clayton <chris2553@googlemail.com>,
        Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        rcu <rcu@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        "Huang, Ying" <ying.huang@intel.com>, gregkh@linuxfoundation.org
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Message-ID: <YPVtBBumSTMKGuld@casper.infradead.org>
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2145858.R0O0FObHBN@natalenko.name>
 <688a2cb1-5cd8-2c00-889c-4d48021371f8@huawei.com>
 <5812280.fcLxn8YiTP@natalenko.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5812280.fcLxn8YiTP@natalenko.name>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 02:12:15PM +0200, Oleksandr Natalenko wrote:
> On pondělí 19. července 2021 14:08:37 CEST Miaohe Lin wrote:
> > On 2021/7/19 19:59, Oleksandr Natalenko wrote:
> > > On pondělí 19. července 2021 13:50:07 CEST Miaohe Lin wrote:
> > >> On 2021/7/19 19:22, Matthew Wilcox wrote:
> > >>> On Mon, Jul 19, 2021 at 07:12:58PM +0800, Miaohe Lin wrote:
> > >>>> When in the commit 2799e77529c2a, we're using the percpu_ref to
> > >>>> serialize
> > >>>> against concurrent swapoff, i.e. there's percpu_ref inside
> > >>>> get_swap_device() instead of rcu_read_lock(). Please see commit
> > >>>> 63d8620ecf93 ("mm/swapfile: use percpu_ref to serialize against
> > >>>> concurrent swapoff") for detail.
> > >>> 
> > >>> Oh, so this is a backport problem.  2799e77529c2 was backported without
> > >>> its prerequisite 63d8620ecf93.  Greg, probably best to just drop
> > >> 
> > >> Yes, they're posted as a patch set:
> > >> 
> > >> https://lkml.kernel.org/r/20210426123316.806267-1-linmiaohe@huawei.com
> > >> 
> > >>> 2799e77529c2 from all stable trees; the race described is not very
> > >>> important (swapoff vs reading a page back from that swap device).
> > >>> .
> > >> 
> > >> The swapoff races with reading a page back from that swap device should
> > >> be
> > >> really uncommon as most users only do swapoff when the system is going to
> > >> shutdown.
> > >> 
> > >> Sorry for the trouble!
> > > 
> > > git log --oneline v5.13..v5.13.3 --author="Miaohe Lin"
> > > 11ebc09e50dc mm/zswap.c: fix two bugs in zswap_writeback_entry()
> > > 95d192da198d mm/z3fold: use release_z3fold_page_locked() to release locked
> > > z3fold page
> > > ccb7848e2344 mm/z3fold: fix potential memory leak in z3fold_destroy_pool()
> > > 9f7229c901c1 mm/huge_memory.c: don't discard hugepage if other processes
> > > are mapping it
> > > f13259175e4f mm/huge_memory.c: add missing read-only THP checking in
> > > transparent_hugepage_enabled()
> > > afafd371e7de mm/huge_memory.c: remove dedicated macro
> > > HPAGE_CACHE_INDEX_MASK a533a21b692f mm/shmem: fix shmem_swapin() race
> > > with swapoff
> > > c3b39134bbd0 swap: fix do_swap_page() race with swapoff
> > > 
> > > Do you suggest reverting "mm/shmem: fix shmem_swapin() race with swapoff"
> > > as well?
> > 
> > This patch also rely on its prerequisite 63d8620ecf93. I think we should
> > either revert any commit in this series or just backport the entire series.
> 
> Then why not just pick up 2 more patches instead of dropping 2 patches. Greg, 
> could you please make sure the whole series from [1] gets pulled?

Because none of these patches should have been backported in the first
place.  It's just not worth the destabilisation.
