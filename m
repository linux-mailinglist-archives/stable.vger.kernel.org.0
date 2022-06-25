Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4433755AB1B
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 16:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbiFYOpl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 10:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232985AbiFYOpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 10:45:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FB912773
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 07:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53001B80B4F
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 14:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550FAC3411C;
        Sat, 25 Jun 2022 14:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656168336;
        bh=Vud8zdaujSPi6GvUxcPYA2+E7Ua714cyxP55l+kGqGE=;
        h=Subject:To:Cc:From:Date:From;
        b=hx6OG2BcLcdsO4xTjgK6G9bxUBGlau11uBlOwwc6774KVri2D+OK9Drs7xYwmXpHG
         ZVO/2pTbQSG5K5weNBRjD6jVfrfxx9kB1FFcSw/sJFMqCRdWeTS4BKM9Pk9EgC2jIh
         MN4TCa4GhSBzUDAeAvH9nq5dalRS+W/MUosWLTmE=
Subject: FAILED: patch "[PATCH] mm/slub: add missing TID updates on slab deactivation" failed to apply to 5.4-stable tree
To:     jannh@google.com, 42.hyeyoo@gmail.com, cl@linux.com,
        rientjes@google.com, songmuchun@bytedance.com, vbabka@suse.cz
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 25 Jun 2022 16:45:29 +0200
Message-ID: <1656168329175139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eeaa345e128515135ccb864c04482180c08e3259 Mon Sep 17 00:00:00 2001
From: Jann Horn <jannh@google.com>
Date: Wed, 8 Jun 2022 20:22:05 +0200
Subject: [PATCH] mm/slub: add missing TID updates on slab deactivation

The fastpath in slab_alloc_node() assumes that c->slab is stable as long as
the TID stays the same. However, two places in __slab_alloc() currently
don't update the TID when deactivating the CPU slab.

If multiple operations race the right way, this could lead to an object
getting lost; or, in an even more unlikely situation, it could even lead to
an object being freed onto the wrong slab's freelist, messing up the
`inuse` counter and eventually causing a page to be freed to the page
allocator while it still contains slab objects.

(I haven't actually tested these cases though, this is just based on
looking at the code. Writing testcases for this stuff seems like it'd be
a pain...)

The race leading to state inconsistency is (all operations on the same CPU
and kmem_cache):

 - task A: begin do_slab_free():
    - read TID
    - read pcpu freelist (==NULL)
    - check `slab == c->slab` (true)
 - [PREEMPT A->B]
 - task B: begin slab_alloc_node():
    - fastpath fails (`c->freelist` is NULL)
    - enter __slab_alloc()
    - slub_get_cpu_ptr() (disables preemption)
    - enter ___slab_alloc()
    - take local_lock_irqsave()
    - read c->freelist as NULL
    - get_freelist() returns NULL
    - write `c->slab = NULL`
    - drop local_unlock_irqrestore()
    - goto new_slab
    - slub_percpu_partial() is NULL
    - get_partial() returns NULL
    - slub_put_cpu_ptr() (enables preemption)
 - [PREEMPT B->A]
 - task A: finish do_slab_free():
    - this_cpu_cmpxchg_double() succeeds()
    - [CORRUPT STATE: c->slab==NULL, c->freelist!=NULL]

From there, the object on c->freelist will get lost if task B is allowed to
continue from here: It will proceed to the retry_load_slab label,
set c->slab, then jump to load_freelist, which clobbers c->freelist.

But if we instead continue as follows, we get worse corruption:

 - task A: run __slab_free() on object from other struct slab:
    - CPU_PARTIAL_FREE case (slab was on no list, is now on pcpu partial)
 - task A: run slab_alloc_node() with NUMA node constraint:
    - fastpath fails (c->slab is NULL)
    - call __slab_alloc()
    - slub_get_cpu_ptr() (disables preemption)
    - enter ___slab_alloc()
    - c->slab is NULL: goto new_slab
    - slub_percpu_partial() is non-NULL
    - set c->slab to slub_percpu_partial(c)
    - [CORRUPT STATE: c->slab points to slab-1, c->freelist has objects
      from slab-2]
    - goto redo
    - node_match() fails
    - goto deactivate_slab
    - existing c->freelist is passed into deactivate_slab()
    - inuse count of slab-1 is decremented to account for object from
      slab-2

At this point, the inuse count of slab-1 is 1 lower than it should be.
This means that if we free all allocated objects in slab-1 except for one,
SLUB will think that slab-1 is completely unused, and may free its page,
leading to use-after-free.

Fixes: c17dda40a6a4e ("slub: Separate out kmem_cache_cpu processing from deactivate_slab")
Fixes: 03e404af26dc2 ("slub: fast release on full slab")
Cc: stable@vger.kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Link: https://lore.kernel.org/r/20220608182205.2945720-1-jannh@google.com

diff --git a/mm/slub.c b/mm/slub.c
index a5b14c1dfd86..b1281b8654bd 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2963,6 +2963,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	if (!freelist) {
 		c->slab = NULL;
+		c->tid = next_tid(c->tid);
 		local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 		stat(s, DEACTIVATE_BYPASS);
 		goto new_slab;
@@ -2995,6 +2996,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	freelist = c->freelist;
 	c->slab = NULL;
 	c->freelist = NULL;
+	c->tid = next_tid(c->tid);
 	local_unlock_irqrestore(&s->cpu_slab->lock, flags);
 	deactivate_slab(s, slab, freelist);
 

