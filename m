Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E82CEEB0
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 23:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbfJGV7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 17:59:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728422AbfJGV7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Oct 2019 17:59:04 -0400
Received: from akpm3.svl.corp.google.com (unknown [104.133.8.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16ED6206C0;
        Mon,  7 Oct 2019 21:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570485543;
        bh=vccaCfLekIcqrg8RQFT5wkIkeO9fGglQMnl9ddohi3I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DN+h02cpgv8d+Ejd5EN5YVKMhepec70IQOiCXb9JSCch6mASL0uEQB7yMuQHMEBvT
         l7Jbk1GmZ8HyfHw2sXhUVm7teniTYmTFqrgq/Qtt1gY5Hz1ruYREBCug0GS+PgJIoq
         CICr5sHeej3dbaCyraAh0n/gN7lxLsld/R41sB+k=
Date:   Mon, 7 Oct 2019 14:59:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Qian Cai <cai@lca.pw>, tj@kernel.org, vdavydov.dev@gmail.com,
        hannes@cmpxchg.org, guro@fb.com, cl@linux.com, penberg@kernel.org,
        rientjes@google.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: fix a deadlock in show_slab_objects()
Message-Id: <20191007145902.a1ae6aac11c29d466a445a94@linux-foundation.org>
In-Reply-To: <20191007081621.GE2381@dhcp22.suse.cz>
References: <1570192309-10132-1-git-send-email-cai@lca.pw>
        <20191004125701.GJ9578@dhcp22.suse.cz>
        <20191007081621.GE2381@dhcp22.suse.cz>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 7 Oct 2019 10:16:21 +0200 Michal Hocko <mhocko@kernel.org> wrote:

> On Fri 04-10-19 14:57:01, Michal Hocko wrote:
> > On Fri 04-10-19 08:31:49, Qian Cai wrote:
> > > Long time ago, there fixed a similar deadlock in show_slab_objects()
> > > [1]. However, it is apparently due to the commits like 01fb58bcba63
> > > ("slab: remove synchronous synchronize_sched() from memcg cache
> > > deactivation path") and 03afc0e25f7f ("slab: get_online_mems for
> > > kmem_cache_{create,destroy,shrink}"), this kind of deadlock is back by
> > > just reading files in /sys/kernel/slab which will generate a lockdep
> > > splat below.
> > > 
> > > Since the "mem_hotplug_lock" here is only to obtain a stable online node
> > > mask while racing with NUMA node hotplug, in the worst case, the results
> > > may me miscalculated while doing NUMA node hotplug, but they shall be
> > > corrected by later reads of the same files.
> > 
> > I think it is important to mention that this doesn't expose the
> > show_slab_objects to use-after-free. There is only a single path that
> > might really race here and that is the slab hotplug notifier callback
> > __kmem_cache_shrink (via slab_mem_going_offline_callback) but that path
> > doesn't really destroy kmem_cache_node data structures.

Yes, I noted this during review.  It's a bit subtle and is worthy of
more than a changelog note, I think.  How about this?

--- a/mm/slub.c~mm-slub-fix-a-deadlock-in-show_slab_objects-fix
+++ a/mm/slub.c
@@ -4851,6 +4851,10 @@ static ssize_t show_slab_objects(struct
 	 * already held which will conflict with an existing lock order:
 	 *
 	 * mem_hotplug_lock->slab_mutex->kernfs_mutex
+	 *
+	 * We don't really need mem_hotplug_lock (to hold off
+	 * slab_mem_going_offline_callback()) here because slab's memory hot
+	 * unplug code doesn't destroy the kmem_cache->node[] data.
 	 */
 
 #ifdef CONFIG_SLUB_DEBUG
_

> Andrew, please add this to the changelog so that we do not have to
> scratch heads again when looking into that code.

I did that as well.
